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
        public static DataRow GetStation(long stationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_Station_Get",
                    new SqlParameter("@StationId", stationId));
            }
        }

        public static long SaveStation(long? stationId, string callLetters, long? bandId, string frequency, long? repeaterStatusId, long? flagshipStationId, long? memberStatusId, long? minorityStatusId, DateTime? statusDate, long? licenseeTypeId, string licenseeName, string addressLine1, string addressLine2, string city, long? stateId, string county, string country, string zipCode, string phone, string fax, string email, string webPage, string tsaCume, string tsaaqh, long? metroMarketId, int? metroMarketRank, long? dmaMarketId, int? dmaMarketRank, long? timeZoneId, int? hoursFromFlagship, int? maxNumberOfUsers, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_Station_Save",
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@CallLetters", callLetters),
                    new SqlParameter("@BandId", bandId),
                    new SqlParameter("@Frequency", frequency),
                    new SqlParameter("@RepeaterStatusId", repeaterStatusId),
                    new SqlParameter("@FlagshipStationId", flagshipStationId),
                    new SqlParameter("@MemberStatusId", memberStatusId),
                    new SqlParameter("@MinorityStatusId", minorityStatusId),
                    new SqlParameter("@StatusDate", statusDate),
                    new SqlParameter("@LicenseeTypeId", licenseeTypeId),
                    new SqlParameter("@LicenseeName", licenseeName),
                    new SqlParameter("@AddressLine1", addressLine1),
                    new SqlParameter("@AddressLine2", addressLine2),
                    new SqlParameter("@City", city),
                    new SqlParameter("@StateId", stateId),
                    new SqlParameter("@County", county),
                    new SqlParameter("@Country", country),
                    new SqlParameter("@ZipCode", zipCode),
                    new SqlParameter("@Phone", phone),
                    new SqlParameter("@Fax", fax),
                    new SqlParameter("@Email", email),
                    new SqlParameter("@WebPage", webPage),
                    new SqlParameter("@TSACume", tsaCume),
                    new SqlParameter("@TSAAQH", tsaaqh),
                    new SqlParameter("@MetroMarketId", metroMarketId),
                    new SqlParameter("@MetroMarketRank", metroMarketRank),
                    new SqlParameter("@DMAMarketId", dmaMarketId),
                    new SqlParameter("@DMAMarketRank", dmaMarketRank),
                    new SqlParameter("@TimeZoneId", timeZoneId),
                    new SqlParameter("@HoursFromFlagship", hoursFromFlagship),
                    new SqlParameter("@MaxNumberOfUsers", maxNumberOfUsers),
                    new SqlParameter("@DisabledDate", disabledDate),
                    new SqlParameter("@DisabledUserId", disabledUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static DataRow GetStationDetail(long stationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_StationDetail_Get",
                    new SqlParameter("@StationId", stationId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetStations()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_Stations_Get");
            }
        }

        public static DataTable GetStationAssociates(long stationId, string hdFlag)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationAssociates_Get",
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@HDFlag", hdFlag));
            }
        }

        public static DataTable GetStationsList()
        {
            return GetStationsList(null);
        }

		public static DataTable GetStationsListBandMemberStatus(String Band, String MemberStatusId)
        {
            return GetStationsListBandMemberStatus(null,Band, MemberStatusId);
        }



        public static DataTable GetStationsList(long? userId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationsList_Get",
                    new SqlParameter("@UserId", userId));
            }
        }


		public static DataTable GetStationsListBandMemberStatus(long? userId,String Band, String MemberStatusId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationsListBandMemberStatus_Get",
                    new SqlParameter("@UserId", userId),
					new SqlParameter("@Band", Band),
					new SqlParameter("@MemberStatusId", MemberStatusId)
					);
            }
        }

        public static DataTable GetStationsActiveList(long? userId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationsActiveList_Get",
                    new SqlParameter("@UserId", userId)					
					);
            }
        }

        public static DataTable GetEnabledStationList()
        {
            return GetEnabledStationList(null);
        }

        public static DataTable GetEnabledStationList(long? userId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationsEnabledList_Get",
                    new SqlParameter("@UserId", userId));
            }
        }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]

        public static DataTable GetEnabledProgram()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProgramEnabledList_Get");
            }
        }

        public static DataTable GetStationLinkStatus(long userId,long? stationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationLinkStatus_Get",
                    new SqlParameter("@UserId", userId),
					new SqlParameter("@StationId",stationId)
					);
            }
        }

        public static DataTable GetStationLinkPrimaryUser(long? stationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationLinkPrimaryUser_Get",
                    new SqlParameter("@StationId", stationId));
            }
        }	

        public static DataTable SearchStations(long? stationId, long? repeaterStatusId, long? metroMarketId, string enabled, long? memberStatusId, long? dmaMarketId, string bandId, long? stateId, long? licenseeTypeId, long? affiliateId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationsSearch_Get",
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@RepeaterStatusId", repeaterStatusId),
                    new SqlParameter("@MetroMarketId", metroMarketId),
                    new SqlParameter("@Enabled", enabled),
                    new SqlParameter("@MemberStatusId", memberStatusId),
                    new SqlParameter("@DMAMarketId", dmaMarketId),
                    new SqlParameter("@BandId", bandId),
                    new SqlParameter("@StateId", stateId),
                    new SqlParameter("@LicenseeTypeId", licenseeTypeId),
                    new SqlParameter("@AffiliateId", affiliateId));
            }
        }

        public static DataTable StationSearch(string searchTerm)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationSearch_Get",
                    new SqlParameter("@SearchTerm", searchTerm));
            }
        }

        public static DataTable StationActiveSearch(string searchTerm)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationActiveSearch_Get",
                    new SqlParameter("@SearchTerm", searchTerm));
            }
        }

        public static DataTable GetStationNotesReport(long? stationId, string keyword, DateTime? lastUpdatedFromDate, DateTime? lastUpdatedToDate, string deletedInd)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationNotesReport_Get",
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@Keyword", keyword),
                    new SqlParameter("@LastUpdatedFromDate", lastUpdatedFromDate),
                    new SqlParameter("@LastUpdatedToDate", lastUpdatedToDate),
                    new SqlParameter("@DeletedInd", deletedInd),
                    new SqlParameter("@DebugInd", "N"));
            }
        }

        public static DataTable GetStationUsersReport(string userPermission, string bandSpan, string repeaterStatus)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationUsersReport_Get",
                    new SqlParameter("@UserPermission", userPermission),
                    new SqlParameter("@BandSpan", bandSpan),
                    new SqlParameter("@RepeaterStatus", repeaterStatus),
                    new SqlParameter("@DebugInd", "N")
                    );
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetFlagshipStationsList()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_FlagshipStationsList_Get");
            }
        }

        public static long UpdateStationAQHCume(string callLetters, string band, long aQH, long cume, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_StationAQHCume_Update",
                    new SqlParameter("@CallLetters", callLetters),
                    new SqlParameter("@Band", band),
                    new SqlParameter("@AQH", aQH),
                    new SqlParameter("@Cume", cume),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

         [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetStationAllList()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure("dbo.PSP_StationListAll_Get");
            }
        }

         public static bool ValidateCallLettersIsUnique(long? stationId, string callLetters, long? bandId)
         {
             using (var sqlHelper = new InfSqlHelper())
             {
                 var isUnique = sqlHelper.ExecuteScalarProcedure<string>(
                     "dbo.PSP_CallLettersIsUnique_Get",
                     new SqlParameter("@StationId", stationId),
                     new SqlParameter("@BandId", bandId),
                     new SqlParameter("@CallLetters", callLetters));

                 return isUnique.Equals("Y", StringComparison.OrdinalIgnoreCase);
             }
         }
    }
}
