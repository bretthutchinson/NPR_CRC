var inf = inf || {};

inf.initButtons = function ($parent) {
    /// <summary>
    /// Converts all elements within the specified parent having class = "button" to jquery ui buttons.
    /// &#10; If no parent is specified then the top-level document object will be used as the parent.
    /// </summary>

    $parent = $parent || $(document);

    // add the button class to elements that actually are buttons
    $parent.find(":button, input[type=submit], input[type=reset]").addClass("inf-button");

    $parent.find(".inf-button").button();
};

$(document).ready(function () {
    // auto-init buttons on page load
    inf.initButtons();
});
