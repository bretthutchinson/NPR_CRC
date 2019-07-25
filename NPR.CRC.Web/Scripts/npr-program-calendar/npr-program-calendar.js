(function ($) {
    $.fn.extend({



        nprProgramCalendar: function (calendarResourceUrls, options) {

            var defaults = {
                year: new Date().getFullYear(),
                month: new Date().getMonth(),
                title: "NPR Program Calendar",
                deleteEnabled: false
            };

            var options = $.extend(defaults, options, this.data("nprprogramcalendaroptions"));



            return this.each(function () {


                var $calendar = $(this).fullCalendar({
                    year: options.year,
                    month: options.month,
                    date: 1,
                    allDaySlot: false,
                    defaultView: "agendaWeek",
                    header: false,
                    events: loadEvents,
                    firstDay: 1, // monday
                    select: showAddDialog,
                    eventClick: function (event, jsEvent, view) { //alert(event._id);
                        showAddDialog(event.start, event.end, true, jsEvent, event._id, view);
                    },
                    selectable: true,
                    snapMinutes: calendarResourceUrls.increment,
                    theme: true,
                    contentHeight: calendarResourceUrls.contentHeight,
                    height: calendarResourceUrls.height,
                    viewDisplay: function () {
                        var $this = $(this);

                        $this.find("tr:first th").each(function () {
                            $headerCell = $(this);
                            $headerCell.text($headerCell.text().substring(0, 3));
                        });
                        $this.find(".ui-state-highlight, .fc-today")
                            .removeClass("ui-state-highlight fc-today");

                        var calendarDate = $this.fullCalendar("getDate");
                        var calendarMonthText = $.fullCalendar.formatDate(calendarDate, "MMMM yyyy");
                        $(".npr-program-calendar-monthtext").text(calendarMonthText);
                    },
                    eventRender: function (event, element) {

                        // Sum quarter hours for validation
                        if (calendarResourceUrls.dialogType === "P") {
                            //Add check for skip EMPTY program 
                            if (event.title !== 'EMPTY') {
                                sumQuarters(parseInt(event.quarterHours));
                            }
                        }
                        element.find(".fc-event-title").remove();
                        element.find(".fc-event-time").text("");

                        var timeRange = $.fullCalendar.formatDate(event.start, "h:mm tt") + " - " + $.fullCalendar.formatDate(event.end, "h:mm tt");
                        element.attr("title", timeRange + ": " + event.title);

                        if ($.inArray("newscast", event.className) < 0) {
                            element.find(".fc-event-time").text(event.title);
                        }

                        if (calendarResourceUrls.dialogType === "N") {
                            element.find(".fc-event-time").text("");
                        }

                    }
                });

                var calendarDate = $calendar.fullCalendar("getDate");
                var calendarMonthText = $.fullCalendar.formatDate(calendarDate, "MMMM yyyy");

                var $monthBar = $("<div></div>")
                    .addClass("npr-program-calendar-monthbar")
                    .append($("<a>Prev</a>")
                        .addClass("npr-program-calendar-monthbar-next")
                        .button({
                            icons: {
                                primary: "ui-icon-triangle-1-w"
                            }
                        })
                        .click(function () {
                            $calendar.fullCalendar("incrementDate", 0, -1);
                        }))
                    .append($("<span></span>").text(calendarMonthText).addClass("ui-widget npr-program-calendar-monthtext"))
                    .append($("<a>Next</a>")
                        .addClass("npr-program-calendar-monthbar-prev")
                        .button({
                            icons: {
                                secondary: "ui-icon-triangle-1-e"
                            }
                        })
                        .click(function () {
                            $calendar.fullCalendar("incrementDate", 0, 1);
                        }));

                $('.calendarHeader .subTitle').html($monthBar);
            });

            function loadEvents(start, end, callback) {
                var requestData = {
                    scheduleId: $('#ScheduleId_Value').val(),
                    start: start.getTime() / 1000,
                    end: end.getTime() / 1000
                };
                $.ajax({
                    url: calendarResourceUrls.programSchedule,
                    cache: false,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: requestData,
                    success: function (responseData) {
                        calendarResourceUrls.responseData = responseData.rows;
                        if (callback != null) {
                            callback(responseData.rows);
                        }
                    }
                });
            };

            function saveEvent(eventData, $calendar) {
                $.post(calendarResourceUrls.programScheduleSave, eventData, function () {
                    if ($("input[name='calendarView']:checked").val() === "Calendar") {
                    }
                    else {
                        $("#quarterHours").val("");
                    }
                    $("#programListGrid").trigger("reloadGrid");
                    $("#newscastListGrid").trigger("reloadGrid");
                });
                window.setTimeout(function () {

                    $('[class^="fc-slot"]').css("height", 'auto');
                    $(".npr-program-calendar").fullCalendar("refresh");
                    $(".npr-newscast-calendar").fullCalendar("refresh");
                    $(".npr-program-calendar").fullCalendar("refetchEvents");
                    $(".npr-newscast-calendar").fullCalendar("refetchEvents");
                    $(".npr-program-calendar-print").fullCalendar("refetchEvents");
                    $(".npr-newscast-calendar-print").fullCalendar("refetchEvents");
                    //
                    if (calendarResourceUrls.dialogType === "P") {
                        window.setTimeout(function () {
                            //alert('test34');
                            $('[class^="fc-slot"]').css("height", '43px');
                            //location.reload();
                            reloadRegularCalendar();
                            adjustGridTimer();
                            //alert($('.fc-slot47').offset());
                        }, 500);
                    }

                }, 1000);
            };

            function deleteEvent(eventData, $calendar) {
                $.post(calendarResourceUrls.programScheduleDelete, eventData, function () {

                    $("#programListGrid").trigger("reloadGrid");
                    $("#newscastListGrid").trigger("reloadGrid");
                    //loadLists();
                });
                window.setTimeout(function () {

                    $(".npr-program-calendar").fullCalendar("refetchEvents");
                    $(".npr-newscast-calendar").fullCalendar("refetchEvents");
                    $(".npr-program-calendar-print").fullCalendar("refetchEvents");
                    $(".npr-newscast-calendar-print").fullCalendar("refetchEvents");
                    adjustGrid();
                }, 1000);
            };

            function loadProgramList() {
                var $programList = $("#ProgramList");
                $programList.empty();

                var term = $("#ProgramFirstLetter").find("option:selected").prop("value");
                $.getJSON(calendarResourceUrls.programSearch + "?term=" + term + "&searchType=StartsWith", function (data) {
                    $(data).each(function (index, item) {
                        var $option = $("<option></option")
                                        .prop("value", item.value)
                                        .text(item.label);

                        $programList.append($option);
                    });
                    if ($programList.find('option').length < 1) {
                        $("#ProgramId").val('');
                    }
                    else if ($("#ProgramId").val() === "" || $("#ProgramId").val() === "0") {
                        $programList.find("option:first").prop("selected", true);
                        $("#ProgramId").val($programList.val());
                    }
                    else {
                        $programList.val($("#ProgramId").val());
                    }
                    $programList.trigger("change");
                });

            };

            function setTypeDuration(scheduleNewscastId) {
                // Used to set edited newscast duration type and minutes

                $.each(calendarResourceUrls.responseData, function (index, value) {
                    if (value.scheduleNewscastId === scheduleNewscastId) {

                        if (value.hourlyInd === "Y") {
                            $("#Hourly").prop("checked", true);
                            $("#HourlyInd").val(true);
                        }
                        else {
                            $("#Daily").prop("checked", true);
                            $(".durationRow").hide();
                            $("#HourlyInd").val(false);
                        }

                        $("#DurationMinutes").val(value.durationMinutes);
                    }
                });
            }

            function getProgramDaysOfWeek(scheduleProgramNewscastId, dialogType) {

                var daysOfWeek = null;
                $.each(calendarResourceUrls.responseData, function (index, value) {
                    if (dialogType === "P") {
                        if (value.scheduleProgramId === scheduleProgramNewscastId) {
                            daysOfWeek = value.daysOfWeek;
                        }
                    }
                    else {
                        if (value.scheduleNewscastId === scheduleProgramNewscastId) {
                            daysOfWeek = value.daysOfWeek;
                        }
                    }
                });

                return daysOfWeek;
            };

            function markDaysOfWeek(obj, startDate, programDaysOfWeek) {
                if (programDaysOfWeek !== null) {
                    for (var i = 0; i < programDaysOfWeek.length; i++) {
                        var id;

                        switch (programDaysOfWeek[i]) {
                            case "0":
                                id = "SundayInd";
                                break;
                            case "1":
                                id = "MondayInd";
                                break;
                            case "2":
                                id = "TuesdayInd";
                                break;
                            case "3":
                                id = "WednesdayInd";
                                break;
                            case "4":
                                id = "ThursdayInd";
                                break;
                            case "5":
                                id = "FridayInd";
                                break;
                            case "6":
                                id = "SaturdayInd";
                                break;
                        }
                        obj.find("input[id=" + id + "]").prop("checked", true);
                    }
                } else if (startDate !== undefined) {
                    var id;
                    switch (startDate.getDay().toString()) {
                        case "0":
                            id = "SundayInd";
                            break;
                        case "1":
                            id = "MondayInd";
                            break;
                        case "2":
                            id = "TuesdayInd";
                            break;
                        case "3":
                            id = "WednesdayInd";
                            break;
                        case "4":
                            id = "ThursdayInd";
                            break;
                        case "5":
                            id = "FridayInd";
                            break;
                        case "6":
                            id = "SaturdayInd";
                            break;
                    }
                    obj.find("input[id=" + id + "]").prop("checked", true);
                }
            }

            function getProgramId(scheduleProgramId) {
                var programId = null;
                $.each(calendarResourceUrls.responseData, function (index, value) {
                    if (value.scheduleProgramId === scheduleProgramId) {
                        programId = value.programId;
                    }
                });

                return programId;
            }

            function sumQuarters(hrs) {
                var sum;
                //inf-change "add check if quarterHours === 672 then set hidden field value 0"
                sum = $("#quarterHours").val() === "" || $("#quarterHours").val() ==="672" ? 0 : parseInt($("#quarterHours").val());
                $("#quarterHours").val(sum + hrs);
            }



            function showAddDialog(startDate, endDate, allDay, jsEvent, scheduleProgramNewscastId, view) {
                //alert(calendarResourceUrls.dialogType);
                window.dialogue = 1;
                var dialogURL = calendarResourceUrls.dialog;
                var incMins = $("input[name='calIncrement']:checked").val();

                if (calendarResourceUrls.dialogType === "P") {
                    dialogURL += "/?incrMins=" + incMins;
                }
                if (calendarResourceUrls.readOnly === "False") {
                    var buttons = [
                                {
                                    text: "Save",
                                    click: function () {
                                        eval(calendarResourceUrls.validationMethod + '()');
                                        if ($dialog.find(".validationError").length < 1) {
                                            /** for newscast daily this is to force to save the selected dates */
                                            if (calendarResourceUrls.dialogType === "N") {

                                                if ($dialog.find("#HourlyInd").val() === "false") {

                                                    $dialog.find("#StartTime").val($dialog.find("#StartHour").val() + ":" + $dialog.find("#StartMinute").val() + " " + $dialog.find("#StartPeriod").val());
                                                    $dialog.find("#EndTime").val($dialog.find("#EndHour").val() + ":" + $dialog.find("#EndMinute").val() + " " + $dialog.find("#EndPeriod").val());
                                                } else {
                                                    $dialog.find("#StartTime").val($dialog.find("#StartHour").val() + ":00 " + $dialog.find("#StartPeriod").val());
                                                    $dialog.find("#EndTime").val($dialog.find("#EndHour").val() + ":" + $dialog.find("#EndMinute").val() + " " + $dialog.find("#EndPeriod").val());
                                                }
                                            }
                                            /**   **/
                                            var eventData = $(this).find("form").serialize();
                                            saveEvent(eventData, $(view.calendar));
                                            window.dialogue = 0;
                                            $dialog.dialog("close");
                                        }
                                    }
                                },
                                {
                                    text: "Cancel",
                                    click: function () {
                                        window.dialogue = 0;
                                        $(this).dialog("close");
                                    }
                                }
                    ];

                    var title = calendarResourceUrls.dialogTitle;
                    if (options.deleteEnabled && scheduleProgramNewscastId !== undefined) {
                        title = title.replace("Add ", "Edit ");
                        buttons.push({
                            text: "Delete",
                            click: function () {
                                var eventData = $(this).find("form").serialize();
                                deleteEvent(eventData, $(view.calendar));
                                $dialog.dialog("close");
                            }
                        });
                    }

                    var $dialog = $("<div></div")
                        .addClass("npr-program-calendar-dialog")

                        .load(dialogURL, function () {
                            var $this = $(this);
                            var programDaysOfWeek = null;

                            if (calendarResourceUrls.dialogType === "P") {
                                // Functionality only pertaining to add/edit programs

                                if (!isNaN(scheduleProgramNewscastId)) {
                                    var scheduleProgramId = parseInt(scheduleProgramNewscastId);

                                    $('#ScheduleProgramId').val(scheduleProgramId);
                                    programDaysOfWeek = getProgramDaysOfWeek(scheduleProgramId, calendarResourceUrls.dialogType);
                                    $("#ProgramId").val(getProgramId(scheduleProgramId));
                                }

                                loadProgramList();

                                $("#programTabs").tabs();

                                $("#ProgramFirstLetter").change(function () {
                                    $("#ProgramList").removeClass("validationError");
                                    loadProgramList();
                                });

                                $("#ProgramList").change(function () {
                                    var $selectedItem = $(this).find("option:selected");
                                    $this.find("#ProgramId").val($selectedItem.prop("value"));
                                });

                                $("#ProgramName").autocomplete({
                                    source: calendarResourceUrls.programSearch,
                                    minLength: 3,
                                    select: function (event, ui) {
                                        $(this).val(ui.item.label);
                                        $("#ProgramId").val(ui.item.value);
                                        return false;
                                    }
                                });

                                $("#ProgramName").watermark("Type at least 3 characters to search");
                                $("#ProgramName").focus(function () {
                                    $(this).removeClass("validationError");
                                });
                            }
                            else {
                                // Functionality only pertaining to add/edit newscasts
                                if (!isNaN(scheduleProgramNewscastId)) {
                                    var scheduleNewscastId = parseInt(scheduleProgramNewscastId)

                                    $('#ScheduleNewscastId').val(scheduleNewscastId);
                                    setTypeDuration(scheduleNewscastId);
                                    programDaysOfWeek = getProgramDaysOfWeek(scheduleNewscastId, calendarResourceUrls.dialogType);
                                }
                                else {
                                    $this.find('input[name=HourlyInd][value=Daily]').prop("checked", true);
                                    $(".durationRow").hide();
                                    $("#HourlyInd").val(false);

                                }
                            }

                            // Common functionality
                            markDaysOfWeek($this, startDate, programDaysOfWeek);
                            $("#ScheduleId").val($("#ScheduleId_Value").val());

                            if (startDate !== undefined) {
                                var minutes = startDate.getMinutes();
                                if (minutes < 10) {
                                    minutes = "0" + minutes;
                                }

                                var hours = startDate.getHours() % 12;
                                if (hours === 0) { hours = 12; }

                                // Workaround for radio group 15/60 minute increment for fullcalendar
                                if (calendarResourceUrls.dialogType === "P") {
                                    //if (incMins == "60" && (minutes == 15 || minutes == 45)) {
                                    //    minutes = "00";
                                    //}
                                }

                                $this.find('#StartTime').val(hours + ':' + minutes + (startDate.getHours() < 12 ? " am" : " pm"));
                                $this.find('#StartHour').val(hours);
                                $this.find('#StartMinute').val(minutes);
                                $this.find("#StartPeriod").val(startDate.getHours() < 12 ? "am" : "pm");
                            }

                            if (isNaN(hours) && isNaN(minutes)) {
                                $this.find('#StartTime').val("12:00 am");
                                $this.find('#StartHour').val("12");
                                $this.find("#StartPeriod").val("am");
                            }

                            if (endDate !== undefined) {

                                var minutes = endDate.getMinutes();


                                var hours = endDate.getHours() % 12;


                                if (calendarResourceUrls.dialogType != "P" && isNaN(scheduleProgramNewscastId)) {

                                    if (minutes >= 10) {
                                        minutes = minutes - 10;
                                    } else {
                                        minutes = minutes + 50;
                                        if (hours > 0) {
                                            hours = hours - 1;
                                        } else {
                                            hours = hours + 11;
                                        }

                                    }
                                }
                                if (hours === 0) { hours = 12; }
                                if (minutes < 10) {
                                    minutes = "0" + minutes;
                                }

                                //alert(hours + " : " + minutes);
                                // Workaround for radio group 15/30 minute increment for fullcalendar
                                var midnight = "";
                                if (calendarResourceUrls.dialogType === "P") {
                                    if (incMins == "60" && scheduleProgramNewscastId == null) {
                                        if (endDate.getHours() == 23) {
                                            //switch (minutes) {
                                            //    case 15:
                                            //        minutes = "00";
                                            //        break;
                                            //    case 45:
                                            //        midnight = "Y";
                                            //        break;
                                            //}
                                            if (minutes == "00") {
                                                minutes = "45";
                                            } else {
                                                midnight = "Y";
                                            }
                                        }
                                        else {
                                            //if (minutes == 45) {
                                            //    hours += 1;
                                            //}
                                            //minutes = "00";
                                            if (minutes == "00") {
                                                minutes = "45";
                                            }
                                            else if (minutes == "30" || minutes == "45") {
                                                minutes -= 15;
                                                hours == 12 ? hours = 1 : hours += 1;
                                            }
                                            else if (minutes == 15) {
                                                minutes = "00";
                                                hours == 12 ? hours = 1 : hours += 1;
                                            }
                                        }
                                    }
                                }

                                if ((hours + ':' + minutes + (endDate.getHours() < 12 ? " am" : " pm") == "11:59 pm") || midnight == "Y") {
                                    $this.find('#EndTime option:last-child').attr('selected', 'selected');
                                }
                                else {
                                    $this.find('#EndTime').val(hours + ':' + minutes + (endDate.getHours() < 12 ? " am" : " pm"));
                                }

                                $this.find('#EndHour').val(hours);
                                $this.find('#EndMinute').val(minutes);

                                $this.find("#EndPeriod").val(endDate.getHours() < 12 ? "am" : "pm");

                                if (isNaN(hours) && isNaN(minutes)) {
                                    $this.find('#EndTime').val("12:00 am");
                                    $this.find('#EndHour').val("12");
                                    $this.find("#EndPeriod").val("am");
                                }
                            }
                        })
                        .dialog({
                            buttons: buttons,
                            close: function () {
                                $(this).dialog('destroy').remove();
                                //$(view.calendar).fullCalendar("removeEvents");
                                $(view.calendar).fullCalendar("refetchEvents");
                            },
                            modal: true,
                            title: title,
                            width: 425
                        });
                }
            };
        }
    });
})(jQuery);

