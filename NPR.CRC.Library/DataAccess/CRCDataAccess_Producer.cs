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
        public static DataRow GetProducer(long producerId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_Producer_Get",
                    new SqlParameter("@ProducerId", producerId));
            }
        }

        public static long SaveProducer(long? producerId, long? salutationId, string firstName, string middleName, string lastName, string suffix, string role, string email, string phone, DateTime? disabledDate, long? disabledUserId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_Producer_Save",
                    new SqlParameter("@ProducerId", producerId),
                    new SqlParameter("@SalutationId", salutationId),
                    new SqlParameter("@FirstName", firstName),
                    new SqlParameter("@MiddleName", middleName),
                    new SqlParameter("@LastName", lastName),
                    new SqlParameter("@Suffix", suffix),
                    new SqlParameter("@Role", role),
                    new SqlParameter("@Email", email),
                    new SqlParameter("@Phone", phone),
                    new SqlParameter("@DisabledDate", disabledDate),
                    new SqlParameter("@DisabledUserId", disabledUserId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetProducers()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_Producers_Get");
            }
        }

        public static DataTable SearchProgramProducers(long? programId, long? producerid)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProgramProducerSearch_Get",
                    new SqlParameter("@ProgramId", programId),
                    new SqlParameter("@ProducerId", producerid),
                    new SqlParameter("@DebugInd", "N"));
            }
        }

        public static DataTable GetProgramProducersByProducerId(long producerId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProgramProducersByProducerId_Get",
                    new SqlParameter("@ProducerId", producerId));
            }
        }

        public static DataTable GetProgramProducersByProgramId(long programId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProgramProducersByProgramId_Get",
                    new SqlParameter("@ProgramId", programId));
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetProducersList()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_ProducersList_Get");
            }
        }

        public static void SaveProgramProducer(long programId, long? producerId, long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                sqlHelper.ExecuteNonQueryProcedure(
                    "dbo.PSP_ProgramProducer_Save",
                    new SqlParameter("@ProgramId", programId),
                    new SqlParameter("@ProducerId", producerId),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        public static void RemoveProgramProducer(long programProducerId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                sqlHelper.ExecuteNonQueryProcedure(
                    "dbo.PSP_ProgramProducer_DELETE",                    
                    new SqlParameter("@ProgramProducerId", programProducerId));
            }
        }
    }
}
