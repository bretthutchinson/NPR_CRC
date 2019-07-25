CREATE TABLE [dbo].[MinorityStatus] (
    [MinorityStatusId]   BIGINT       IDENTITY (1, 1) NOT NULL,
    [MinorityStatusName] VARCHAR (50) NOT NULL,
    [DisabledDate]       DATETIME     NULL,
    [DisabledUserId]     BIGINT       NULL,
    [CreatedDate]        DATETIME     CONSTRAINT [DEF_MinorityStatus_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]      BIGINT       NOT NULL,
    [LastUpdatedDate]    DATETIME     CONSTRAINT [DEF_MinorityStatus_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId]  BIGINT       NOT NULL,
    CONSTRAINT [PK_MinorityStatus] PRIMARY KEY CLUSTERED ([MinorityStatusId] ASC),
    CONSTRAINT [FK_MinorityStatus_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_MinorityStatus_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_MinorityStatus_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MinorityStatus_MinorityStatusName]
    ON [dbo].[MinorityStatus]([MinorityStatusName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MinorityStatus_LastUpdatedUserId]
    ON [dbo].[MinorityStatus]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MinorityStatus_DisabledUserId]
    ON [dbo].[MinorityStatus]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MinorityStatus_CreatedUserId]
    ON [dbo].[MinorityStatus]([CreatedUserId] ASC);

