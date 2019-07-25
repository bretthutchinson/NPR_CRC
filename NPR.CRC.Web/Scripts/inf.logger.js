var inf = inf || {};

inf.logLevel = {
    /// <summary>
    /// Indicates the logging verbosity level and importance of a log entry.
    /// </summary>

    error: 10,
    warning: 20,
    milestone: 30,
    information: 40,
    debug: 50
};

inf.log = function (logLevel, source, message) {
    /// <summary>
    /// Sends a message to the server to be logged.
    /// &#10;
    /// &#10;Example 1 - a typical log entry:
    /// &#10;
    /// &#10;  inf.log(inf.logLevel.error, "myFunction", "Something bad happened!");
    /// </summary>

    // validate that a log level argument was specified
    if (!logLevel) {
        inf.messageBox("inf.Log(logLevel, source, message): &quot;logLevel&quot; is a required argument.");
        return;
    }

    // validate that a source argument was specified
    if (!source) {
        inf.messageBox("inf.Log(logLevel, source, message): &quot;source&quot; is a required argument.");
    }

    // validate that a message argument was specified
    if (!message) {
        inf.messageBox("inf.Log(logLevel, source, message): &quot;message&quot; is a required argument.");
    }

    // modify the source arguement to make it clear the source is javascript
    source = "javascript: " + source;

    // append the javascript stack trace to the message
    message += "; " + printStackTrace().join(" --> ");

    // make sure this line of javascript is present in your main _Layout.cshtml file: inf.siteRoot = "@Url.Content("~/")";
    var url = inf.siteRoot + "InfBase/Log";

    // post the log entry to the server
    $.post(url, {
        logLevel: logLevel,
        source: source,
        message: message
    });
};

$(document).ready(function () {
    // define a global javascript exception handler that logs the error
    window.onerror = function (message, url, lineNumber) {
        inf.log(inf.logLevel.error, url + ":" + lineNumber, message);
    };

    // also define a global ajax error handler, as ajax errors typically are not javascript exceptions
    $(document).ajaxError(function (event, jqXHR, ajaxSettings, thrownError) {
        var errorMessage = ajaxSettings.type + " " + ajaxSettings.url + ", data: " + ajaxSettings.data + " returned " + jqXHR.status + "-" + jqXHR.statusText + "; response: " + jqXHR.responseText;
        //throw errorMessage;
    });
});
