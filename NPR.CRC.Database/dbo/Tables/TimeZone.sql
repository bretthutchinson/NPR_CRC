CREATE TABLE [dbo].[TimeZone] (
    [TimeZoneId]        BIGINT       IDENTITY (1, 1) NOT NULL,
    [TimeZoneCode]      VARCHAR (50) NOT NULL,
    [DisplayName]       VARCHAR (50) NOT NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_TimeZone_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_TimeZone_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_TimeZone] PRIMARY KEY CLUSTERED ([TimeZoneId] ASC),
    CONSTRAINT [FK_TimeZone_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_TimeZone_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TimeZone_DisplayName]
    ON [dbo].[TimeZone]([DisplayName] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TimeZone_TimeZoneCode]
    ON [dbo].[TimeZone]([TimeZoneCode] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TimeZone_LastUpdatedUserId]
    ON [dbo].[TimeZone]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_TimeZone_CreatedUserId]
    ON [dbo].[TimeZone]([CreatedUserId] ASC);

