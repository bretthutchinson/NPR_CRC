using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using InfoConcepts.Library.Validation;

namespace NPR.CRC.Web.ViewModels.StationAdmin
{
    public class AddEditMinorityStatusViewModel
    {
        public long? MinorityStatusId { get; set; }
        public DateTime DisabledDate { get; set; }

        [Required]
        [DisplayName("Enter Minority Status Name")]
        [InfUnique("MinorityStatus", "MinorityStatusName", "MinorityStatusId")]
        public string MinorityStatusName { get; set; }        

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }



        public AddEditMinorityStatusViewModel()
        {
            EnabledInd = true;
        }
    }
}