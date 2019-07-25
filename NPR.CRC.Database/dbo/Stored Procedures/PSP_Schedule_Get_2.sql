--DROP PROCEDURE [dbo].[PSP_Schedule_Get]

CREATE PROCEDURE [dbo].[PSP_Schedule_Get]
(
    @ScheduleId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        sch.ScheduleId,
		sch.StationId,
		sta.CallLetters + '-' + b.BandName AS StationDisplayName,
		sch.[Year],
		sch.[Month],
		DATENAME(MONTH, DATEADD(MONTH, sch.[Month] - 1, '1900-1-1')) AS [MonthName],
		CASE 
			WHEN rs.RepeaterStatusName = '100% Repeater' THEN 'Y' 
			WHEN AcceptedDate IS NOT NULL THEN 'Y' 
			ELSE 'N' 
		END As [ReadOnly],	
		CASE 
			WHEN rs.RepeaterStatusName = '100% Repeater' THEN 'Y'
			ELSE 'N' 
		END As [IsRepeaterInd],	
		sch.SubmittedDate,
		sch.SubmittedUserId,
		sch.AcceptedDate,
		sch.AcceptedUserId,
		sch.CreatedDate,
		sch.CreatedUserId,
		sch.LastUpdatedDate,
		sch.LastUpdatedUserId

    FROM
        dbo.Schedule sch JOIN 
		dbo.Station sta ON sta.StationId = sch.StationId JOIN 
		dbo.Band b ON b.BandId = sta.BandId JOIN 
		dbo.RepeaterStatus rs ON sta.RepeaterStatusId = rs.RepeaterStatusId

    WHERE
        sch.ScheduleId = @ScheduleId

END
GO


