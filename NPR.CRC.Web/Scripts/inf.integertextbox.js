var inf = inf || {};

inf.initIntegerTextBoxes = function ($parent) {
	/// <summary>
	/// Converts all &lt;input&gt; elements within the specified parent having class = "integer" to integer-only textboxes.
	/// &#10; If no parent is specified then the top-level document object will be used as the parent.
	/// </summary>

	$parent = $parent || $(document);

	$parent.find("input.inf-integer").infIntegerTextBox();
}

$(document).ready(function () {
	// auto-init integer textboxes on page load
	inf.initIntegerTextBoxes();
});

// infIntegerTextBox custom jquery plugin
// adapted from: http://stackoverflow.com/a/995193
(function ($) {
	$.fn.extend({
		infIntegerTextBox: function (options) {
			var defaults = {};
			var options = $.extend(defaults, options, this.data("infintegertextboxoptions"));

			return this.each(function () {
				$(this).keydown(function (event) {
					// allow: backspace, delete, tab, escape, enter and .
					if ($.inArray(event.keyCode, [46, 8, 9, 27, 13, 190]) !== -1 ||
						// allow: Ctrl+A
						(event.keyCode == 65 && event.ctrlKey === true) ||
						// allow: home, end, left, right
						(event.keyCode >= 35 && event.keyCode <= 39)) {
						// let it happen, don't do anything
						return;
					}
					else {
						// ensure that it is a number and stop the keypress
						if (event.shiftKey || (event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105)) {
							event.preventDefault();
						}
					}
				});
			});
		}
	});
})(jQuery);
