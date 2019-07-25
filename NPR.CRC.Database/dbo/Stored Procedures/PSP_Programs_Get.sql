CREATE PROCEDURE [dbo].[PSP_Programs_Get]
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
    
END
GO


