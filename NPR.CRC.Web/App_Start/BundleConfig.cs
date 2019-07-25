using System.Web;
using System.Web.Optimization;

namespace NPR.CRC.Web
{
    public static class BundleConfig
    {
        // For more information on Bundling, visit http://go.microsoft.com/fwlink/?LinkId=254725
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/js").Include(
                "~/Scripts/stacktrace.js",
                "~/Scripts/jquery-{version}.js",
                "~/Scripts/jquery-migrate-{version}.js",
                "~/Scripts/jquery-ui-{version}.js",
                "~/Scripts/jquery.unobtrusive*",
                "~/Scripts/jquery.validate*",
                "~/Scripts/requiredif.js",
                "~/Scripts/i18n/grid.locale-en.js",
                "~/Scripts/jquery.jqGrid*",
                "~/Scripts/modernizr-*",
                "~/Scripts/FileUpload/jquery.iframe-transport.js",
                "~/Scripts/FileUpload/jquery.fileupload.js",
                "~/Scripts/fullcalendar*",
                "~/Scripts/gcal.js",
                "~/Scripts/date.format.js",
                "~/Scripts/jquery.nextindom.js",
                "~/Scripts/Helper.js",

                // "inf" scripts
                "~/Scripts/inf.ajax.js",
                "~/Scripts/inf.stringutils.js",
                "~/Scripts/inf.mouseclick.js",
                "~/Scripts/inf.form.js",
                "~/Scripts/inf.messagebox.js",
                "~/Scripts/inf.logger.js",
                "~/Scripts/inf.button.js",
                "~/Scripts/inf.datepicker.js",
                "~/Scripts/inf.integertextbox.js",
                "~/Scripts/inf.checkboxlist.js",
                "~/Scripts/inf.fileupload.js",
                "~/Scripts/inf.jqgrid.js",
                "~/Scripts/inf.dropdownmenu.js",
                "~/Scripts/inf.validation.js",
                "~/Scripts/inf.dialog.js",

                // "crc" scripts
                "~/Scripts/crc.layout.js"
                ));

            bundles.Add(new StyleBundle("~/bundles/css").Include(
                "~/Content/site.css",
                "~/Content/themes/base/jquery.ui.all.css",
                "~/Content/jquery.jqGrid/ui.jqgrid.css",
                "~/Content/Fullcalendar/fullcalendar.css",
                "~/Content/Fullcalendar/fullcalendar.print.css"
                ));
        }
    }
}