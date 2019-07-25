using System;
using System.Globalization;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web.Mvc;
using InfoConcepts.Library.Extensions;
using NPR.CRC.Library;
using NPR.CRC.Library.DataAccess;

namespace NPR.CRC.Web.ViewModels.Schedules
{
    public class AddEditProgramViewModel
    {
        #region Properties

        public long? ScheduleProgramId { get; set; }
        public long ScheduleId { get; set; }
        //public long ProgramId { get; set; }

        public ProgramSearch ProgramSearch { get; set; }

        [RequiredForTimeSpan]
        [DisplayName("Start Time")]
        public string StartTime { get; set; }

        [Required]
        [DisplayName("End Time")]
        public string EndTime { get; set; }

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

        public AddEditProgramMode Mode { get; set; }

//        public string ProgramFirstLetter { get; set; }

//        public string ProgramName { get; set; }
//        public IEnumerable<SelectListItem> ProgramFirstLetterList { get; private set; }
//        public IEnumerable<SelectListItem> ProgramList { get; set; }
        public IEnumerable<SelectListItem> StartTimeList { get; private set; }
        public IEnumerable<SelectListItem> EndTimeList { get; private set; }

        #endregion

        #region Constructors

        public AddEditProgramViewModel()
        {
            Mode = AddEditProgramMode.Add;

//            ProgramFirstLetterList = GetCharacterList().ToSelectListItems().OrderBy(li => li.Text);
            StartTimeList = GetProgramTimeSpan().ToSelectListItems();
            EndTimeList = GetProgramTimeSpan().ToSelectListItems();
//            ProgramList = CRCDataAccess.ProgramCalendarSearch("*", "StartsWith").ToSelectListItems();
        }

        public AddEditProgramViewModel(long incrMins) 
        {
            Mode = AddEditProgramMode.Add;
            ProgramSearch = new ProgramSearch();
//            ProgramFirstLetterList = GetCharacterList().ToSelectListItems().OrderBy(li => li.Text);
            StartTimeList = GetProgramTimeSpan(incrMins).ToSelectListItems();
            EndTimeList = GetProgramTimeSpan(incrMins).ToSelectListItems();
//            ProgramList = CRCDataAccess.ProgramCalendarSearch("*", "StartsWith").ToSelectListItems();
        }

        #endregion

        #region Methods
        /*
        private IEnumerable<char> GetCharacterList()
        {
            yield return '*';

            for (var ch = 'A'; ch <= 'Z'; ch++)
            {
                yield return ch;
            }

            for (var ch = '0'; ch <= '9'; ch++)
            {
                yield return ch;
            }
        }
        */
        private IEnumerable<string> GetProgramTimeSpan(long incrMins)
        {
            TimeSpan startTime = TimeSpan.Parse("00:00:00");
            TimeSpan endTime = TimeSpan.Parse("23:59:00");
            while (startTime < endTime) {
                yield return Convert.ToDateTime(startTime.ToString()).ToString("hh:mm tt", CultureInfo.GetCultureInfo("en-US")).ToLower().TrimStart('0');
                //startTime = startTime.Add(TimeSpan.FromMinutes(incrMins));
                startTime = startTime.Add(TimeSpan.FromMinutes(15));
            }
        }

        private IEnumerable<string> GetProgramTimeSpan()
        {
            TimeSpan startTime = TimeSpan.Parse("00:00:00");
            TimeSpan endTime = TimeSpan.Parse("23:59:00");
            while (startTime < endTime)
            {
                yield return Convert.ToDateTime(startTime.ToString()).ToString("hh:mm tt", CultureInfo.GetCultureInfo("en-US")).ToLower().TrimStart('0');
                startTime = startTime.Add(TimeSpan.FromMinutes(15));
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
                var addEditProgram = (AddEditProgramViewModel)validationContext.ObjectInstance;
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
                var addEditProgram = (AddEditProgramViewModel)validationContext.ObjectInstance;
                var message = string.Empty;

                DateTime start = Convert.ToDateTime(addEditProgram.StartTime);
                DateTime end = Convert.ToDateTime( "12:00 am".Equals(addEditProgram.EndTime, StringComparison.InvariantCultureIgnoreCase) ? "11:59:59 pm" : addEditProgram.EndTime);

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

    public enum AddEditProgramMode
    {
        Add,
        Edit
    }

}