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
        public static DataRow GetSalutation(long salutationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_Salutation_Get",
                    new SqlParameter("@SalutationId", salutationId));
            }
        }

        public static long SaveSalutation(long salutationId, string salutationName, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_Salutation_Save",
                    new SqlParameter("@SalutationId", salutationId),
                    new SqlParameter("@SalutationName", salutationName),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetSalutations()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_Salutations_Get");
            }
        }
    }
}
