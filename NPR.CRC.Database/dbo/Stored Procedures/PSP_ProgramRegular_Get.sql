

CREATE  PROCEDURE [dbo].[PSP_ProgramRegular_Get]

WITH EXECUTE AS OWNER

AS BEGIN

SET NOCOUNT ON
SELECT DISTINCT 
p.ProgramName from dbo.ScheduleProgram AS sp
INNER JOIN dbo.Program AS p ON p.ProgramId = sp.ProgramId
LEFT JOIN dbo.ScheduleNewscast AS sn ON sn.ScheduleId = sp.ScheduleId
WHERE p.ProgramName NOT LIKE '%Off Air%' AND sn.ScheduleNewscastId IS NULL

END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PSP_ProgramRegular_Get] TO [crcuser]
    AS [dbo];

