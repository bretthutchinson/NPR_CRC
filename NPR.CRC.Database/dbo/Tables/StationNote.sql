CREATE TABLE [dbo].[StationNote] (
    [StationNoteId]     BIGINT        IDENTITY (1, 1) NOT NULL,
    [StationId]         BIGINT        NOT NULL,
    [NoteText]          VARCHAR (MAX) NOT NULL,
    [DeletedDate]       DATETIME      NULL,
    [DeletedUserId]     BIGINT        NULL,
    [CreatedDate]       DATETIME      CONSTRAINT [DEF_StationNote_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT        NOT NULL,
    [LastUpdatedDate]   DATETIME      CONSTRAINT [DEF_StationNote_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT        NOT NULL,
    CONSTRAINT [PK_StationNote] PRIMARY KEY CLUSTERED ([StationNoteId] ASC),
    CONSTRAINT [FK_StationNote_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_StationNote_CRCUser_DeletedUserId] FOREIGN KEY ([DeletedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_StationNote_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_StationNote_Station_StationId] FOREIGN KEY ([StationId]) REFERENCES [dbo].[Station] ([StationId])
);


GO
CREATE NONCLUSTERED INDEX [IX_StationNote_StationId]
    ON [dbo].[StationNote]([StationId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StationNote_LastUpdatedUserId]
    ON [dbo].[StationNote]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StationNote_DeletedUserId]
    ON [dbo].[StationNote]([DeletedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StationNote_CreatedUserId]
    ON [dbo].[StationNote]([CreatedUserId] ASC);

