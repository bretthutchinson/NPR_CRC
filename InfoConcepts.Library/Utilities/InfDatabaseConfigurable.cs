using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using InfoConcepts.Library.DataAccess;
using InfoConcepts.Library.Extensions;

namespace InfoConcepts.Library.Utilities
{
    /// <summary>
    /// TODO: refactor this!
    /// </summary>
    public static class InfDatabaseConfigurable
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public static DataTable GetAllTextContent()
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_InfTextContentAll_Get");
            }
        }

        public static string GetTextContent(string parentName, string contentName)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                var dataRow = sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_InfTextContentByName_Get",
                    new SqlParameter("@ParentName", parentName),
                    new SqlParameter("@ContentName", contentName));

                if (dataRow == null)
                {
                    return string.Format(CultureInfo.InvariantCulture, "WARNING: No content found for parent name = \"{0}\" and content name = \"{1}\".", parentName, contentName);
                }
                else
                {
                    return dataRow["ContentText"].ToString();
                }
            }
        }

        public static InfDocument GetDocument(long infDocumentId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                var dataRow = sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_InfDocument_Get",
                    new SqlParameter("@InfDocumentId", infDocumentId));

                if (dataRow != null)
                {
                    var document = new InfDocument();
                    dataRow.MapTo(document);
                    return document;
                }
                else
                {
                    return null;
                }
            }
        }

        public static InfDocument GetDocument(string documentFileName)
        {
            return GetDocument(null, documentFileName);
        }

        public static InfDocument GetDocument(string parentName, string documentFileName)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                var dataRow = sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_InfDocumentByName_Get",
                    new SqlParameter("@ParentName", parentName),
                    new SqlParameter("@DocumentFileName", documentFileName));

                if (dataRow != null)
                {
                    var document = new InfDocument();
                    dataRow.MapTo(document);
                    return document;
                }
                else
                {
                    return null;
                }
            }
        }
    }
}
