using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using InfoConcepts.Library.Validation;
using NPR.CRC.Library.DataAccess;

namespace NPR.CRC.Web.ViewModels.UserAdmin
{
    public class AddEditCRCUserViewModel
    {
        public long? UserId { get; set; }

        [Required]
        [DisplayName("Email Address")]
        [DataType(DataType.EmailAddress)]
        [InfUnique("CRCUser", "Email", "UserId")]
        public string Email { get; set; }

        [DisplayName("Salutation")]
        [DataType("Salutation")]
        public long? SalutationId { get; set; }

        [Required]
        [DisplayName("First Name")]
        public string FirstName { get; set; }

        [DisplayName("Middle Name")]
        public string MiddleName { get; set; }

        [Required]
        [DisplayName("Last Name")]
        public string LastName { get; set; }

        [DisplayName("Suffix")]
        public string Suffix { get; set; }

        [DisplayName("Job Title")]
        public string JobTitle { get; set; }

        [DisplayName("Address 1")]
        public string AddressLine1 { get; set; }

        [DisplayName("Address 2")]
        public string AddressLine2 { get; set; }

        [DisplayName("City")]
        public string City { get; set; }

        [DisplayName("State")]
        [DataType("State")]
        public long? StateId { get; set; }

        [DisplayName("County")]
        public string County { get; set; }

        [DisplayName("Country")]
        public string Country { get; set; }

        [DisplayName("Zip Code")]
        [DataType(DataType.PostalCode)]
        public string ZipCode { get; set; }

        [DisplayName("Phone")]
        [DataType(DataType.PhoneNumber)]
        public string Phone { get; set; }

        [DisplayName("Fax")]
        [DataType(DataType.PhoneNumber)]
        public string Fax { get; set; }

        [Required]
        [DisplayName("Role")]
        public string UserRole { get; set; }

        public IEnumerable<SelectListItem> UserRolesList { get; private set; }

        [DisplayName("CRC Manager")]
        public bool CrcManagerInd { get; set; }

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }

        public bool IsCrcManager
        {
            get { return UserId.HasValue && CrcManagerUserId.HasValue && UserId.Value == CrcManagerUserId.Value; }
        }

        public long? CrcManagerUserId { get; set; }

        public string CrcManagerDisplayName { get; set; }

        public AddEditCRCUserViewModel()
        {
            EnabledInd = true;
            UserRolesList = new[] { "Station User", "System Administrator" }.ToSelectListItems().AddBlankFirstItem();

            var drCrcManager = CRCDataAccess.GetCRCManager();
            if (drCrcManager != null)
            {
                CrcManagerUserId = drCrcManager["UserId"] as long?;
                CrcManagerDisplayName = drCrcManager["UserDisplayName"].ToString();
            }
        }
    }
}
