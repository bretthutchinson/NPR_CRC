using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using NPR.CRC.Library.DataAccess;

namespace NPR.CRC.Web.ViewModels.Schedules
{
    public class ProgrammingSchedulesViewModel
    {
        [Required]
        [DisplayName("Select a Station")]
        public long? StationId { get; set; }

        public string StationName { get; set; }

        public IEnumerable<SelectListItem> StationList { get; private set; }
        public IEnumerable<SelectListItem> MonthsList { get; private set; }
        public IEnumerable<SelectListItem> YearsList { get; private set; }

        public ProgrammingSchedulesViewModel(long userId)
        {
            StationList = CRCDataAccess.GetStationsActiveList(userId).ToSelectListItems().OrderBy(li => li.Text).AddBlankFirstItem();
            MonthsList = CRCDataAccess.GetMonthsList().ToSelectListItems("MonthNumber", "MonthName").SetSelected(DateTime.UtcNow.Month);
            YearsList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);
        }
    }
}
