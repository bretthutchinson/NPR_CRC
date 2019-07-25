CREATE TABLE [dbo].[InfEmailTemplate] (
    [InfEmailTemplateId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [TemplateName]       VARCHAR (50)  NOT NULL,
    [FromAddress]        VARCHAR (50)  NOT NULL,
    [ToAddress]          VARCHAR (MAX) NOT NULL,
    [CcAddress]          VARCHAR (MAX) NULL,
    [BccAddress]         VARCHAR (MAX) NULL,
    [Subject]            VARCHAR (500) NOT NULL,
    [Body]               VARCHAR (MAX) NOT NULL,
    [HtmlInd]            CHAR (1)      CONSTRAINT [DEF_InfEmailTemplate_HtmlInd] DEFAULT ('N') NOT NULL,
    [Priority]           VARCHAR (50)  NOT NULL,
    [CreatedDate]        DATETIME      NOT NULL,
    [CreatedUserId]      BIGINT        NOT NULL,
    [LastUpdatedDate]    DATETIME      NOT NULL,
    [LastUpdatedUserId]  BIGINT        NOT NULL,
    CONSTRAINT [PK_InfEmailTemplate] PRIMARY KEY NONCLUSTERED ([InfEmailTemplateId] ASC),
    CONSTRAINT [CHK_InfEmailTemplate_HtmlInd] CHECK ([HtmlInd]='N' OR [HtmlInd]='Y'),
    CONSTRAINT [CHK_InfEmailTemplate_Priority] CHECK ([Priority]='High' OR [Priority]='Normal' OR [Priority]='Low'),
    CONSTRAINT [FK_InfEmailTemplate_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_InfEmailTemplate_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);




GO
CREATE NONCLUSTERED INDEX [IX_InfEmailTemplate_LastUpdatedUserId]
    ON [dbo].[InfEmailTemplate]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_InfEmailTemplate_CreatedUserId]
    ON [dbo].[InfEmailTemplate]([CreatedUserId] ASC);

