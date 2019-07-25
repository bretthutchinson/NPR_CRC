using System.Collections.Generic;
using System.ComponentModel;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using System;

namespace NPR.CRC.Web.ViewModels.Schedules
{
    public class CalendarPrintViewModel
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

        public CalendarPrintViewModel()
        {
            
        }
    }
}
