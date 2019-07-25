#region Using
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Net.Mail;
using System.Timers;
using System.Transactions;
using InfoConcepts.Library.Extensions;
using InfoConcepts.Library.Logging;
using InfoConcepts.Library.Utilities;
#endregion

namespace InfoConcepts.Library.Email
{
    /// <summary>
    /// Provides methods for queuing emails to be sent in the background.
    /// </summary>
    public static class InfEmail
    {
        #region Fields

        private static SmtpClient _smtpClient = new SmtpClient();
        private static Timer _queueTimer;

        #endregion

        #region Properties

        /// <summary>
        /// The connection information for the SMTP server to use.
        /// In addition to setting the SMTP connection information programmatically,
        /// it can also be configured in the &lt;system.net&gt;&lt;mailSettings&gt; section of the config file.
        /// See http://msdn.microsoft.com/en-us/library/w355a94k.aspx.
        /// </summary>
        public static SmtpClient SmtpSettings
        {
            get { return _smtpClient; }
        }

        /// <summary>
        /// Gets or sets the number of unsuccesful attempts to send an email before giving up.
        /// </summary>
        public static int MaxRetryAttempts
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets how often the queue will be checked for pending emails.
        /// </summary>
        public static TimeSpan QueueInterval
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets whether or not the queue will be automatically started, if not already started, whenever an email is added to the queue.
        /// </summary>
        public static bool AutoStartQueue
        {
            get;
            set;
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Queues an email message to be sent in the background.
        /// </summary>
        public static long AddToQueue(MailMessage email, long lastUpdatedUserId)
        {
            using (var transactionScope = new TransactionScope())
            {
                var InfEmailId = InfEmailDataAccess.SaveEmail(
                    email.From.ToString(),
                    email.To.ToString(),
                    email.CC.ToString(),
                    email.Bcc.ToString(),
                    email.Priority.ToString(),
                    email.Subject,
                    email.Body,
                    email.IsBodyHtml,
                    lastUpdatedUserId);

                foreach (var attachment in email.Attachments)
                {
                    InfEmailDataAccess.SaveEmailAttachment(
                        InfEmailId,
                        attachment.Name,
                        attachment.ContentStream.ReadAllBytes(),
                        lastUpdatedUserId);
                }

                transactionScope.Complete();

                if (AutoStartQueue)
                {
                    StartQueue();
                }

                return InfEmailId;
            }
        }

        /// <summary>
        /// Queues an email message to be sent in the background.
        /// </summary>
        public static void AddToQueue(string from, string to, string subject, string body, long lastUpdatedUserId)
        {
            using (var email = new MailMessage(from, to, subject, body))
            {
                AddToQueue(email, lastUpdatedUserId);
            }
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Token placeholders within the referenced template should have the format "{FieldName}".
        /// </summary>
        public static void AddToQueue(string templateName, IDictionary<string, object> tokens, long lastUpdatedUserId)
        {
            AddToQueue(templateName, tokens, null, null, lastUpdatedUserId);
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Token placeholders within the referenced template should have the format "{FieldName}".
        /// </summary>
        public static void AddToQueue(string templateName, object tokens, long lastUpdatedUserId)
        {
            AddToQueue(templateName, tokens.ToDictionary(), lastUpdatedUserId);
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Token placeholders within the referenced template should have the format "{FieldName}".
        /// </summary>
        public static void AddToQueue(string templateName, DataRow tokens, long lastUpdatedUserId)
        {
            AddToQueue(templateName, tokens.ToDictionary(), lastUpdatedUserId);
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Use the token options argument to indicate the prefix and/or suffix used to denote token placeholders within the referenced template.
        /// <param name="lastUpdatedUserId"></param>
        public static void AddToQueue(string templateName, IDictionary<string, object> tokens, InfTokenOptions tokenOptions, long lastUpdatedUserId)
        {
            AddToQueue(templateName, tokens, tokenOptions, null, lastUpdatedUserId);
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Use the token options argument to indicate the prefix and/or suffix used to denote token placeholders within the referenced template.
        /// <param name="lastUpdatedUserId"></param>
        public static void AddToQueue(string templateName, object tokens, InfTokenOptions tokenOptions, long lastUpdatedUserId)
        {
            AddToQueue(templateName, tokens.ToDictionary(), tokenOptions, lastUpdatedUserId);
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Use the token options argument to indicate the prefix and/or suffix used to denote token placeholders within the referenced template.
        /// <param name="lastUpdatedUserId"></param>
        public static void AddToQueue(string templateName, DataRow tokens, InfTokenOptions tokenOptions, long lastUpdatedUserId)
        {
            AddToQueue(templateName, tokens.ToDictionary(), tokenOptions, lastUpdatedUserId);
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Token placeholders within the referenced template should have the format "{FieldName}".
        /// <param name="lastUpdatedUserId"></param>
        public static void AddToQueue(string templateName, IDictionary<string, object> tokens, IDictionary<string, byte[]> attachments, long lastUpdatedUserId)
        {
            AddToQueue(templateName, tokens, null, attachments, lastUpdatedUserId);
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Token placeholders within the referenced template should have the format "{FieldName}".
        /// <param name="lastUpdatedUserId"></param>
        public static void AddToQueue(string templateName, object tokens, IDictionary<string, byte[]> attachments, long lastUpdatedUserId)
        {
            AddToQueue(templateName, tokens.ToDictionary(), attachments, lastUpdatedUserId);
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Token placeholders within the referenced template should have the format "{FieldName}".
        /// <param name="lastUpdatedUserId"></param>
        public static void AddToQueue(string templateName, DataRow tokens, IDictionary<string, byte[]> attachments, long lastUpdatedUserId)
        {
            AddToQueue(templateName, tokens.ToDictionary(), attachments, lastUpdatedUserId);
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Use the token options argument to indicate the prefix and/or suffix used to denote token placeholders within the referenced template.
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2202:Do not dispose objects multiple times")]
        public static void AddToQueue(string templateName, IDictionary<string, object> tokens, InfTokenOptions tokenOptions, IDictionary<string, byte[]> attachments, long lastUpdatedUserId)
        {
            var emailTemplateRow = InfEmailDataAccess.GetEmailTemplateByName(templateName);
            if (emailTemplateRow == null)
            {
                throw new ArgumentException("Email template not found.", "templateName");
            }

            var fromAddress = emailTemplateRow["FromAddress"].ToString().ReplaceTokens(tokens, tokenOptions);
            var toAddress = emailTemplateRow["ToAddress"].ToString().ReplaceTokens(tokens, tokenOptions);
            var ccAddress = emailTemplateRow["CcAddress"].ToString().ReplaceTokens(tokens, tokenOptions);
            var bccAddress = emailTemplateRow["BccAddress"].ToString().ReplaceTokens(tokens, tokenOptions);
            var subject = emailTemplateRow["Subject"].ToString().ReplaceTokens(tokens, tokenOptions);
            var body = emailTemplateRow["Body"].ToString().ReplaceTokens(tokens, tokenOptions);
            var priority = emailTemplateRow["Priority"].ToString();
            var htmlInd = emailTemplateRow["HtmlInd"].ToString().StartsWith("Y", StringComparison.OrdinalIgnoreCase);

            using (var email = new MailMessage(fromAddress, toAddress, subject, body))
            {
                email.IsBodyHtml = htmlInd;

                if (!string.IsNullOrWhiteSpace(ccAddress))
                {
                    email.CC.Add(ccAddress);
                }

                if (!string.IsNullOrWhiteSpace(bccAddress))
                {
                    email.Bcc.Add(bccAddress);
                }

                if (!string.IsNullOrWhiteSpace(priority))
                {
                    email.Priority = (MailPriority)Enum.Parse(typeof(MailPriority), priority, true);
                }

                if (attachments != null)
                {
                    foreach (var item in attachments)
                    {
                        var attachmentName = item.Key;
                        var attachmentBytes = item.Value;

                        using (var memoryStream = new MemoryStream(attachmentBytes))
                        {
                            using (var attachment = new Attachment(memoryStream, attachmentName))
                            {
                                email.Attachments.Add(attachment);
                            }
                        }
                    }
                }

                AddToQueue(email, lastUpdatedUserId);
            }
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Use the token options argument to indicate the prefix and/or suffix used to denote token placeholders within the referenced template.
        /// </summary>
        public static void AddToQueue(string templateName, object tokens, InfTokenOptions tokenOptions, IDictionary<string, byte[]> attachments, long lastUpdatedUserId)
        {
            AddToQueue(templateName, tokens.ToDictionary(), tokenOptions, attachments, lastUpdatedUserId);
        }

        /// <summary>
        /// Queues a templage-based email message to be sent in the background.
        /// Use the token options argument to indicate the prefix and/or suffix used to denote token placeholders within the referenced template.
        /// </summary>
        public static void AddToQueue(string templateName, DataRow tokens, InfTokenOptions tokenOptions, IDictionary<string, byte[]> attachments, long lastUpdatedUserId)
        {
            AddToQueue(templateName, tokens.ToDictionary(), tokenOptions, attachments, lastUpdatedUserId);
        }

        /// <summary>
        /// Starts the queue so it will begin sending any pending emails at the inverval indicated by the QueueInterval property.
        /// </summary>
        public static void StartQueue()
        {
            if (_queueTimer == null)
            {
                _queueTimer = new Timer();
                _queueTimer.Interval = QueueInterval.TotalMilliseconds;
                _queueTimer.AutoReset = false;
                _queueTimer.Elapsed +=
                    delegate(object sender, ElapsedEventArgs e)
                    {
                        SendQueuedEmails();
                        _queueTimer.Start();
                    };
            }

            _queueTimer.Start();
        }

        /// <summary>
        /// Stops the queue so emails will not be sent.
        /// </summary>
        public static void StopQueue()
        {
            if (_queueTimer != null)
            {
                _queueTimer.Stop();
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Sends all unsent emails that are pending in the queue.
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2202:Do not dispose objects multiple times")]
        private static void SendQueuedEmails()
        {
            using (var emailQueue = InfEmailDataAccess.GetQueuedEmails(MaxRetryAttempts))
            {
                foreach (DataRow emailRow in emailQueue.Rows)
                {
                    var infEmailId = (long)emailRow["InfEmailId"];
                    var from = emailRow["FromAddress"].ToString();
                    var to = emailRow["ToAddress"].ToString().Replace(';', ',');
                    var cc = emailRow["CcAddress"].ToString().Replace(';', ',');
                    var bcc = emailRow["BccAddress"].ToString().Replace(';', ',');
                    var subject = emailRow["Subject"].ToString();
                    var body = emailRow["Body"].ToString();
                    var priority = emailRow["Priority"].ToString();
                    var htmlInd = emailRow["HtmlInd"].ToString().StartsWith("Y", StringComparison.OrdinalIgnoreCase);

                    using (var email = new MailMessage(from, to, subject, body))
                    {
                        email.IsBodyHtml = htmlInd;

                        if (!string.IsNullOrWhiteSpace(cc))
                        {
                            email.CC.Add(cc);
                        }

                        if (!string.IsNullOrWhiteSpace(bcc))
                        {
                            email.Bcc.Add(bcc);
                        }

                        if (!string.IsNullOrWhiteSpace(priority))
                        {
                            email.Priority = (MailPriority)Enum.Parse(typeof(MailPriority), priority, true);
                        }

                        using (var attachmentsTable = InfEmailDataAccess.GetAttachmentsForEmail(infEmailId))
                        {
                            foreach (DataRow attachmentRow in attachmentsTable.Rows)
                            {
                                var attachmentName = attachmentRow["AttachmentName"].ToString();
                                var attachmentBytes = attachmentRow["AttachmentBytes"] as byte[];

                                using (var memoryStream = new MemoryStream(attachmentBytes))
                                {
                                    using (var attachment = new Attachment(memoryStream, attachmentName))
                                    {
                                        email.Attachments.Add(attachment);
                                    }
                                }
                            }
                        }

                        try
                        {
                            Send(email);
                            InfEmailDataAccess.SaveSuccessStatus(infEmailId);
                        }
                        catch (Exception ex)
                        {
                            var baseException = ex.GetBaseException();
                            InfLogger.Log(baseException);

                            var lastError = string.Format(CultureInfo.InvariantCulture, "{0}: {1}", baseException.GetType().FullName, baseException.Message);
                            InfEmailDataAccess.SaveErrorStatus(infEmailId, lastError);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Sends the specified email.
        /// </summary>
        private static void Send(MailMessage email)
        {
            _smtpClient.Send(email);
        }

        #endregion
    }
}
