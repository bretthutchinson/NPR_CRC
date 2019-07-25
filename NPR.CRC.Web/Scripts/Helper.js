/***** BEGIN DropDownMenu *****/
var dropDownMenu_Hover = false;
function DropDownMenu_Click(target) {
    $(target).parent().parent().children('.dropDownMenuList').toggle();
}
function DropDownMenu_Over(target) {
    dropDownMenu_Hover = true;
}
function DropDownMenu_Out(target) {
    dropDownMenu_Hover = false;
    var hoverTimer = setTimeout(function () {
        if (!dropDownMenu_Hover) {
            $(target).children('.dropDownMenuList, .navDropDownMenuList').hide();
        }
        clearTimeout(hoverTimer);
    }, 10);
}
/***** END DropDownMenu *****/

/***** BEGIN NavDropDownMenu *****/
function NavDropDownMenu_Click(target) {
    $(target).parent().parent().children('.navDropDownMenuList')
        .show()
        .focus()
        .blur(function (e) {
            var $this = $(this);
            setTimeout(function () {
                $this.hide()
            }, 250);
        });
}

function NavDropDownMenu_Over(target) {
    $(target).parent().parent().children('.navDropDownMenuList')
        .show()
        .focus()
        .blur(function (e) {
            var $this = $(this);
            setTimeout(function () {
                $this.hide()
            }, 250);
        });
}
/***** END DropDownMenu *****/

function HighlightMenu(target) {
    $(target).addClass("menuHighlight");
}

function UnhighlightMenu(target) {
    $(target).removeClass("menuHighlight");
}

/***** BEGIN Program Search *****/

function initProgramSearchControls(searchUrl) {
    $("#programTabs").tabs();

    $("#ProgramName").watermark("Type at least 3 characters to search");
    $("#ProgramName").hide();

    $("#ProgramFirstLetter").change(function () {
        loadProgramSearchList(searchUrl);
    });

    $("#ProgramList").change(function () {
        $("#ProgramId").val($("#ProgramList").val());
        $("#ProgramName").val($("#ProgramList").text());
    });

    $("#ProgramName").autocomplete({
        source: searchUrl,
        minLength: 3,
        select: function (event, ui) {
            $(this).val(ui.item.label);
            $("#ProgramId").val(ui.item.value);
            $("#ProgramName").val(ui.item.label);
            return false;
        },
        response: function (event, ui) {
            if (ui.content.length == 0) {
                $("#ProgramName").val('');
            }
        }
    });
    
    $("#ProgramName").change(function () {
        if ($("#ProgramName").val().length < 3) {
            $("#ProgramName").val('');
            $("#ProgramId").val('');
        }
    });
}

function loadProgramSearchList(searchUrl) {
    var $programList = $("#ProgramList");
    $programList.empty();

    var term = $("#ProgramFirstLetter").find("option:selected").prop("value");
    $.getJSON(searchUrl + "?term=" + term + "&searchType=StartsWith", function (data) {
        if (term == "*") {
            var $option = $("<option></option")
                    .prop("value", "")
                    .text("Select a Program Name");
            $programList.append($option);
        }

        $(data).each(function (index, item) {
            var $option = $("<option></option")
                            .prop("value", item.value)
                            .text(item.label);
            $programList.append($option);
        });

        if ($programList.find('option').length < 1) {
            $("#ProgramId").val('');
            $("#ProgramName").val('');
        }
        else {
            $programList.find("option:first").prop("selected", true);
            $("#ProgramId").val($programList.val());
            $("#ProgramName").val($programList.text());
        }

        $programList.trigger("change");
    });
};

function toggleSearch(method) {
    switch (method) {
        case "search":
            $("#ProgramId").val('');
            $("#ProgramName").val('');
            $("#ProgramFirstLetter").hide();
            $("#ProgramList").hide();
            $("#ProgramName").show();
            break;
        case "select":
            $("#ProgramId").val($("#ProgramList").val());
            $("#ProgramName").val('');

            $("#ProgramFirstLetter").show();
            $("#ProgramList").show();
            $("#ProgramName").hide();
            break;
    }
}
/***** END Program Search *****/
