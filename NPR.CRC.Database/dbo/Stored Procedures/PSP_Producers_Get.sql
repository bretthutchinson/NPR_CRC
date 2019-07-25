CREATE PROCEDURE [dbo].[PSP_Producers_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProducerId,
		SalutationId,
		FirstName,
		MiddleName,
		LastName,
		(FirstName + ' ' + LastName) As FullName,
		Suffix,
		[Role],
		Email,
		Phone,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Producer
	--where disableddate is null
    
END
GO


