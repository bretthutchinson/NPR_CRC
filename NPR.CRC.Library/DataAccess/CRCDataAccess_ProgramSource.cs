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
        public static DataRow GetProgramSource(long programSourceId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_ProgramSource_Get",
                    new SqlParameter("@ProgramSourceId", programSourceId));
            }
        }

        public static long SaveProgramSource(long? programSourceId, string programSourceName, string programSourceCode, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_ProgramSource_Save",
                    new SqlParameter("@ProgramSourceId", programSourceId),
                    new SqlParameter("@ProgramSourceName", programSourceName),
                    new SqlParameter("@ProgramSourceCode", programSourceCode),
                    new SqlParameter("@DisabledDate", disabledDate),
                    new SqlParameter("@DisabledUserId", disabledUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetProgramSources()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProgramSources_Get");
            }
        }


        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetDropDownProgramSources()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProgramSources_DD_Get");
            }
        }
    }
}
