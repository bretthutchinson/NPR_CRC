CREATE TABLE [dbo].[Band] (
    [BandId]            BIGINT       IDENTITY (1, 1) NOT NULL,
    [BandName]          VARCHAR (50) NOT NULL,
    [DisabledDate]      DATETIME     NULL,
    [DisabledUserId]    BIGINT       NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_Band_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_Band_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_Band] PRIMARY KEY CLUSTERED ([BandId] ASC),
    CONSTRAINT [FK_Band_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Band_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Band_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Band_BandName]
    ON [dbo].[Band]([BandName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Band_LastUpdatedUserId]
    ON [dbo].[Band]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Band_DisabledUserId]
    ON [dbo].[Band]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Band_CreatedUserId]
    ON [dbo].[Band]([CreatedUserId] ASC);

