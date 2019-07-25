using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InfoConcepts.Library.Utilities;
using System.Globalization;
using System.ComponentModel;
using NPR.CRC.Library.DataAccess;

namespace NPR.CRC.Web.ViewModels.StationAdmin
{
    public class ImportDocumentAQHCumeViewModel
    {
        public long? ApplicationId { get; set; }

        [DisplayName("Document")]
        public HttpPostedFileBase Document { get; set; }

        [DisplayName("Import Type")]
        public string ImportType { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1002:DoNotExposeGenericLists")]
        public List<ImportAQHCumeViewModel> Results { get; set; }

        public ImportDocumentAQHCumeViewModel() { }

        #region Validation

        [AttributeUsage(AttributeTargets.Property)]
        internal sealed class CsvFileExtensionsAttribute : ValidationAttribute
        {
            protected override ValidationResult IsValid(object value, ValidationContext validationContext)
            {

                var model = (ImportDocumentAQHCumeViewModel)validationContext.ObjectInstance;
                var file = model.Document;

                if (file.ContentType != "text/csv" && file.ContentType != "application/vnd.ms-excel")
                {
                    var message = string.Format(CultureInfo.InvariantCulture, "The import file format must be CSV.");

                    return new ValidationResult(message, new[] { validationContext.MemberName });
                }

                return ValidationResult.Success;
            }
        }

        #endregion
    }
}