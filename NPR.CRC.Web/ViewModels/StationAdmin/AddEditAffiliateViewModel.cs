using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using InfoConcepts.Library.Validation;

namespace NPR.CRC.Web.ViewModels.StationAdmin
{
    public class AddEditAffiliateViewModel
    {
        public long? AffiliateId { get; set; }

        [Required]
        [DisplayName("Enter Affiliate Name")]
        [InfUnique("Affiliate", "AffiliateName", "AffiliateId")]
        public string AffiliateName { get; set; }

        [Required]
        [DisplayName("Enter Affiliate Code")]
        [InfUnique("Affiliate", "AffiliateCode", "AffiliateId")]
        public string AffiliateCode { get; set; }

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }

        public AddEditAffiliateViewModel()
        {
            EnabledInd = true;
        }
    }
}