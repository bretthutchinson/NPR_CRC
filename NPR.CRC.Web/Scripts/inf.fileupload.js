var inf = inf || {};

inf.initFileUploads = function ($parent) {
    /// <summary>
    /// Enables ajax uploads for all file upload elements within the specified parent
    /// &#10; If no parent is specified then the top-level document object will be used as the parent.
    /// </summary>

    $parent = $parent || $(document);

    $parent.find("input[type=file]").infFileUpload();
};

$(document).ready(function () {
    // auto-init file uploads on page load
    inf.initFileUploads();
});

// infFileUplpad custom jquery plugin
// based on and requires jquery file upload plugin: https://github.com/blueimp/jQuery-File-Upload
(function ($) {
    $.fn.extend({
        infFileUpload: function (options) {
            var defaults = {};
            var options = $.extend(defaults, options, this.data("inffileuploadoptions"));

            return this.each(function () {
                var $input = $(this);
                var $form = $input.closest("form");

                $input.addClass("inf-fileupload");

                var $inputWrapper = $("<div></div>")
                    .height(0)
                    .width(0)
                    .css({
                        overflow: "hidden"
                    });
                $inputWrapper.appendTo($input.parent());
                $input.appendTo($inputWrapper);

                var $filename = $("<input type='text' />")
                    .prop("readonly", true)
                    .attr("id", "_" + $input.attr("id"))
                    .attr("name", "_" + $input.attr("name"))
                    .insertAfter($inputWrapper);

                // remove all the data-val-* attributes from $input, and add them to $filename
                var inputAttributes = $input.prop("attributes");
                for (var i = inputAttributes.length - 1; i >= 0; i--) {
                    var attrName = inputAttributes[i].name;
                    var attrValue = inputAttributes[i].value;

                    if (attrName.startsWith("data-val")) {
                        $input.removeAttr(attrName);
                        $filename.attr(attrName, attrValue);
                    }
                }

                var $button = $("<span></span>")
                    .text("Browse...")
                    .button()
                    .click(function () {
                        $input.fileupload({
                            formData: $form.serializeArray(),
                            add: function (e, data) {
                                $filename.val(data.files[0].name);
                                $form.submit(function () {
                                    data.submit();
                                    return false;
                                });
                            },
                            submit: function (e, data) {
                                return (data.files[0].name === $filename.val());
                            },
                            success: function (data, textStatus, jqXHR) {
                                var inputId = $input.attr("id");
                                $input = $("#" + inputId);
                                var dialogId = $input.closest(".ui-dialog-content").attr("id");
                                if (dialogId) {
                                    inf.dialogSuccess(data, textStatus, jqXHR, dialogId);
                                }
                                else {
                                    var successContentContainerId = $input.data("infsuccesscontentcontainerid");
                                    if (successContentContainerId) {
                                        var $successContentContainer = $("#" + successContentContainerId);
                                        if ($successContentContainer.length > 0) {
                                            $successContentContainer.html(data);
                                        }
                                    }
                                }
                            }
                        });

                        $input.click();
                    });
                $button.insertAfter($filename);
            });
        }
    });
})(jQuery);