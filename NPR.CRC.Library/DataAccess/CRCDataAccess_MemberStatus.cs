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
        public static DataRow GetMemberStatus(long memberStatusId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_MemberStatus_Get",
                    new SqlParameter("@MemberStatusId", memberStatusId));
            }
        }

        public static long SaveMemberStatus(long? memberStatusId, string memberStatusName, bool nprMembershipInd, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_MemberStatus_Save",
                    new SqlParameter("@MemberStatusId", memberStatusId),
                    new SqlParameter("@MemberStatusName", memberStatusName),
                    new SqlParameter("@NPRMembershipInd", (nprMembershipInd == true ? "Y" : "N")),
                    new SqlParameter("@DisabledDate", disabledDate),
                    new SqlParameter("@DisabledUserId", disabledUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetMemberStatuses()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_MemberStatuses_Get");
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetMemberStatusEnabled()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_MemberStatusEnabled_Get");
            }
        }
    }
}
