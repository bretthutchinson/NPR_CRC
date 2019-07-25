using System;
using System.Data.SqlClient;
using InfoConcepts.Library.DataAccess;

namespace InfoConcepts.Library.Validation
{
    public static class InfValidationHelper
    {
        public static bool IsValueUnique(object value, string tableName, string columnName, long? id)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<string>(
                    "dbo.PSP_InfIsValueUnique_Get",
                    new SqlParameter("@Value", value),
                    new SqlParameter("@TableName", tableName),
                    new SqlParameter("@ColumnName", columnName),
                    new SqlParameter("@Id", id))
                    .Equals("Y", StringComparison.OrdinalIgnoreCase);
            }
        }
    }
}
