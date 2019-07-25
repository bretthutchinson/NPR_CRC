CREATE PROCEDURE [dbo].[PSP_ProgramProducersByProducerId_Get]
(
    @ProducerId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramProducerId,
		ProgramId,
		ProducerId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.ProgramProducer

    WHERE
        ProducerId = @ProducerId

END
GO


