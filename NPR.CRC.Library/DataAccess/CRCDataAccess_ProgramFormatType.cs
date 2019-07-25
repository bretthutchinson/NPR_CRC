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
        public static DataRow GetProgramFormatType(long programFormatTypeId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_ProgramFormatType_Get",
                    new SqlParameter("@ProgramFormatTypeId", programFormatTypeId));
            }
        }

        public static long SaveProgramFormatType(long? programFormatTypeId, string programFormatTypeName, string programFormatTypeCode, long majorFormatId, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_ProgramFormatType_Save",
                    new SqlParameter("@ProgramFormatTypeId", programFormatTypeId),
                    new SqlParameter("@ProgramFormatTypeName", programFormatTypeName),
                    new SqlParameter("@ProgramFormatTypeCode", programFormatTypeCode),
                    new SqlParameter("@MajorFormatId", majorFormatId),
                    new SqlParameter("@DisabledDate", disabledDate),
                    new SqlParameter("@DisabledUserId", disabledUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetProgramFormatTypes()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProgramFormatTypes_Get");
            }
        }
    }
}
