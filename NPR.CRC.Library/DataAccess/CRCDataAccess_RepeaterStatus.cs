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
        public static DataRow GetRepeaterStatus(long repeaterStatusId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_RepeaterStatus_Get",
                    new SqlParameter("@RepeaterStatusId", repeaterStatusId));
            }
        }

        public static long SaveRepeaterStatus(long repeaterStatusId, string repeaterStatusName, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_RepeaterStatus_Save",
                    new SqlParameter("@RepeaterStatusId", repeaterStatusId),
                    new SqlParameter("@RepeaterStatusName", repeaterStatusName),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetRepeaterStatuses()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_RepeaterStatuses_Get");
            }
        }
    }
}
