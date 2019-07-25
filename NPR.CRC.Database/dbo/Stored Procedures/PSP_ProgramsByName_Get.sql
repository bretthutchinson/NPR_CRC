CREATE PROCEDURE [dbo].[PSP_ProgramsByName_Get]
(
	@ProgramName VARCHAR(100),
	@StartsWithInd CHAR(1)
)
AS BEGIN

    SET NOCOUNT ON

	SET @ProgramName =
		CASE @StartsWithInd
		WHEN 'Y' THEN @ProgramName + '%'
		ELSE '%' + @ProgramName + '%'
		END

    SELECT
        ProgramId,
		ProgramName,
		ProgramSourceId,
		ProgramFormatTypeId,
		ProgramCode,
		CarriageTypeId,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Program

	WHERE
		ProgramName LIKE @ProgramName
    
END
GO


