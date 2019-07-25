CREATE TABLE [dbo].[InfEmail] (
    [InfEmailId]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [FromAddress]       VARCHAR (50)  NOT NULL,
    [ToAddress]         VARCHAR (MAX) NOT NULL,
    [CcAddress]         VARCHAR (MAX) NULL,
    [BccAddress]        VARCHAR (MAX) NULL,
    [Priority]          VARCHAR (50)  NOT NULL,
    [Subject]           VARCHAR (500) NOT NULL,
    [Body]              VARCHAR (MAX) NOT NULL,
    [HtmlInd]           CHAR (1)      CONSTRAINT [DEF_InfEmail_HtmlInd] DEFAULT ('N') NOT NULL,
    [SentDate]          DATETIME      NULL,
    [RetryCount]        INT           NOT NULL,
    [LastError]         VARCHAR (MAX) NULL,
    [CreatedDate]       DATETIME      NOT NULL,
    [CreatedUserId]     BIGINT        NOT NULL,
    [LastUpdatedDate]   DATETIME      NOT NULL,
    [LastUpdatedUserId] BIGINT        NOT NULL,
    CONSTRAINT [PK_InfEmail] PRIMARY KEY CLUSTERED ([InfEmailId] ASC),
    CONSTRAINT [CHK_InfEmail_HtmlInd] CHECK ([HtmlInd]='N' OR [HtmlInd]='Y'),
    CONSTRAINT [CHK_InfEmail_Priority] CHECK ([Priority]='High' OR [Priority]='Normal' OR [Priority]='Low'),
    CONSTRAINT [CHK_InfEmail_RetryCount] CHECK ([RetryCount]>=(0)),
    CONSTRAINT [FK_InfEmail_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_InfEmail_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);




GO
CREATE NONCLUSTERED INDEX [IX_InfEmail_LastUpdatedUserId]
    ON [dbo].[InfEmail]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_InfEmail_CreatedUserId]
    ON [dbo].[InfEmail]([CreatedUserId] ASC);

