CREATE PROCEDURE [dbo].[DT_ProgramFormatType]
(
	@UserId INT
)

AS BEGIN

INSERT INTO [CRC_Migration].[dbo].[ProgramFormatType]
           ([ProgramFormatTypeName]
           ,[ProgramFormatTypeCode]
           ,[MajorFormatId]
           ,[DisabledDate]
           ,[DisabledUserId]
           ,[CreatedDate]
           ,[CreatedUserId]
           ,[LastUpdatedDate]
           ,[LastUpdatedUserId])

SELECT 
      [FormatName]
	  ,[FormatCode]
	  ,(SELECT TOP 1 MajorFormatID FROM CRC_Migration.dbo.MajorFormat mf WHERE mf.MajorFormatCode = MajorFormatCode)
	  ,NULL
	  ,NULL
	  ,GETUTCDATE()
	  ,@UserId
	  ,GETUTCDATE()
	  ,@UserId	            

  FROM [crc3].[dbo].[ProgramFormat]

  END

  GRANT EXEC ON dbo.DT_ProgramFormatType TO CRCUser