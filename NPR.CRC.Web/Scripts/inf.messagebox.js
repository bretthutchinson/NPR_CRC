var inf = inf || {};

inf.messageBox = function (message, title, buttons, callback) {
    /// <summary>
    /// Shows a modal message box, with optional title, custom buttons and a callback function.
    /// &#10;
    /// &#10;Example 1 - "OK" message box:
    /// &#10;
    /// &#10;  inf.messageBox("Lorem ipsum dolor sit amet.");
    /// &#10;
    /// &#10;Example 2 - "Yes-No-Cancel" message box with callback:
    /// &#10;
    /// &#10;  inf.messageBox("Lorem ipsum dolor sit amet.", "Warning", ["Yes", "No", "Cancel"], function (value) {
    /// &#10;     alert(value); // value will contain the text of the clicked button
    /// &#10;  });
    /// </summary>

    var $messageBox = $("<div></div>")
		.html(message)
		.css({
		    paddingTop: "15px",
		    textAlign: "center",
		    minWidth: "250px",
		    maxWidth: "600px"
		})
        .dialog({
            modal: true,
            title: title || document.title || "Message",
            width: "auto",
            resizable: false,
            close: function () {
                $(this).dialog("destroy").remove();
            }
        });

    if (!buttons) {
        // buttons argument was not passed in at all
        // create a new empty array
        buttons = [];
    }
    else if (!($.isArray(buttons))) {
        // buttons argument was passed in as something other than an array
        // create a new array consisting of a single element containing whatever value was passed in
        buttons = [].concat(buttons);
    }

    // if no buttons were specified then by default show a single "OK" button
    if (buttons.length < 1) {
        buttons[0] = "OK";
    }

    // create the buttons
    var dialogButtons = {};
    $.each(buttons, function (index, value) {
        dialogButtons[value] = function () {

            // close when the button is clicked
            $messageBox.dialog("close");

            // trigger the callback, if one is defined
            if (callback) {
                callback(value);
            }
        }
    });

    // add the buttons to the dialog
    $messageBox.dialog("option", "buttons", dialogButtons);
};

inf.initConfirmationMessages = function ($parent) {
    /// <summary>
    /// Adds confirmation prompts to all links, buttons, checkboxes, and other applicable elements that have a "data-inf-confirm" attribute within the specified parent.
    /// &#10; If no parent is specified then the top-level document object will be used as the parent.
    /// </summary>

    $parent = $parent || $(document);

    $parent.find("[data-inf-confirm]").click(function () {
        var $this = $(this);
        if (!$this.is(".inf-confirmed")) {

            inf.messageBox($this.data("infConfirm"), "Confirmation", ["Yes", "No"], function (value) {
                if (value === "Yes") {
                    $this.addClass("inf-confirmed");
                    inf.mouseClick($this);
                }
                else {
                    $this.removeClass("inf-confirmed");
                }
            });

            return false;
        }
    });
};

$(document).ready(function () {
    // auto-init confirmation messages on page load
    inf.initConfirmationMessages();
});
