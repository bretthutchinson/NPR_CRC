var inf = inf || {};

// global jqgrid event handlers
var origJqGrid = $.fn.jqGrid;
$.fn.jqGrid = function () {
    this.on("jqGridBeforeRequest", function () {
        $(this).data("jqGridAfterLoadCompleteHandled", false);
    });
    this.on("jqGridAfterLoadComplete", function (e) {
        var $this = $(this);
        if ($this.data("jqGridAfterLoadCompleteHandled") !== true) {
            $this.data("jqGridAfterLoadCompleteHandled", true);
            inf.initButtons();
            inf.initDialogLinks($this);
            inf.initGridRowSelection($this.parent());
            inf.initConfirmationMessages($this);
        }
    });
    this.on("jqGridBeforeSelectRow", function (rowid, e) {
        return false;
    });
    return origJqGrid.apply(this, arguments);
};
$.extend($.fn.jqGrid, origJqGrid);

// extensions to the jqgrid plugin
$.jgrid.extend({
    addPostData: function (extraPostData) {
        /// <summary>
        /// Appends additional data arguments to the jqgrid ajax request.
        /// &#10;This should be called from within the jqgrid beforerequest event.
        /// &#10;extraPostData can be the name or id of an input element, a jquery object that wraps an input element, or a json object.
        /// &#10;
        /// &#10;Example 1: add post data from a form input element, by input name or id:
        /// &#10;
        /// &#10;  $grid.addPostData("FirstName"); // assuming you have an element &lt;nput type="text" name="FirstName" /&gt;
        /// &#10;
        /// &#10;Example 2: add post data from a jquery object that wraps a form input element:
        /// &#10;
        /// &#10;  var $firstName = $("#FirstName");
        /// &#10;  $grid.addPostData($firstName);
        /// &#10;
        /// &#10;Example 3: add post data from a json object:
        /// &#10;
        /// &#10;  $grid.addPostData({
        /// &#10;    firstName: "John",
        /// &#10;    lastName: "Smith"
        /// &#10;  });
        /// </summary>

        var postData = this.getGridParam("postData");
        var $el = null;

        if (extraPostData instanceof jQuery) {
            $el = extraPostData;
        }
        else if (typeof (extraPostData) === "string") {
            if (extraPostData.substring(0, 1) !== "#") {
                extraPostData = "#" + extraPostData;
            }
            $el = $(extraPostData);
        }

        if ($el && $el.length > 0) {
            var name = $el.attr("name") || $el.attr("id");
            var d = {};
            if ($el.is(":radio") || $el.is(":checkbox")) {
                d[name] = $el.is(":checked");
            }
            else {
                d[name] = $el.val();
            }
            $.extend(postData, d);
        }
        else {
            $.extend(postData, extraPostData);
        }
    },

    resetPostData: function () {
        /// <summary>
        /// Removes all data arguments that have been previously added with addPostData().
        /// </summary>
        var postData = this.getGridParam("postData");
        for (var el in postData) {
            if (el.startsWith("_") || el === "filters" || el === "nd" || el === "page" || el === "rows" || el === "sidx" || el === "sord") {
                continue;
            }
            else {
                delete postData[el];
            }
            console.log(el);
        }
    },

    getSelectedRowIds: function () {
        /// <summary>
        /// Gets the IDs of the selected grid rows.
        /// </summary>

        var selectedRowIds = [];
        // find rows that contain a checked .inf-gridrowselect
        this.find("tr .inf-gridrowselect:checked").each(function () {
            selectedRowIds.push($(this).closest("tr").attr("id"));
        });
        return selectedRowIds;
    },

    getSelectedRowObjects: function () {
        /// <summary>
        /// Gets the jqGrid rowObject's for the selected grid rows.
        /// </summary>

        var $grid = this;
        var selectedRowObjects = [];
        $.each(this.getSelectedRowIds(), function (index, rowId) {
            selectedRowObjects.push($grid.getRowData(rowId));
        });
        return selectedRowObjects;
    },

    getSelectedRowProperties: function (propertyName) {
        /// <summary>
        /// Gets the specified property values from the jqGrid rowObject's for the selected grid rows.
        /// </summary>

        var $grid = this;
        var selectedRowProperties = [];
        $.each(this.getSelectedRowObjects(), function (index, rowObject) {
            selectedRowProperties.push(rowObject[propertyName]);
        });
        return selectedRowProperties;
    }
});


