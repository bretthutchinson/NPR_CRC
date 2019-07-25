CREATE PROCEDURE [dbo].[PSP_MetroMarket_Update]
(
    @CallLetters VARCHAR(100),
	@Band VARCHAR(10),
	@MetroMarket VARCHAR(50),
	@MetroMarketRank INT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

		IF NOT (EXISTS (SELECT MetroMarketId FROM MetroMarket WHERE MarketName = @MetroMarket)) Begin
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
				@MetroMarket,
				GETUTCDATE(),
				@LastUpdatedUserId,
				GETUTCDATE(),
				@LastUpdatedUserId
			)
		End

        UPDATE s
		SET        
			MetroMarketId = (SELECT MetroMarketId FROM MetroMarket WHERE MarketName = @MetroMarket),
			MetroMarketRank = @MetroMarketRank,
			LastUpdatedDate = GETUTCDATE(),
			LastUpdatedUserId = @LastUpdatedUserId
		
			FROM dbo.Station s
			JOIN dbo.Band b on b.BandId = s.BandId		

		WHERE
			CallLetters = @CallLetters AND b.BandName = @Band

		SELECT @@ROWCOUNT

END
GO


