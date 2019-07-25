CREATE PROCEDURE [dbo].[PSP_MetroMarket_Save]
(
    @MetroMarketId BIGINT,
	@MarketName VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.MetroMarket
    SET
        MarketName = @MarketName,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        MetroMarketId = @MetroMarketId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.MetroMarket
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

        SET @MetroMarketId = SCOPE_IDENTITY()

    END

    SELECT @MetroMarketId AS MetroMarketId

END
GO


