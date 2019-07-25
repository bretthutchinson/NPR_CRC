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
        public static DataRow GetAffiliate(long affiliateId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_Affiliate_Get",
                    new SqlParameter("@AffiliateId", affiliateId));
            }
        }

        public static long SaveAffiliate(long? affiliateId, string affiliateName, string affiliateCode, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_Affiliate_Save",
                    new SqlParameter("@AffiliateId", affiliateId),
                    new SqlParameter("@AffiliateName", affiliateName),
                    new SqlParameter("@AffiliateCode", affiliateCode),
                    new SqlParameter("@DisabledDate", disabledDate),
                    new SqlParameter("@DisabledUserId", disabledUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetAffiliates()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_Affiliates_Get");
            }
        }

        public static DataRow GetStationAffiliate(long stationAffiliateId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_StationAffiliate_Get",
                    new SqlParameter("@StationAffiliateId", stationAffiliateId));
            }
        }

        public static long SaveStationAffiliate(long stationAffiliateId, long stationId, long affiliateId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_StationAffiliate_Save",
                    new SqlParameter("@StationAffiliateId", stationAffiliateId),
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@AffiliateId", affiliateId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static void DeleteStationAffiliates(long stationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                 sqlHelper.ExecuteScalarProcedure(
                    "dbo.PSP_StationAffiliate_Del",
                    new SqlParameter("@StationId", stationId));
            }
        }

        public static DataTable GetStationAffiliates(long stationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationAffiliates_Get",
                    new SqlParameter("@StationId", stationId));
            }
        }

        public static bool ValidateAffiliateCodeIsUnique(long? affiliateId, string affiliateCode)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                var isUnique = sqlHelper.ExecuteScalarProcedure<string>(
                    "dbo.PSP_AffiliateValidateCodeIsUnique_Get",
                    new SqlParameter("@AffiliateId", affiliateId),
                    new SqlParameter("@AffiliateCode", affiliateCode));

                return isUnique.Equals("Y", StringComparison.OrdinalIgnoreCase);
            }
        }

        public static bool ValidateAffiliateNameIsUnique(long? affiliateId, string affiliateName)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                var isUnique = sqlHelper.ExecuteScalarProcedure<string>(
                    "dbo.PSP_AffiliateValidateNameIsUnique_Get",
                    new SqlParameter("@AffiliateId", affiliateId),
                    new SqlParameter("@AffiliateName", affiliateName));

                return isUnique.Equals("Y", StringComparison.OrdinalIgnoreCase);
            }
        }
    }
}
