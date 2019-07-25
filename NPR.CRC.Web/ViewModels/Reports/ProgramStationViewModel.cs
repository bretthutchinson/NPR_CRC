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
    public class ProgramStationViewModel
    {
        #region Properties


        [Required]
        [DisplayName("Current Survey Season:")]
        public string CurrentSeason { get; set; }
        public IEnumerable<SelectListItem> CurrentSeasonList { get; private set; }

        [Required]
        public int CurrentYear { get; set; }
        public IEnumerable<SelectListItem> CurrentYearList { get; private set; }


        [Required]
        [DisplayName("Past Survey Season:")]
        public string PastSeason { get; set; }
        public IEnumerable<SelectListItem> PastSeasonList { get; private set; }

        [Required]
        public int PastYear { get; set; }
        public IEnumerable<SelectListItem> PastYearList { get; private set; }

        [Required]
        [DisplayName("Select a Format:")]
        public string Format { get; set; }
        public IEnumerable<SelectListItem> FormatList { get; private set; }

        [Required]
        [DisplayName("Band:")]
        public string Band { get; set; }
        public IEnumerable<SelectListItem> BandList { get; private set; }


        #endregion

        #region Constructors

        public ProgramStationViewModel()
        {

            CurrentSeasonList = new[] { "Winter", "Spring", "Summer", "Fall" }.ToSelectListItems();
            CurrentYearList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);
            PastSeasonList = new[] { "Winter", "Spring", "Summer", "Fall" }.ToSelectListItems();
            PastYearList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);
            FormatList = new[] { "EXCEL", "PDF", "CSV" }.ToSelectListItems();
            GetBandList();
        }

        #endregion

        #region Methods
        private void GetBandList()
        {
            var bandsList = new List<SelectListItem>
            {
                new SelectListItem { Value = "|AM|, |FM|", Text = "Terrestrial" },
                new SelectListItem { Value = "|AM|, |AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "Terrestrial & HD Multicast" },
                new SelectListItem { Value = "|AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "HD Multicast" },
                new SelectListItem { Value = "|AM-HD1|, |AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM-HD1|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "HD All" },
            };

            BandList = bandsList.SetSelected("AM, FM");
        }

        #endregion

        #region Validators
        #endregion

    }
}