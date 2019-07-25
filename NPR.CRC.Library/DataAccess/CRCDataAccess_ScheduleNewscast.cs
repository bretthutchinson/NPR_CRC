#region Using
using System;
using System.Data;
using System.Data.SqlClient;
using InfoConcepts.Library.DataAccess;
#endregion

namespace NPR.CRC.Library.DataAccess
{
    public static partial class CRCDataAccess
    {
        public static DataRow GetScheduleNewscast(long scheduleNewscastId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_ScheduleNewscast_Get",
                    new SqlParameter("@ScheduleNewscastId", scheduleNewscastId));
            }
        }

        public static long SaveScheduleNewscast(long scheduleNewscastId, long scheduleId, string startTime, string endTime, string hourlyInd, int durationMinutes, string sundayInd, string mondayInd, string tuesdayInd, string wednesdayInd, string thursdayInd, string fridayInd, string saturdayInd, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_ScheduleNewscast_Save",
                    new SqlParameter("@ScheduleNewscastId", scheduleNewscastId),
                    new SqlParameter("@ScheduleId", scheduleId),
                    new SqlParameter("@StartTime", startTime),
                    new SqlParameter("@EndTime", endTime),
                    new SqlParameter("@HourlyInd", hourlyInd),
                    new SqlParameter("@DurationMinutes", durationMinutes),
                    new SqlParameter("@SundayInd", sundayInd),
                    new SqlParameter("@MondayInd", mondayInd),
                    new SqlParameter("@TuesdayInd", tuesdayInd),
                    new SqlParameter("@WednesdayInd", wednesdayInd),
                    new SqlParameter("@ThursdayInd", thursdayInd),
                    new SqlParameter("@FridayInd", fridayInd),
                    new SqlParameter("@SaturdayInd", saturdayInd),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static void DeleteScheduleNewscast(long scheduleNewscastId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                sqlHelper.ExecuteNonQueryProcedure(
                    "dbo.PSP_ScheduleNewscast_Del",
                    new SqlParameter("@ScheduleNewscastId", scheduleNewscastId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static DataTable GetScheduleNewscasts(long scheduleId, char gridInd)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ScheduleNewscasts_Get",
                    new SqlParameter("@ScheduleId", scheduleId),
                    new SqlParameter("@GridInd", gridInd));
            }
        }
    }
}
