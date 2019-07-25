CREATE PROCEDURE [dbo].[PSP_ProgramProducer_DELETE]
(
	@ProgramProducerId BIGINT	
)
AS BEGIN

    SET NOCOUNT ON

	DELETE FROM dbo.ProgramProducer
	WHERE
	ProgramProducerId = @ProgramProducerId

END
GO


