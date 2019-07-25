CREATE PROCEDURE [dbo].[PSP_ProgramFormatType_Get]
(
    @ProgramFormatTypeId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramFormatTypeId,
		ProgramFormatTypeName,
		ProgramFormatTypeCode,
		MajorFormatId,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.ProgramFormatType

    WHERE
        ProgramFormatTypeId = @ProgramFormatTypeId

END
GO


