using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using NPR.CRC.Library.DataAccess;

namespace NPR.CRC.Web.ViewModels.ProgramAdmin
{
    public class AddEditProgramViewModel
    {
        public long? ProgramId { get; set; }

        [Required]
        [DisplayName("Enter Program Name")]
        public string ProgramName { get; set; }

        [Required]
        [DisplayName("Select a Program Source")]
        public long? ProgramSourceId { get; set; }

        [Required]
        [DisplayName("Select a Program Format Type")]
        public long? ProgramFormatTypeId { get; set; }

        [RequiredForProgramCodeAttribute]
        [DisplayName("Enter Program Code")]
        public string ProgramCode { get; set; }

        [DisplayName("Select a Carriage Type")]
        public long? CarriageTypeId { get; set; }

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }

        public IEnumerable<SelectListItem> ProgramSourceList { get; private set; }
        public IEnumerable<SelectListItem> ProgramFormatTypeList { get; private set; }
        public IEnumerable<SelectListItem> CarriageTypeList { get; private set; }

        public AddEditProgramViewModel()
        {
            ProgramSourceList = CRCDataAccess.GetDropDownProgramSources().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            ProgramFormatTypeList = CRCDataAccess.GetProgramFormatTypes().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            CarriageTypeList = CRCDataAccess.GetCarriageTypes().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible")]
        [AttributeUsage(AttributeTargets.Property)]
        public sealed class RequiredForProgramCodeAttribute : ValidationAttribute
        {
            protected override ValidationResult IsValid(object value, ValidationContext validationContext)
            {
                var addEditProgramViewModel = (AddEditProgramViewModel)validationContext.ObjectInstance;
                var message = string.Empty;


                if (!CRCDataAccess.ValidateProgramCodeIsUnique(addEditProgramViewModel.ProgramId,addEditProgramViewModel.ProgramCode))
                {
                    message = message = "Program code must be unique";
                    return new ValidationResult(message, new[] { validationContext.MemberName });
                }
                else
                {
                    return ValidationResult.Success;
                }

            }
        }
    }
}