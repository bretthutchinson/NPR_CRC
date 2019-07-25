CREATE PROCEDURE [dbo].[PSP_DMAMarket_Update]
(
    @CallLetters VARCHAR(100),
	@Band VARCHAR(10),
	@DMAMarket VARCHAR(50),
	@DMAMarketRank INT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	if NOT (EXISTS (SELECT DMAMarketId FROM DMAMarket WHERE MarketName = @DMAMarket)) Begin
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
            @DMAMarket,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        ) 
	End
	

    UPDATE s
	SET        
		DMAMarketId = (SELECT DMAMarketId FROM DMAMarket WHERE MarketName = @DMAMarket),
		DMAMarketRank = @DMAMarketRank,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
		
		FROM dbo.Station s
		JOIN dbo.Band b on b.BandId = s.BandId		

	WHERE
		CallLetters = @CallLetters AND b.BandName = @Band
	





    SELECT @@ROWCOUNT

END
GO


