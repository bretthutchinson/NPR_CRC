CREATE TABLE [dbo].[CarriageType] (
    [CarriageTypeId]    BIGINT       IDENTITY (1, 1) NOT NULL,
    [CarriageTypeName]  VARCHAR (50) NOT NULL,
    [DisabledDate]      DATETIME     NULL,
    [DisabledUserId]    BIGINT       NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_CarriageType_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_CarriageType_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_CarriageType] PRIMARY KEY CLUSTERED ([CarriageTypeId] ASC),
    CONSTRAINT [FK_CarriageType_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_CarriageType_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_CarriageType_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CarriageType_CarriageTypeName]
    ON [dbo].[CarriageType]([CarriageTypeName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CarriageType_LastUpdatedUserId]
    ON [dbo].[CarriageType]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CarriageType_DisabledUserId]
    ON [dbo].[CarriageType]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CarriageType_CreatedUserId]
    ON [dbo].[CarriageType]([CreatedUserId] ASC);

