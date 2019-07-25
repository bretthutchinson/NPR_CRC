#region Using
using System;
using System.Data;
using System.Data.SqlClient;
using InfoConcepts.Library.DataAccess;
using InfoConcepts.Library.Security;
using InfoConcepts.Library.Web.Mvc;
using NPR.CRC.Library;
using NPR.CRC.Library.DataAccess;
using InfoConcepts.Library.Extensions;



#endregion

namespace NPR.CRC.Library.DataAccess
{
    public static partial class CRCDataAccess
    {
        public static DataTable GetSchedules(long stationId, int year, int month, string status)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_Schedules_Get",
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@Year", year),
                    new SqlParameter("@Month", month),
                    new SqlParameter("@Status", status));
            }
        }

        public static DataRow GetSchedule(long scheduleId, long userId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
					
                    "dbo.PSP_Schedule_Get",
                    new SqlParameter("@UserId",userId),
					new SqlParameter("@ScheduleId", scheduleId));
            }
        }


        public static long SaveSchedule(long scheduleId, long stationId, int year, int month, DateTime submittedDate, long submittedUserId, DateTime acceptedDate, long acceptedUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_Schedule_Save",
                    new SqlParameter("@ScheduleId", scheduleId),
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@Year", year),
                    new SqlParameter("@Month", month),
                    new SqlParameter("@SubmittedDate", submittedDate),
                    new SqlParameter("@SubmittedUserId", submittedUserId),
                    new SqlParameter("@AcceptedDate", acceptedDate),
                    new SqlParameter("@AcceptedUserId", acceptedUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static void DeleteSchedule(long scheduleId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                sqlHelper.ExecuteNonQueryProcedure(
                    "dbo.PSP_Schedule_Del",
                    new SqlParameter("@ScheduleId", scheduleId));
            }
        }

        public static void SaveScheduleStatus(long scheduleId, string status, long lastUpdateduserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                sqlHelper.ExecuteNonQueryProcedure(
                    "dbo.PSP_ScheduleCalendarStatus_Save",
                    new SqlParameter("@ScheduleId", scheduleId),
                    new SqlParameter("@ScheduleStatus", status),
                    new SqlParameter("@LastUpdatedUserId", lastUpdateduserId));
            }
        }

        public static void SubmitSchedule(long scheduleId, string dNAInd, string disableValidation, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                sqlHelper.ExecuteNonQueryProcedure(
                    "dbo.PSP_ScheduleCalendar_Save",
                    new SqlParameter("@ScheduleId", scheduleId),
                    new SqlParameter("@DNAInd", dNAInd),
					new SqlParameter("@disableValidation", disableValidation),
                    new SqlParameter("@LastUpdatedUserid", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetMonthsList()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure("dbo.PSP_MonthsList_Get");
            }
        }

        public static DataTable GetScheduleYearsList(int futureYears)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ScheduleYearsList_Get",
                    new SqlParameter("@FutureYears", futureYears));
            }
        }

        public static DataTable SearchSchedules(long? stationId, int? month, int? year, string status)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ScheduleSearch_Get",
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@Month", month),
                    new SqlParameter("@Year", year),
                    new SqlParameter("@Status", status));
            }
        }

        public static DataTable SearchSchedulesManage(long? stationId, int? month, int? year, string status)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ScheduleSearchManage_Get",
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@Month", month),
                    new SqlParameter("@Year", year),
                    new SqlParameter("@Status", status));
            }
        }


        public static long CreateSchedule(long stationId, int month, int year, long lastUpdatedUserId)
        {
            return CreateSchedule(stationId, month, year, null, null, lastUpdatedUserId);
        }

        public static long CreateSchedule(long stationId, int month, int year, int? monthToCopy, int? yearToCopy, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
				return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_ScheduleCreate_Save",
                    new SqlParameter("@StationId", stationId),
					new SqlParameter("@Month", month),
					new SqlParameter("@Year", year),
					new SqlParameter("@MonthToCopy", monthToCopy),
					new SqlParameter("@YearToCopy", yearToCopy),
					new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static DataTable GetGridDataReport(string bandSpan, string deletedInd, string repeaterStatus, string regularNewscastInd, int month, int year)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_GridDataReport_Get",
                    new SqlParameter("@BandSpan", bandSpan),
                    new SqlParameter("@DeletedInd", deletedInd),
                    new SqlParameter("@RepeaterStatus", repeaterStatus),
                    new SqlParameter("@RegularNewscastInd", regularNewscastInd),
                    new SqlParameter("@Month", month),
                    new SqlParameter("@Year", year),
                    new SqlParameter("@DebugInd", 'N'));
            }
        }

    }
}
