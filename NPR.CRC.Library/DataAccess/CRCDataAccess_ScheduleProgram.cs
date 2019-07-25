#region Using
using System;
using System.Data;
using System.Data.SqlClient;
using InfoConcepts.Library.DataAccess;
using NPR.CRC.Library;
#endregion

namespace NPR.CRC.Library.DataAccess
{
    public static partial class CRCDataAccess
    {
        public static DataRow GetScheduleProgram(long scheduleProgramId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_ScheduleProgram_Get",
                    new SqlParameter("@ScheduleProgramId", scheduleProgramId));
            }
        }

        public static long SaveScheduleProgram(long scheduleProgramId, long scheduleId, long? programId, string startTime, string endTime, string sundayInd, string mondayInd, string tuesdayInd, string wednesdayInd, string thursdayInd, string fridayInd, string saturdayInd, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_ScheduleProgram_Save",
                    new SqlParameter("@ScheduleProgramId", scheduleProgramId),
                    new SqlParameter("@ScheduleId", scheduleId),
                    new SqlParameter("@ProgramId", programId),
                    new SqlParameter("@StartTime", startTime),
                    new SqlParameter("@EndTime", endTime),
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

        public static DataTable GetSchedulePrograms(long scheduleId, char grindInd)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_SchedulePrograms_Get",
                    new SqlParameter("@ScheduleId", scheduleId),
                    new SqlParameter("@GridInd", grindInd));
            }
        }

        public static DataTable ProgramCalendarSearch(string programName, string searchType)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_CalendarProgramSearch_Get",
                    new SqlParameter("@ProgramName", programName),
                    new SqlParameter("@SearchType", searchType)
                    //new SqlParameter("@IncludeDisabled", includeDisabled)
                    );
            }
        }

        public static DataTable ProgramActiveCalendarSearch(string programName, string searchType, string includeDisabled)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_CalendarActiveProgramSearch_Get",
                    new SqlParameter("@ProgramName", programName),
                    new SqlParameter("@SearchType", searchType)
                    ,new SqlParameter("@IncludeDisabled", includeDisabled)
                    );
            }
        }
    }
}
