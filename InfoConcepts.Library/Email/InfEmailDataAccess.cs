#region Using
using System.Data;
using System.Data.SqlClient;
using InfoConcepts.Library.DataAccess;
using InfoConcepts.Library.Extensions;
#endregion

namespace InfoConcepts.Library.Email
{
    /// <summary>
    /// Provides methods for creating, reading, updating and deleting database data for the "Inf" email classes and related functionality.
    /// </summary>
    internal static class InfEmailDataAccess
    {
        /// <summary>
        /// Gets all the unsent emails from the queue that have fewer than the specified number of retry attempts.
        /// </summary>
        public static DataTable GetQueuedEmails(int maxRetryAttempts)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_InfEmailUnsent_Get",
                    new SqlParameter("@MaxRetryAttempts", maxRetryAttempts));
            }
        }

        /// <summary>
        /// Gets the attachments for the specified email.
        /// </summary>
        public static DataTable GetAttachmentsForEmail(long InfEmailId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataTableProcedure(
                    "dbo.PSP_InfEmailAttachmentsForEmail_Get",
                    new SqlParameter("@InfEmailId", InfEmailId));
            }
        }

        /// <summary>
        /// Saves an email to the email queue.
        /// </summary>
        public static long SaveEmail(
            string fromAddress,
            string toAddress,
            string ccAddress,
            string bccAddress,
            string priority,
            string subject,
            string body,
            bool isBodyHtml,
            long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_InfEmail_Insert",
                    new SqlParameter("@FromAddress", fromAddress),
                    new SqlParameter("@ToAddress", toAddress),
                    new SqlParameter("@CcAddress", ccAddress),
                    new SqlParameter("@BccAddress", bccAddress),
                    new SqlParameter("@Priority", priority),
                    new SqlParameter("@Subject", subject),
                    new SqlParameter("@Body", body),
                    new SqlParameter("@HtmlInd", isBodyHtml ? "Y" : "N"),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        /// <summary>
        /// Saves an email attachment.
        /// </summary>
        public static long SaveEmailAttachment(
            long InfEmailId,
            string attachmentName,
            byte[] attachmentBytes,
            long lastUpdatedUserId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteScalarProcedure<long>(
                    "dbo.PSP_InfEmailAttachment_Insert",
                    new SqlParameter("@InfEmailId", InfEmailId),
                    new SqlParameter("@AttachmentName", attachmentName),
                    new SqlParameter("@AttachmentBytes", attachmentBytes),
                    new SqlParameter("@LastUpdatedUserId", lastUpdatedUserId));
            }
        }

        /// <summary>
        /// Returns the email template record with the specified name.
        /// </summary>
        public static DataRow GetEmailTemplateByName(string templateName)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                return sqlHelper.ExecuteDataRowProcedure(
                    "dbo.PSP_InfEmailTemplateByName_Get",
                    new SqlParameter("@TemplateName", templateName));
            }
        }

        /// <summary>
        /// Saves a success status for the specified InfEmail record.
        /// </summary>
        public static void SaveSuccessStatus(long InfEmailId)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                sqlHelper.ExecuteNonQueryProcedure(
                    "dbo.PSP_InfEmailSuccess_Update",
                    new SqlParameter("@InfEmailId", InfEmailId));
            }
        }

        /// <summary>
        /// Saves an error status for the specified InfEmail record.
        /// </summary>
        public static void SaveErrorStatus(long InfEmailId, string lastError)
        {
            using (var sqlHelper = new InfSqlHelper())
            {
                sqlHelper.ExecuteNonQueryProcedure(
                    "dbo.PSP_InfEmailError_Update",
                    new SqlParameter("@InfEmailId", InfEmailId),
                    new SqlParameter("@LastError", lastError));
            }
        }
    }
}
