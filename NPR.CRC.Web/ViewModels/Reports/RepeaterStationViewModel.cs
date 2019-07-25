using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using InfoConcepts.Library.Extensions;
using InfoConcepts.Library.Validation;
using System.Web.Mvc;

namespace NPR.CRC.Web.ViewModels.Reports
{
    public class RepeaterStationViewModel
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
      [DisplayName("Select a Format:")]
      public string ReportFormat { get; set; }
      public IEnumerable<SelectListItem> ReportFormatList { get; private set; }

      public RepeaterStationViewModel()
        {
            StationEnabledList = new[] { "Yes", "No", "Both" }.ToSelectListItems();
            GetBandList();
            ReportFormatList = new[] { "Excel", "CSV", "PDF"}.ToSelectListItems();
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