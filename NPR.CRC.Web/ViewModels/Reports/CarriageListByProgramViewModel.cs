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
    public class CarriageListByProgramViewModel
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

        public CarriageListByProgramViewModel()
        {

            CarriageType = new[] { "Regular", "NPR Newscasts" }.ToSelectListItems();
            ProgramEnabledList = new[] { "Yes", "No", "Both" }.ToSelectListItems();
            //ProgramList = new[] { "abc", "abc", "abc" }.ToSelectListItems();
            ProgramList = CRCDataAccess.GetProgramLookup().ToSelectListItems("ProgramID", "ProgramName").OrderBy(li => li.Text).AddBlankFirstItem(); ;
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