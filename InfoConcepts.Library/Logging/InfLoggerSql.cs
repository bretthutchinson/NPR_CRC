using System.Data.SqlClient;
using System.Transactions;
using InfoConcepts.Library.DataAccess;

namespace InfoConcepts.Library.Logging
{
    internal class InfLoggerSql : IInfLogger
    {
        public void Log(InfLogEntry logEntry)
        {
            using (var transaction = new TransactionScope(TransactionScopeOption.Suppress))
            {
                using (var sqlHelper = new InfSqlHelper())
                {
                    sqlHelper.ExecuteNonQueryProcedure(
                        "dbo.PSP_InfLog_Insert",
                        new SqlParameter("@SerialNumber", logEntry.SerialNumber),
                        new SqlParameter("@LogLevel", logEntry.LogLevel),
                        new SqlParameter("@Source", logEntry.Source),
                        new SqlParameter("@Message", logEntry.Message),
                        new SqlParameter("@UserName", logEntry.UserName),
                        new SqlParameter("@ServerAddress", logEntry.ServerAddress),
                        new SqlParameter("@ServerHostname", logEntry.ServerHostname),
                        new SqlParameter("@ClientAddress", logEntry.ClientAddress),
                        new SqlParameter("@ClientHostname", logEntry.ClientHostname));
                }
            }
        }
    }
}
