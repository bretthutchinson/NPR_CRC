CREATE PROCEDURE [dbo].[PSP_CarriageType_Get]
(
    @CarriageTypeId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        CarriageTypeId,
		CarriageTypeName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.CarriageType

    WHERE
        CarriageTypeId = @CarriageTypeId

END
GO


