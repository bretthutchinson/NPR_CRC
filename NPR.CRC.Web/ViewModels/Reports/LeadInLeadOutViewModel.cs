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
    public class LeadInLeadOutViewModel
    {
        [Required]
        [DisplayName("Type:")]
        public string type { get; set; }
        public IEnumerable<SelectListItem> CarriageType { get; private set; }


        [Required]
        [DisplayName("Program Enabled:")]
        public string ProgramEnabled { get; set; }
        public IEnumerable<SelectListItem> ProgramEnabledList { get; private set; }



        [Required]
        [DisplayName("Select a Program:")]
        public string ProgramID { get; set; }
        public IEnumerable<SelectListItem> ProgramList { get; private set; }


        [Required]
        [DisplayName("Report Month From:")]
        public string MonthsFrom { get; set; }
        public IEnumerable<SelectListItem> MonthsFromList { get; private set; }


        [Required]
        public int YearsFrom { get; set; }
        public IEnumerable<SelectListItem> YearsFromList { get; private set; }


        [Required]
        [DisplayName("Report Month To:")]
        public string MonthsTo { get; set; }
        public IEnumerable<SelectListItem> MonthsToList { get; private set; }


        [Required]
		[DisplayName("Days:")]
		public string Day { get; set; }
		[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
		public IEnumerable<SelectListItem> DaysList { get; private set; }

		[Required]
        [DisplayName("Start Time:")]
        public string StartTime { get; set; }
		[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
		public IEnumerable<SelectListItem> StartTimeList { get; private set; }

		[Required]
        [DisplayName("End Time:")]
        public string EndTime { get; set; }
		[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
		public IEnumerable<SelectListItem> EndTimeList { get; private set; }
		

        [Required]
        public int YearsTo { get; set; }
        public IEnumerable<SelectListItem> YearsToList { get; private set; }

        [Required]
        [DisplayName("Select a Format:")]
        public string ReportFormat { get; set; }
        public IEnumerable<SelectListItem> ReportFormatList { get; private set; }


        [Required]
        [DisplayName("Band:")]
        public string Band { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        public IEnumerable<SelectListItem> BandList { get; private set; }


        [Required]
        [DisplayName("Station Enabled:")]
        public string StationEnabled { get; set; }
        public IEnumerable<SelectListItem> StationEnabledList { get; private set; }


        [DisplayName("Member Status:")]
        public string MemberStatus { get; set; }
        public IEnumerable<SelectListItem> MemberStatusList { get; private set; }

        [DisplayName("Select a station:")]
        public string StationId { get; set; }
        public IEnumerable<SelectListItem> StationList { get; private set; }


        [DisplayName("Station City:")]
        public string City { get; set; }
        public IEnumerable<SelectListItem> StationCityList { get; private set; }

        [DisplayName("Station State:")]
        public string StateId { get; set; }
        public IEnumerable<SelectListItem> StationStateList { get; private set; }

        public LeadInLeadOutViewModel()
        {

            CarriageType = new[] { "Regular", "NPR Newscasts" }.ToSelectListItems();
            ProgramEnabledList = new[] { "Yes", "No", "Both" }.ToSelectListItems();
            //ProgramList = new[] { "abc", "abc", "abc" }.ToSelectListItems();
            ProgramList = CRCDataAccess.GetProgramLookup_ED("Yes").ToSelectListItems("ProgramID", "ProgramName").OrderBy(li => li.Text).AddBlankFirstItem(); ;
            MonthsFromList = CRCDataAccess.GetMonthsList().ToSelectListItems("MonthNumber", "MonthName").SetSelected(DateTime.UtcNow.Month);
            YearsFromList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);
            MonthsToList = CRCDataAccess.GetMonthsList().ToSelectListItems("MonthNumber", "MonthName").SetSelected(DateTime.UtcNow.Month);
            YearsToList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);
            ReportFormatList = new[] { "Excel", "CSV", "PDF" }.ToSelectListItems();
            //BandList = new[] { "Terrestrial", "Terrestrial & HD Multicast", "HD Multicast", "HD All" }.ToSelectListItems();
            GetBandList();
            StationEnabledList = new[] { "Yes", "No", "Both" }.ToSelectListItems();
            MemberStatusList = CRCDataAccess.GetMemberStatusEnabled().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            StationList = CRCDataAccess.GetStationsList().ToSelectListItems("StationId", "DisplayName").OrderBy(li => li.Text).AddBlankFirstItem();
            StationStateList = CRCDataAccess.GetStates().ToSelectListItems("StateId", "Abbreviation").OrderBy(li => li.Text).AddBlankFirstItem();
            StationCityList = CRCDataAccess.GetCities().ToSelectListItems("City", "City").OrderBy(li => li.Text).AddBlankFirstItem();
			DaysList = new[] { "Sun", "Mon", "Tue", "Wed", "Thu","Fri","Sat" }.ToSelectListItems();
			StartTimeList = new[] { 
					"12:00 AM" ,"12:15 AM" ,"12:30 AM" ,"12:45 AM" ,"1:00 AM" ,"1:15 AM" ,"1:30 AM" ,"1:45 AM" ,"2:00 AM" ,"2:15 AM" ,"2:30 AM" ,"2:45 AM" ,"3:00 AM" ,"3:15 AM" ,"3:30 AM" ,"3:45 AM" ,"4:00 AM" ,"4:15 AM" ,"4:30 AM" ,"4:45 AM" ,"5:00 AM" ,"5:15 AM" ,"5:30 AM" ,"5:45 AM" ,"6:00 AM" ,"6:15 AM" ,"6:30 AM" ,"6:45 AM" ,"7:00 AM" ,"7:15 AM" ,"7:30 AM" ,"7:45 AM" ,"8:00 AM" ,"8:15 AM" ,"8:30 AM" ,"8:45 AM" ,"9:00 AM" ,"9:15 AM" ,"9:30 AM" ,"9:45 AM" ,"10:00 AM" ,"10:15 AM" ,"10:30 AM" ,"10:45 AM" ,"11:00 AM" ,"11:15 AM" ,"11:30 AM" ,"11:45 AM" ,"12:00 PM" ,"12:15 PM" ,"12:30 PM" ,"12:45 PM" ,"1:00 PM" ,"1:15 PM" ,"1:30 PM" ,"1:45 PM" ,"2:00 PM" ,"2:15 PM" ,"2:30 PM" ,"2:45 PM" ,"3:00 PM" ,"3:15 PM" ,"3:30 PM" ,"3:45 PM" ,"4:00 PM" ,"4:15 PM" ,"4:30 PM" ,"4:45 PM" ,"5:00 PM" ,"5:15 PM" ,"5:30 PM" ,"5:45 PM" ,"6:00 PM" ,"6:15 PM" ,"6:30 PM" ,"6:45 PM" ,"7:00 PM" ,"7:15 PM" ,"7:30 PM" ,"7:45 PM" ,"8:00 PM" ,"8:15 PM" ,"8:30 PM" ,"8:45 PM" ,"9:00 PM" ,"9:15 PM" ,"9:30 PM" ,"9:45 PM" ,"10:00 PM" ,"10:15 PM" ,"10:30 PM" ,"10:45 PM" ,"11:00 PM" ,"11:15 PM" ,"11:30 PM" ,"11:45 PM"
			}.ToSelectListItems();
			EndTimeList = new[] { 
					"12:15 AM" ,"12:30 AM" ,"12:45 AM" ,"1:00 AM" ,"1:15 AM" ,"1:30 AM" ,"1:45 AM" ,"2:00 AM" ,"2:15 AM" ,"2:30 AM" ,"2:45 AM" ,"3:00 AM" ,"3:15 AM" ,"3:30 AM" ,"3:45 AM" ,"4:00 AM" ,"4:15 AM" ,"4:30 AM" ,"4:45 AM" ,"5:00 AM" ,"5:15 AM" ,"5:30 AM" ,"5:45 AM" ,"6:00 AM" ,"6:15 AM" ,"6:30 AM" ,"6:45 AM" ,"7:00 AM" ,"7:15 AM" ,"7:30 AM" ,"7:45 AM" ,"8:00 AM" ,"8:15 AM" ,"8:30 AM" ,"8:45 AM" ,"9:00 AM" ,"9:15 AM" ,"9:30 AM" ,"9:45 AM" ,"10:00 AM" ,"10:15 AM" ,"10:30 AM" ,"10:45 AM" ,"11:00 AM" ,"11:15 AM" ,"11:30 AM" ,"11:45 AM" ,"12:00 PM" ,"12:15 PM" ,"12:30 PM" ,"12:45 PM" ,"1:00 PM" ,"1:15 PM" ,"1:30 PM" ,"1:45 PM" ,"2:00 PM" ,"2:15 PM" ,"2:30 PM" ,"2:45 PM" ,"3:00 PM" ,"3:15 PM" ,"3:30 PM" ,"3:45 PM" ,"4:00 PM" ,"4:15 PM" ,"4:30 PM" ,"4:45 PM" ,"5:00 PM" ,"5:15 PM" ,"5:30 PM" ,"5:45 PM" ,"6:00 PM" ,"6:15 PM" ,"6:30 PM" ,"6:45 PM" ,"7:00 PM" ,"7:15 PM" ,"7:30 PM" ,"7:45 PM" ,"8:00 PM" ,"8:15 PM" ,"8:30 PM" ,"8:45 PM" ,"9:00 PM" ,"9:15 PM" ,"9:30 PM" ,"9:45 PM" ,"10:00 PM" ,"10:15 PM" ,"10:30 PM" ,"10:45 PM" ,"11:00 PM" ,"11:15 PM" ,"11:30 PM" ,"11:45 PM", "Midnight"
			}.ToSelectListItems();
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
    }
}