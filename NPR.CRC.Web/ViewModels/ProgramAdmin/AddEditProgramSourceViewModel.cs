using NPR.CRC.Library.DataAccess;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using InfoConcepts.Library.Validation;

namespace NPR.CRC.Web.ViewModels.ProgramAdmin
{
    public class AddEditProgramSourceViewModel
    {
        public long? ProgramSourceId { get; set; }

        [Required]
        [DisplayName("Enter Program Source Name")]
        [InfUnique("ProgramSource", "ProgramSourceName", "ProgramSourceId")]
        public string ProgramSourceName { get; set; }

        [Required]
        [DisplayName("Enter Program Source Code")]
        [InfUnique("ProgramSource", "ProgramSourceCode", "ProgramSourceId")]
        public string ProgramSourceCode { get; set; }

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }

        public AddEditProgramSourceViewModel()
        {
            EnabledInd = true;
        }
    }
}