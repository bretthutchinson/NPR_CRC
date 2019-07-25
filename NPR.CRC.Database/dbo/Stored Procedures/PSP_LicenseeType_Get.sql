CREATE PROCEDURE [dbo].[PSP_LicenseeType_Get]
(
    @LicenseeTypeId BIGINT
)
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

    WHERE
        LicenseeTypeId = @LicenseeTypeId

END
GO


