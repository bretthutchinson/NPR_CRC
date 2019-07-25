CREATE FUNCTION dbo.FN_CalculateQuarterHours(@StartTime varchar(20), @EndTime varchar(20))
RETURNS Numeric(17, 6)
AS
BEGIN
	DECLARE @QuarterHours Numeric(17, 6);

	IF @StartTime = '00:00:00.0000000' AND @EndTime = '23:59:59.0000000'
		SET @QuarterHours = 96;
	ELSE
		SET @QuarterHours = CEILING(datediff(minute, @StartTime, @EndTime)/(15.0));
	RETURN @QuarterHours;
END