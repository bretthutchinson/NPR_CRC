CREATE TABLE [dbo].[DMAMarket] (
    [DMAMarketId]       BIGINT       IDENTITY (1, 1) NOT NULL,
    [MarketName]        VARCHAR (50) NOT NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_DMAMarket_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_DMAMarket_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_DMAMarket] PRIMARY KEY CLUSTERED ([DMAMarketId] ASC),
    CONSTRAINT [FK_DMAMarket_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_DMAMarket_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DMAMarket_MarketName]
    ON [dbo].[DMAMarket]([MarketName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DMAMarket_LastUpdatedUserId]
    ON [dbo].[DMAMarket]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DMAMarket_CreatedUserId]
    ON [dbo].[DMAMarket]([CreatedUserId] ASC);

