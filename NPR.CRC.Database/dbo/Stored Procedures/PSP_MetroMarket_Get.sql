CREATE PROCEDURE [dbo].[PSP_MetroMarket_Get]
(
    @MetroMarketId BIGINT
)
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

    WHERE
        MetroMarketId = @MetroMarketId

END
GO


