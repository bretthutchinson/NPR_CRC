using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using InfoConcepts.Library.Validation;

namespace NPR.CRC.Web.ViewModels.StationAdmin
{
    public class AddEditLicenseeTypeViewModel
    {
        public long? LicenseeTypeId { get; set; }
        public DateTime DisabledDate { get; set; }

        [Required]
        [DisplayName("Enter Licensee Type Name")]
        [InfUnique("LicenseeType", "LicenseeTypeName", "LicenseeTypeId")]
        public string LicenseeTypeName { get; set; }        

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }



        public AddEditLicenseeTypeViewModel()
        {
            EnabledInd = true;
        }
    }
}