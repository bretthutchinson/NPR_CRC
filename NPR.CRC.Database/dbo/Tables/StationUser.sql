CREATE TABLE [dbo].[StationUser] (
    [StationUserId]           BIGINT   IDENTITY (1, 1) NOT NULL,
    [StationId]               BIGINT   NOT NULL,
    [UserId]                  BIGINT   NOT NULL,
    [GridWritePermissionsInd] CHAR (1) CONSTRAINT [DEF_StationUser_GridWritePermissionsInd] DEFAULT ('N') NOT NULL,
    [CreatedDate]             DATETIME CONSTRAINT [DEF_StationUser_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]           BIGINT   NOT NULL,
    [LastUpdatedDate]         DATETIME CONSTRAINT [DEF_StationUser_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId]       BIGINT   NOT NULL,
    CONSTRAINT [PK_StationUser] PRIMARY KEY CLUSTERED ([StationUserId] ASC),
    CONSTRAINT [CHK_StationUser_GridWritePermissionsInd] CHECK ([GridWritePermissionsInd]='N' OR [GridWritePermissionsInd]='Y'),
    CONSTRAINT [FK_StationUser_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_StationUser_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_StationUser_CRCUser_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_StationUser_Station_StationId] FOREIGN KEY ([StationId]) REFERENCES [dbo].[Station] ([StationId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_StationUser_UserId_StationId]
    ON [dbo].[StationUser]([UserId] ASC, [StationId] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_StationUser_StationId_UserId]
    ON [dbo].[StationUser]([StationId] ASC, [UserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StationUser_UserId]
    ON [dbo].[StationUser]([UserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StationUser_StationId]
    ON [dbo].[StationUser]([StationId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StationUser_LastUpdatedUserId]
    ON [dbo].[StationUser]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StationUser_CreatedUserId]
    ON [dbo].[StationUser]([CreatedUserId] ASC);

