CREATE PROCEDURE [dbo].[PSP_Producer_Get]
(
    @ProducerId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProducerId,
		SalutationId,
		FirstName,
		MiddleName,
		LastName,
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

    WHERE
        ProducerId = @ProducerId

END
GO


