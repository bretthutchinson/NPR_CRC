CREATE TABLE [dbo].[ProgramFormatType] (
    [ProgramFormatTypeId]   BIGINT       IDENTITY (1, 1) NOT NULL,
    [ProgramFormatTypeName] VARCHAR (50) NOT NULL,
    [ProgramFormatTypeCode] VARCHAR (50) NOT NULL,
    [MajorFormatId]         BIGINT       NOT NULL,
    [DisabledDate]          DATETIME     NULL,
    [DisabledUserId]        BIGINT       NULL,
    [CreatedDate]           DATETIME     CONSTRAINT [DEF_ProgramFormatType_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]         BIGINT       NOT NULL,
    [LastUpdatedDate]       DATETIME     CONSTRAINT [DEF_ProgramFormatType_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId]     BIGINT       NOT NULL,
    CONSTRAINT [PK_ProgramFormatType] PRIMARY KEY CLUSTERED ([ProgramFormatTypeId] ASC),
    CONSTRAINT [FK_ProgramFormatType_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_ProgramFormatType_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_ProgramFormatType_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_ProgramFormatType_MajorFormat_MajorFormatId] FOREIGN KEY ([MajorFormatId]) REFERENCES [dbo].[MajorFormat] ([MajorFormatId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProgramFormatType_ProgramFormatTypeName]
    ON [dbo].[ProgramFormatType]([ProgramFormatTypeName] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProgramFormatType_ProgramFormatTypeCode]
    ON [dbo].[ProgramFormatType]([ProgramFormatTypeCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProgramFormatType_MajorFormatId]
    ON [dbo].[ProgramFormatType]([MajorFormatId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProgramFormatType_LastUpdatedUserId]
    ON [dbo].[ProgramFormatType]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProgramFormatType_DisabledUserId]
    ON [dbo].[ProgramFormatType]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProgramFormatType_CreatedUserId]
    ON [dbo].[ProgramFormatType]([CreatedUserId] ASC);

