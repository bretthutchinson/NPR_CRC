using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using InfoConcepts.Library.Validation;

namespace NPR.CRC.Web.ViewModels.StationAdmin
{
    public class AddEditMemberStatusViewModel
    {
        public long? MemberStatusId { get; set; }
        public DateTime DisabledDate { get; set; }

        [Required]
        [DisplayName("Enter Member Status Name")]
        [InfUnique("MemberStatus", "MemberStatusName", "MemberStatusId")]
        public string MemberStatusName { get; set; }        

        [DisplayName("Enabled")]
        public bool NPRMemberShipInd { get; set; }



        public AddEditMemberStatusViewModel()
        {
            NPRMemberShipInd = true;
        }
    }
}