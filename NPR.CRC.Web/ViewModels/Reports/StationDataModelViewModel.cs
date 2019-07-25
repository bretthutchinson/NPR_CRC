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
    public class StationDataModelViewModel
    {

        [Required]
        [DisplayName("Station Enabled:")]
        public string StationEnabled { get; set; }
        public IEnumerable<SelectListItem> StationEnabledList { get; private set; }

        [Required]
        [DisplayName("Band:")]
        public string Band { get; set; }
        public IEnumerable<SelectListItem> BandList { get; private set; }

        [Required]
        [DisplayName("Repeater Status:")]
        public string RepeaterStatus { get; set; }
        public IEnumerable<SelectListItem> RepeaterStatusList { get; private set; }

        [Required]
        [DisplayName("Select a Format:")]
        public string ReportFormat { get; set; }
        public IEnumerable<SelectListItem> ReportFormatList { get; private set; }

        public StationDataModelViewModel()
        {
            GetStationEnabledList();
            //StationEnabledList = new[] { "Yes", "No", "Both" }.ToSelectListItems();
            GetBandList();
            GetRepeaterList();
            ReportFormatList = new[] { "PDF", "CSV", "Excel" }.ToSelectListItems();
        }


        private void GetRepeaterList()
        {
            var RepeaterList = new List<SelectListItem>
            {
                new SelectListItem { Value = "|1|,|2|,|3|", Text = "All Statuses" },
                new SelectListItem { Value = "2",  Text = "Flagship" },
                new SelectListItem { Value = "1",  Text = "100% Repeater" },
				new SelectListItem { Value = "3",  Text = "Non-100%(Partial) Repeater" },
                new SelectListItem { Value = "|2|,|3|",  Text = "All Statuses except 100% Repeater" },
													
            };
            RepeaterStatusList = RepeaterList.SetSelected("All Statuses");
        }

        private void GetStationEnabledList()
        {
            var StationList = new List<SelectListItem>
            {
                new SelectListItem {Value = "Y",Text="Yes"},
                new SelectListItem {Value = "N",Text="No"},
                new SelectListItem {Value = "B",Text="Both"}
            };
            StationEnabledList = StationList.SetSelected("Y");
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