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
    public class FormatCalculationViewModel
    {

        #region fields

        [Required]
        [DisplayName("Duration:")]
        public string Duration { get; set; }
        public IEnumerable<SelectListItem> DurationList { get; private set; }

        [DisplayName("Start Hour:")]
        public string StartHours { get; set; }
        public IEnumerable<SelectListItem> StartHoursList { get; private set; }

        [DisplayName("Ending Hour:")]
        public string EndingHours { get; set; }
        public IEnumerable<SelectListItem> EndigHoursList { get; private set; }

        [DisplayName("Sun")]
        public bool DaySun { get; set; }
        [DisplayName("Mon")]
        public bool DayMon { get; set; }
        [DisplayName("Tue")]
        public bool DayTue { get; set; }
        [DisplayName("Wed")]
        public bool DayWed { get; set; }
        [DisplayName("Thu")]
        public bool DayThu { get; set; }
        [DisplayName("Fri")]
        public bool DayFri { get; set; }
        [DisplayName("Sat")]
        public bool DaySat { get; set; }

        [Required]
        [DisplayName("Select Month and Year:")]
        public int Month { get; set; }
        public IEnumerable<SelectListItem> MonthList { get; private set; }

        [Required]
        public int Year { get; set; }
        public IEnumerable<SelectListItem> YearList { get; private set; }

        [Required]
        [DisplayName("Station Status:")]
        public string StationStatus { get; set; }
        public IEnumerable<SelectListItem> StationStatusList { get; private set; }

        [Required]
        [DisplayName("Select a Member Status:")]
        public string MemberStatus { get; set; }
        public IEnumerable<SelectListItem> MemberStatusList { get; private set; }

        [Required]
        [DisplayName("Station")]
        public string Station { get; set; }

        public string StationsList { get; set; }
        public IEnumerable<SelectListItem> StationList { get; private set; }

        [Required]
        [DisplayName("Select a Format:")]
        public string FormatType { get; set; }
        public IEnumerable<SelectListItem> FormatTypeList { get; private set; }

        [Required]
        [DisplayName("Band:")]
        public string Band { get; set; }
        public IEnumerable<SelectListItem> BandList { get; private set; }

        #endregion


        #region constructor
        public FormatCalculationViewModel()
        {
            DurationList = new[] { "18 hours", "24 hours", "Custom" }.ToSelectListItems();

            GetStartHoursList("StartHours");

            GetStartHoursList("EndingHours");

            GetMonthList();

            YearList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);

            StationStatusList = new[] { "Flagship and Non-100%(Partial) Repeater", "100% Repeater", "All Statuses" }.ToSelectListItems();

            GetStationStatusList();

            GetMemberStatusList();

            //StationList = CRCDataAccess.GetStationsList().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();

            StationList = CRCDataAccess.GetStationsList().ToSelectListItems().AddBlankFirstItem();

            //FormatTypeList = new[] { "Excel", "CSV", "PDF" }.ToSelectListItems();

            FormatTypeList = new[] { "Excel", "CSV"}.ToSelectListItems();

            GetBandList();

        }

        #endregion


        #region Methods

        private void GetStartHoursList(string StartEndTime)
        {
            var sHoursList = new List<SelectListItem>
            {
                new SelectListItem { Value = "00:00:00", Text = "12:00 am" },
                new SelectListItem { Value = "1:00:00",  Text = "1:00 am" },
                new SelectListItem { Value = "2:00:00",  Text = "2:00 am" },
                new SelectListItem { Value = "3:00:00",  Text = "3:00 am" },
				new SelectListItem { Value = "4:00:00",  Text = "4:00 am" },
				new SelectListItem { Value = "5:00:00",  Text = "5:00 am" },
				new SelectListItem { Value = "6:00:00",  Text = "6:00 am" },
				new SelectListItem { Value = "7:00:00",  Text = "7:00 am" },
				new SelectListItem { Value = "8:00:00",  Text = "8:00 am" },
				new SelectListItem { Value = "9:00:00",  Text = "9:00 am" },
				new SelectListItem { Value = "10:00:00", Text = "10:00 am" },
				new SelectListItem { Value = "11:00:00", Text = "11:00 am" },
				new SelectListItem { Value = "12:00:00", Text = "12:00 pm" },
				new SelectListItem { Value = "13:00:00", Text = "1:00 pm" },
				new SelectListItem { Value = "14:00:00", Text = "2:00 pm" },
				new SelectListItem { Value = "15:00:00", Text = "3:00 pm" },
				new SelectListItem { Value = "16:00:00", Text = "4:00 pm" },
				new SelectListItem { Value = "17:00:00", Text = "5:00 pm" },
				new SelectListItem { Value = "18:00:00", Text = "6:00 pm" },
			    new SelectListItem { Value = "19:00:00", Text = "7:00 pm" },
				new SelectListItem { Value = "20:00:00", Text = "8:00 pm" },
				new SelectListItem { Value = "21:00:00", Text = "9:00 pm" },
				new SelectListItem { Value = "22:00:00", Text = "10:00 pm" },
				new SelectListItem { Value = "23:00:00", Text = "11:00 pm" }
								
            };

            switch (StartEndTime)
            {
                case "StartHours":

                    StartHoursList = sHoursList.AddBlankFirstItem();
                    break;
                case "EndingHours":
                    EndigHoursList = sHoursList.AddBlankFirstItem();
                    break;
            }


        }



        private void GetMonthList()
        {
            var rMonthList = new List<SelectListItem>
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

            MonthList = rMonthList.AddBlankFirstItem();
        }

        private void GetMemberStatusList()
        {
            var rMemeberStatusList = new List<SelectListItem>
            {
                new SelectListItem { Value = "Y", Text = "NPR Members" },
                new SelectListItem { Value = "N", Text = "Non-Member" },
			    new SelectListItem { Value = "All", Text = "All" }
            };

            MemberStatusList = rMemeberStatusList;
        }

        private void GetStationStatusList()
        {
            var rStationStatusList = new List<SelectListItem>
            {
                new SelectListItem { Value = "1", Text = "Flagship and Non-100%(Partial) Repeater" },
                new SelectListItem { Value = "2", Text = "100% Repeater" },
				new SelectListItem { Value = "0", Text = "All Statuses" }
            };

            StationStatusList = rStationStatusList;
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

    }
}