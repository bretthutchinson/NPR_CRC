CREATE PROCEDURE [dbo].[PSP_ProgramProducer_Save]
(
	@ProgramId BIGINT,
	@ProducerId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    INSERT INTO dbo.ProgramProducer
    (
        ProgramId,
		ProducerId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
    )
    SELECT
        @ProgramId,
		@ProducerId,
		GETUTCDATE(),
		@LastUpdatedUserId,
		GETUTCDATE(),
		@LastUpdatedUserId
	WHERE
		NOT EXISTS
		(
			SELECT *
			FROM dbo.ProgramProducer
			WHERE ProgramId = @ProgramId
			AND ProducerId = @ProducerId
		)

END
GO


