var inf = inf || {};

inf.mouseClick = function (element) {
    /// <summary>
    /// Triggers a "native" mouse click on tbe specified element.
    /// This differs from jQuery's .trigger("click") and .click() approaches, because jQuery only triggers
    /// event handlers that have been bound by jQuery.
    /// Whereas inf.mouseClick triggers the same behavior as if the user actually clicked on the element with their mouse,
    /// including the firing of all event handlers bound with or without jQuery, and even the browser's native handlers,
    /// such as navigation when a hyperlink is clicked.
    /// Adapted from http://stackoverflow.com/a/1421968
    /// </summary>

    if (element) {
        if (element instanceof jQuery) {
            element = element.length > 0 ? element[0] : null;
        }

        if (element) {
            if (element.click) {
                element.click();
            }
            else if (document.createEvent) {
                var newEvent = document.createEvent("MouseEvents");
                newEvent.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
                var allowDefault = anchorObj.dispatchEvent(newEvent);
                // you can check allowDefault for false to see if
                // any handler called newEvent.preventDefault().
                // Firefox will *not* redirect to anchorObj.href
                // for you. However every other browser will.
            }
        }
    }
};
