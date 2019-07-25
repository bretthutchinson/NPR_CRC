--[DT_Program] 1
CREATE PROCEDURE [dbo].[DT_Program]
(
	@UserId INT
)

AS BEGIN 

INSERT INTO [CRC_Migration_Test_BH].[dbo].[Program]
           ([ProgramName]
           ,[ProgramSourceId]
           ,[ProgramFormatTypeId]
           ,[ProgramCode]
           ,[CarriageTypeId]
           ,[DisabledDate]
           ,[DisabledUserId]
           ,[CreatedDate]
           ,[CreatedUserId]
           ,[LastUpdatedDate]
           ,[LastUpdatedUserId])    

SELECT
	  [ProgramName]
      --,[ProgramTypeID] --Not Sure how this maps*****      
      ,(SELECT TOP 1 ProgramSourceID FROM [CRC_Migration_Test_BH].[dbo].[ProgramSource] ps WHERE ps.ProgramSourceCode = source.ProgramSourceCode) As ProgramSourceCode
      ,(SELECT ProgramFormatTypeId FROM [CRC_Migration_Test_BH].[dbo].[ProgramFormatType] pft WHERE pft.ProgramFormatTypeCode = pf.FormatCode) -- Assumption ProgramFormat = ProgramFormatType
      ,[ProgramCode] --NOT Sure how this maps (Not to be confused with FormatTypeCode) Assumption - maps directly as a varhcar
      ,NULL --CarriageTypeId - NOT sure how this maps or where it comes from***************
	  ,NULL
      ,NULL
      ,GETUTCDATE()
      ,@UserId
      ,GETUTCDATE()
      ,@UserId
	  
	  /* These will have to be mapped in another procedure 
	  ,[ProducerID] -- Map to new table 'ProgramProducer'
      ,[ValidEndDate]
      ,[ValidStartDate]
      ,[ValidStartTime]
      ,[ValidEndTime]
      ,[ValidDuration]
      ,[ValidMonday]
      ,[ValidTuesday]
      ,[ValidWednesday]
      ,[ValidThursday]
      ,[ValidFriday]
      ,[ValidSaturday]
      ,[ValidSunday]
      ,[Enabled]
	  */
  FROM crc3_20141030.[dbo].[Program] p

  JOIN crc3_20141030.[dbo].ProgramFormat pf ON pf.FormatID = p.FormatID

  JOIN crc3_20141030.[dbo].ProgramSource source ON source.ProgramSourceId = p.ProgramSourceID

  where p.programid > = 4391

  END

  GRANT EXEC on dbo.DT_Program TO CRCUser