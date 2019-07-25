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
    public class AddDropProgramViewModel
    {
        [Required]
        [DisplayName("Select a Station Type:")]
        public string StationType { get; set; }
        public IEnumerable<SelectListItem> StationTypeList { get; private set; }

        [Required]
        [DisplayName("Select Station Status:")]
        public string StationStatus { get; set; }
        public IEnumerable<SelectListItem> StationStatusList { get; private set; }

        [Required]
        [DisplayName("Repeater Status:")]
        public string RepeaterStatus { get; set; }
        public IEnumerable<SelectListItem> RepeaterStatusList { get; private set; }

        [Required]
        [DisplayName("Select a program:")]
        public string ProgramName { get; set; }
        public IEnumerable<SelectListItem> ProgramList { get; private set; }

        [Required]
        [DisplayName("Survey Season From:")]
        public string SurveySeasonFromMonth { get; set; }
        public IEnumerable<SelectListItem> FromMonthList { get; private set; }

        [Required]
        public int SurveySeasonFromYear { get; set; }
        public IEnumerable<SelectListItem> FromYearList { get; private set; }

        [Required]
        [DisplayName("Survey Season To:")]
        public string SurveySeasonToMonth { get; set; }
        public IEnumerable<SelectListItem> ToMonthList { get; private set; }

        [Required]
        public int SurveySeasonToYear { get; set; }
        public IEnumerable<SelectListItem> ToYearList { get; private set; }

        [Required]
        [DisplayName("Select a Format:")]
        public string Format { get; set; }
        public IEnumerable<SelectListItem> FormatList { get; private set; }

        public AddDropProgramViewModel()
        {

            //StationTypeList = new[] {"Terrestrial","HD Multicast","HD All","All Terrestrial & HD"}.ToSelectListItems();
            GetStationTypeList();
            StationStatusList = new[] { "Enabled", "Disabled", "Both" }.ToSelectListItems();
            //RepeaterStatusList= new[] {"Flagship and Non-100% (Partial) Repeater","100% Repeater","All"}.ToSelectListItems();	
            GeRepeaterList();
            //ProgramList = CRCDataAccess.GetEnabledProgram().ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            ProgramList = CRCDataAccess.GetProgramLookup().ToSelectListItems("ProgramID", "ProgramName").OrderBy(li => li.Text).AddBlankFirstItem(); ;
            FromMonthList = new[] { "Winter", "Spring", "Summer", "Fall" }.ToSelectListItems();
            FromYearList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);
            ToMonthList = new[] { "Winter", "Spring", "Summer", "Fall" }.ToSelectListItems();
            ToYearList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);
            FormatList = new[] { "Excel", "PDF", "CSV" }.ToSelectListItems();

        }


        private void GetStationTypeList()
        {
            var stationTypeList = new List<SelectListItem>
            {
                new SelectListItem { Value = "|AM|, |FM|", Text = "Terrestrial" },
                new SelectListItem { Value = "|AM|, |AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "Terrestrial & HD Multicast" },
                new SelectListItem { Value = "|AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "HD Multicast" },
                new SelectListItem { Value = "|AM-HD1|, |AM-HD2|, |AM-HD3|, |AM-HD4|, |AM-HD5|, |AM-HD6|, |FM-HD1|, |FM-HD2|, |FM-HD3|, |FM-HD4|, |FM-HD5|, |FM-HD6|", Text = "HD All" },
            };

            StationTypeList = stationTypeList.SetSelected("AM, FM");
        }


        private void GeRepeaterList()
        {
            var repeaterList = new List<SelectListItem>
            {
                new SelectListItem { Value = "|Flagship|, |Non-100% (Partial) Repeater|", Text = "Flagship and Non-100% (Partial) Repeater" },
                new SelectListItem { Value = "|100% Repeater|", Text = "100% Repeater" },
                new SelectListItem { Value = "All", Text = "All" },
                
            };

            RepeaterStatusList = repeaterList.SetSelected("Flagship, Non-100% (Partial) Repeater");
        }

    }
}