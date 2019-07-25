CREATE PROCEDURE dbo.DT_ProgramProducer
(
	@UserId INT
)

AS BEGIN

INSERT INTO [CRC_Migration].[dbo].[ProgramProducer]
           ([ProgramId]
           ,[ProducerId]
           ,[CreatedDate]
           ,[CreatedUserId]
           ,[LastUpdatedDate]
           ,[LastUpdatedUserId])

SELECT (SELECT ProgramID FROM CRC_Migration.dbo.Program p WHERE p.ProgramName = prog.ProgramName) As ProgramId--No Dupes
      ,(SELECT TOP 1 ProducerId FROM CRC_Migration.dbo.Producer prod WHERE prod.FirstName = pro.FirstName AND prod.LastName = pro.LastName) As ProducerId --Contains Dupes, but should be weeded out when producers are Migrated
	  ,GETUTCDATE()
	  ,@UserId
	  ,GETUTCDATE()
	  ,@UserId

  FROM [crc3].[dbo].[Program] prog

  JOIN crc3.dbo.Producer pro ON pro.ProducerId = prog.ProducerID 

END

GRANT EXEC ON dbo.DT_ProgramProducer TO CRCUser

