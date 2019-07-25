CREATE PROCEDURE [dbo].[PSP_StationAQHCume_Update]
(
    @CallLetters VARCHAR(100),
	@Band VARCHAR(10),
	@AQH INT,
	@Cume INT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	UPDATE st
    SET        
		st.TSAAQH = @AQH,
		st.TSACume = @Cume,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
		
	FROM 
		dbo.Station st INNER JOIN 
		dbo.Band b ON b.BandId = st.BandId		
    WHERE
        CallLetters = @CallLetters AND b.BandName = @Band

    SELECT @@ROWCOUNT
END
GO


