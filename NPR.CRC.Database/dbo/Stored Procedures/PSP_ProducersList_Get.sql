CREATE PROCEDURE [dbo].[PSP_ProducersList_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProducerId,
		FirstName + ' ' + LastName AS ProducerDisplayName

    FROM
        dbo.Producer
		where disableddate is null
END
GO


