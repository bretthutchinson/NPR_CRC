#region Using
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using InfoConcepts.Library.Logging;
using Microsoft.Reporting.WebForms;
#endregion

namespace InfoConcepts.Library.Reporting
{
    public class InfReport : IDisposable
    {
        #region Public Properties

        public string FileName
        {
            get;
            private set;
        }

        #endregion

        #region Private Properties

        private IDictionary<string, DataTable> DataTables
        {
            get;
            set;
        }

        private IDictionary<string, string> Parameters
        {
            get;
            set;
        }

        #endregion

        #region Constructors

        public InfReport(string fileName)
        {
            FileName = fileName;
            DataTables = new Dictionary<string, DataTable>(StringComparer.OrdinalIgnoreCase);
            Parameters = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        }

        #endregion

        #region Public Methods

        public void AddDataTable(string dataTableName, DataTable dataTable)
        {
            if (string.IsNullOrWhiteSpace(dataTableName))
            {
                throw new ArgumentNullException("dataTableName");
            }

            if (DataTables.ContainsKey(dataTableName))
            {
                var message = string.Format(CultureInfo.InvariantCulture, "Another data table named \"{0}\" has already been added.", dataTableName);
                throw new ArgumentException(message, "dataTableName");
            }

            if (dataTable == null)
            {
                throw new ArgumentNullException("dataTable");
            }

            dataTable.TableName = dataTableName;
            DataTables.Add(dataTableName, dataTable);
        }

        public void AddParameter(string parameterName, string parameterValue)
        {
            if (string.IsNullOrWhiteSpace(parameterName))
            {
                throw new ArgumentNullException("parameterName");
            }

            if (DataTables.ContainsKey(parameterName))
            {
                var message = string.Format(CultureInfo.InvariantCulture, "Another data parameter named \"{0}\" has already been added.", parameterName);
                throw new ArgumentException(message, "parameterName");
            }

            if (string.IsNullOrWhiteSpace(parameterValue))
            {
                throw new ArgumentNullException("parameterValue");
            }

            Parameters.Add(parameterName, parameterValue);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity")]
        public InfReportOutput Render(InfReportFormat format)
        {
            if (string.IsNullOrWhiteSpace(FileName))
            {
                throw new InvalidOperationException("The report file name property has not been set.");
            }

            if (FileName.StartsWith("/", StringComparison.Ordinal) && HttpContext.Current != null)
            {
                FileName = HttpContext.Current.Server.MapPath(FileName);
            }

            if (!File.Exists(FileName))
            {
                throw new FileNotFoundException("The specified report file name does not exist. Be sure to provide the full path, and set the \"Build Action\" of the report file to \"Content\".", FileName);
            }

            try
            {
                using (var report = new LocalReport())
                {
                    report.ReportPath = FileName;

                    foreach (var dataSourceName in report.GetDataSourceNames())
                    {
                        if (!DataTables.Any(dt => dt.Key.Equals(dataSourceName, StringComparison.OrdinalIgnoreCase)))
                        {
                            var message = string.Format(CultureInfo.InvariantCulture, "No data table has been added for the report data source name \"{0}\".", dataSourceName);
                            throw new InvalidOperationException(message);
                        }
                    }

                    foreach (var parameter in report.GetParameters())
                    {
                        if (!Parameters.Any(p => p.Key.Equals(parameter.Name, StringComparison.OrdinalIgnoreCase)))
                        {
                            var message = string.Format(CultureInfo.InvariantCulture, "No parameter has been added for the report parameter \"{0}\".", parameter.Name);
                            throw new InvalidOperationException(message);
                        }
                    }

                    report.EnableExternalImages = true;
                    report.EnableHyperlinks = true;
                    report.DataSources.Clear();

                    foreach (var item in DataTables)
                    {
                        report.DataSources.Add(new ReportDataSource(item.Key, item.Value));
                    }

                    foreach (var item in Parameters)
                    {
                        report.SetParameters(new ReportParameter(item.Key, item.Value));
                    }

                    if (!report.IsReadyForRendering)
                    {
                        throw new InvalidOperationException("The report is not ready for rendering. Check that all required data tables and parameters have been added.");
                    }

                    var reportBytes = new byte[0];
                    var mimeType = string.Empty;
                    var fileExtension = string.Empty;
                    var encoding = string.Empty;
                    var streams = new string[0];
                    var warnings = new Warning[0];

                    report.Refresh();
                    reportBytes = report.Render(
                        format.ToString(),
                        string.Empty, // device info
                        out mimeType,
                        out encoding,
                        out fileExtension,
                        out streams,
                        out warnings);

                    if (warnings != null && warnings.Length > 0 && warnings.Any(w => w.Severity == Severity.Error))
                    {
                        var message = new StringBuilder();
                        message.Append("The following error(s) occurred during report rendering: ");

                        foreach (var warning in warnings.Where(w => w.Severity == Severity.Error))
                        {
                            message.AppendFormat(
                                CultureInfo.InvariantCulture,
                                "code = \"{0}\"; object name = \"{1}\"; object type = \"{2}\"; message = \"{3}\".",
                                warning.Code,
                                warning.ObjectName,
                                warning.ObjectType,
                                warning.Message);
                        }
                    }

                    return new InfReportOutput
                    {
                        FileExtension = fileExtension,
                        MimeType = mimeType,
                        Encoding = encoding,
                        ReportBytes = reportBytes
                    };
                }
            }
            catch (Exception ex)
            {
                InfLogger.Log(ex);
                throw;
            }
        }

        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                foreach (var item in DataTables)
                {
                    if (item.Value != null)
                    {
                        item.Value.Dispose();
                    }
                }
            }
        }

        #endregion
    }
}
