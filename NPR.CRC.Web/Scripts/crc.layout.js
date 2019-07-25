$(document).ready(function () {

    // if there is no content in the left menu area, then remove it
    var $layoutMiddleLeft = $(".layout-middle-left");
    if ($layoutMiddleLeft.text().trim().length < 1) {
        $layoutMiddleLeft.remove();

        var $layoutMiddleRight = $(".layout-middle-right");
        $layoutMiddleRight.attr("colspan", 2);
    }
});

