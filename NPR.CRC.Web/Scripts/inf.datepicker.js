var inf = inf || {};

inf.initDatePickers = function ($parent) {
    /// <summary>
    /// Converts all &lt;input&gt; elements within the specified parent having class = "date" to jquery ui datepickers.
    /// &#10; If no parent is specified then the top-level document object will be used as the parent.
    /// </summary>

    $parent = $parent || $(document);

    $parent.find("input.inf-date").datepicker({
        dateFormat: "m/d/yy",
        changeMonth: true,
        changeYear: true,
        yearRange: "1900:2100",
        // make sure this line of javascript is present in your main _Layout.cshtml file: inf.siteRoot = "@Url.Content("~/")";
        // and also that the rest of the button image path is correct
        buttonImage: inf.siteRoot + "Content/Images/datepicker.png",
        buttonImageOnly: true,
        showOn: "both"
    });
};

$(document).ready(function () {
    // auto-init datepickers on page load
    inf.initDatePickers();
});
