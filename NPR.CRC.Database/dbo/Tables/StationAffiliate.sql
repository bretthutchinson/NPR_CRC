CREATE TABLE [dbo].[StationAffiliate] (
    [StationAffiliateId] BIGINT   IDENTITY (1, 1) NOT NULL,
    [StationId]          BIGINT   NOT NULL,
    [AffiliateId]        BIGINT   NOT NULL,
    [CreatedDate]        DATETIME CONSTRAINT [DEF_StationAffiliate_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]      BIGINT   NOT NULL,
    [LastUpdatedDate]    DATETIME CONSTRAINT [DEF_StationAffiliate_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId]  BIGINT   NOT NULL,
    CONSTRAINT [PK_StationAffiliate] PRIMARY KEY CLUSTERED ([StationAffiliateId] ASC),
    CONSTRAINT [FK_StationAffiliate_Affiliate_AffiliateId] FOREIGN KEY ([AffiliateId]) REFERENCES [dbo].[Affiliate] ([AffiliateId]),
    CONSTRAINT [FK_StationAffiliate_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_StationAffiliate_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_StationAffiliate_Station_StationId] FOREIGN KEY ([StationId]) REFERENCES [dbo].[Station] ([StationId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_StationAffiliate_AffiliateId_StationId]
    ON [dbo].[StationAffiliate]([AffiliateId] ASC, [StationId] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_StationAffiliate_StationId_AffiliateId]
    ON [dbo].[StationAffiliate]([StationId] ASC, [AffiliateId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StationAffiliate_StationId]
    ON [dbo].[StationAffiliate]([StationId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StationAffiliate_LastUpdatedUserId]
    ON [dbo].[StationAffiliate]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StationAffiliate_CreatedUserId]
    ON [dbo].[StationAffiliate]([CreatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_StationAffiliate_AffiliateId]
    ON [dbo].[StationAffiliate]([AffiliateId] ASC);

