var inf = inf || {};

inf.initCheckBoxLists = function ($parent) {
    /// <summary>
    /// Converts all &lt;select&gt; elements within the specified parent having class = "checkboxlist" to checkbox lists.
    /// &#10; If no parent is specified then the top-level document object will be used as the parent.
    /// </summary>

    $parent = $parent || $(document);

    // add the checkboxlist class to multi-selects
    $parent.find("select[multiple]").addClass("inf-checkboxlist");

    $parent.find("select.inf-checkboxlist").infCheckBoxList();
}

$(document).ready(function () {
    // auto-init checkbox lists on page load
    inf.initCheckBoxLists();
});

(function ($) {

    var methods = {
        init: function () {
            var $select = $(this);
            if ($select.length) {
                var $ul = $("<ul/>")
                    .width($select.width())
                    .height($select.height())
                    .insertAfter($select)
                    .addClass("inf-checkboxlist-ul");
                var baseId = "_" + $select.attr("id");
                $select.children("option").each(function (index) {
                    var $option = $(this);
                    var id = baseId + index;
                    var $li = $("<li/>").appendTo($ul);
                    var $checkbox = $('<input type="checkbox" />')
                        .attr("id", id)
                        .appendTo($li)
                        .change(function () {
                            if ($(this).is(":checked")) {
                                $option.prop("selected", true);
                            }
                            else {
                                $option.prop("selected", false);
                            }

                            methods.validate($select, $ul);
                        });
                    if ($option.is(":selected")) {
                        $checkbox.prop("checked", true);
                    }
                    $checkbox.after("<label for='" + id + "'>" + $option.text() + "</label>");
                });

                $.each($select[0].attributes, function (i, attr) {
                    var name = attr.name;
                    var value = attr.value;

                    if (name.startsWith("data-val")) {
                        $ul.attr(name, value);
                    }
                });

                methods.validate($select, $ul);
                $select.hide();
            }
        },

        validate: function ($select, $ul) {
            if ($select.is("[data-val-required]")) {
                var validationErrorClassName = "input-validation-error";
                if ($select.val()) {
                    $select.removeClass(validationErrorClassName);
                    $ul.removeClass(validationErrorClassName);
                }
                else {
                    $select.addClass(validationErrorClassName);
                    $ul.addClass(validationErrorClassName);
                }
            }
        }

    };

    $.fn.infCheckBoxList = function (method) {
        if (methods[method]) {
            return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
        }
        else if (typeof method === 'object' || !method) {
            return methods.init.apply(this, arguments);
        }
        else {
            $.error('Method ' + method + ' does not exist on jQuery.infCheckBoxList');
        }
    };

})(jQuery);