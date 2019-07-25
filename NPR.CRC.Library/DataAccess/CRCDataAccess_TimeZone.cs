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
        public static DataRow GetTimeZone(long timeZoneId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_TimeZone_Get",
                    new SqlParameter("@TimeZoneId", timeZoneId));
            }
        }

        public static long SaveTimeZone(long timeZoneId, string timeZoneCode, string displayName, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_TimeZone_Save",
                    new SqlParameter("@TimeZoneId", timeZoneId),
                    new SqlParameter("@TimeZoneCode", timeZoneCode),
                    new SqlParameter("@DisplayName", displayName),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetTimeZones()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_TimeZones_Get");
            }
        }
    }
}
