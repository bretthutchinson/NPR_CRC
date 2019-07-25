CREATE PROCEDURE [dbo].[PSP_LicenseeTypes_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        LicenseeTypeId,
		LicenseeTypeName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.LicenseeType
    
END
GO


