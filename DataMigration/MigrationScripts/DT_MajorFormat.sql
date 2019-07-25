CREATE PROCEDURE dbo.DT_MajorFormat
(
	@UserId INT
)

AS BEGIN

INSERT INTO [CRC_Migration].[dbo].[MajorFormat]
           ([MajorFormatName]
           ,[MajorFormatCode]
           ,[DisabledDate]
           ,[DisabledUserId]
           ,[CreatedDate]
           ,[CreatedUserId]
           ,[LastUpdatedDate]
           ,[LastUpdatedUserId])

SELECT [MajorFormatName]
      ,[MajorFormatCode]      
	  ,NULL
	  ,NULL
	  ,GETUTCDATE()
	  ,@UserId
	  ,GETUTCDATE()
	  ,@UserId

FROM [crc3].[dbo].[MajorFormat]

END

GRANT EXEC ON dbo.DT_MajorFormat TO CRCUser AS [dbo];