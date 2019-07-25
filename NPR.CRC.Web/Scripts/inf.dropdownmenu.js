var inf = inf || {};

inf.initDropDownMenus = function ($parent) {
    /// <summary>
    /// Converts &lt;ul&gt; elements within the specified parent having class = "inf-dropdownmenu" to jquery ui menus.
    /// &#10;Expects a preceding element with class = "inf-dropdownmenu-header".
    /// &#10;If no parent is specified then the top-level document object will be used as the parent.
    /// &#10;
    /// &#10;Example: html markup:
    /// &#10;
    /// &#10;  &lt;a href="#" class="inf-dropdownmenu-header"&gt;Administration&lt;/a&gt;
    /// &#10;  &lt;ul class="inf-dropdownmenu"&gt;
    /// &#10;    &lt;li&gt;&lt;a href="@Url.Action("Index", "Admin")"&gt;Manage Users&lt;/a&gt;&lt;/li&gt;
    /// &#10;    &lt;li&gt;&lt;a href="@Url.Action("ManageUsers", "Admin")"&gt;Manage Applicants&lt;/a&gt;&lt;/li&gt;
    /// &#10;    &lt;li&gt;&lt;a href="@Url.Action("ManageLookups", "Admin")"&gt;Delete Applications&lt;/a&gt;&lt;/li&gt;
    /// &#10;  &lt;/ul&gt;
    /// </summary>

    $parent = $parent || $(document);

    var showMenu = function ($menu, $header) {
        $menu
            .show()
            .position({
                my: "left top",
                at: "left bottom",
                of: $header
            });
    };

    $parent.find(".inf-dropdownmenu").each(function () {
        var $menu = $(this);
        var $header = $menu.prev(".inf-dropdownmenu-header");

        $menu
            .menu()
            .css({
                position: "absolute"
            })
            .hide();

        $header
            .click(function () {
                showMenu($menu, $header);
                return false;
            })
            .mouseover(function () {
                showMenu($menu, $header);
            });
    });

    $(document).click(function () {
        $(".inf-dropdownmenu").hide();
    });
};

$(document).ready(function () {
    // auto-init drop down menus on page load
    inf.initDropDownMenus();
});