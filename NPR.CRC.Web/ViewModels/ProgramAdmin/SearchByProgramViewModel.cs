using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using NPR.CRC.Library;
using NPR.CRC.Library.DataAccess;

namespace NPR.CRC.Web.ViewModels.ProgramAdmin
{
    public class SearchByProgramViewModel
    {
        public ProgramSearch ProgramSearch { get; set; }
        public IEnumerable<SelectListItem> ProgramSourceList { get; private set; }
        public IEnumerable<SelectListItem> ProgramEnabledList { get; private set; }
        public IEnumerable<SelectListItem> ProgramFormatTypeList { get; private set; }
        public IEnumerable<SelectListItem> MajorFormatList { get; private set; }
        public IEnumerable<SelectListItem> FirstCharacterList { get; private set; }

        public SearchByProgramViewModel()
        {
            ProgramSearch = new ProgramSearch();
            ProgramSourceList = CRCDataAccess.GetDropDownProgramSources().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            ProgramEnabledList = new[] { "Yes", "No", "Both" }.ToSelectListItems();
            ProgramFormatTypeList = CRCDataAccess.GetProgramFormatTypes().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            MajorFormatList = CRCDataAccess.GetMajorFormats().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            FirstCharacterList = GetCharacterList().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
        }

        private IEnumerable<char> GetCharacterList()
        {
            for (var ch = '0'; ch <= '9'; ch++)
            {
                yield return ch;
            }

            for (var ch = 'A'; ch <= 'Z'; ch++)
            {
                yield return ch;
            }
        }
    }
}