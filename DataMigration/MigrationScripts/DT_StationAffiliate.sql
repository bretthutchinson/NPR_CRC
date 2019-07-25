CREATE PROCEDURE dbo.DT_StationAffiliate
(
	@UserId INT
)

AS BEGIN

INSERT INTO [CRC_Migration].[dbo].[StationAffiliate]
           ([StationId]
           ,[AffiliateId]
           ,[CreatedDate]
           ,[CreatedUserId]
           ,[LastUpdatedDate]
           ,[LastUpdatedUserId])


      SELECT
	  (SELECT  StationId FROM [CRC_Migration].[dbo].[Station] stat JOIN [CRC_Migration].[dbo].[Band] b ON stat.BandId = b.BandId WHERE stat.CallLetters = st.CallLetters AND b.BandName = st.Band) As StationId
      ,(SELECT AffiliateID FROM [CRC_Migration].[dbo].[Affiliate] a WHERE a.AffiliateCode = AffiliateAbbreviation) As AffiliateId
	  ,GETUTCDATE()
	  ,1
	  ,GETUTCDATE()
	  ,1


  FROM [crc3].[dbo].[StationAffiliate] sa

  JOIN [crc3].[dbo].[Affiliate] aff ON aff.AffiliateID = sa.AffiliateID

  JOIN [crc3].[dbo].[Station] st ON st.StationID = sa.StationID WHERE st.Email IS NOT NULL

  END

  GRANT EXEC ON dbo.DT_StationAffiliate TO CRCUser