--[DT_ProgramProducer] 1
CREATE PROCEDURE [dbo].[DT_ProgramProducer] 
(
	@UserId INT
)

AS BEGIN

INSERT INTO CRC_Migration_Test_BH.[dbo].[ProgramProducer]
           ([ProgramId]
           ,[ProducerId]
           ,[CreatedDate]
           ,[CreatedUserId]
           ,[LastUpdatedDate]
           ,[LastUpdatedUserId])

SELECT (SELECT ProgramID FROM CRC_Migration_Test_BH.dbo.Program p WHERE p.ProgramName = prog.ProgramName) As ProgramId--No Dupes
      ,(SELECT TOP 1 ProducerId FROM CRC_Migration_Test_BH.dbo.Producer prod WHERE prod.FirstName = pro.FirstName AND prod.LastName = pro.LastName) As ProducerId --Contains Dupes, but should be weeded out when producers are Migrated
	  ,GETUTCDATE()
	  ,1
	  ,GETUTCDATE()
	  ,1

  FROM crc3_20141208_NoBackup.[dbo].[Program] prog

  JOIN crc3_20141208_NoBackup.dbo.Producer pro ON pro.ProducerId = prog.ProducerID 
  where pro.producerid is not null and prog.ProducerID is not null

END

GRANT EXEC ON dbo.DT_ProgramProducer TO CRCUser


--GO
--INSERT INTO CRC_Migration_Test_BH.[dbo].[ProgramProducer]
--           ([ProgramId]
--           ,[ProducerId]
--           ,[CreatedDate]
--           ,[CreatedUserId]
--           ,[LastUpdatedDate]
--           ,[LastUpdatedUserId])

--select 
----po.programid,
--max(pn.programid),
--case when max(prn.producerid) is not null then  max(prn.producerid) else 372 end
--	  ,GETUTCDATE()
--	  ,1
--	  ,GETUTCDATE()
--	  ,1

--from crc3_20141208_NoBackup.dbo.producer pro
--join crc3_20141208_NoBackup.dbo.Program po on pro.producerid=po.producerid
--join program pn on pn.programname = po.programname
--left join producer prn on prn.firstname=pro.firstname and prn.lastname=pro.lastname
--group by po.programid



--and prn.producerid is null

--update crc3_20141208_NoBackup.dbo.producer set lastname = 'None' where producerid = 1

--update crc3_20141208_NoBackup.dbo.producer set firstname = 'No Contact Listed' where producerid = 1
--select count(*) from program


--select * from producer

----truncate table ProgramProducer

--select * from 
--crc3_20141208_NoBackup.dbo.Program 
--where programid = 2564
--group by producerid order by cn desc

--select * from 

--where producerid =1 order by count *