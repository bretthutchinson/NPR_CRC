using System;
using System.Globalization;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using NPR.CRC.Library.DataAccess;

namespace NPR.CRC.Web.ViewModels.Schedules
{
    public class AddEditNewscastViewModel
    {
        #region Properties

        public long? ScheduleNewscastId { get; set; }
        public long ScheduleId { get; set; }

        [DisplayName("Type")]
        public bool HourlyInd { get; set; }

        [DisplayName("NPR Newscast Length")]
        public int DurationMinutes { get; set; }

        [DisplayName("NPR Newscast Offset")]
        public int OffsetMinutes { get; set; }


        [RequiredForTimeSpan]
        [DisplayName("Start Time")]
        public string StartTime { get; set; }

        public string StartHour { get; set; }
        public string StartMinute { get; set; }
        public string StartPeriod { get; set; }

        [Required]
        [DisplayName("End Time")]
        public string EndTime { get; set; }

        public string EndHour { get; set; }
        public string EndMinute { get; set; }
        public string EndPeriod { get; set; }

        [RequiredforDaysOfWeek]
        [DisplayName("Mon")]
        public bool MondayInd { get; set; }

        [DisplayName("Tue")]
        public bool TuesdayInd { get; set; }

        [DisplayName("Wed")]
        public bool WednesdayInd { get; set; }

        [DisplayName("Thu")]
        public bool ThursdayInd { get; set; }

        [DisplayName("Fri")]
        public bool FridayInd { get; set; }

        [DisplayName("Sat")]
        public bool SaturdayInd { get; set; }

        [DisplayName("Sun")]
        public bool SundayInd { get; set; }

        public AddEditNewscastMode Mode { get; set; }

        public IEnumerable<SelectListItem> StartHourList { get; private set; }
        public IEnumerable<SelectListItem> StartMinuteList { get; private set; }
        public IEnumerable<SelectListItem> StartPeriodList { get; private set; }
        public IEnumerable<SelectListItem> EndHourList { get; set; }
        public IEnumerable<SelectListItem> EndMinuteList { get; private set; }
        public IEnumerable<SelectListItem> EndPeriodList { get; set; }
        public IEnumerable<SelectListItem> NewscastDurationList { get; private set; }
        public IEnumerable<SelectListItem> NewscastOffsetList { get; private set; }

        #endregion

        #region Constructors

        public AddEditNewscastViewModel() 
        {
            Mode = AddEditNewscastMode.Add;

            StartHourList = GetHours().ToSelectListItems();
            StartMinuteList = GetMinutesInHour().ToSelectListItems();
            EndHourList = GetHours().ToSelectListItems();
            EndMinuteList = GetMinutesInHour().ToSelectListItems();
            LoadTimePeriod();
            NewscastDurationList = GetNewscastDuration().ToSelectListItems();
            NewscastOffsetList = GetNewscastOffset().ToSelectListItems();
            
            //Set defaults for start/end times if they're null, else they will not save properly
            StartTime = StartTime ?? "1:00 am";
            EndTime = EndTime ?? "1:00 pm";
        }

        #endregion

        #region Methods

        private IEnumerable<string> GetMinutesInHour()
        {
            string minutes;
            for (int i = 0; i < 60; i++)
            {
                minutes = i.ToString().Length < 2 ? "0" + i.ToString() : i.ToString();
                yield return minutes;
            }
        }

        private IEnumerable<string> GetHours()
        {
            for (int i = 1; i < 13; i++)
            {
                yield return i.ToString();
            }
        }

        private void LoadTimePeriod()
        {
            var periodList = new List<SelectListItem>
            {
                new SelectListItem { Value = "am", Text = "am" },
                new SelectListItem { Value = "pm", Text = "pm" }
            };

            StartPeriodList = periodList.OrderBy(li => li.Text);
            EndPeriodList = periodList.OrderBy(li => li.Text);
        }

        private IEnumerable<int> GetNewscastDuration()
        {
            for (int i = 1; i < 11; i++)
            {
                yield return i;
            }
        }

        private IEnumerable<int> GetNewscastOffset()
        {
            for (int i = 0; i < 59; i++)
            {
                yield return i;
            }
        }

        #endregion

        #region Validators

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible")]
        [AttributeUsage(AttributeTargets.Property)]
        public sealed class RequiredforDaysOfWeekAttribute : ValidationAttribute
        {
            protected override ValidationResult IsValid(object value, ValidationContext validationContext)
            {
                var addEditProgram = (AddEditNewscastViewModel)validationContext.ObjectInstance;
                var message = string.Empty;

                if (!addEditProgram.MondayInd &&
                    !addEditProgram.TuesdayInd &&
                    !addEditProgram.WednesdayInd &&
                    !addEditProgram.ThursdayInd &&
                    !addEditProgram.FridayInd &&
                    !addEditProgram.SaturdayInd &&
                    !addEditProgram.SundayInd)
                {
                    message = string.Format(CultureInfo.InvariantCulture, " {0} At least one day of the week must be selected", validationContext.DisplayName);
                    return new ValidationResult(message, new[] { validationContext.MemberName });
                }
                else
                {
                    return ValidationResult.Success;
                }
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1034:NestedTypesShouldNotBeVisible")]
        [AttributeUsage(AttributeTargets.Property)]
        public sealed class RequiredForTimeSpanAttribute : ValidationAttribute
        {
            protected override ValidationResult IsValid(object value, ValidationContext validationContext)
            {
                var addEditNewscast = (AddEditNewscastViewModel)validationContext.ObjectInstance;
                var message = string.Empty;

                DateTime start = Convert.ToDateTime(addEditNewscast.StartTime);
                DateTime end = Convert.ToDateTime("12:00 am".Equals(addEditNewscast.EndTime, StringComparison.InvariantCultureIgnoreCase) ? "11:59:59 pm" : addEditNewscast.EndTime);

                if (end <= start)
                {
                    if (start == Convert.ToDateTime("12:00 AM") && end == Convert.ToDateTime("12:00 AM"))
                    {
                        return ValidationResult.Success;
                    }
                    else
                    {
                        message = message = string.Format(CultureInfo.InvariantCulture, " {0} Start Time must be earlier than the End Time", validationContext.DisplayName);
                        return new ValidationResult(message, new[] { validationContext.MemberName });
                    }
                }
                else
                {
                    return ValidationResult.Success;
                }
            }
        }

        #endregion
    }

    public enum AddEditNewscastMode
    {
        Add,
        Edit
    }
}