using System;
using System.Data;
using System.Web.Mvc;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.IO;
using InfoConcepts.Library.Extensions;
using MvcJqGrid;
using NPR.CRC.Library;
using NPR.CRC.Library.DataAccess;
using NPR.CRC.Web.ViewModels.Schedules;
using InfoConcepts.Library.Web.Mvc;
using InfoConcepts.Library.Email;
using NPR.CRC.Web.ViewModels.Home;

namespace NPR.CRC.Web.Controllers
{
    [Authorize]
    public class SchedulesController : BaseController
    {
        public ActionResult Index()
        {
            var viewModel = new ProgrammingSchedulesViewModel(CRCUser.UserId);
            
            //table.AsEnumerable().Select(dr => dr.Field<string>("FuncName")).ToList()

            return View(viewModel);
        }

        public ActionResult ProgrammingSchedulesGridData(GridSettings gridSettings, long stationId)
        {
            using (var dataTable = CRCDataAccess.SearchSchedules(stationId, null, null, null))
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        public ActionResult GetSelectedStationInfo(long stationId)
        {
            var dataRow = CRCDataAccess.GetStation(stationId);
            if (dataRow != null)
            {
                return Json(
                    new
                    {
                        StationDisplayName = dataRow["StationDisplayName"].ToString(),
                        PrimaryUserDisplayName = dataRow["PrimaryUserDisplayName"].ToString(),
                        PrimaryUserPhone = dataRow["PrimaryUserPhone"].ToString(),
                        PrimaryUserEmail = dataRow["PrimaryUserEmail"].ToString(),
                        RepeaterStatusId = dataRow["RepeaterStatusId"].ToString(),
                        Flagship = dataRow["flagship"].ToString()
                    }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(false, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult Create(long stationId, int month, int year)
        {
            var dataTable = CRCDataAccess.SearchSchedules(stationId, month, year, null);
            if (dataTable != null && dataTable.Rows.Count < 1)
            {
                var scheduleId = CRCDataAccess.CreateSchedule(stationId, month, year, CRCUser.UserId);
               // return RedirectToAction("Calendar", new { scheduleId = scheduleId });

                return Json(new { RedirectUrl = Url.Action("Calendar", new { scheduleId = scheduleId }), Validation =true});
   
            }

            return Json(new { Validation = false });

        }

        public ActionResult CreateNew(long stationId, int month, int year)
        {

                var scheduleId = CRCDataAccess.CreateSchedule(stationId, month, year, CRCUser.UserId);
                return RedirectToAction("Calendar", new { scheduleId = scheduleId });

        }

        [Authorize(Roles = CRCUserRoles.Administrator)]
        public ActionResult Delete(long scheduleId)
        {
            CRCDataAccess.DeleteSchedule(scheduleId);
            return Json(true, JsonRequestBehavior.AllowGet);
        }

        public ActionResult CalendarPrint(long scheduleId)
        {
            var viewModel = new CalendarPrintViewModel();
            var dataRow = CRCDataAccess.GetSchedule(scheduleId,CRCUser.UserId);
            dataRow.MapTo(viewModel);
            return View(viewModel);
        }

        public ActionResult Calendar(long scheduleId)
        {
            var viewModel = new CalendarViewModel();
            var dataRow = CRCDataAccess.GetSchedule(scheduleId, CRCUser.UserId);
            dataRow.MapTo(viewModel);
            //if(CRCUser.IsInRole(CRCUserRoles.CRCManager)) viewModel.ReadOnly = false;

            return View(viewModel);
        }

        public JsonResult ProgramSchedule(long scheduleId, string start, string end)
        {
            var paramStartTimeStamp = Convert.ToInt64(start);
            var paramStartDate = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Local).AddSeconds(paramStartTimeStamp).Date;

            var paramEndTimeStamp = Convert.ToInt64(end);
            var paramEndDate = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Local).AddSeconds(paramEndTimeStamp).Date;

            DataTable scheduleProgramsDt = CRCDataAccess.GetSchedulePrograms(scheduleId, 'N');

            IEnumerable<object> rows = (from DataRow row in scheduleProgramsDt.Rows
                                        select
                                        new
                                        {
                                            // FullCalendar standard event object fields
                                            id = row["ScheduleProgramId"].ToString(),
                                            title = row["ProgramName"],
                                            start = calcDateTime(row["DayOfWeek"].ToString(), (TimeSpan)row["StartTime"], paramStartDate, paramEndDate),
                                            end = calcDateTime(row["DayOfWeek"].ToString(), (TimeSpan)row["EndTime"], paramStartDate, paramEndDate),
                                            allDay = false,

                                            // custom fields
                                            scheduleProgramId = row["ScheduleProgramId"],
                                            programId = row["ProgramId"],
                                            programName = row["ProgramName"],
                                            year = row["Year"],
                                            month = row["Month"],
                                            startTime = calcDateTime(row["DayOfWeek"].ToString(), (TimeSpan)row["StartTime"], paramStartDate, paramEndDate).ToString("h:mm tt"),
                                            endTime = calcDateTime(row["DayOfWeek"].ToString(), (TimeSpan)row["EndTime"], paramStartDate, paramEndDate).ToString("h:mm tt"),
                                            quarterHours = row["QuarterHours"],
                                            dayOfWeekText = row["DayOfWeek"].ToString(),
                                            className = getProgramType(row["ProgramName"].ToString()),
                                            daysOfWeek = getDaysOfWeek(row),
                                        });
            var jsonData = new
            {
                rows = rows
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }

        public JsonResult NewscastSchedule(long scheduleId, string start, string end)
        {
            var paramStartTimeStamp = Convert.ToInt64(start);
            var paramStartDate = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Local).AddSeconds(paramStartTimeStamp).Date;

            var paramEndTimeStamp = Convert.ToInt64(end);
            var paramEndDate = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Local).AddSeconds(paramEndTimeStamp).Date;

            DataTable scheduleNewscastsDt = CRCDataAccess.GetScheduleNewscasts(scheduleId, 'N');
            IEnumerable<object> rows = (from DataRow row in scheduleNewscastsDt.Rows
                                        select
                                        new
                                        {
                                            // FullCalendar standard event object fields
                                            id = row["ScheduleNewscastId"].ToString(),
                                            title = row["ProgramName"],
                                            start = calcDateTime(row["DayOfWeek"].ToString(), (TimeSpan)row["StartTime"], paramStartDate, paramEndDate),
                                            end = calcDateTime(row["DayOfWeek"].ToString(), (TimeSpan)row["EndTime"], paramStartDate, paramEndDate),
                                            allDay = false,

                                            // custom fields
                                            scheduleNewscastId = row["ScheduleNewscastId"],
                                            year = row["Year"],
                                            month = row["Month"],
                                            startTime = calcDateTime(row["DayOfWeek"].ToString(), (TimeSpan)row["StartTime"], paramStartDate, paramEndDate).ToString("h:mm tt"),
                                            endTime = calcDateTime(row["DayOfWeek"].ToString(), (TimeSpan)row["EndTime"], paramStartDate, paramEndDate).ToString("h:mm tt"),
                                            hourlyInd = row["HourlyInd"],
                                            durationMinutes = row["DurationMinutes"],
                                            dayOfWeekText = row["DayOfWeek"].ToString(),
                                            // className = getProgramType(row["ProgramName"].ToString()),
                                            daysOfWeek = getDaysOfWeek(row),
                                        });
            var jsonData = new
            {
                rows = rows
            };
            return Json(jsonData, JsonRequestBehavior.AllowGet);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "rw")]
        public ActionResult ProgramListGridData(GridSettings gridSettings, long scheduleId)
        {
            // Retrieve Schedule Programs list data
            var dataTable = CRCDataAccess.GetSchedulePrograms(scheduleId, 'Y');
            int row = 0;

            foreach (DataColumn c in dataTable.Columns)
                c.ReadOnly = false;
            foreach (DataRow rw in dataTable.Rows)
            {
                dataTable.Rows[row][6] = ReportsController.multiDayMerge(dataTable.Rows[row][6].ToString());
                row++;
            }
            using (dataTable)
            {
                return InfJqGridData(dataTable, gridSettings);
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1804:RemoveUnusedLocals", MessageId = "rw")]
        public ActionResult NewscastListGridData(GridSettings gridSettings, long scheduleId)
        {
            var dataTable = CRCDataAccess.GetScheduleNewscasts(scheduleId, 'Y');
            int row = 0;

            foreach (DataColumn c in dataTable.Columns)
                c.ReadOnly = false;
            foreach (DataRow rw in dataTable.Rows)
            {
                dataTable.Rows[row][5] = ReportsController.multiDayMerge(dataTable.Rows[row][5].ToString());
                row++;
            }
            using (dataTable)
            {
                InfJqGridDataResult infjqgrid = InfJqGridData(dataTable, gridSettings);
                
                return infjqgrid;
            }
        }

        public ActionResult AddEditProgram(long incrMins)
        {   
            var viewModel = new AddEditProgramViewModel(incrMins);
            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditProgram(AddEditProgramViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                // Workaround for end time being 12:00 am
                viewModel.EndTime = viewModel.EndTime == "12:00 am" ? "23:59:59" : viewModel.EndTime;

                var scheduleProgramId = CRCDataAccess.SaveScheduleProgram(
                    viewModel.ScheduleProgramId.HasValue ? viewModel.ScheduleProgramId.Value : 0,
                    viewModel.ScheduleId,
                    viewModel.ProgramSearch.ProgramId,
                    viewModel.StartTime,
                    viewModel.EndTime,
                    viewModel.SundayInd.ToIndicator(),
                    viewModel.MondayInd.ToIndicator(),
                    viewModel.TuesdayInd.ToIndicator(),
                    viewModel.WednesdayInd.ToIndicator(),
                    viewModel.ThursdayInd.ToIndicator(),
                    viewModel.FridayInd.ToIndicator(),
                    viewModel.SaturdayInd.ToIndicator(),
                    CRCUser.UserId);

                return Json(scheduleProgramId, JsonRequestBehavior.AllowGet);
            }
            else
            {
                var validationErrors =
                    ModelState.Keys
                        .Where(key => ModelState[key].Errors.Count > 0)
                        .ToDictionary(
                            key => key,
                            key => ModelState[key].Errors.First().ErrorMessage);

                return Json(validationErrors);
            }
        }

        public ActionResult AddEditNewscast()
        { 

            var viewModel = new AddEditNewscastViewModel();
            return PartialView(viewModel);
        }

        [HttpPost]
        public ActionResult AddEditNewscast(AddEditNewscastViewModel viewModel)
        { 
            viewModel.StartTime = viewModel.StartHour + ":" + viewModel.StartMinute + " " + viewModel.StartPeriod;
            //viewModel.EndTime = viewModel.EndHour + ":" + viewModel.EndMinute + " " + viewModel.EndPeriod;
            viewModel.HourlyInd = viewModel.HourlyInd != true && viewModel.HourlyInd != false ? viewModel.HourlyInd = false : viewModel.HourlyInd;
            // viewModel.DurationMinutes = viewModel.HourlyInd != true ? 0 : viewModel.DurationMinutes;

            if (ModelState.IsValid)
            {
                var scheduleNewscastId = CRCDataAccess.SaveScheduleNewscast(
                    viewModel.ScheduleNewscastId.HasValue ? viewModel.ScheduleNewscastId.Value : 0,
                    viewModel.ScheduleId,
                    viewModel.StartTime,
                    viewModel.EndTime,
                    viewModel.HourlyInd.ToIndicator(),
                    viewModel.DurationMinutes,
                    viewModel.SundayInd.ToIndicator(),
                    viewModel.MondayInd.ToIndicator(),
                    viewModel.TuesdayInd.ToIndicator(),
                    viewModel.WednesdayInd.ToIndicator(),
                    viewModel.ThursdayInd.ToIndicator(),
                    viewModel.FridayInd.ToIndicator(),
                    viewModel.SaturdayInd.ToIndicator(),
                    CRCUser.UserId);

                return Json(scheduleNewscastId, JsonRequestBehavior.AllowGet);
            }
            else
            {
                var validationErrors =
                    ModelState.Keys
                        .Where(key => ModelState[key].Errors.Count > 0)
                        .ToDictionary(
                            key => key,
                            key => ModelState[key].Errors.First().ErrorMessage);

                return Json(validationErrors);
            }
        }

        [HttpPost]
        public ActionResult DeleteNewscast(AddEditNewscastViewModel viewModel)
        {
            CRCDataAccess.DeleteScheduleNewscast(viewModel.ScheduleNewscastId.HasValue ? viewModel.ScheduleNewscastId.Value : 0, CRCUser.UserId);

            return Json(true, JsonRequestBehavior.AllowGet);
        }

		[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "disableValidation"), HttpPost]
        public ActionResult SubmitSchedule(long scheduleId, bool DNAInd, bool disableValidation)
        {
            CRCDataAccess.SubmitSchedule(scheduleId, DNAInd.ToIndicator(), disableValidation.ToIndicator(), CRCUser.UserId);
            return Json(new { url = Url.Action("Index", "Schedules") });
        }

        public ActionResult ProgramCalendarSearch(string term, string searchType)
        {
            using (var dt = CRCDataAccess.ProgramCalendarSearch(term, searchType))
            {
                var searchResults =
                    from DataRow dr in dt.Rows
                    select new
                    {
                        value = dr["ProgramId"],
                        label = dr["ProgramName"]
                    };

                return Json(searchResults, JsonRequestBehavior.AllowGet);
            }
        }


        public ActionResult ProgramActiveCalendarSearch(string term, string searchType)
        {
            using (var dt = CRCDataAccess.ProgramActiveCalendarSearch(term, searchType, "N"))
            {
                var searchResults =
                    from DataRow dr in dt.Rows
                    select new
                    {
                        value = dr["ProgramId"],
                        label = dr["ProgramName"]
                    };

                return Json(searchResults, JsonRequestBehavior.AllowGet);
            }
        }

		[System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "emailBody"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "email_body"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "Call_Letters_NU"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "Email_NU"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "Laast_Name_NU"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "Title_NU"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "Phone_NU"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA1801:ReviewUnusedParameters", MessageId = "First_Name_NU")]
		public ActionResult NewUserRequest(
			string First_Name_NU,
			string Last_Name_NU,
			string Email_NU,
			string Phone_NU,
			string Call_Letters_NU,
			string Title_NU
		)
		//public ActionResult NewUserRequest(
		//	string emailBody
		//)
        {
			var viewModel = new SignInViewModel();
			var drCRCManager = CRCDataAccess.GetCRCManager();
            if (drCRCManager != null)
            {
                viewModel.CRCManagerEmail = drCRCManager["Email"].ToString();
                viewModel.CRCManagerPhone = drCRCManager["Phone"].ToString();
                viewModel.CRCManagerFirstName = drCRCManager["FirstName"].ToString();
                viewModel.CRCManagerMiddleName = drCRCManager["MiddleName"].ToString();
                viewModel.CRCManagerLastName = drCRCManager["LastName"].ToString();
                viewModel.userId = Convert.ToInt64(drCRCManager["UserId"]);
                //viewModel.Email = Session["useremail"].ToString();

            }
			string UserEmail = CRCUser.Email;
			string emailBody= viewModel.CRCManagerFirstName + " - Please Add the User below to station: " + Call_Letters_NU + "\n\n";
			emailBody +=    "First Name: " + "  " + First_Name_NU;
			emailBody +=    "\n"+ "Last Name:" + "  " + Last_Name_NU;
			emailBody +=    "\n" + "Email: " + "  " + Email_NU;
			emailBody +=    "\n" + "Phone: " + "  " +Phone_NU;
			emailBody +=    "\n" + "Call Letters: " + "  " + Call_Letters_NU;
			emailBody +=	"\n" + "Title: " + "  " + Title_NU;
			emailBody +=	"\n" + "Submitted By:" + "  " + UserEmail;


			
			InfEmail.AddToQueue(UserEmail,  viewModel.CRCManagerEmail, "New CRC User Request: " + Call_Letters_NU, emailBody, 1);
			//try
			//{
			//	CRCDataAccess.RemoveUserStationLink(userId, stationId);
			//}
			//catch (EntitySqlException e)
			//{
			//	Console.Write(e);
			//}


			//if (primaryUserId.HasValue)
			//{

			//	if (userId == primaryUserId)
			//	{
			//		CRCDataAccess.UpdatePrimaryUserStatus(stationId);
			//	}
			//}
            return Json( "1",JsonRequestBehavior.AllowGet);
        }


        #region Methods

        private static DateTime calcDateTime(string day, TimeSpan time, DateTime startRange, DateTime endRange)
        {
            var date = FirstDayOccurenceInRange(day, startRange, endRange);
            var dateTime = date.Add(time);
            return dateTime;
        }

        private static DateTime FirstDayOccurenceInRange(string dayOfWeek, DateTime rangeStart, DateTime rangeEnd)
        {
            for (var date = rangeStart; date <= rangeEnd; date = date.AddDays(1))
            {
                if (date.DayOfWeek.ToString() == dayOfWeek)
                {
                    return date;
                }
            };

            throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture,
                "Unable to find the first {0} between {1:M/d/yyyy} and {2:M/d/yyyy}",
                dayOfWeek.ToString(),
                rangeStart,
                rangeEnd));
        }

        private static Array getDaysOfWeek(DataRow row)
        {
            List<string> daysOfWeek = new List<string>();
            string[] days = new string[7] { "SundayInd", "MondayInd", "TuesdayInd", "WednesdayInd", "ThursdayInd", "FridayInd", "SaturdayInd" };

            for (int i = 0; i < days.Length; i++)
            {
                if (string.Equals(row[days[i]].ToString(), "Y"))
                {
                    daysOfWeek.Add(i.ToString());
                }
            }
            return daysOfWeek.ToArray();
        }

        private static string getProgramType(string programName)
        {
            string className = "syndicated";
            if (programName.Contains("LOCAL") || programName.Contains("Local"))
            {
                className = "local";
            }
            else if (programName.Contains("Off Air") || programName.Contains("Off The Air"))
            {
                className = "offAir";
            }
            else if (programName.Contains("OTHER REGULAR PROGRAM"))
            {
                className = "regular";
            }
            return className;
        }

        #endregion
    }
}
