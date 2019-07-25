CREATE TABLE [dbo].[Affiliate] (
    [AffiliateId]       BIGINT       IDENTITY (1, 1) NOT NULL,
    [AffiliateName]     VARCHAR (50) NOT NULL,
    [AffiliateCode]     VARCHAR (50) NOT NULL,
    [DisabledDate]      DATETIME     NULL,
    [DisabledUserId]    BIGINT       NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_Affiliate_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_Affiliate_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_Affiliate] PRIMARY KEY CLUSTERED ([AffiliateId] ASC),
    CONSTRAINT [FK_Affiliate_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Affiliate_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Affiliate_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Affiliate_AffiliateCode]
    ON [dbo].[Affiliate]([AffiliateCode] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Affiliate_AffiliateName]
    ON [dbo].[Affiliate]([AffiliateName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Affiliate_LastUpdatedUserId]
    ON [dbo].[Affiliate]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Affiliate_DisabledUserId]
    ON [dbo].[Affiliate]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Affiliate_CreatedUserId]
    ON [dbo].[Affiliate]([CreatedUserId] ASC);

