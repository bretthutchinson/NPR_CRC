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
        public static DataRow GetCarriageType(long carriageTypeId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_CarriageType_Get",
                    new SqlParameter("@CarriageTypeId", carriageTypeId));
            }
        }

        public static long SaveCarriageType(long? carriageTypeId, string carriageTypeName, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_CarriageType_Save",
                    new SqlParameter("@CarriageTypeId", carriageTypeId),
                    new SqlParameter("@CarriageTypeName", carriageTypeName),
                    new SqlParameter("@DisabledDate", disabledDate),
                    new SqlParameter("@DisabledUserId", disabledUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetCarriageTypes()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_CarriageTypes_Get");
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetCarriageTypesEnabled()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_CarriageTypeEnabled_Get");
            }
        }

        public static DataTable GetCarriageWorkbookReport(long carriageTypeId, string monthSpan, int year, string bandSpan, string deletedInd, long? memberStatusId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_CarriageWorkBookReport_Get",
                    new SqlParameter("@CarriageTypeId", carriageTypeId),
                    new SqlParameter("@MonthSpan", monthSpan),
                    new SqlParameter("@Year", year),
                    new SqlParameter("@BandSpan", bandSpan),
                    new SqlParameter("@DeletedInd", deletedInd),
                    new SqlParameter("@MemberStatusId", memberStatusId),
                    new SqlParameter("@DebugInd", 'N'));
            }
        }

        public static DataTable GetCarriageWorkbookFile(long programId, long carriageTypeId, string monthSpan, int year, string bandSpan, string deletedInd, long? memberStatusId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_CarriageWorkBookFile_Get",
                    new SqlParameter("@ProgramId", programId),
                    new SqlParameter("@CarriageTypeId", carriageTypeId),
                    new SqlParameter("@MonthSpan", monthSpan),
                    new SqlParameter("@Year", year),
                    new SqlParameter("@BandSpan", bandSpan),
                    new SqlParameter("@DeletedInd", deletedInd),
                    new SqlParameter("@MemberStatusId", memberStatusId),
                    new SqlParameter("@DebugInd", 'N'));
            }
        }
    }
}
