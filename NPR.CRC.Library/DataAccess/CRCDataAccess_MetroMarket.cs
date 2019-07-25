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
        public static DataRow GetMetroMarket(long metroMarketId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_MetroMarket_Get",
                    new SqlParameter("@MetroMarketId", metroMarketId));
            }
        }

        public static long SaveMetroMarket(long metroMarketId, string marketName, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_MetroMarket_Save",
                    new SqlParameter("@MetroMarketId", metroMarketId),
                    new SqlParameter("@MarketName", marketName),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static long UpdateMetroMarket(string callLetters, string band, string metroMarket, string metroMarketRank, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_MetroMarket_Update",
                    new SqlParameter("@CallLetters", callLetters),
                    new SqlParameter("@Band", band),
                    new SqlParameter("@MetroMarket", metroMarket),
                    new SqlParameter("@MetroMarketRank", metroMarketRank),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetMetroMarkets()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_MetroMarkets_Get");
            }
        }
    }
}
