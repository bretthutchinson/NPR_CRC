CREATE PROCEDURE [dbo].[PSP_DMAMarket_Save]
(
    @DMAMarketId BIGINT,
	@MarketName VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.DMAMarket
    SET
        MarketName = @MarketName,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        DMAMarketId = @DMAMarketId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.DMAMarket
        (
            MarketName,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @MarketName,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @DMAMarketId = SCOPE_IDENTITY()

    END

    SELECT @DMAMarketId AS DMAMarketId

END
GO


