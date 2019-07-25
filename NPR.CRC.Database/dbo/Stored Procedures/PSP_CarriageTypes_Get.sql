CREATE PROCEDURE [dbo].[PSP_CarriageTypes_Get]
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
    
END
GO


