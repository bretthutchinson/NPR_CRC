CREATE  PROCEDURE [dbo].[PSP_ProgramMulticast_Get]

WITH EXECUTE AS OWNER

AS BEGIN

    SET NOCOUNT ON

 SELECT DISTINCT 
 p.ProgramName from dbo.ScheduleNewscast AS snc
INNER JOIN dbo.ScheduleProgram AS sp ON sp.ScheduleId = snc.ScheduleId
INNER JOIN dbo.Program AS p ON p.ProgramId = sp.ProgramId
WHERE p.ProgramName NOT LIKE '%Off Air%'

END