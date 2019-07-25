CREATE TABLE [dbo].[Program] (
    [ProgramId]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [ProgramName]         VARCHAR (100) NOT NULL,
    [ProgramSourceId]     BIGINT        NOT NULL,
    [ProgramFormatTypeId] BIGINT        NOT NULL,
    [ProgramCode]         VARCHAR (50)  NOT NULL,
    [CarriageTypeId]      BIGINT        NULL,
    [DisabledDate]        DATETIME      NULL,
    [DisabledUserId]      BIGINT        NULL,
    [CreatedDate]         DATETIME      CONSTRAINT [DEF_Program_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]       BIGINT        NOT NULL,
    [LastUpdatedDate]     DATETIME      CONSTRAINT [DEF_Program_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId]   BIGINT        NOT NULL,
    CONSTRAINT [PK_Program] PRIMARY KEY CLUSTERED ([ProgramId] ASC),
    CONSTRAINT [FK_Program_CarriageType_CarriageTypeId] FOREIGN KEY ([CarriageTypeId]) REFERENCES [dbo].[CarriageType] ([CarriageTypeId]),
    CONSTRAINT [FK_Program_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Program_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Program_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Program_ProgramFormatType_ProgramFormatTypeId] FOREIGN KEY ([ProgramFormatTypeId]) REFERENCES [dbo].[ProgramFormatType] ([ProgramFormatTypeId]),
    CONSTRAINT [FK_Program_ProgramSource_ProgramSourceId] FOREIGN KEY ([ProgramSourceId]) REFERENCES [dbo].[ProgramSource] ([ProgramSourceId])
);


GO
CREATE NONCLUSTERED INDEX [IX_Program_ProgramSourceId]
    ON [dbo].[Program]([ProgramSourceId] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Program_ProgramCode]
    ON [dbo].[Program]([ProgramCode] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Program_ProgramName]
    ON [dbo].[Program]([ProgramName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Program_ProgramFormatTypeId]
    ON [dbo].[Program]([ProgramFormatTypeId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Program_LastUpdatedUserId]
    ON [dbo].[Program]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Program_DisabledUserId]
    ON [dbo].[Program]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Program_CreatedUserId]
    ON [dbo].[Program]([CreatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Program_CarriageTypeId]
    ON [dbo].[Program]([CarriageTypeId] ASC);

