CREATE PROCEDURE [dbo].[PSP_ProgramProducersByProgramId_Get]
(
    @ProgramId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        pp.ProgramProducerId,
		pp.ProgramId,
		pp.ProducerId,
		p.FirstName + ' ' + p.LastName AS ProducerDisplayName,
		p.Role,
		pp.CreatedDate,
		pp.CreatedUserId,
		pp.LastUpdatedDate,
		pp.LastUpdatedUserId

    FROM
        dbo.ProgramProducer pp

		JOIN dbo.Producer p
			ON p.ProducerId = pp.ProducerId

    WHERE
        pp.ProgramId = @ProgramId

END
GO


