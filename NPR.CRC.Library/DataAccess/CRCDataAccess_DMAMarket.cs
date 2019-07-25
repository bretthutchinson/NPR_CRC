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
        public static DataRow GetDMAMarket(long dmaMarketId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_DMAMarket_Get",
                    new SqlParameter("@DMAMarketId", dmaMarketId));
            }
        }

        public static long SaveDMAMarket(long stationId, long dmaMarketId, string dmaMarketRank, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_DMAMarket_Save",
                    new SqlParameter("@DMAMarketId", stationId),
                    new SqlParameter("@DMAMarketId", dmaMarketId),
                    new SqlParameter("@DMAMarketRank", dmaMarketRank),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static long UpdateDMAMarket(string callLetters, string band, string dmaMarket, string dmaMarketRank, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_DMAMarket_Update",
                    new SqlParameter("@CallLetters", callLetters),
                    new SqlParameter("@Band", band),
                    new SqlParameter("@DMAMarket", dmaMarket),
                    new SqlParameter("@DMAMarketRank", dmaMarketRank),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetDMAMarkets()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_DMAMarkets_Get");
            }
        }
    }
}
