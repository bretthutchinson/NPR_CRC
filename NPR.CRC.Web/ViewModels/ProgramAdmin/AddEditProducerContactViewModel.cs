using NPR.CRC.Library.DataAccess;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using InfoConcepts.Library.Validation;
using System.Collections.Generic;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using System.Linq;

namespace NPR.CRC.Web.ViewModels.ProgramAdmin
{
    public class AddEditProducerContactViewModel
    {
        public long? ProducerId { get; set; }

        [DisplayName("Salutation")]
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

        //[Required]
        [DisplayName("Role")]
        public string Role { get; set; }

        [Required]
        [DisplayName("Email")]
        public string Email { get; set; }
        
        [DisplayName("Phone")]
        public string Phone { get; set; }

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }

        public IEnumerable<SelectListItem> SalutationList { get; private set; }
        

        public AddEditProducerContactViewModel()
        {
            EnabledInd = true;
            SalutationList = CRCDataAccess.GetSalutations().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
        }
    }
}