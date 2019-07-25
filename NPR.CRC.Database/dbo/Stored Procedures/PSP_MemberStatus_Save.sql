CREATE PROCEDURE [dbo].[PSP_MemberStatus_Save]
(
    @MemberStatusId BIGINT,
	@MemberStatusName VARCHAR(50),
	@NPRMembershipInd CHAR(1),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.MemberStatus
    SET
        MemberStatusName = @MemberStatusName,
		NPRMembershipInd = @NPRMembershipInd,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        MemberStatusId = @MemberStatusId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.MemberStatus
        (
            MemberStatusName,
			NPRMembershipInd,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @MemberStatusName,
			@NPRMembershipInd,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @MemberStatusId = SCOPE_IDENTITY()

    END

    SELECT @MemberStatusId AS MemberStatusId

END
GO


