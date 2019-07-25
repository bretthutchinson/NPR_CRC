CREATE TABLE [dbo].[MetroMarket] (
    [MetroMarketId]     BIGINT       IDENTITY (1, 1) NOT NULL,
    [MarketName]        VARCHAR (50) NOT NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_MetroMarket_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_MetroMarket_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_MetroMarket] PRIMARY KEY CLUSTERED ([MetroMarketId] ASC),
    CONSTRAINT [FK_MetroMarket_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_MetroMarket_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MetroMarket_MarketName]
    ON [dbo].[MetroMarket]([MarketName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MetroMarket_LastUpdatedUserId]
    ON [dbo].[MetroMarket]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MetroMarket_CreatedUserId]
    ON [dbo].[MetroMarket]([CreatedUserId] ASC);

