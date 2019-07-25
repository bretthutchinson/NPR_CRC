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
        public static DataRow GetCRCUser(long userId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_CRCUser_Get",
                    new SqlParameter("@UserId", userId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataRow GetCRCManager()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_CRCManager_Get");
            }
        }

        public static long SaveCRCUser(long? userId, string email, long? salutationId, string firstName, string middleName, string lastName, string suffix, string jobTitle, string addressLine1, string addressLine2, string city, long? stateId, string county, string country, string zipCode, string phone, string fax, bool administratorInd, bool crcManagerInd, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_CRCUser_Save",
                    new SqlParameter("@UserId", userId),
                    new SqlParameter("@Email", email),
                    new SqlParameter("@SalutationId", salutationId),
                    new SqlParameter("@FirstName", firstName),
                    new SqlParameter("@MiddleName", middleName),
                    new SqlParameter("@LastName", lastName),
                    new SqlParameter("@Suffix", suffix),
                    new SqlParameter("@JobTitle", jobTitle),
                    new SqlParameter("@AddressLine1", addressLine1),
                    new SqlParameter("@AddressLine2", addressLine2),
                    new SqlParameter("@City", city),
                    new SqlParameter("@StateId", stateId),
                    new SqlParameter("@County", county),
                    new SqlParameter("@Country", country),
                    new SqlParameter("@ZipCode", zipCode),
                    new SqlParameter("@Phone", phone),
                    new SqlParameter("@Fax", fax),
                    new SqlParameter("@AdministratorInd", administratorInd ? "Y" : "N"),
                    new SqlParameter("@CRCManagerInd", crcManagerInd ? "Y" : "N"),
                    new SqlParameter("@DisabledDate", disabledDate),
                    new SqlParameter("@DisabledUserId", disabledUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static void SaveCRCUserPassword(long userId, string password, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                sqlHelper.ExecuteNonQueryProcedure(
                    "dbo.PSP_CRCUserPassword_Save",
                    new SqlParameter("@UserId", userId),
                    new SqlParameter("@Password", password),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static DataRow SaveCRCUserPasswordReset(string email, long? lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_CRCUserPasswordReset_Save",
                    new SqlParameter("@Email", email),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static DataRow GetCRCUserByLogin(string email, string password)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_CRCUserByLogin_Get",
                    new SqlParameter("@Email", email),
                    new SqlParameter("@Password", password));
            }
        }

        public static DataRow GetCRCUserByEmail(string email)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_CRCUserByEmail_Get",
                    new SqlParameter("@Email", email));
            }
        }

        public static DataRow GetCRCUserByResetPasswordToken(string token)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_CRCUserByResetPasswordToken_Get",
                    new SqlParameter("@Token", token));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetCRCUsers()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_CRCUsers_Get");
            }
        }

        public static void SaveStationUser(long stationId, long userId, bool primaryUserInd, bool gridWritePermissionsInd, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                sqlHelper.ExecuteNonQueryProcedure(
                    "dbo.PSP_StationUser_Save",
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@UserId", userId),
                    new SqlParameter("@PrimaryUserInd", primaryUserInd ? "Y" : "N"),
                    new SqlParameter("@GridWritePermissionsInd", gridWritePermissionsInd ? "Y" : "N"),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }

            InfSqlHelper.ExpireCache("dbo.PSP_StationsForUserId_Get");
        }

        public static DataTable GetStationUsers(long stationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationUsers_Get",
                    new SqlParameter("@StationId", stationId));
            }
        }

        public static DataRow GetStationUser(long stationId, long userId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_StationUser_Get",
                    new SqlParameter("@StationId", stationId),
                    new SqlParameter("@UserId", userId));
            }
        }

        public static DataTable GetStationsForUserId(long userId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                DataTable dt = sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_StationsForUserId_Get",
                    new SqlParameter("@UserId", userId));
                return dt;
            }
        }

        public static DataTable GetStationListForGrid(long userId)
        {
            using (var sqlHelper=new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                "dbo.PSP_StationListForGrid_Get", new SqlParameter("@UserId", userId));

            }
        }

        public static DataTable RemoveUserStationLink(long userId,long stationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                "dbo.PSP_UserStationLink_DELETE", 
                new SqlParameter("@UserId", userId),
                new SqlParameter("@StationId", stationId));

            }
        }

        public static DataTable UpdatePrimaryUserStatus(long stationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                "dbo.PSP_UpdateStationPrimaryId",
                 new SqlParameter("@StationId", stationId));

            }
        }


        public static DataTable SearchUsers(string userEnabled, string stationEnabled, string userName, long? repeaterStatusId, string userRole, string band, string userPermission, long? stationId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_CRCUsersSearch_Get",
                    new SqlParameter("@UserEnabled", userEnabled),
                    new SqlParameter("@StationEnabled", stationEnabled),
                    new SqlParameter("@UserName", userName),
                    new SqlParameter("@RepeaterStatusId", repeaterStatusId),
                    new SqlParameter("@UserRole", userRole),
                    new SqlParameter("@Band", band),
                    new SqlParameter("@UserPermission", userPermission),
                    new SqlParameter("@StationId", stationId));
            }
        }

        public static bool ValidateEmailIsUnique(long? userId, string email)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                var uniqueInd = sqlHelper.ExecuteScalarProcedure<string>(
                    "dbo.PSP_CRCUserValidateEmailIsUnique_Get",
                    new SqlParameter("@UserId", userId),
                    new SqlParameter("@Email", email));

                return uniqueInd.Equals("Y", StringComparison.OrdinalIgnoreCase);
            }
        }
    }
}
