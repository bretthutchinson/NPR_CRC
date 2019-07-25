CREATE PROCEDURE dbo.DT_ProgramSource
(
	@UserId INT
)

AS BEGIN 

INSERT INTO [CRC_Migration].[dbo].[ProgramSource]
           ([ProgramSourceName]
           ,[ProgramSourceCode]
           ,[DisabledDate]
           ,[DisabledUserId]
           ,[CreatedDate]
           ,[CreatedUserId]
           ,[LastUpdatedDate]
           ,[LastUpdatedUserId])

SELECT [ProgramSourceName]
	  ,[ProgramSourceCode]      
	  ,NULL
      ,NULL
      ,GETUTCDATE()
      ,@UserId
      ,GETUTCDATE()
      ,@UserId
  FROM [crc3].[dbo].[ProgramSource]
  WHERE ProgramSourceCode IS NOT NULL

END

  GRANT EXEC ON dbo.DT_ProgramSource TO CRCUser 
 
