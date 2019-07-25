using NPR.CRC.Library.DataAccess;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using InfoConcepts.Library.Validation;
using NPR.CRC.Library.DataAccess;
using InfoConcepts.Library.Extensions;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace NPR.CRC.Web.ViewModels.ProgramAdmin
{
    public class AddEditProgramFormatViewModel
    {
        public long? ProgramFormatTypeId { get; set; }

        [Required]
        [DisplayName("Select a Major Format")]
        public long MajorFormatId { get; set; }

        public IEnumerable<SelectListItem> MajorFormatList { get; private set; }

        [Required]
        [DisplayName("Enter Program Format Name")]
        [InfUnique("ProgramFormatType", "ProgramFormatTypeName", "ProgramFormatTypeId")]
        public string ProgramFormatTypeName { get; set; }

        [Required]
        [DisplayName("Enter Program Format Code")]
        [InfUnique("ProgramFormatType", "ProgramFormatTypeCode", "ProgramFormatTypeId")]
        public string ProgramFormatTypeCode { get; set; }

        [DisplayName("Enabled")]
        public bool EnabledInd { get; set; }

        public AddEditProgramFormatViewModel()
        {
            EnabledInd = true;
            MajorFormatList = CRCDataAccess.GetMajorFormats().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
        }
    }
}