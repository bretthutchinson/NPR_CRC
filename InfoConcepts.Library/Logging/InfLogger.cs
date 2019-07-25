using System;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Security.Principal;
using System.Threading;
using System.Web;

namespace InfoConcepts.Library.Logging
{
    public static class InfLogger
    {
        #region Fields

        /// <summary>
        /// Logging will be attempted in the order the instances are defined here.
        /// </summary>
        private static IInfLogger[] loggerInstances = 
        {
            new InfLoggerSql(),
            new InfLoggerFile(),
            new InfLoggerEventLog()
        };

        /// <summary>
        /// When walking the stack trace to find the log entry source,
        /// skip over frames under any of the .Net Framework "System" or "Microsoft" namespaces
        /// or certain other infrastructure namespaces
        /// </summary>
        private static string[] sourceNamespacesToSkip =
        {
            "System",
            "Microsoft",
            "InfoConcepts.Library.DataAccess",
            "InfoConcepts.Library.Logging"
        };

        private static long _serialNumberUniquifier;

        #endregion

        #region Properties

        public static InfLogLevel ApplicationLogLevel
        {
            get;
            set;
        }

        #endregion

        #region Public Methods

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        public static string Log(InfLogEntry logEntry)
        {
            if (logEntry.LogLevel > ApplicationLogLevel)
            {
                return null;
            }

            logEntry.SerialNumber = GetSerialNumber();
            if (string.IsNullOrWhiteSpace(logEntry.Source))
            {
                logEntry.Source = GetSource();
            }

            logEntry.ServerAddress = GetServerAddress();
            logEntry.ServerHostname = GetServerHostname();
            logEntry.ClientAddress = GetClientAddress();
            logEntry.ClientHostname = GetClientHostname();

            if (string.IsNullOrWhiteSpace(logEntry.UserName))
            {
                logEntry.UserName = GetUserName();
            }

            ThreadPool.QueueUserWorkItem(
                delegate(object state)
                {
                    for (var i = 0; i < loggerInstances.Length; i++)
                    {
                        try
                        {
                            // todo: log logging errors
                            loggerInstances[i].Log(logEntry);
                        }
                        catch { }
                    }
                });

            return logEntry.SerialNumber;
        }

        public static string Log(InfLogLevel logLevel, string message)
        {
            return Log(new InfLogEntry
            {
                LogLevel = logLevel,
                Message = message
            });
        }

        public static string Log(InfLogLevel logLevel, string message, string userName)
        {
            return Log(new InfLogEntry
            {
                LogLevel = logLevel,
                Message = message,
                UserName = userName
            });
        }

        public static string Log(Exception exception)
        {
            var baseException = exception.GetBaseException();

            return Log(new InfLogEntry
            {
                LogLevel = InfLogLevel.Error,
                Message = string.Format(CultureInfo.InvariantCulture, "{0}: {1} {2}", baseException.GetType().FullName, baseException.Message, baseException.StackTrace),
            });
        }

        public static string Log(Exception exception, string message)
        {
            var baseException = exception.GetBaseException();

            return Log(new InfLogEntry
            {
                LogLevel = InfLogLevel.Error,
                Message = string.Format(CultureInfo.InvariantCulture, "{0} - {1}: {2} {3}", message, baseException.GetType().FullName, baseException.Message, baseException.StackTrace),
            });
        }

        public static string Log(Exception exception, string message, string userName)
        {
            var baseException = exception.GetBaseException();

            return Log(new InfLogEntry
            {
                LogLevel = InfLogLevel.Error,
                Message = string.Format(CultureInfo.InvariantCulture, "{0} - {1}: {2} {3}", message, baseException.GetType().FullName, baseException.Message, baseException.StackTrace),
                UserName = userName
            });
        }

        #endregion

        #region Private Methods

        private static string GetSerialNumber()
        {
            var serialNumber = DateTime.UtcNow.Ticks + Interlocked.Increment(ref _serialNumberUniquifier);
            return string.Format(CultureInfo.InvariantCulture, "{0:d20}", serialNumber);
        }

        private static string GetSource()
        {
            var stackTrace = new StackTrace(false);

            for (var i = 0; i < stackTrace.FrameCount; i++)
            {
                var stackFrame = stackTrace.GetFrame(i);
                var method = stackFrame.GetMethod();
                var type = method.ReflectedType;

                // don't skip the top-most stack frame regardless of namespace
                if (i < stackTrace.FrameCount - 1)
                {
                    if (sourceNamespacesToSkip.Any(ns => type.Namespace.Equals(ns, StringComparison.OrdinalIgnoreCase)))
                    {
                        continue;
                    }
                }

                return string.Concat(type.Namespace, ".", type.Name, ".", method.Name);
            }

            return "(Unknown)";
        }

        private static string GetUserName()
        {
            var httpContext = HttpContext.Current;
            if (httpContext != null &&
                httpContext.User != null &&
                httpContext.User.Identity != null)
            {
                return httpContext.User.Identity.Name;
            }
            else
            {
                return WindowsIdentity.GetCurrent().Name;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        private static string GetServerAddress()
        {
            var httpContext = HttpContext.Current;
            if (httpContext != null)
            {
                try { return httpContext.Request.ServerVariables["LOCAL_ADDR"]; }
                catch { }
            }

            var ipAddresses = Dns.GetHostAddresses(Dns.GetHostName());

            try { return ipAddresses.First(ip => !IPAddress.IsLoopback(ip) && ip.AddressFamily == AddressFamily.InterNetwork).ToString(); }
            catch { }

            try { return ipAddresses.First(ip => !IPAddress.IsLoopback(ip) && ip.AddressFamily == AddressFamily.InterNetworkV6).ToString(); }
            catch { }

            try { return ipAddresses.First(ip => !IPAddress.IsLoopback(ip)).ToString(); }
            catch { }

            try { return ipAddresses.First().ToString(); }
            catch { }

            return "(Unknown)";
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        private static string GetServerHostname()
        {
            var httpContext = HttpContext.Current;
            if (httpContext != null)
            {
                try { return httpContext.Request.ServerVariables["SERVER_NAME"]; }
                catch { }
            }

            return Dns.GetHostName();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        private static string GetClientAddress()
        {
            var httpContext = HttpContext.Current;
            if (httpContext != null)
            {
                try { return httpContext.Request.ServerVariables["REMOTE_ADDR"]; }
                catch { }
            }

            return GetServerAddress();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        private static string GetClientHostname()
        {
            var httpContext = HttpContext.Current;
            if (httpContext != null)
            {
                try { return httpContext.Request.ServerVariables["REMOTE_HOST"]; }
                catch { }
            }

            return GetServerHostname();
        }

        #endregion
    }
}
