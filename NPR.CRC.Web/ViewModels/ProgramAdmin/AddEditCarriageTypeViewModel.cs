using NPR.CRC.Library.DataAccess;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using InfoConcepts.Library.Validation;

namespace NPR.CRC.Web.ViewModels.ProgramAdmin
{
    public class AddEditCarriageTypeViewModel
    {
        public long? CarriageTypeId { get; set; }

        [Required]
        [DisplayName("Enter Carriage Type Name")]
        [InfUnique("CarriageType", "CarriageTypeName", "CarriageTypeId")]
        public string CarriageTypeName { get; set; }

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }

        public AddEditCarriageTypeViewModel()
        {
            EnabledInd = true;
        }
    }
}