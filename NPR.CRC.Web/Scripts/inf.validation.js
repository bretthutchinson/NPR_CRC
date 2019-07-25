var inf = inf || {};

inf.initValidation = function ($parent) {
    $parent = $parent || $(document);

    $parent.find("form").each(function () {
        var $form = $(this);
        $.validator.unobtrusive.parse($form);
        var validator = $form.data("validator");

        validator.settings.ignore = ":hidden:not(.inf-checkboxlist)";
        validator.settings.showErrors = function (map, errors) {
            this.defaultShowErrors();
            this.checkForm();
            if (this.errorList.length) {
                $(this.currentForm).triggerHandler("invalid-form", [this]);
                $(this.currentForm).find(".validation-summary-container").show();
            }
            else {
                $(this.currentForm).resetSummary();
            }
        }

        // get any server-side validations
        var $serverSideValidationMessages = $form.find("li.inf-validation-serverside");

        $form.valid();

        // re-add server-side validations
        var $div = $(".validation-summary-errors");
        var $ul = $div.find("ul");
        if ($ul.length < 1) {
            $ul = $("<ul></ul").appendTo($div);
        }
        $serverSideValidationMessages.each(function () {
            var $li = $(this);
            $ul.append($li);
        });

        $form.find("input, select, textarea").change(function () {
            $form.valid();
        });

        // enable "soft" validation if there is a hidden input having class = "inf-softvalidation" and value = "true"
        if ($form.find("input.inf-softvalidation[value=true]").length > 0) {
            $form.find(":submit").addClass("cancel");
        }
    });

    // add the "required" class to any label elements associated required input fields
    $parent.find("input, select, textarea").each(function () {
        var $input = $(this);
        if (($input.is("[data-val-required]") || $input.is("[data-val-requiredif]")) && !($input.is(":checkbox"))) {
            var id = $input.attr("id") || $input.attr("name") || "";
            if (id.length > 0) {
                $("label[for=" + id + "]").addClass("required");
            }
        }
    });

    $(document).tooltip({
        items: ".input-validation-error",
        content: function () {
            var $input = $(this);
            var $form = $input.closest("form");
            if ($form.length > 0) {
                var validator = $form.data("validator");
                if (validator) {
                    if ($input.hasClass("inf-checkboxlist-ul")) {
                        return validator.errorMap[$input.prev("select.inf-checkboxlist").attr("id")];
                    }
                    else {
                        return validator.errorMap[$input.attr("id")];
                    }
                }
            }
        },
        position: {
            my: "left center",
            at: "right+10 center"
        }
    });
};

$(document).ready(function () {
    $("[data-valmsg-summary=true] li:not(:empty)").addClass("inf-validation-serverside");
    // auto-init validation on page load
    inf.initValidation();
});

jQuery.fn.resetSummary = function () {
    var $form = this.is("form") ? this : this.closest("form");
    var $summary = $form.find("[data-valmsg-summary=true]");
    $summary.find("li").not(".inf-validation-serverside").remove();

    if ($summary.find("li").length < 1) {
        $summary
            .removeClass("validation-summary-errors")
            .addClass("validation-summary-valid");

        $form.find(".validation-summary-container").hide();
    }
    return this;
};
