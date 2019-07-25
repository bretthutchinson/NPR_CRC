#region Using
using System;
using System.IO;
using System.Web;
#endregion

namespace InfoConcepts.Library.Utilities
{
    public class InfDocument
    {
        public long? InfDocumentId { get; set; }
        public string ParentName { get; set; }
        public string DocumentFileName { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1819:PropertiesShouldNotReturnArrays")]
        public byte[] DocumentDataContent { get; set; }
        public string DocumentDescription { get; set; }
        public DateTime? CreatedDate { get; set; }
        public long? CreatedUserId { get; set; }
        public string CreatedUserName { get; set; }
        public DateTime? LastUpdatedDate { get; set; }
        public long? LastUpdatedUserId { get; set; }
        public string LastUpdatedUserName { get; set; }

        public long Size
        {
            get { return DocumentDataContent != null ? DocumentDataContent.Length : 0; }
        }

        public string FileExtension
        {
            get { return DocumentFileName != null ? Path.GetExtension(DocumentFileName) : string.Empty; }
        }

        public string MimeType
        {
            get { return DocumentFileName != null ? MimeMapping.GetMimeMapping(DocumentFileName) : string.Empty; }
        }
    }
}
