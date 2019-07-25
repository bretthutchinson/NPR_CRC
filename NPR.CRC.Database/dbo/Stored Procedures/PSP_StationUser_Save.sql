CREATE PROCEDURE [dbo].[PSP_StationUser_Save]
(
	@StationId BIGINT,
	@UserId BIGINT,
	@PrimaryUserInd CHAR(1),
	@GridWritePermissionsInd CHAR(1),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.StationUser
    SET
		GridWritePermissionsInd = @GridWritePermissionsInd,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        StationId = @StationId
		AND
		UserId = @UserId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.StationUser
        (
            StationId,
			UserId,
			GridWritePermissionsInd,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @StationId,
			@UserId,
			@GridWritePermissionsInd,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

    END

	IF @PrimaryUserInd = 'Y'
	BEGIN
		UPDATE dbo.Station
		SET PrimaryUserId = @UserId
		WHERE StationId = @StationId
	END
	ELSE BEGIN
		UPDATE dbo.Station
		SET PrimaryUserId = NULL
		WHERE StationId = @StationId
		AND PrimaryUserId = @UserId
	END

END
GO