inf.initExportGridButtons = function ($parent) {
    /// <summary>
    /// Adds export-to-csv functionality to all &lt;form&gt; elements within the specified parent
    /// having class = "inf-exportgrid"
    /// </summary>

    $parent = $parent || $(document);

    $parent.find("form.inf-exportgrid").each(function () {
        var $form = $(this);
        $form.submit(function () {
            var gridId = $form.data("gridid");
            
            var $grid = $("#" + gridId).closest(".ui-jqgrid");

            var headers = [];
            $grid.find(".ui-jqgrid-htable th:visible").each(function () {
                headers.push($(this).text());
            });

            var dataRows = [];
            $grid.find(".ui-jqgrid-btable tr:visible").each(function () {

                // if the first visible cell contains an unchecked checkbox, then skip exporting this row
                if ($(this).find("td:visible:first").find("input[type=checkbox]:not(:checked)").length > 0) {
                    return true;
                }

                var dataCells = [];
                $(this).find("td:visible").each(function () {
                    dataCells.push($(this).text());
                });

                dataRows.push(dataCells);
            });

            $form.find("input[name=gridHeaders]").val(JSON.stringify(headers));
            $form.find("input[name=gridData]").val(JSON.stringify(dataRows));

            return true;
        });
    });
};

inf.initGridRowSelection = function ($parent) {
    /// <summary>
    /// For all grids within the specified parent, if the first visible column is a checkbox,
    /// then uses that checkbox as a row selector.
    /// </summary>

    $parent = $parent || $(document);

    $parent.find(".ui-jqgrid-btable").each(function () {
        var $grid = $(this);
        var $container = $grid.closest(".ui-jqgrid");

        // if the first visible cell in each row contains a checkbox, then assume the checckbox is meant to be a row-selector
        $grid.find("tr:visible").each(function () {
            $(this).find("td:visible:first").find("input[type=checkbox]")
                .addClass("inf-gridrowselect")
                .change(function () {
                    var allSelected = $grid.find(".inf-gridrowselect:checked").length === $grid.find(".inf-gridrowselect").length;
                    $container.find(".inf-gridrowselect-all").prop("checked", allSelected);
                });

            // Only for search schedule grid
            $(this).find("td:visible").eq(9).find("input[type=checkbox]")
                .addClass("inf-gridrowaccepted")

            // Only for search schedule grid
            $(this).find("td:visible").eq(10).find("input[type=checkbox]")
                .addClass("inf-gridrowunaccepted")
        });

        // if the grid now contains row selectors, then convert the corresponding header cell into a select-all/unselect-all checkbox
        if ($grid.find(".inf-gridrowselect").length > 0) {
            var $headerCell = $container.find(".ui-jqgrid-htable tr:visible:first th:visible:first");
            var $checkbox = $("<input></input>")
                .attr("type", "checkbox")
                .addClass("inf-gridrowselect-all")
                .change(function () {
                    $grid.find(".inf-gridrowselect").prop("checked", $(this).prop("checked"));
                });
            $headerCell
                .empty()
                .append("<label>Select</label><br>")
                .append($checkbox);

            // Only for search schedule grid
            if ($('#SearchSchedulesGrid').length >0 ) {
                $headerCell = $container.find(".ui-jqgrid-htable tr:visible:first th:visible").eq(9);
                $checkbox = $("<input></input>")
                    .attr("type", "checkbox")
                    .addClass("inf-gridrowselect-all")
                    .change(function () {
                        $grid.find(".inf-gridrowaccepted").prop("checked", $(this).prop("checked"));
                    });
                $headerCell
                    .empty()
                    .append("<label>Accepted</label><br>")
                    .append($checkbox);
            }

            // Only for search schedule grid
            $headerCell = $container.find(".ui-jqgrid-htable tr:visible:first th:visible").eq(10);
            $checkbox = $("<input></input>")
                .attr("type", "checkbox")
                .addClass("inf-gridrowselect-all")
                .change(function () {
                    $grid.find(".inf-gridrowunaccepted").prop("checked", $(this).prop("checked"));
                });
            $headerCell
                .empty()
                .append("<label>Unaccepted</label><br>")
                .append($checkbox);
        }
    });
};

inf.indicatorColumnFormatter = function (cellValue, options, rowObject) {
    if (cellValue.startsWith("Y")) {
        return "Yes";
    }
    else if (cellValue.startsWith("N")) {
        return "No";
    }
    else {
        return "(n/a)";
    }
};

inf.genderColumnFormatter = function (cellValue, options, rowObject) {
    if (cellValue.startsWith("M")) {
        return "Male";
    }
    else if (cellValue.startsWith("F")) {
        return "Female";
    }
    else {
        return "(n/a)";
    }
};

$(document).ready(function () {
    // auto-init grid features on page load
    inf.initExportGridButtons();
});
