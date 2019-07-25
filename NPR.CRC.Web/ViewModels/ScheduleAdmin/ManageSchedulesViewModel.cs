using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using NPR.CRC.Library.DataAccess;

namespace NPR.CRC.Web.ViewModels.ScheduleAdmin
{
    public class ManageSchedulesViewModel
    {
        [Required]
        [DisplayName("Select month and year")]
        public int? Month { get; set; }

        [Required]
        [DisplayName("Select month and year")]
        public int? Year { get; set; }

        [Required]
        [DisplayName("Status")]
        public string Status { get; set; }

        public IEnumerable<SelectListItem> MonthsList { get; private set; }
        public IEnumerable<SelectListItem> YearsList { get; private set; }
        public IEnumerable<SelectListItem> StatusList { get; private set; }

        public ManageSchedulesViewModel()
        {
            MonthsList = CRCDataAccess.GetMonthsList().ToSelectListItems("MonthNumber", "MonthName").SetSelected(DateTime.UtcNow.Month);
            YearsList = CRCDataAccess.GetScheduleYearsList(2).ToSelectListItems().SetSelected(DateTime.UtcNow.Year);
            StatusList = new[] { "All", "Unsubmitted", "Unaccepted", "Accepted" }.ToSelectListItems();
        }
    }
}