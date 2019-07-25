CREATE PROCEDURE dbo.DT_Producer
(
	@UserId INT
)
AS BEGIN

INSERT INTO CRC_Migration.dbo.Producer
           (SalutationId
           ,FirstName
           ,MiddleName
           ,LastName
           ,Suffix
           ,[Role]
           ,Email
           ,Phone
           ,DisabledDate
           ,DisabledUserId
           ,CreatedDate
           ,CreatedUserId
           ,LastUpdatedDate
           ,LastUpdatedUserId)

SELECT       
      (Select SalutationId FROM CRC_Migration.dbo.Salutation sal WHERE sal.SalutationName = 'Salutation')
      ,FirstName
      ,MiddleInitial
      ,LastName
      ,Suffix
	  ,NULL --Role??? ie; 'Executive Producer' --currently not sure where this comes from
      ,EmailAddress
      ,PhoneNumber
	  ,NULL -- DisabledDate ???
	  ,NULL --DisabldUserId ??
	  ,GETUTCDATE()
	  ,@UserId
	  ,GETUTCDATE()
	  ,@UserId

  FROM crc3.dbo.Producer
  
  WHERE LastName IS NOT NULL AND FirstName IS NOT NULL

  END

  GRANT EXEC ON dbo.DT_Producer TO CRCUser

