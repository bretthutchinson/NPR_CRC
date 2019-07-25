using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NPR.CRC.Web.ViewModels.Home
{
    public class SignInViewModel
    {
        [Required]
        [DisplayName("Email Address")]
        [DataType(DataType.EmailAddress)]
        public string Email { get; set; }

        [Required]
        [DisplayName("Password")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        public string CRCManagerPhone { get; set; }

        public string CRCManagerEmail { get; set; }

        public string CRCManagerFirstName { get; set; }

        public string CRCManagerMiddleName { get; set; }

        public string CRCManagerLastName { get; set; }

        public long userId { get; set; }
    }
}