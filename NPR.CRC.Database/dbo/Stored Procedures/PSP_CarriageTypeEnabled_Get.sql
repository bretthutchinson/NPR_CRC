
CREATE  PROCEDURE [dbo].[PSP_CarriageTypeEnabled_Get]

AS BEGIN

    SET NOCOUNT ON

    SELECT
		CarriageTypeName
	FROM
        dbo.CarriageType
    WHERE
        DisabledUserId IS NULL
END