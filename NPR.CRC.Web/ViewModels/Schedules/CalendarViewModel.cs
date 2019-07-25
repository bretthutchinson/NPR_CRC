using System.Collections.Generic;
using System.ComponentModel;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using System;

namespace NPR.CRC.Web.ViewModels.Schedules
{
    public class CalendarViewModel
    {
        public long? ScheduleId { get; set; }
        public long? StationId { get; set; }

        [DisplayName("Station")]
        public string StationDisplayName { get; set; }

        public int? Month { get; set; }

        public DateTime? SubmittedDate { get; set; }

        [DisplayName("Month")]
        public string MonthName { get; set; }

        [DisplayName("Year")]
        public int? Year { get; set; }

        public bool ReadOnly { get; set; }

        public bool IsRepeaterInd { get; set; }

        [DisplayName("Type")]
        public string ProgramType { get; set; }

        public string Previous { get; set; }

        public IEnumerable<SelectListItem> ProgramTypesList { get; private set; }

		public string ShowSubmitVerification { get; set; }

        public CalendarViewModel()
        {
            ProgramTypesList = new Dictionary<string, string>
            {
                { "Program", "Regular"},
                { "Newscast", " NPR Newscast"}
            }.ToSelectListItems();

            Previous = "/" + System.Web.HttpContext.Current.Request.RequestContext.RouteData.Values["controller"].ToString();
        }
    }
}
