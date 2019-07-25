CREATE PROCEDURE [dbo].[PSP_MajorFormats_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MajorFormatId,
		MajorFormatName,
		MajorFormatCode,
		CASE
			WHEN DisabledDate IS NULL
			THEN 'Yes'
			ELSE 'No'
		END AS EnabledInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MajorFormat
    
END
GO


