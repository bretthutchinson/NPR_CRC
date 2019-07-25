using NPR.CRC.Library.DataAccess;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using InfoConcepts.Library.Validation;

namespace NPR.CRC.Web.ViewModels.ProgramAdmin
{
    public class AddEditMajorFormatViewModel
    {
        public long? MajorFormatId { get; set; }

        [Required]
        [DisplayName("Enter Major Format Name")]
        [InfUnique("MajorFormat", "MajorFormatName", "MajorFormatId")]
        public string MajorFormatName { get; set; }

        [Required]
        [DisplayName("Enter Major Format Code")]
        [InfUnique("MajorFormat", "MajorFormatCode", "MajorFormatId")]
        public string MajorFormatCode { get; set; }

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }

        public AddEditMajorFormatViewModel()
        {
            EnabledInd = true;
        }
    }
}