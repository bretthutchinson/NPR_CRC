using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace NPR.CRC.Web.ViewModels.Home
{
    public class ResetPasswordViewModel
    {
        public string Token { get; set; }

        [DisplayName("Email Address")]
        [DataType(DataType.EmailAddress)]
        public string Email { get; set; }

        [Required]
        [DisplayName("New Password")]
        [DataType(DataType.Password)]
        [StringLength(15, MinimumLength = 8, ErrorMessage = "Password must be between 8 and 15 characters.")]
        public string NewPassword { get; set; }

        [Required]
        [DisplayName("Confirm Password")]
        [DataType(DataType.Password)]
        [Compare("NewPassword", ErrorMessage = "Passwords do not match.")]
        public string ConfirmNewPassword { get; set; }

        public ResetPasswordStatus Status { get; set; }
    }

    public enum ResetPasswordStatus
    {
        TokenValid,
        TokenInvalid,
        NoTokenProvided,
        PasswordChanged
    }
}