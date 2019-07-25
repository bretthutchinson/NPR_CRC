CREATE PROCEDURE [dbo].[GET_CASUsers]

AS BEGIN

SELECT [UserName]      
      ,[Password]
      ,[UserRoleID]
      ,[FirstName]
      ,[LastName]      
      ,[MiddleInitial]
      ,[Suffix]
      ,[JobTitle]
      ,CASE WHEN [Email] = '' THEN [UserName] + '@DEFAULTEMAIL.com' ELSE [Email] END As [Email]
      ,[Address1]
      ,[Address2]
      ,[City]
      ,[Zip]
      ,[County]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[TimeFormat24]
      ,[ProgramEntryWizard]
      ,(SELECT StateId From CRC_Migration.dbo.State ss WHERE st.StateProvinceName = ss.StateName) As StateId
      ,(SELECT SalutationId FROM [CRC_Migration].dbo.Salutation WHERE SalutationName = s.Salutation) As SalutationId
	  ,cas.[Salutation_ID] As OldSalutation
      ,[Enabled]
  FROM [crc3].[dbo].[CASUser] cas
  JOIN crc3.dbo.Salutation s ON s.Salutation_Id = cas.Salutation_ID
  JOIN crc3.dbo.StateProvince st ON st.StateProvince_ID = cas.StateProvince_ID

  WHERE Email IS NOT NULL --AND RTRIM(LTRIM(Email)) != ''

END

GRANT EXECUTE
    ON OBJECT::[dbo].[GET_CASUsers] TO [crcuser]
    AS [dbo];
GO