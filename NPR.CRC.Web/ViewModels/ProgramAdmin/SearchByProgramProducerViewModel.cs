using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using InfoConcepts.Library.Validation;
using NPR.CRC.Library;
using NPR.CRC.Library.DataAccess;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NPR.CRC.Web.ViewModels.ProgramAdmin
{
    public class SearchByProgramProducerViewModel
    {
        #region Properties

        public ProgramSearch ProgramSearch { get; set; }
        /*
        public long? ProgramId { get; set; }

        [DisplayName("Programs:")]
        public string ProgramFirstLetter { get; set; }
        public IEnumerable<SelectListItem> ProgramFirstLetterList { get; private set; }
        public IEnumerable<SelectListItem> ProgramList { get; set; }
        */
        public string ProgramName { get; set; }

        [DisplayName("Producer/Contact")]
        public long? ProducerId { get; set; }
        public IEnumerable<SelectListItem> ProducerList { get; private set; }

        #endregion

        #region Constructors

        public SearchByProgramProducerViewModel() 
        {
            ProgramSearch = new ProgramSearch();
            //ProgramFirstLetterList = GetCharacterList().ToSelectListItems().OrderBy(li => li.Text);
            //ProgramList = CRCDataAccess.ProgramCalendarSearch("*", "StartsWith").ToSelectListItems();
            ProducerList = CRCDataAccess.GetProducersList().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
        }

        #endregion

        #region Methods
        /*
        private IEnumerable<char> GetCharacterList()
        {
            yield return '*';

            for (var ch = 'A'; ch <= 'Z'; ch++)
            {
                yield return ch;
            }

            for (var ch = '0'; ch <= '9'; ch++)
            {
                yield return ch;
            }
        }
        */
        #endregion

        #region Validators

        #endregion
    }
}