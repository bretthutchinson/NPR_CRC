CREATE PROCEDURE [dbo].[PSP_DMAMarket_Get]
(
    @DMAMarketId BIGINT
)
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

    WHERE
        DMAMarketId = @DMAMarketId

END
GO


