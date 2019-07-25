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

namespace NPR.CRC.Web.ViewModels.Reports
{
    public class ProgramLineUpViewModel
    {
        #region Properties

        //public ProgramSearch ProgramSearch { get; set; }
        [Required]
        [DisplayName("Select a Program:")]
        public string ProgramID { get; set; }
        public IEnumerable<SelectListItem> ProgramList { get; private set; }

        [Required]
        [DisplayName("Select a Survey Season:")]
        public string Season { get; set; }
        public IEnumerable<SelectListItem> SeasonList { get; private set; }

        [Required]
        public int Year { get; set; }
        public IEnumerable<SelectListItem> YearList { get; private set; }

        [Required]
        [DisplayName("Band:")]
        public string BandsString { get; set; }
        public IEnumerable<SelectListItem> BandList { get; private set; }

        [Required]
        [DisplayName("Station Enabled:")]
        public string StationEnabled { get; set; }
        public IEnumerable<SelectListItem> StationEnabledList { get; private set; }


        [DisplayName("Member Status:")]
        public long? MemberStatusId { get; set; }
        public IEnumerable<SelectListItem> MemberStatusList { get; private set; }

        [Required]
        [DisplayName("Select a Format:")]
        public string Format { get; set; }
        public IEnumerable<SelectListItem> FormatList { get; private set; }

        #endregion

        #region Constructors

        public ProgramLineUpViewModel()
        {
            //ProgramSearch = new ProgramSearch();
            ProgramList = CRCDataAccess.GetProgramLookup().ToSelectListItems("ProgramID", "ProgramName").OrderBy(li => li.Text).AddBlankFirstItem(); ;

            GetSeasonList();
            YearList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);
            GetBandList();
            MemberStatusList = CRCDataAccess.GetMemberStatuses().ToSelectListItems().AddBlankFirstItem();
            GetStationEnabledList();
            FormatList = new[] { "Excel", "CSV", "PDF" }.ToSelectListItems();
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
        private void GetStationEnabledList()
        {
            var stationEnabledList = new List<SelectListItem>
            {
                new SelectListItem { Value = "N", Text = "Yes" },
                new SelectListItem { Value = "Y", Text = "No" },
                new SelectListItem { Value = "B", Text = "Both" },
            };
            StationEnabledList = stationEnabledList;
        }

        private void GetSeasonList()
        {
            var seasonList = new List<SelectListItem>
            {
                new SelectListItem { Value = "1, 2, 3", Text = "Winter" },
                new SelectListItem { Value = "4, 5, 6", Text = "Spring" },
                new SelectListItem { Value = "7, 8, 9", Text = "Summer" },
                new SelectListItem { Value = "10, 11, 12", Text = "Fall" },
            };

            SeasonList = seasonList;
        }

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