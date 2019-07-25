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
        public static DataRow GetMajorFormat(long majorFormatId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_MajorFormat_Get",
                    new SqlParameter("@MajorFormatId", majorFormatId));
            }
        }

        public static long SaveMajorFormat(long? majorFormatId, string majorFormatName, string majorFormatCode, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_MajorFormat_Save",
                    new SqlParameter("@MajorFormatId", majorFormatId),
                    new SqlParameter("@MajorFormatName", majorFormatName),
                    new SqlParameter("@MajorFormatCode", majorFormatCode),
                    new SqlParameter("@DisabledDate", disabledDate),
                    new SqlParameter("@DisabledUserId", disabledUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetMajorFormats()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_MajorFormats_Get");
            }
        }

        public static bool ValidateMajorFormatCodeIsUnique(long? majorFormatId, string majorFormatCode)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                var isUnique = sqlHelper.ExecuteScalarProcedure<string>(
                    "dbo.PSP_MajorFormatValidateCodeIsUnique_Get",
                    new SqlParameter("@MajorFormatId", majorFormatId),
                    new SqlParameter("@MajorFormatCode", majorFormatCode));

                return isUnique.Equals("Y", StringComparison.OrdinalIgnoreCase);
            }
        }

        public static bool ValidateMajorFormatNameIsUnique(long? majorFormatId, string majorFormatName)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                var isUnique = sqlHelper.ExecuteScalarProcedure<string>(
                    "dbo.PSP_MajorFormatValidateNameIsUnique_Get",
                    new SqlParameter("@MajorFormatId", majorFormatId),
                    new SqlParameter("@MajorFormatName", majorFormatName));

                return isUnique.Equals("Y", StringComparison.OrdinalIgnoreCase);
            }
        }
    }
}