$(document).ready(function () {
    $(".npr-program-calendar").nprProgramCalendar(programCalendarResourceUrls);
    $(".npr-newscast-calendar").nprProgramCalendar(newscastCalendarResourceUrls, { deleteEnabled: true });
    $(".npr-program-calendar-print").nprProgramCalendar(printProgramCalendarResourceUrls);
    $(".npr-newscast-calendar-print").nprProgramCalendar(printNewscastCalendarResourceUrls, { deleteEnabled: true });


});

function validateAddEditProgram() {
    var $dialog = $('#addProgramCalendarDialog');
    var $validationList = $(".validation-summary-valid").children('');
    var error = false;

    $validationList.empty();

    // Validate Program
    if ($("#programTabs").tabs('option', 'active') === 0) {
        if ($("#ProgramId").val() !== undefined && $("#ProgramId").val().length < 1) {
            error = true;
            $validationList.append('<li>Program is required.</li>');
            $("#ProgramList").addClass("validationError");
        }
        else {
            $("#ProgramList").removeClass("validationError");
            $("#ProgramName").removeClass("validationError");
        }
    }
    else {
        if (($("#ProgramId").val() !== undefined && $("#ProgramId").val().length < 1) || $("#ProgramName").val().length < 4) {
            error = true;
            $validationList.append('<li>Program is required.</li>');
            $("#ProgramName").addClass("validationError");
        }
        else {
            $("#ProgramList").removeClass("validationError");
            $("#ProgramName").removeClass("validationError");
        }
    }

    // Validate start and end times
    var startTime = $dialog.find("#StartTime");
    var endTime = $dialog.find("#EndTime");

    var startDate = parseDate(startTime.val());
    var endDate = parseDate(endTime.val());

    if (startDate >= endDate && startTime.val() !== "12:00 am" && endTime.val() !== "12:00 am") {
        error = true;
        $validationList.append('<li>Start Time must be earlier than End Time.</li>');
        startTime.addClass("validationError");
        endTime.addClass("validationError");
    }
    else {
        startTime.removeClass("validationError");
        endTime.removeClass("validationError");
    }

    // Validate Days indicator
    if (!$("#SundayInd").is(':checked') && !$("#MondayInd").is(':checked') && !$("#TuesdayInd").is(':checked') && !$("#WednesdayInd").is(':checked') &&
        !$("#ThursdayInd").is(':checked') && !$("#FridayInd").is(':checked') && !$("#SaturdayInd").is(':checked')) {
        error = true;
        $validationList.append('<li>At least one day must be selected.</li>');
        $("#daysOfWeekInd").addClass("validationError");
    }
    else {
        $("#daysOfWeekInd").removeClass("validationError");
    }

    if (error) {
        $dialog.find(".validation-summary-container").show();
        $dialog.find(".validation-summary-valid").css('display', 'block');
        $dialog.find(".validation-summary-valid").addClass("validation-summary-errors");
    }
}

