using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;

namespace InfoConcepts.Library.Web.Mvc
{
    public static class HtmlHelpers
    {
        public static HtmlString InfDocumentLink(this HtmlHelper helper, string linkText, string documentFileName)
        {
            return helper.InfDocumentLink(linkText, null, documentFileName, null);
        }

        public static HtmlString InfDocumentLink(this HtmlHelper helper, string linkText, string documentFileName, object htmlAttributes)
        {
            return helper.InfDocumentLink(linkText, null, documentFileName, htmlAttributes);
        }

        public static HtmlString InfDocumentLink(this HtmlHelper helper, string linkText, string parentName, string documentFileName)
        {
            return helper.InfDocumentLink(linkText, parentName, documentFileName, null);
        }

        public static HtmlString InfDocumentLink(this HtmlHelper helper, string linkText, string parentName, string documentFileName, object htmlAttributes)
        {
            return helper.ActionLink(
                linkText,
                "InfDocument",
                "InfBase",
                new
                {
                    parentName = parentName,
                    documentFileName = documentFileName
                },
                htmlAttributes);
        }
    }
}
