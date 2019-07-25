CREATE TABLE [dbo].[ProgramSource] (
    [ProgramSourceId]   BIGINT       IDENTITY (1, 1) NOT NULL,
    [ProgramSourceName] VARCHAR (50) NOT NULL,
    [ProgramSourceCode] VARCHAR (50) NOT NULL,
    [DisabledDate]      DATETIME     NULL,
    [DisabledUserId]    BIGINT       NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_ProgramSource_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_ProgramSource_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_ProgramSource] PRIMARY KEY CLUSTERED ([ProgramSourceId] ASC),
    CONSTRAINT [FK_ProgramSource_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_ProgramSource_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_ProgramSource_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);




GO
CREATE NONCLUSTERED INDEX [IX_ProgramSource_LastUpdatedUserId]
    ON [dbo].[ProgramSource]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProgramSource_DisabledUserId]
    ON [dbo].[ProgramSource]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProgramSource_CreatedUserId]
    ON [dbo].[ProgramSource]([CreatedUserId] ASC);

