using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Transactions;
using InfoConcepts.Library.DataAccess;
using NPR.CRC.Library.DataAccess;

namespace DataMigration
{
    class Program
    {
        private static long userId = 1;

        static void Main(string[] args)
        {
            //Set Connection String For legacy DB
            LegacySqlHelper.DefaultConnectionString = ConfigurationManager.ConnectionStrings["Legacy"].ConnectionString;
            LegacySqlHelper.DefaultCommandTimeout = TimeSpan.FromSeconds(3);

            InfSqlHelper.DefaultConnectionString = ConfigurationManager.ConnectionStrings["Dev"].ConnectionString;
            InfSqlHelper.DefaultCommandTimeout = TimeSpan.FromSeconds(3);
            Console.Write("Beginning. Press Any key to continue(Where's the 'Any' key?): ");
            Console.ReadKey();            

            Console.WriteLine("Beginning data transfer... ");

            using (var sqlHelper = new InfSqlHelper())
            {
                using (var transactionScope = new TransactionScope())
                {                    
                    Console.WriteLine("Transferring Users to the CRCUser Table... ");
                    TransferCRCUsers();
                    Console.WriteLine("CRCUser Transfer Complete------- ");
                    Console.Write("Transfer complete. Press any key to transfer Grid data to Schedules.");
                    Console.ReadKey();
                    sqlHelper.ExecuteNonQueryProcedure("dbo.DT_Station", new SqlParameter("@UserId", userId));
                    sqlHelper.ExecuteNonQueryProcedure("dbo.DT_Affiliate", new SqlParameter("@UserId", userId));
                    //dbo.Band -- Transfered via ReferenceTableData.sql
                    //dbo.CarriageType -- Transfered via ReferenceTableData.sql
                    //dbo.DMAMarket -- Transfered via ReferenceTableData.sql
                    //Inf Tables --No Data Migration for these??
                    //dbo.LicenseeType -- Transfered via ReferenceTableData.sql
                    sqlHelper.ExecuteScalarProcedure("dbo.DT_MajorFormat", new SqlParameter("@UserId", userId));
                    //dbo.MemberStatus -- Transfered via ReferenceTableData.sql
                    //dbo.MetroMarket -- Transfered via ReferenceTableData.sql
                    //dbo.MinorityStatus Transfered via ReferenceTableData.sql
                    sqlHelper.ExecuteScalarProcedure("dbo.DT_ProgramSource", new SqlParameter("@UserId", userId));
                    sqlHelper.ExecuteScalarProcedure("dbo.DT_ProgramFormatType", new SqlParameter("@UserId", userId)); //crc3.dbo.ProgramFormat
                    sqlHelper.ExecuteScalarProcedure("dbo.DT_Producer", new SqlParameter("@UserId", userId));
                    sqlHelper.ExecuteScalarProcedure("dbo.DT_Program", new SqlParameter("@UserId", userId));      
                    sqlHelper.ExecuteScalarProcedure("dbo.DT_ProgramProducer", new SqlParameter("@UserId", userId)); //crc.dbo.ProgramFormat --Info for this stored in crc3.dbo.Program
                    //dbo.repeaterStatus -- Transfered via ReferenceTableData.sql
                    //dbo.Salutation -- Transfered via ReferenceTableData.sql
                    //dbo.State -- Transfered via ReferenceTableData.sql
                    sqlHelper.ExecuteScalarProcedure("dbo.DT_StationAffiliate", new SqlParameter("@UserId", userId));
                    sqlHelper.ExecuteScalarProcedure("dbo.DT_StationNote", new SqlParameter("@UserId", userId));
                    sqlHelper.ExecuteScalarProcedure("dbo.DT_StationUser", new SqlParameter("@UserId", userId));
                    //dbo.TimeZone -- Transfered via ReferenceTableData.sql      
                    Console.WriteLine("Transferring Grid data to Schedules...Please wait.");
                    sqlHelper.ExecuteNonQueryProcedure("dbo.DT_GridToSchedule");
                    Console.WriteLine("Transfer complete. Press any key to transfer PERegular1 Partition.");
                    Console.ReadKey();

                    Console.WriteLine("Transferring PERegular1 Partition data to ScheduleProgram...Please wait.");
                    sqlHelper.ExecuteNonQueryProcedure("dbo.DT_PERegularToScheduleProgram1");
                    Console.WriteLine("Transfer complete. Press any key to transfer PERegular2 Partition.");
                    Console.ReadKey();

                    Console.WriteLine("Transferring PERegular2 Partition data to ScheduleProgram...Please wait.");
                    sqlHelper.ExecuteNonQueryProcedure("dbo.DT_PERegularToScheduleProgram2");
                    Console.WriteLine("Transfer complete. Press any key to transfer PERegular3 Partition");
                    Console.ReadKey();

                    Console.WriteLine("Transferring PERegular3 Partition data to ScheduleProgram...Please wait.");
                    sqlHelper.ExecuteNonQueryProcedure("dbo.DT_PERegularToScheduleProgram3");
                    Console.WriteLine("Transfer complete. Press any key to transfer PERegular4 Partition");
                    Console.ReadKey();

                    Console.WriteLine("Transferring PERegular4 Partition data to ScheduleProgram...Please wait.");
                    sqlHelper.ExecuteNonQueryProcedure("dbo.DT_PERegularToScheduleProgram4");
                    Console.WriteLine("Transfer complete. Press any key to transfer PEModular Partition");
                    Console.ReadKey();

                    Console.WriteLine("Transferring PEModular Partition data to ScheduleNewscast...Please wait.");
                    sqlHelper.ExecuteNonQueryProcedure("dbo.DT_PEModularToScheduleNewscast");
                    Console.WriteLine("Transfer complete. Press any key to continue");
                    Console.ReadKey();

                    transactionScope.Complete();
                }
            }
        }

