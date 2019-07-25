CREATE TABLE [dbo].[RepeaterStatus] (
    [RepeaterStatusId]   BIGINT       IDENTITY (1, 1) NOT NULL,
    [RepeaterStatusName] VARCHAR (50) NOT NULL,
    [CreatedDate]        DATETIME     CONSTRAINT [DEF_RepeaterStatus_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]      BIGINT       NOT NULL,
    [LastUpdatedDate]    DATETIME     CONSTRAINT [DEF_RepeaterStatus_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId]  BIGINT       NOT NULL,
    CONSTRAINT [PK_RepeaterStatus] PRIMARY KEY CLUSTERED ([RepeaterStatusId] ASC),
    CONSTRAINT [FK_RepeaterStatus_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_RepeaterStatus_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_RepeaterStatus_RepeaterStatusName]
    ON [dbo].[RepeaterStatus]([RepeaterStatusName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RepeaterStatus_LastUpdatedUserId]
    ON [dbo].[RepeaterStatus]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RepeaterStatus_CreatedUserId]
    ON [dbo].[RepeaterStatus]([CreatedUserId] ASC);

