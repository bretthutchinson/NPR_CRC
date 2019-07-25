using System;
using System.Globalization;
using System.IO;
using System.Text;
using System.Web;
using System.Xml;

namespace InfoConcepts.Library.Logging
{
    internal class InfLoggerFile : IInfLogger
    {
        #region Fields

        private XmlWriterSettings _xmlWriterSettings = new XmlWriterSettings
        {
            Indent = true
        };

        #endregion

        #region Properties

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        private static string LogFileName
        {
            get
            {
                var httpContext = HttpContext.Current;
                if (httpContext != null)
                {
                    try
                    {
                        var siteRootDirectory = new DirectoryInfo(httpContext.Request.PhysicalApplicationPath);

                        return Path.Combine(
                            siteRootDirectory.FullName,
                            string.Format(CultureInfo.InvariantCulture, "{0}_{1:yyyy-MM-dd}.log", siteRootDirectory.Name, DateTime.Today));
                    }
                    catch { }
                }

                // todo: implement for non-web contexts
                throw new NotImplementedException();
            }
        }

        #endregion

        public void Log(InfLogEntry logEntry)
        {
            var logEntryString = new StringBuilder();

            using (var xmlWriter = XmlWriter.Create(logEntryString, _xmlWriterSettings))
            {
                xmlWriter.WriteStartElement("InfLogEntry");

                xmlWriter.WriteStartElement("SerialNumber");
                xmlWriter.WriteValue(logEntry.SerialNumber);
                xmlWriter.WriteEndElement();

                xmlWriter.WriteStartElement("LogDate");
                xmlWriter.WriteValue(string.Format(CultureInfo.InvariantCulture, "{0:yyyy-MM-dd hh:mm:ss.fff tt}", DateTime.Now));
                xmlWriter.WriteEndElement();

                xmlWriter.WriteStartElement("Source");
                xmlWriter.WriteValue(logEntry.Source);
                xmlWriter.WriteEndElement();

                xmlWriter.WriteStartElement("Message");
                xmlWriter.WriteValue(logEntry.Message);
                xmlWriter.WriteEndElement();

                xmlWriter.WriteStartElement("UserName");
                xmlWriter.WriteValue(logEntry.UserName);
                xmlWriter.WriteEndElement();

                xmlWriter.WriteStartElement("ServerAddress");
                xmlWriter.WriteValue(logEntry.ServerAddress);
                xmlWriter.WriteEndElement();

                xmlWriter.WriteStartElement("ServerHostname");
                xmlWriter.WriteValue(logEntry.ServerHostname);
                xmlWriter.WriteEndElement();

                xmlWriter.WriteStartElement("ClientAddress");
                xmlWriter.WriteValue(logEntry.ClientAddress);
                xmlWriter.WriteEndElement();

                xmlWriter.WriteStartElement("ClientHostname");
                xmlWriter.WriteValue(logEntry.ClientHostname);
                xmlWriter.WriteEndElement();

                xmlWriter.WriteEndElement(); // </InfLogEntry >
                xmlWriter.Flush();
            }

            File.AppendAllText(LogFileName, logEntryString.ToString());
        }
    }
}
