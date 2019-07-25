CREATE TABLE [dbo].[CRCUser] (
    [UserId]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [Email]             VARCHAR (100)  NOT NULL,
    [PasswordHash]      VARBINARY (50) NOT NULL,
    [PasswordSalt]      VARCHAR (50)   NOT NULL,
    [ResetPasswordHash] VARBINARY (50) NULL,
    [SalutationId]      BIGINT         NULL,
    [FirstName]         VARCHAR (50)   NOT NULL,
    [MiddleName]        VARCHAR (50)   NULL,
    [LastName]          VARCHAR (50)   NOT NULL,
    [Suffix]            VARCHAR (50)   NULL,
    [JobTitle]          VARCHAR (50)   NULL,
    [AddressLine1]      VARCHAR (50)   NULL,
    [AddressLine2]      VARCHAR (50)   NULL,
    [City]              VARCHAR (50)   NULL,
    [StateId]           BIGINT         NULL,
    [County]            VARCHAR (50)   NULL,
    [Country]           VARCHAR (50)   NULL,
    [ZipCode]           VARCHAR (50)   NULL,
    [Phone]             VARCHAR (50)   NULL,
    [Fax]               VARCHAR (50)   NULL,
    [AdministratorInd]  CHAR (1)       CONSTRAINT [DEF_CRCUser_AdministratorInd] DEFAULT ('N') NOT NULL,
    [CRCManagerInd]     CHAR (1)       CONSTRAINT [DEF_CRCUser_CRCManagerInd] DEFAULT ('N') NOT NULL,
    [DisabledDate]      DATETIME       NULL,
    [DisabledUserId]    BIGINT         NULL,
    [CreatedDate]       DATETIME       CONSTRAINT [DEF_CRCUser_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT         NOT NULL,
    [LastUpdatedDate]   DATETIME       CONSTRAINT [DEF_CRCUser_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT         NOT NULL,
    CONSTRAINT [PK_CRCUser] PRIMARY KEY CLUSTERED ([UserId] ASC),
    CONSTRAINT [CHK_CRCUser_AdministratorInd] CHECK (([AdministratorInd]='N' OR [AdministratorInd]='Y') AND NOT ([AdministratorInd]='N' AND [CRCManagerInd]='Y')),
    CONSTRAINT [CHK_CRCUser_CRCManagerInd] CHECK (([CRCManagerInd]='N' OR [CRCManagerInd]='Y') AND NOT ([AdministratorInd]='N' AND [CRCManagerInd]='Y')),
    CONSTRAINT [FK_CRCUser_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_CRCUser_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_CRCUser_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_CRCUser_Salutation_SalutationId] FOREIGN KEY ([SalutationId]) REFERENCES [dbo].[Salutation] ([SalutationId]),
    CONSTRAINT [FK_CRCUser_State_StateId] FOREIGN KEY ([StateId]) REFERENCES [dbo].[State] ([StateId])
);




GO
CREATE NONCLUSTERED INDEX [IX_CRCUser_Email_PasswordHash]
    ON [dbo].[CRCUser]([Email] ASC, [PasswordHash] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CRCUser_Email]
    ON [dbo].[CRCUser]([Email] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CRCUser_StateId]
    ON [dbo].[CRCUser]([StateId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CRCUser_SalutationId]
    ON [dbo].[CRCUser]([SalutationId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CRCUser_LastUpdatedUserId]
    ON [dbo].[CRCUser]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CRCUser_DisabledUserId]
    ON [dbo].[CRCUser]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CRCUser_CreatedUserId]
    ON [dbo].[CRCUser]([CreatedUserId] ASC);


GO
CREATE TRIGGER dbo.TRG_CRCUser_InsUpd
ON dbo.CRCUser
FOR INSERT, UPDATE
AS BEGIN

	IF (SELECT COUNT(*) FROM dbo.CRCUser WHERE CRCManagerInd = 'Y') > 1
	BEGIN

		IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
		RAISERROR ('dbo.TRG_CRCUser_InsUpd: There cannot be more than one user with CRCManagerInd = ''Y''', 16, 1)

	END

END