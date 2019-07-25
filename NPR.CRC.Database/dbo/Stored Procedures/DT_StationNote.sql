CREATE PROCEDURE [dbo].[DT_StationNote]
(
	@UserId INT
)

AS BEGIN

INSERT INTO [CRC_Migration].[dbo].[StationNote]
           ([StationId]
           ,[NoteText]
           ,[DeletedDate]
           ,[DeletedUserId]
           ,[CreatedDate]
           ,[CreatedUserId]
           ,[LastUpdatedDate]
           ,[LastUpdatedUserId])

SELECT
 (SELECT  StationId FROM [CRC_Migration].[dbo].[Station] stat JOIN [CRC_Migration].[dbo].[Band] b ON stat.BandId = b.BandId WHERE stat.CallLetters = st.CallLetters AND b.BandName = st.Band) As StationId
      ,sn.notes
	  ,NULL --DeletedDate
	  ,NULL --DeletedUserId
	  ,GETUTCDATE()
	  ,@UserId
	  ,GETUTCDATE()
	  ,@UserId
 
From crc3.dbo.StationNotes sn  
  JOIN [crc3].[dbo].[Station] st ON st.StationID = sn.StationID WHERE st.Email IS NOT NULL


  END

  GRANT EXEC ON dbo.DT_StationNote TO CRCUser