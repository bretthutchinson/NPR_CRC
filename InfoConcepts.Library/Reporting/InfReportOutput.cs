using System;

namespace InfoConcepts.Library.Reporting
{
    public class InfReportOutput
    {
        public string FileExtension { get; set; }
        public string MimeType { get; set; }
        public string Encoding { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1819:PropertiesShouldNotReturnArrays")]
        public byte[] ReportBytes { get; set; }
    }
}
