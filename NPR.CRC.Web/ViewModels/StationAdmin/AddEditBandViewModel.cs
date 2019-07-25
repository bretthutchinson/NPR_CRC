using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using InfoConcepts.Library.Validation;

namespace NPR.CRC.Web.ViewModels.StationAdmin
{
    public class AddEditBandViewModel
    {
        public long? BandId { get; set; }
        public DateTime DisabledDate { get; set; }

        [Required]
        [DisplayName("Enter Band Name")]
        [InfUnique("Band", "BandName", "BandId")]
        public string BandName { get; set; }        

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }



        public AddEditBandViewModel()
        {
            EnabledInd = true;
        }
    }
}