        private static void TransferCRCUsers()
        {
            InfSqlHelper.DefaultConnectionString = ConfigurationManager.ConnectionStrings["Dev"].ConnectionString;
            InfSqlHelper.DefaultCommandTimeout = TimeSpan.FromSeconds(30);
            var sqlHelper = new InfSqlHelper();
                var casUserDataTable = sqlHelper.ExecuteDataTableProcedure("dbo.GET_CASUsers");

                int i = 0;
                foreach(DataRow dr in casUserDataTable.Rows)
                {            
                    i++;
                    //Assumption: 'UserName' no longer being used
                    SaveCRCUserDataMigration(
                        (long?)null,
                        dr["Email"].ToString(),
                        dr["SalutationId"] == "" ? (long?)dr["SalutationId"] : default(long?),
                        dr["FirstName"].ToString(),
                        dr["MiddleInitial"].ToString(),
                        dr["LastName"].ToString(),
                        dr["Suffix"].ToString(),
                        dr["JobTitle"].ToString(),
                        dr["Address1"].ToString(),
                        dr["Address2"].ToString(),
                        dr["City"].ToString(),
                        (long?)dr["StateId"],
                        dr["County"].ToString(),
                        null,  // 'Country' Default to United States?
                        dr["Zip"].ToString(),
                        dr["PhoneNumber"].ToString(),
                        dr["FaxNumber"].ToString(),
                        false, // 'AdministratorInd'
                        false,  // 'ManagerInd' Are users in the 'CASUsers' table all admins?  how does that work?
                        DateTime.UtcNow,
                        (bool)dr["Enabled"] ? userId : (long?)null,
                        userId,
                        dr["Password"].ToString());
                    
                    //if (i < 5) break;
                }
        }

        public static void SaveCRCUserDataMigration(long? userId, string email, long? salutationId, string firstName, string middleName, 
            string lastName, string suffix, string jobTitle, string addressLine1, string addressLine2, string city, long? stateId, string county, string country, string zipCode, string phone, string fax, 
            bool administratorInd, bool crcManagerInd, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId, string password)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                try
                {
                    sqlHelper.ExecuteNonQueryProcedure(
                        "dbo.DT_CRCUsers_Save",
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
                        new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId),
                        new SqlParameter("@Password", password));
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Could Not Insert User: " + email + " - " + ex.Message);
                }
            }
        }

    }
}
