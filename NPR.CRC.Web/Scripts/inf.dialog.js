var inf = inf || {};

inf.initDialogLinks = function ($parent) {
    /// <summary>
    /// Converts all &lt;a&gt; elements within the specified parent having class = "inf-dialog" to triggers for opening a jquery dialog.
    /// &#10;If no parent is specified then the top-level document object will be used as the parent.
    /// &#10;The content referenced by the target of the link will be loaded into the dialog.
    /// &#10;Make sure the server-side controller action returns a partial view, rather than a view.
    /// &#10;
    /// &#10;Example:
    /// &#10;
    /// &#10;  &lt;a href="@Url.Action("Edit", "Employee")" class="inf-dialog"&gt;Edit&lt;/a&gt;
    /// </summary>

    $parent = $parent || $(document);

    $parent.find("a.inf-dialog").click(function () {
        var $link = $(this);

        // check if the id of a related grid was provided as a data-gridid=".." attribute of the link
        // if yes, then the grid will be refreshed when the dialog is closed
        var gridId = $link.data("gridid");

        if (!gridId) {
            // check if the link is within a grid; if yes then the grid will be refreshed when the dialog is closed
            var $grid = $link.closest(".ui-jqgrid-btable");
            if ($grid.length > 0) {
                gridId = $grid.attr("id");
            }
        }

        if (!gridId) {
            // check if there is a grid that comes after the link; if yes then the grid will be refreshed when the dialog is closed
            var $grid = $link.nextInDOM(".ui-jqgrid-btable");
            if ($grid.length > 0) {
                gridId = $grid.attr("id");
            }
        }

        var dialogId = "_" + Math.random().toString(36).substring(7);
        var $dialog = $("<div></div>")
            .attr("id", dialogId)
            .load($link.attr("href"), function () {
                $(this).dialog({
                    title: $link.attr("title") || $link.text(),
                    modal: true,
                    width: "auto",
                    open: function () {
                        inf.initButtons($dialog);
                        inf.initCheckBoxLists($dialog);
                        inf.initFileUploads($dialog);
                        inf.initIntegerTextBoxes($dialog);
                        inf.initValidation($dialog);
                        inf.initDialog($dialog, gridId);
                    },
                    close: function () {
                        $(this).dialog("destroy").remove();
                    }
                });
            });
        return false;
    });
};

inf.initDialog = function ($dialog, gridId) {
    $dialog.find(".inf-dialogcancel").click(function () {
        $dialog.dialog("close");
    });
    var $form = $dialog.find("form");
    if ($form.length > 0) {
        var successCallback = $form.attr("data-ajax-success");
        if (!successCallback) {
            var callbackString = "inf.dialogSuccess(data, status, xhr, '" + $dialog.attr("id") + "', " + (gridId ? "'" + gridId + "'" : "null") + ")"
            $form.attr("data-ajax-success", callbackString);
        }
    }
};

inf.dialogSuccess = function (data, textStatus, jqXHR, dialogId, gridId) {
    var $dialog = $("#" + dialogId);
    if (data === true) {
        $dialog.dialog("close");
        if (gridId) {
            var $grid = $("#" + gridId);
            $grid.jqGrid().trigger("reloadGrid");
        }
        else {
            location.reload();
        }
    }
    else {
        $dialog.html(data);
        $dialog.find("[data-valmsg-summary=true] li").addClass("inf-validation-serverside");
        inf.initButtons($dialog);
        inf.initCheckBoxLists($dialog);
        inf.initFileUploads($dialog);
        inf.initIntegerTextBoxes($dialog);
        inf.initValidation($dialog);
        inf.initDialog($dialog);
    }
};

$(document).ready(function () {
    // auto-init dialong links on page load
    inf.initDialogLinks();
});