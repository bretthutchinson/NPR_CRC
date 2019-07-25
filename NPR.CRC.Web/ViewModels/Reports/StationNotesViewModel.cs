using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using InfoConcepts.Library.Validation;
using NPR.CRC.Library.DataAccess;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NPR.CRC.Web.ViewModels.Reports
{
    public class StationNotesViewModel
    {
        #region Properties

        [DisplayName("Keyword")]
        public string Keyword { get; set; }

        public long? StationId { get; set; }

        public string StationName { get; set; }

        [DisplayName("Last Updated From Date")]
        [DisplayFormat(DataFormatString = "{0:d}")]
        public DateTime? LastUpdatedFromDate { get; set; }

        [DisplayName("Last Updated To Date")]
        [DisplayFormat(DataFormatString = "{0:d}")]
        public DateTime? LastUpdatedToDate { get; set; }

        [DisplayName("Note Status")]
        public string NoteStatus { get; set; }

        public IEnumerable<SelectListItem> NoteStatusList { get; private set; }

        #endregion

        #region Constructors

        public StationNotesViewModel()
        {
            LoadNotesStatus();
        }

        #endregion

        #region Methods

        private void LoadNotesStatus()
        {
            var notesStatusList = new List<SelectListItem>
            {
                new SelectListItem { Value = "Y", Text = "Active" },
                new SelectListItem { Value = "N", Text = "Deleted" }
            };

            NoteStatusList = notesStatusList.OrderBy(li => li.Text);
        }

        #endregion

        #region Validators
        #endregion

    }
}