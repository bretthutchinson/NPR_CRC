CREATE PROCEDURE [dbo].[PSP_MetroMarkets_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MetroMarketId,
		MarketName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MetroMarket
    
END
GO


