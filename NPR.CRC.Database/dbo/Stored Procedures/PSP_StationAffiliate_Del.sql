CREATE PROCEDURE [dbo].[PSP_StationAffiliate_Del]
(
	@StationId BIGINT	
)
AS BEGIN

    SET NOCOUNT ON

	DELETE FROM dbo.StationAffiliate 
	WHERE 
	StationId=@StationId

END