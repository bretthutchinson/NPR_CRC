CREATE  PROCEDURE [dbo].[PSP_StationListForGrid_Get]

		
	@UserId BIGINT
	
	AS BEGIN

   SET NOCOUNT ON

   select
   s.StationId,
   
   s.CallLetters + '-' + b.BandName AS DisplayName,
  
  
   CASE 
	WHEN s.PrimaryUserId is NULL or s.PrimaryUserId != su.UserId
	THEN 'No'
	ELSE 'Yes' 
   END AS PrimaryUser,
   
    
   CASE 
	WHEN su.GridWritePermissionsInd = 'N'
	THEN 'No'
	ELSE 'Yes' 
   END AS GridWritePermissionsInd
   
    from dbo.Band as b
   
    Inner Join dbo.Station as s on 
   
   s.BandId=b.BandID 
   
     
   Inner Join dbo.StationUser as su on (su.StationId=s.StationId) where su.UserId=@UserId And s.RepeaterStatusId !=1

  
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PSP_StationListForGrid_Get] TO [crcuser]
    AS [dbo];

