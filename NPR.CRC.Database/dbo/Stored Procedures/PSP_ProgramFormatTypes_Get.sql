CREATE PROCEDURE [dbo].[PSP_ProgramFormatTypes_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramFormatTypeId,
		ProgramFormatTypeName,
		ProgramFormatTypeCode,
		MajorFormatName,
		pft.DisabledDate,
		pft.DisabledUserId,
		pft.CreatedDate,
		pft.CreatedUserId,
		pft.LastUpdatedDate,
		pft.LastUpdatedUserId

    FROM
        dbo.ProgramFormatType pft
		join MajorFormat mf on pft.majorformatid = mf.majorformatid
    
END
GO


