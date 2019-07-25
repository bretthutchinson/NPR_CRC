CREATE PROCEDURE [dbo].[PSP_InfLog_Insert]
(
	@LogLevel INT,
	@Source VARCHAR(250),
	@Message VARCHAR(MAX),
	@UserName VARCHAR(50),
	@ServerAddress VARCHAR(50),
	@ServerHostname VARCHAR(50),
	@ClientAddress VARCHAR(50),
	@ClientHostname VARCHAR(50),
	@SerialNumber VARCHAR(50)
)
AS BEGIN

	SET NOCOUNT ON

	INSERT INTO dbo.InfLog
	(
		LogDate,
		LogLevel,
		Source,
		Message,
		UserName,
		ServerAddress,
		ServerHostname,
		ClientAddress,
		ClientHostname,
		SerialNumber
	)
	VALUES
	(
		GETUTCDATE(),
		@LogLevel,
		@Source,
		@Message,
		@UserName,
		@ServerAddress,
		@ServerHostname,
		@ClientAddress,
		@ClientHostname,
		@SerialNumber
	)

	SELECT CAST(SCOPE_IDENTITY() AS BIGINT)

END
GO


