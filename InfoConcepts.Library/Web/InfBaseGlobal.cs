using System;
using System.Configuration;
using System.Globalization;
using System.Text;
using System.Web;
using InfoConcepts.Library.DataAccess;
using InfoConcepts.Library.Email;
using InfoConcepts.Library.Extensions;
using InfoConcepts.Library.Logging;

namespace InfoConcepts.Library.Web
{
    public class InfBaseGlobal : HttpApplication
    {
        public override void Init()
        {
            base.Init();

            InitSqlHelper();
            InitLogger();
            InitEmail();

            this.PreRequestHandlerExecute += InfBaseGlobal_PreRequestHandlerExecute;
            this.Error += InfBaseGlobal_Error;
        }

        private static void InitSqlHelper()
        {
            var defaultConnectionString = ConfigurationManager.AppSettings["Inf:DefaultConnectionString"];
            InfSqlHelper.DefaultConnectionString = ConfigurationManager.ConnectionStrings[defaultConnectionString].ConnectionString;
            InfSqlHelper.DefaultCommandTimeout = TimeSpan.FromSeconds(ConfigurationManager.AppSettings["Inf:DatabaseCommandTimeoutSeconds"].TryConvertTo<int>(5));
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        private static void InitEmail()
        {
            InfEmail.AutoStartQueue = ConfigurationManager.AppSettings["Inf:AutoStartEmailQueue"].TryConvertTo<bool>(false);
            InfEmail.QueueInterval = TimeSpan.FromSeconds(ConfigurationManager.AppSettings["Inf:EmailQueueIntervalSeconds"].TryConvertTo<int>(10));
            InfEmail.MaxRetryAttempts = ConfigurationManager.AppSettings["Inf:MaxEmailRetryAttempts"].TryConvertTo<int>(5);

            if (InfEmail.AutoStartQueue)
            {
                try
                {
                    InfEmail.StartQueue();
                }
                catch (Exception exception)
                {
                    InfLogger.Log(exception);
                }
            }
        }

        private static void HandleValidationException(HttpContext context)
        {
            context.Response.Clear();
            context.Response.StatusCode = 200;

            var message = "One or more elements of your previous request contains a character sequence representing a potential security risk. Please remove any special characters from data entry fields and try again. This page will be reloaded.";

            var responseContent = new StringBuilder();
            responseContent.Append("<html>");
            responseContent.Append("<head>");
            responseContent.Append("<title>Security Warning</title>");
            responseContent.Append("</head>");
            responseContent.Append("<body>");
            responseContent.Append("<script type=\"text/javascript\">");
            responseContent.Append("if (typeof(inf) !== \"undefined\" && inf.messageBox) {");
            responseContent.AppendFormat("inf.messageBox(\"{0}\", \"Security Warning\", null, function() {{", message);
            responseContent.Append("window.location.href = window.location.href;");
            responseContent.Append("});");
            responseContent.Append("} else {");
            responseContent.AppendFormat("alert(\"{0}\");", message);
            responseContent.Append("window.location.href = window.location.href;");
            responseContent.Append("}");

            responseContent.Append("</script>");
            responseContent.Append("</body>");
            responseContent.Append("</html>");

            context.Response.Write(responseContent);
            context.Response.End();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        private static void InitLogger()
        {
            try
            {
                var logLevelSetting = ConfigurationManager.AppSettings["Inf:ApplicationLogLevel"];
                if (!string.IsNullOrEmpty(logLevelSetting))
                {
                    InfLogger.ApplicationLogLevel = (InfLogLevel)Convert.ToInt32(logLevelSetting, CultureInfo.InvariantCulture);
                }
            }
            catch
            {
                InfLogger.ApplicationLogLevel = InfLogLevel.Information;
            }
        }

        protected void InfBaseGlobal_PreRequestHandlerExecute(object sender, EventArgs e)
        {
            InfLogger.Log(InfLogLevel.Debug, HttpContext.Current.Request.ToLogString());
        }

        protected void InfBaseGlobal_Error(object sender, EventArgs e)
        {
            var exception = Server.GetLastError();
            InfLogger.Log(exception);

            // HttpRequestValidationException is thrown by ASP.Net when a potentially malicious input string
            // is received from the client as part of the request data.
            // We want to handle it more gracefully than just displaying the default ASP.Net error page.
            // We also want to handle SQL injection validation exceptions the same way.
            if (exception is HttpRequestValidationException ||
                exception is InfSqlValidationException)
            {
                HandleValidationException(Context);
            }
        }
    }
}
