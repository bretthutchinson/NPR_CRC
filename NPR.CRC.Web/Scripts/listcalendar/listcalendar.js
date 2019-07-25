/*
(function ($) {
    $.fn.extend({
        listCalendar: function (calendarResourceUrls, data, editColumn) {
            return this.each(function () {
                target = this;
                calendarParams = data;
                var start = new Date();
                start.setDate(1);
                start = clearTime(start);
                var end = new Date(+start);
                end.setDate(8);
                loadEvents(start, end);
            });

            var calendarParams
            var calendarDom;
            var target;

            function buildHeader() {
                calendarDom += '<thead><tr>';
                $.each(calendarParams, function (index, value) {
                    if (index !== 'id') {
                        calendarDom += '<th>' + value + '</th>';
                    }
                });
                calendarDom += '</tr></thead>';
                return calendarDom;
            };

            function buildBody(data) {
                $.each(data, function (index, value) {
                    calendarDom += '<tr id="listCalendarRow' + value.id + '">';
                    $.each(calendarParams, function (pIndex, pValue) {
                        if (pIndex !== 'id') {
                            var additionalClass = '';
                            if (pIndex === 'startTime' || pIndex === 'endTime') {
                                additionalClass = 'nowrap';
                            }
                            calendarDom += '<td class="listCalendarCell' + pIndex + ' ' + additionalClass + '">';
                            if (pIndex === editColumn) {
                                firstInd = false;
                                calendarDom += '<a onclick="' + calendarResourceUrls.listCalendarEditMethod + '(\'' + value.id + '\');">';
                                calendarDom += eval('value.' + pIndex);
                                calendarDom += '</a>';
                            }
                            else {
                                calendarDom += eval('value.' + pIndex);
                            }
                            calendarDom += '</td>';
                        }
                    });
                    calendarDom += '</tr>';
                });
            };

            function loadEvents(start, end) {
                var requestData = {
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
                        calendarDom = '<div class="listCalendar"><div class="scrollable"><table cellpadding="0" cellspacing="0">';
                        buildHeader();
                        buildBody(responseData);
                        calendarDom += '</table></div></div>';
                        $(target).html(calendarDom);
                    }
                });
            };

            function cloneDate(d, dontKeepTime) {
                if (dontKeepTime) {
                    return clearTime(new Date(+d));
                }
                return new Date(+d);
            };

            function clearTime(d) {
                d.setHours(0);
                d.setMinutes(0);
                d.setSeconds(0);
                d.setMilliseconds(0);
                return d;
            }
        }
    });
})(jQuery);

function editProgramEntry(id) {
    var row = $('#listCalendarRow' + id);
    var startTime = row.find('.listCalendarCellstartTime').text();
    var endTime = row.find('.listCalendarCellendTime').text();
    $('.npr-program-calendar').fullCalendar('select', parseDate(startTime), parseDate(endTime), null, id);
}

function editNewscastEntry(id) {
    var row = $('#listCalendarRow' + id);
    var startTime = row.find('.listCalendarCellstartTime').text();
    var endTime = row.find('.listCalendarCellendTime').text();
    $('.npr-newscast-calendar').fullCalendar('select', parseDate(startTime), parseDate(endTime), null, id);
}

function parseDate(stringValue) {
    var valueSplitSpace = stringValue.split(" ");
    if (valueSplitSpace.length === 2) {
        var valueSplitColon = valueSplitSpace[0].split(":");
        if (valueSplitColon.length === 2) {
            var hours = parseInt(valueSplitColon[0]);
            if (valueSplitSpace[1].toUpperCase() === 'PM' && hours !== 12 ) {
                hours += 12;
            }
            else if (valueSplitSpace[1].toUpperCase() === 'AM' && hours === 12) {
                hours = 0;
            }
            var minutes = parseInt(valueSplitColon[1]);
            var date = new Date();
            date.setHours(hours, minutes);
            return date;
        }
    }
    return null;
}
*/