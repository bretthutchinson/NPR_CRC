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
    public class GridDataViewModel
    {
        #region Properties

        [Required]
        [DisplayName("Select a Station Type")]
        public string StationType { get; set; }
        public IEnumerable<SelectListItem> StationTypeList { get; private set; }

        [Required]
        [DisplayName("Station Enabled")]
        public string StationEnabled { get; set; }
        public IEnumerable<SelectListItem> StationEnabledList { get; private set; }

        [Required]
        [DisplayName("Repeater Status")]
        public string RepeaterStatus { get; set; }
        public IEnumerable<SelectListItem> RepeaterStatusList { get; private set; }

        [Required]
        [DisplayName("Program Type")]
        public string ProgramType { get; set; }
        public IEnumerable<SelectListItem> ProgramTypeList { get; private set; }

        [Required]
        [DisplayName("Select Month and Year")]
        public int Month { get; set; }
        public IEnumerable<SelectListItem> MonthsList { get; private set; }

        [Required]
        public int Years { get; set; }
        public IEnumerable<SelectListItem> YearsList { get; private set; }

        [Required]
        [DisplayName("Select a Format")]
        public string Format { get; set; }
        public IEnumerable<SelectListItem> FormatList { get; private set; }

        #endregion

        #region Constructors

        public GridDataViewModel()
        {
            StationTypeList = GetStationTypeList();
            StationEnabledList = new[] { "Yes", "No", "Both" }.ToSelectListItems();
            RepeaterStatusList = GetRepeaterList();
            ProgramTypeList = GetProgramTypeList();
            MonthsList = GetMonthList();
            YearsList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);
            FormatList = new[] { "CSV","Txt"}.ToSelectListItems();
        }

        #endregion

        #region Methods

        private static IEnumerable<SelectListItem> GetStationTypeList()
        {
            var stationTypesList = new List<SelectListItem>
            {
                new SelectListItem { Value = "|AM|, |FM|", Text = "Terrestrial" },
                new SelectListItem { Value = "|AM|, |AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "Terrestrial & HD Multicast" },
                new SelectListItem { Value = "|AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "HD Multicast" },
                new SelectListItem { Value = "|AM-HD1|, |AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM-HD1|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "HD All" },
            };

            return stationTypesList.SetSelected("AM, FM");
        }

        private static IEnumerable<SelectListItem> GetRepeaterList()
        {
            var RepeaterList = new List<SelectListItem>
            {
                new SelectListItem { Value = "A", Text = "All" },
                new SelectListItem { Value = "F",  Text = "Flagship" },
                new SelectListItem { Value = "R",  Text = "100% Repeater" },
				new SelectListItem { Value = "N",  Text = "Non-100%(Partial) Repeater" },													
            };

            return RepeaterList.SetSelected("All Statuses");
        }

        private static IEnumerable<SelectListItem> GetProgramTypeList()
        {
            var stationTypesList = new List<SelectListItem>
            {
                new SelectListItem { Value = "Regular", Text = "Regular" },
                new SelectListItem { Value = "NPR Newscast", Text = "Newscast" },
            };

            return stationTypesList.SetSelected("Regular");
        }

        private static IEnumerable<SelectListItem> GetMonthList()
        {
            var monthList = new List<SelectListItem>
            {
                new SelectListItem { Value = "1", Text = "January" },
                new SelectListItem { Value = "2",  Text = "February" },
                new SelectListItem { Value = "3",  Text = "March" },
                new SelectListItem { Value = "4",  Text = "April" },
				new SelectListItem { Value = "5",  Text = "May" },
				new SelectListItem { Value = "6",  Text = "June" },
				new SelectListItem { Value = "7",  Text = "July" },
				new SelectListItem { Value = "8",  Text = "August" },
				new SelectListItem { Value = "9",  Text = "September" },
				new SelectListItem { Value = "10",  Text = "October" },
				new SelectListItem { Value = "11", Text = "November" },
				new SelectListItem { Value = "12", Text = "December" }	
            };

            return monthList.SetSelected(DateTime.UtcNow);
        }

        #endregion

        #region Validators

        #endregion


    }
}