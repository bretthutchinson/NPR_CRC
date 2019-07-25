$(document).ready(function () {
    $("input.inf-entersubmit").keypress(function (e) {
        if (e.which === 13) {
            $(this).closest("form").submit();
            e.preventDefault();
        }
    });
});
