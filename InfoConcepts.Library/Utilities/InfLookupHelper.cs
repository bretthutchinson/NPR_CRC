#region Using
using System.Data;
using System.Data.SqlClient;
using InfoConcepts.Library.DataAccess;
#endregion

namespace InfoConcepts.Library.Utilities
{
    /// <summary>
    /// TODO: refactor this!
    /// </summary>
    public static class InfLookupHelper
    {
        public static DataTable GetLookupList(string tableName, string idColumnName, string displayColumnName)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_InfLookupList_Get",
                    new SqlParameter("@TableName", tableName),
                    new SqlParameter("@IdColumnName", idColumnName),
                    new SqlParameter("@DisplayColumnName", displayColumnName));
            }
        }

        public static T LookupById<T>(string lookupTableName, long id, string valueColumnName)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<T>(
                    "dbo.PSP_InfLookupById_Get",
                    new SqlParameter("@LookupTableName", lookupTableName),
                    new SqlParameter("@Id", id),
                    new SqlParameter("@ValueColumnName", valueColumnName));
            }
        }

        public static long? ReverseLookup(string lookupTableName, string lookupColumnName, string lookupValue)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure(
                    "dbo.PSP_InfReverseLookup_Get",
                    new SqlParameter("@LookupTableName", lookupTableName),
                    new SqlParameter("@LookupColumnName", lookupColumnName),
                    new SqlParameter("@LookupValue", lookupValue)) as long?;
            }
        }
    }
}
