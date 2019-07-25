CREATE TABLE [dbo].[MemberStatus] (
    [MemberStatusId]    BIGINT       IDENTITY (1, 1) NOT NULL,
    [MemberStatusName]  VARCHAR (50) NOT NULL,
    [NPRMembershipInd]  CHAR (1)     CONSTRAINT [DEF_MemberStatus_NPRMembershipInd] DEFAULT ('N') NOT NULL,
    [DisabledDate]      DATETIME     NULL,
    [DisabledUserId]    BIGINT       NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_MemberStatus_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_MemberStatus_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_MemberStatus] PRIMARY KEY CLUSTERED ([MemberStatusId] ASC),
    CONSTRAINT [CHK_MemberStatus_NPRMembershipInd] CHECK ([NPRMembershipInd]='N' OR [NPRMembershipInd]='Y'),
    CONSTRAINT [FK_MemberStatus_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_MemberStatus_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_MemberStatus_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MemberStatus_MemberStatusName]
    ON [dbo].[MemberStatus]([MemberStatusName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MemberStatus_LastUpdatedUserId]
    ON [dbo].[MemberStatus]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MemberStatus_DisabledUserId]
    ON [dbo].[MemberStatus]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MemberStatus_CreatedUserId]
    ON [dbo].[MemberStatus]([CreatedUserId] ASC);

