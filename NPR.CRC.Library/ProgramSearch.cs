using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using InfoConcepts.Library.Validation;
using NPR.CRC.Library.DataAccess;
using System.ComponentModel;

namespace NPR.CRC.Library
{
    public class ProgramSearch
    {
        #region Properties

        public long? ProgramId { get; set; }

        public string ProgramFirstLetter { get; set; }
        public IEnumerable<SelectListItem> ProgramFirstLetterList { get; private set; }
        public IEnumerable<SelectListItem> ProgramList { get; set; }

        public string ProgramName { get; set; }

        #endregion

        #region Constructors

        public ProgramSearch()
        {
            ProgramFirstLetterList = GetCharacterList().ToSelectListItems().OrderBy(li => li.Text);
            GetProgramLists();
        }

        #endregion

        #region Methods

        private IEnumerable<char> GetCharacterList()
        {
            yield return '*';

            for (var ch = 'A'; ch <= 'Z'; ch++)
            {
                yield return ch;
            }
           
        }

        private void GetProgramLists()
        {
            DataTable dtProgramList = CRCDataAccess.ProgramCalendarSearch("*", "StartsWith");
            ProgramList = (new SelectListItem[] { new SelectListItem() { Text = "Select a Program Name", Value = "" } }).Union((from DataRow row in dtProgramList.Rows
                                                                                   select new SelectListItem()
                                                                                   {
                                                                                       Text = row["ProgramName"].ToString(),
                                                                                       Value = row["ProgramId"].ToString()
                                                                                   }));
        }
        #endregion
    }
}
