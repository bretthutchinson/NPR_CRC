CREATE TABLE [dbo].[LicenseeType] (
    [LicenseeTypeId]    BIGINT       IDENTITY (1, 1) NOT NULL,
    [LicenseeTypeName]  VARCHAR (50) NOT NULL,
    [DisabledDate]      DATETIME     NULL,
    [DisabledUserId]    BIGINT       NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_LicenseeType_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_LicenseeType_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_LicenseeType] PRIMARY KEY CLUSTERED ([LicenseeTypeId] ASC),
    CONSTRAINT [FK_LicenseeType_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_LicenseeType_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_LicenseeType_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LicenseeType_LicenseeTypeName]
    ON [dbo].[LicenseeType]([LicenseeTypeName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_LicenseeType_LastUpdatedUserId]
    ON [dbo].[LicenseeType]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_LicenseeType_DisabledUserId]
    ON [dbo].[LicenseeType]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_LicenseeType_CreatedUserId]
    ON [dbo].[LicenseeType]([CreatedUserId] ASC);

