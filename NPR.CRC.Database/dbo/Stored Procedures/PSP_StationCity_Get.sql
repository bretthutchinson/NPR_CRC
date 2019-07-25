CREATE PROCEDURE [dbo].[PSP_StationCity_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        distinct(city) 

    FROM
        station
    where city is not null
END