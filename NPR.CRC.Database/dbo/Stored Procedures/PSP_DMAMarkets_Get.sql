CREATE PROCEDURE [dbo].[PSP_DMAMarkets_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        DMAMarketId,
		MarketName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.DMAMarket
    
END
GO


