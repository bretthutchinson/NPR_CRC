CREATE PROCEDURE [dbo].[PSP_Schedule_Del]
(
	@ScheduleId BIGINT
)
AS BEGIN
    SET NOCOUNT ON

	DELETE FROM dbo.ScheduleNewscast WHERE ScheduleId = @ScheduleId;

	DELETE FROM dbo.ScheduleProgram WHERE ScheduleId = @ScheduleId;

	DELETE FROM dbo.Schedule WHERE ScheduleId = @ScheduleId;
 
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PSP_Schedule_Del] TO [crcuser]
    AS [dbo];