function validateAddEditNewscast() {

    var $dialog = $('#addNewscastCalendarDialog');
    var $validationList = $(".validation-summary-valid").children('');
    var error = false;

    $validationList.empty();

    var hourlyInd, hourlyTimeDiff;
    var startHour, startMinute, startPeriod, startTime, startDate;
    var endHour, endMinute, endPeriod, endTime, endDate;

    hourlyInd = $dialog.find("input[name=HourlyInd]:checked").val();

    startHour = $dialog.find("#StartHour");
    startMinute = $dialog.find("#StartMinute");
    startPeriod = $dialog.find("#StartPeriod");

    endHour = $dialog.find("#EndHour");
    endMinute = $dialog.find("#EndMinute");
    endPeriod = $dialog.find("#EndPeriod");

    startTime = startHour.val() + ":" + startMinute.val() + " " + startPeriod.val();
    endTime = endHour.val() + ":" + endMinute.val() + " " + endPeriod.val();

    startDate = parseDate(startTime);
    endDate = parseDate(endTime);

    hourlyTimeDiff = endDate - startDate;
    // alert(hourlyInd + ' ' + startDate + ' ' + endDate + ' ' + hourlyTimeDiff);
    if (startDate >= endDate && startTime !== "12:00 am" && endTime !== "12:00 am") {
        error = true;
        $validationList.append('<li>Start Time must be earlier than End Time.</li>');
        startHour.addClass("validationError");
        startMinute.addClass("validationError");
        startPeriod.addClass("validationError");
        endHour.addClass("validationError");
        endMinute.addClass("validationError");
        endPeriod.addClass("validationError");
    }
    else if (hourlyInd == "False" && startDate < endDate && parseInt(hourlyTimeDiff) > 600000) {
        error = true;
        $validationList.append('<li>Daily NPR Newscast Service program cannot exceed 10 minutes.</li>');
        startHour.addClass("validationError");
        startMinute.addClass("validationError");
        startPeriod.addClass("validationError");
        endHour.addClass("validationError");
        endMinute.addClass("validationError");
        endPeriod.addClass("validationError");
    }
    else {
        startHour.removeClass("validationError");
        startMinute.removeClass("validationError");
        startPeriod.removeClass("validationError");
        endHour.removeClass("validationError");
        endMinute.removeClass("validationError");
        endPeriod.removeClass("validationError");
    }

    // Validate Days indicator
    if (!$("#SundayInd").is(':checked') && !$("#MondayInd").is(':checked') && !$("#TuesdayInd").is(':checked') && !$("#WednesdayInd").is(':checked') &&
        !$("#ThursdayInd").is(':checked') && !$("#FridayInd").is(':checked') && !$("#SaturdayInd").is(':checked')) {
        error = true;
        $validationList.append('<li>At least one day must be selected.</li>');
        $("#daysOfWeekInd").addClass("validationError");
    }
    else {
        $("#daysOfWeekInd").removeClass("validationError");
    }

    if (error) {
        $dialog.find(".validation-summary-container").show();
        $dialog.find(".validation-summary-valid").css('display', 'block');
        $dialog.find(".validation-summary-valid").addClass("validation-summary-errors");
    }
}
