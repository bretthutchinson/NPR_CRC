using System;
using System.Collections;
using System.Data;
using System.Globalization;
using System.IO;
using System.Text;
using System.Web.Mvc;
using System.Web.Security;
using InfoConcepts.Library.Email;
using InfoConcepts.Library.Extensions;
using InfoConcepts.Library.Logging;
using InfoConcepts.Library.Security;
using InfoConcepts.Library.Utilities;
using MvcJqGrid;
using Newtonsoft.Json;

namespace InfoConcepts.Library.Web.Mvc
{
    public class InfBaseController : Controller
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1709:IdentifiersShouldBeCasedCorrectly", MessageId = "Jq"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        protected InfJqGridDataResult InfJqGridData(DataTable gridData, GridSettings gridSettings)
        {
            return new InfJqGridDataResult(gridData, gridSettings);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1709:IdentifiersShouldBeCasedCorrectly", MessageId = "Jq"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        protected InfJqGridDataResult InfJqGridData(IEnumerable gridData, GridSettings gridSettings)
        {
            return new InfJqGridDataResult(gridData, gridSettings);
        }

        protected ActionResult SignOutResult(string actionName)
        {
            return SignOutResult(actionName, null);
        }

        protected ActionResult SignOutResult(string actionName, string controllerName)
        {
            FormsAuthentication.SignOut();
            Session.Abandon();
            Response.Cookies.Remove(FormsAuthentication.FormsCookieName);

            var cookie = Request.Cookies[FormsAuthentication.FormsCookieName];
            if (cookie != null)
            {
                cookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(cookie);
            }

            Response.Cache.SetExpires(DateTime.Now.AddDays(-1));

            return RedirectToAction(actionName, controllerName);
        }

        new protected JsonResult Json(object data)
        {
            return this.Json(data, null, null, JsonRequestBehavior.DenyGet);
        }

        new protected JsonResult Json(object data, string contentType)
        {
            return this.Json(data, contentType, null, JsonRequestBehavior.DenyGet);
        }

        override protected JsonResult Json(object data, string contentType, Encoding contentEncoding)
        {
            return this.Json(data, contentType, contentEncoding, JsonRequestBehavior.DenyGet);
        }

        new protected JsonResult Json(object data, JsonRequestBehavior behavior)
        {
            return this.Json(data, null, null, behavior);
        }

        new protected JsonResult Json(object data, string contentType, JsonRequestBehavior behavior)
        {
            return this.Json(data, contentType, null, behavior);
        }

        override protected JsonResult Json(object data, string contentType, Encoding contentEncoding, JsonRequestBehavior behavior)
        {
            return new InfJsonDotNetResult
            {
                Data = data,
                ContentType = contentType,
                ContentEncoding = contentEncoding,
                JsonRequestBehavior = behavior
            };
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult Log(int logLevel, string source, string message)
        {
            return Json(InfLogger.Log(new InfLogEntry
                {
                    LogLevel = (InfLogLevel)logLevel,
                    Source = source,
                    Message = message
                }));
        }

        protected ActionResult InfDocument(string parentName, string documentFileName)
        {
            var document = InfDatabaseConfigurable.GetDocument(parentName, documentFileName);

            if (document == null)
            {
                return HttpNotFound();
            }
            else
            {
                return File(document.DocumentDataContent, document.MimeType, document.DocumentFileName);
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1822:MarkMembersAsStatic")]
        protected ActionResult Empty()
        {
            return new EmptyResult();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        public ActionResult StartEmailQueue()
        {
            try
            {
                InfEmail.StartQueue();
                return Content("The email queue was started successfully.");
            }
            catch (Exception exception)
            {
                var baseException = exception.GetBaseException();
                InfLogger.Log(baseException);
                return Content(string.Format(CultureInfo.InvariantCulture, "An error occurred while attempting to start the email queue: {0}", baseException.Message));
            }
        }

        protected InfUserPrincipal InfUser
        {
            get { return User as InfUserPrincipal; }
        }

        [HttpPost]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2202:Do not dispose objects multiple times")]
        public ActionResult ExportGrid(string outputFileName, string gridHeaders, string gridData)
        {
            if (string.IsNullOrWhiteSpace(outputFileName))
            {
                outputFileName = "Export";
            }

            if (!Path.HasExtension(outputFileName))
            {
                outputFileName = Path.ChangeExtension(outputFileName, ".csv");
            }

            using (var memoryStream = new MemoryStream())
            {
                using (var streamWriter = new StreamWriter(memoryStream, Encoding.UTF8))
                {
                    if (!string.IsNullOrWhiteSpace(gridHeaders))
                    {
                        var gridHeadersArray = JsonConvert.DeserializeObject<string[]>(gridHeaders);
                        streamWriter.WriteLine(gridHeadersArray.ToCsvString());
                    }

                    if (!string.IsNullOrWhiteSpace(gridData))
                    {
                        var gridDataArray = JsonConvert.DeserializeObject<string[][]>(gridData);
                        foreach (var row in gridDataArray)
                        {
                            streamWriter.WriteLine(row.ToCsvString());
                        }
                    }

                    streamWriter.Flush();
                    return File(memoryStream.ToArray(), "text/csv", outputFileName);
                }
            }
        }
    }
}
