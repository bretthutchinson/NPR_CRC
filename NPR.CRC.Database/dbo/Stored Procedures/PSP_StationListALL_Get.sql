CREATE PROCEDURE [dbo].[PSP_StationListALL_Get]

AS BEGIN
	
    SET NOCOUNT ON

    SELECT  DISTINCT S.CallLetters   FROM    dbo.Station S
	
END