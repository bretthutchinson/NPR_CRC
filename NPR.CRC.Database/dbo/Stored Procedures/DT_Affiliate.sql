CREATE PROCEDURE [dbo].[DT_Affiliate]
(
	@UserId INT
)
AS BEGIN

INSERT INTO CRC.dbo.Affiliate
           (AffiliateName
           ,AffiliateCode
           ,DisabledDate
           ,DisabledUserId
           ,CreatedDate
           ,CreatedUserId
           ,LastUpdatedDate
           ,LastUpdatedUserId)

SELECT 
      AffiliateName
      ,AffiliateAbbreviation
	  ,NULL -- DisabledDate ???
	  ,NULL --DisabldUserId ??
	  ,GETUTCDATE()
	  ,@UserId
	  ,GETUTCDATE()
	  ,@UserId

  FROM crc3.dbo.Affiliate

  END

  GRANT EXEC ON dbo.DT_Affiliate TO CRCUser AS [dbo];