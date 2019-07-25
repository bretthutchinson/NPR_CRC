CREATE PROCEDURE [dbo].[PSP_Program_Get]
(
    @ProgramId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramId,
		ProgramName,
		ProgramSourceId,
		ProgramFormatTypeId,
		ProgramCode,
		CarriageTypeId,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Program

    WHERE
        ProgramId = @ProgramId

END
GO


