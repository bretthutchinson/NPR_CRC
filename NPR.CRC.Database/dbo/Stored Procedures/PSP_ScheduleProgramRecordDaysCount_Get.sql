CREATE PROCEDURE [dbo].[PSP_ScheduleProgramRecordDaysCount_Get]
(
    @ScheduleProgramID BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	declare @count int = 0
	DEclare @ExistingSundayInd int =0
	DEclare @ExistingMondayInd int =0 
	DEclare @ExistingTuesdayInd int =0
	DEclare @ExistingWednesdayInd int =0 
	DEclare @ExistingThursdayInd int =0 
	DEclare @ExistingFridayInd int =0
	DEclare @ExistingSaturdayInd int =0

	--select * from ScheduleProgram

    SELECT @count = 

	case when SundayInd = 'Y'THEN 1 else 0 End +
	case when MondayInd = 'Y'THEN 1 else 0 End +
	case when TuesdayInd = 'Y'THEN 1 else 0 End +
	case when WednesdayInd = 'Y'THEN 1 else 0 End + 
	case when ThursdayInd = 'Y'THEN 1 else 0 End +
	case when FridayInd = 'Y'THEN 1 else 0 End +
	case when SaturdayInd = 'Y'THEN 1 else 0 End
	--@ExistingMondayInd = MondayInd,
	--@ExistingTuesdayInd = TuesdayInd,
	--@ExistingWednesdayInd = WednesdayInd,
	--@ExistingThursdayInd = ThursdayInd,
	--@ExistingFridayInd = FridayInd,
	--@ExistingSaturdayInd = SaturdayInd

	FROM dbo.ScheduleProgram 
	WHERE
	    ScheduleProgramID = @ScheduleProgramID


	--@count =
	--case When SundayInd = 'Y' set @count = @count+1
	----@ExistingMondayInd = MondayInd,
	----@ExistingTuesdayInd = TuesdayInd,
	----@ExistingWednesdayInd = WednesdayInd,
	----@ExistingThursdayInd = ThursdayInd,
	----@ExistingFridayInd = FridayInd,
	----@ExistingSaturdayInd = SaturdayInd
	----FROM dbo.ScheduleProgram 
	--WHERE
 --       ScheduleProgramID = @ScheduleProgramID

	select @count

	--[PSP_ScheduleProgramRecordDaysCount_Get] 971
	 --select * from scheduleprogram 

END