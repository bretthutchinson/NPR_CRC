CREATE TABLE [dbo].[MajorFormat] (
    [MajorFormatId]     BIGINT       IDENTITY (1, 1) NOT NULL,
    [MajorFormatName]   VARCHAR (50) NOT NULL,
    [MajorFormatCode]   VARCHAR (50) NOT NULL,
    [DisabledDate]      DATETIME     NULL,
    [DisabledUserId]    BIGINT       NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_MajorFormat_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_MajorFormat_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_MajorFormat] PRIMARY KEY CLUSTERED ([MajorFormatId] ASC),
    CONSTRAINT [FK_MajorFormat_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_MajorFormat_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_MajorFormat_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MajorFormat_MajorFormatName]
    ON [dbo].[MajorFormat]([MajorFormatName] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MajorFormat_MajorFormatCode]
    ON [dbo].[MajorFormat]([MajorFormatCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MajorFormat_LastUpdatedUserId]
    ON [dbo].[MajorFormat]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MajorFormat_DisabledUserId]
    ON [dbo].[MajorFormat]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MajorFormat_CreatedUserId]
    ON [dbo].[MajorFormat]([CreatedUserId] ASC);

