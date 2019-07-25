USE [master]
GO
/****** Object:  Database [CRC]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE DATABASE [CRC]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CRC', FILENAME = N'E:\MSSQL\Data\NGS_STS_CRC.mdf' , SIZE = 1057472KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CRC_log', FILENAME = N'E:\MSSQL\Data\NGC_STS_CRC_log.ldf' , SIZE = 5120KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [CRC] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CRC].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CRC] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CRC] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CRC] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CRC] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CRC] SET ARITHABORT OFF 
GO
ALTER DATABASE [CRC] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CRC] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [CRC] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CRC] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CRC] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CRC] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CRC] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CRC] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CRC] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CRC] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CRC] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CRC] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CRC] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CRC] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CRC] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CRC] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CRC] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CRC] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CRC] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CRC] SET  MULTI_USER 
GO
ALTER DATABASE [CRC] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CRC] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CRC] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CRC] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'CRC', N'ON'
GO
USE [CRC]
GO
/****** Object:  User [crcuser]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE USER [crcuser] FOR LOGIN [crcuser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [crcuser]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [crcuser]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [crcuser]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [crcuser]
GO
ALTER ROLE [db_datareader] ADD MEMBER [crcuser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [crcuser]
GO
/****** Object:  StoredProcedure [dbo].[PSP_Affiliate_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Affiliate_Get]
(
    @AffiliateId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        AffiliateId,
		AffiliateName,
		AffiliateCode,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Affiliate

    WHERE
        AffiliateId = @AffiliateId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Affiliate_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Affiliate_Save]
(
    @AffiliateId BIGINT,
	@AffiliateName VARCHAR(50),
	@AffiliateCode VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Affiliate
    SET
        AffiliateName = @AffiliateName,
		AffiliateCode = @AffiliateCode,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        AffiliateId = @AffiliateId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Affiliate
        (
            AffiliateName,
			AffiliateCode,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @AffiliateName,
			@AffiliateCode,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @AffiliateId = SCOPE_IDENTITY()

    END

    SELECT @AffiliateId AS AffiliateId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Affiliates_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_Affiliates_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        AffiliateId,
		AffiliateName,
		AffiliateCode,
		CASE
			WHEN DisabledDate IS NULL
			THEN 'Yes'
			ELSE 'No'
		END AS EnabledInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Affiliate
    
END


GO
/****** Object:  StoredProcedure [dbo].[PSP_AffiliateValidateCodeIsUnique_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_AffiliateValidateCodeIsUnique_Get]
(
	@AffiliateId BIGINT,
    @AffiliateCode VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT *
			FROM dbo.Affiliate
			WHERE AffiliateCode = @AffiliateCode
			AND (AffiliateId <> @AffiliateId OR @AffiliateId IS NULL)
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_AffiliateValidateNameIsUnique_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_AffiliateValidateNameIsUnique_Get]
(
	@AffiliateId BIGINT,
    @AffiliateName VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT *
			FROM dbo.Affiliate
			WHERE AffiliateName = @AffiliateName
			AND (AffiliateId <> @AffiliateId OR @AffiliateId IS NULL)
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_Band_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Band_Get]
(
    @BandId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        BandId,
		BandName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Band

    WHERE
        BandId = @BandId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Band_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Band_Save]
(
    @BandId BIGINT,
	@BandName VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Band
    SET
        BandName = @BandName,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        BandId = @BandId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Band
        (
            BandName,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @BandName,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @BandId = SCOPE_IDENTITY()

    END

    SELECT @BandId AS BandId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Bands_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Bands_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        BandId,
		BandName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Band
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_CalendarProgramSearch_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_CalendarProgramSearch_Get]
(
	@ProgramName VARCHAR(250),
	@SearchType VARCHAR(50) = 'Wildcard' -- options are 'Wildcard' and 'StartsWith'
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

	IF @SearchType = 'StartsWith'
		BEGIN
			IF rtrim(ltrim(@ProgramName)) = '*'
				BEGIN
					SELECT TOP 100 ProgramId, ProgramName
					FROM dbo.Program
					ORDER BY ProgramName			
				END
			ELSE
				BEGIN
					SELECT TOP 100 ProgramId, ProgramName
					FROM dbo.Program
					WHERE ProgramName LIKE (rtrim(ltrim(@ProgramName)) + '%')
					ORDER BY ProgramName
				END
		END
	ELSE
		BEGIN
			SELECT TOP 100 ProgramId, ProgramName
			FROM dbo.Program
			WHERE ProgramName LIKE ('%' + rtrim(ltrim(@ProgramName)) + '%')
			ORDER BY ProgramName
		END
	
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_CarriageListByProgramReport_GET]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_CarriageListByProgramReport_GET]
(
	@MemberStatusName VARCHAR(50)
)
WITH EXECUTE AS OWNER
AS BEGIN

SET NOCOUNT ON

SELECT DISTINCT
p.ProgramName, ps.ProgramSourceName,pf.ProgramFormatTypeName,mf.MajorFormatName,sp.StartTime,sp.EndTime
from dbo.Program AS p
INNER JOIN  dbo.ProgramSource AS ps on ps.ProgramSourceId=p.ProgramSourceId
INNER JOIN  dbo.ProgramFormatType AS pf on pf.ProgramFormatTypeId=p.ProgramFormatTypeId
INNER JOIN  dbo.MajorFormat AS mf on mf.MajorFormatId=pf.MajorFormatId
INNER JOIN  dbo.ScheduleProgram AS sp on sp.ProgramId=p.ProgramId
INNER JOIN  dbo.Schedule AS s on s.ScheduleId=sp.ScheduleID
INNER JOIN dbo.Station As st on st.StationId=s.StationId
INNER JOIN dbo.MemberStatus As m on m.MemberStatusId=st.MemberStatusId
where 
(m.MemberStatusName= @MemberStatusName OR Coalesce(@MemberStatusName,'0')='0')
ORDER BY
p.ProgramName, ps.ProgramSourceName
END


GO
/****** Object:  StoredProcedure [dbo].[PSP_CarriageType_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_CarriageType_Get]
(
    @CarriageTypeId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        CarriageTypeId,
		CarriageTypeName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.CarriageType

    WHERE
        CarriageTypeId = @CarriageTypeId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_CarriageType_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_CarriageType_Save]
(
    @CarriageTypeId BIGINT,
	@CarriageTypeName VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.CarriageType
    SET
        CarriageTypeName = @CarriageTypeName,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        CarriageTypeId = @CarriageTypeId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.CarriageType
        (
            CarriageTypeName,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @CarriageTypeName,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @CarriageTypeId = SCOPE_IDENTITY()

    END

    SELECT @CarriageTypeId AS CarriageTypeId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_CarriageTypes_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_CarriageTypes_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        CarriageTypeId,
		CarriageTypeName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.CarriageType
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Check]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_Check]
(   @BandSpan VARCHAR(100),
	@MemberStatusName VARCHAR(100),
	@StationEnabled VARCHAR(10)
)

WITH EXECUTE AS OWNER

AS BEGIN
    
		SET NOCOUNT ON
		SELECT s.CallLetters from station AS s
		INNER JOIN  dbo.MemberStatus AS m on m.MemberStatusId=s.MemberStatusId
		INNER JOIN dbo.Band AS b on b.BandId=s.BandId

where 
b.BandName IN (REPLACE(@BandSpan, '|', '''') )
AND
(m.MemberStatusName=@MemberStatusName OR Coalesce(@MemberStatusName,'0')='0')
AND
	((s.DisabledDate IS NULL AND @StationEnabled = 'Y') OR (s.DisabledDate IS NOT NULL AND @StationEnabled = 'N') OR Coalesce(@StationEnabled,'0')='0')
	
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Check1]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Check1]
(
	@MemberStatusName VARCHAR(100)

)

WITH EXECUTE AS OWNER
 
AS BEGIN
    
		SET NOCOUNT ON
		
		DECLARE @DynSql NVARCHAR(MAX) =
		
		'
		SELECT s.CallLetters from station AS s
		INNER JOIN  dbo.MemberStatus AS m on m.MemberStatusId=s.MemberStatusId
		INNER JOIN dbo.Band AS b on b.BandId=s.BandId

		where '

		IF @MemberStatusName IS NOT NULL
			SET @DynSql= @DynSql + 'm.MemberStatusName=@MemberStatusName'
		
		IF @MemberStatusName IS NULL
			SET @DynSql= @DynSql + '@MemberStatusName=@MemberStatusName'
		
 
	PRINT @DynSql

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_CRCManager_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[PSP_CRCManager_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        UserId,
		dbo.FN_GetUserDisplayName(UserId) AS UserDisplayName,
		Email,
		PasswordHash,
		PasswordSalt,
		ResetPasswordHash,
		SalutationId,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		JobTitle,
		AddressLine1,
		AddressLine2,
		City,
		StateId,
		County,
		Country,
		ZipCode,
		Phone,
		Fax,
		AdministratorInd,
		CRCManagerInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.CRCUser

    WHERE
        CRCManagerInd = 'Y'

END




GO
/****** Object:  StoredProcedure [dbo].[PSP_CRCUser_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PSP_CRCUser_Get]
(
    @UserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        UserId,
		dbo.FN_GetUserDisplayName(UserId) AS UserDisplayName,
		Email,
		PasswordHash,
		PasswordSalt,
		ResetPasswordHash,
		SalutationId,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		JobTitle,
		AddressLine1,
		AddressLine2,
		City,
		StateId,
		County,
		Country,
		ZipCode,
		Phone,
		Fax,
		AdministratorInd,
		CRCManagerInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.CRCUser

    WHERE
        UserId = @UserId

END



GO
/****** Object:  StoredProcedure [dbo].[PSP_CRCUser_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[PSP_CRCUser_Save]
(
    @UserId BIGINT,
	@Email VARCHAR(100),
	@SalutationId BIGINT,
	@FirstName VARCHAR(50),
	@MiddleName VARCHAR(50),
	@LastName VARCHAR(50),
	@Suffix VARCHAR(50),
	@JobTitle VARCHAR(50),
	@AddressLine1 VARCHAR(50),
	@AddressLine2 VARCHAR(50),
	@City VARCHAR(50),
	@StateId BIGINT,
	@County VARCHAR(50),
	@Country VARCHAR(50),
	@ZipCode VARCHAR(50),
	@Phone VARCHAR(50),
	@Fax VARCHAR(50),
	@AdministratorInd CHAR(1),
	@CRCManagerInd CHAR(1),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.CRCUser
    SET
        Email = @Email,
		SalutationId = @SalutationId,
		FirstName = @FirstName,
		MiddleName = @MiddleName,
		LastName = @LastName,
		Suffix = @Suffix,
		JobTitle = @JobTitle,
		AddressLine1 = @AddressLine1,
		AddressLine2 = @AddressLine2,
		City = @City,
		StateId = @StateId,
		County = @County,
		Country = @Country,
		ZipCode = @ZipCode,
		Phone = @Phone,
		Fax = @Fax,
		AdministratorInd = @AdministratorInd,
		CRCManagerInd = @CRCManagerInd,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        UserId = @UserId

    IF @@ROWCOUNT < 1
    BEGIN

		DECLARE @PasswordSalt VARCHAR(50) = NEWID()
		DECLARE @Password VARCHAR(50) = NEWID()
		DECLARE @PasswordHash VARBINARY(50) = HASHBYTES('SHA1', @PasswordSalt + @Password)

        INSERT INTO dbo.CRCUser
        (
            Email,
			PasswordHash,
			PasswordSalt,
			SalutationId,
			FirstName,
			MiddleName,
			LastName,
			Suffix,
			JobTitle,
			AddressLine1,
			AddressLine2,
			City,
			StateId,
			County,
			Country,
			ZipCode,
			Phone,
			Fax,
			AdministratorInd,
			CRCManagerInd,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @Email,
			@PasswordHash,
			@PasswordSalt,
			@SalutationId,
			@FirstName,
			@MiddleName,
			@LastName,
			@Suffix,
			@JobTitle,
			@AddressLine1,
			@AddressLine2,
			@City,
			@StateId,
			@County,
			@Country,
			@ZipCode,
			@Phone,
			@Fax,
			@AdministratorInd,
			@CRCManagerInd,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @UserId = SCOPE_IDENTITY()

    END

    SELECT @UserId AS UserId

END




GO
/****** Object:  StoredProcedure [dbo].[PSP_CRCUserByEmail_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[PSP_CRCUserByEmail_Get]
(
    @Email VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        UserId,
		dbo.FN_GetUserDisplayName(UserId) AS UserDisplayName,
		Email,
		PasswordHash,
		PasswordSalt,
		ResetPasswordHash,
		SalutationId,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		JobTitle,
		AddressLine1,
		AddressLine2,
		City,
		StateId,
		County,
		Country,
		ZipCode,
		Phone,
		Fax,
		AdministratorInd,
		CRCManagerInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.CRCUser

    WHERE
        Email = @Email

END





GO
/****** Object:  StoredProcedure [dbo].[PSP_CRCUserByLogin_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[PSP_CRCUserByLogin_Get]
(
    @Email VARCHAR(100),
	@Password VARCHAR(50)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        UserId,
		dbo.FN_GetUserDisplayName(UserId) AS UserDisplayName,
		Email,
		PasswordHash,
		PasswordSalt,
		ResetPasswordHash,
		SalutationId,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		JobTitle,
		AddressLine1,
		AddressLine2,
		City,
		StateId,
		County,
		Country,
		ZipCode,
		Phone,
		Fax,
		AdministratorInd,
		CRCManagerInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.CRCUser

    WHERE
        Email = @Email
		AND
		PasswordHash = HASHBYTES('SHA1', PasswordSalt + @Password)
		AND
		DisabledDate IS NULL

END





GO
/****** Object:  StoredProcedure [dbo].[PSP_CRCUserByResetPasswordToken_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PSP_CRCUserByResetPasswordToken_Get]
(
    @Token VARCHAR(50)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        UserId,
		dbo.FN_GetUserDisplayName(UserId) AS UserDisplayName,
		Email,
		PasswordHash,
		PasswordSalt,
		ResetPasswordHash,
		SalutationId,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		JobTitle,
		AddressLine1,
		AddressLine2,
		City,
		StateId,
		County,
		Country,
		ZipCode,
		Phone,
		Fax,
		AdministratorInd,
		CRCManagerInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.CRCUser

    WHERE
		ResetPasswordHash = HASHBYTES('SHA1', PasswordSalt + @Token)
		AND
		DisabledDate IS NULL

END







GO
/****** Object:  StoredProcedure [dbo].[PSP_CRCUserPassword_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PSP_CRCUserPassword_Save]
(
    @UserId BIGINT,
	@Password VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	DECLARE @PasswordSalt VARCHAR(50) = NEWID()

    UPDATE dbo.CRCUser
    SET
		PasswordSalt = @PasswordSalt,
		PasswordHash = HASHBYTES('SHA1', @PasswordSalt + @Password),
		ResetPasswordHash = NULL,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        UserId = @UserId

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_CRCUserPasswordReset_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_CRCUserPasswordReset_Save]
(
    @Email VARCHAR(100),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	DECLARE @UserId BIGINT
	DECLARE @Token VARCHAR(50)
	DECLARE @CRCUserFirstName VARCHAR(50)
	DECLARE @CRCUserLastName VARCHAR(50)
	DECLARE @CRCUserEmail VARCHAR(100)
	DECLARE @CRCManagerUserId BIGINT
	DECLARE @CRCManagerFirstName VARCHAR(50)
	DECLARE @CRCManagerLastName VARCHAR(50)
	DECLARE @CRCManagerEmail VARCHAR(100)
	DECLARE @CRCManagerPhone VARCHAR(50)
	DECLARE @CRCManagerJobTitle VARCHAR(50)

	SELECT @UserId = UserId
	FROM dbo.CRCUser
	WHERE Email = @Email
	AND DisabledDate IS NULL

	IF @UserId IS NOT NULL
	BEGIN
		
		SET @Token = NEWID()

		SELECT
			@CRCUserFirstName = FirstName,
			@CRCUserLastName = LastName,
			@CRCUserEmail = Email
		FROM
			dbo.CRCUser
		WHERE
			UserId = @UserId

		SELECT
			@CRCManagerUserId = UserId,
			@CRCManagerFirstName = FirstName,
			@CRCManagerLastName = LastName,
			@CRCManagerEmail = Email,
			@CRCManagerPhone = Phone,
			@CRCManagerJobTitle = JobTitle
		FROM
			dbo.CRCUser
		WHERE
			CRCManagerInd = 'Y'

		UPDATE dbo.CRCUser
		SET
			ResetPasswordHash = HASHBYTES('SHA1', PasswordSalt + @Token),
			LastUpdatedDate = GETUTCDATE(),
			LastUpdatedUserId = ISNULL(@LastUpdatedUserId, @UserId)
		WHERE
			UserId = @UserId

	END

	SELECT
		@Token AS Token,
		@UserId AS UserId,
		@CRCUserFirstName AS CRCUserFirstName,
		@CRCUserLastName AS CRCUserLastName,
		@CRCUserEmail AS CRCUserEmail,
		@CRCManagerFirstName AS CRCManagerFirstName,
		@CRCManagerLastName AS CRCManagerLastName,
		@CRCManagerEmail AS CRCManagerEmail,
		@CRCManagerPhone AS CRCManagerPhone,
		@CRCManagerJobTitle AS CRCManagerJobTitle
	WHERE
		@UserId IS NOT NULL

END






GO
/****** Object:  StoredProcedure [dbo].[PSP_CRCUsers_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_CRCUsers_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        UserId,
		Email,
		PasswordHash,
		PasswordSalt,
		ResetPasswordHash,
		SalutationId,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		JobTitle,
		AddressLine1,
		AddressLine2,
		City,
		StateId,
		County,
		Country,
		ZipCode,
		Phone,
		Fax,
		AdministratorInd,
		CRCManagerInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.CRCUser
    
END


GO
/****** Object:  StoredProcedure [dbo].[PSP_CRCUsersSearch_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_CRCUsersSearch_Get]
(
	@UserEnabled VARCHAR(50),
	@StationEnabled VARCHAR(50),
	@UserName VARCHAR(50),
	@RepeaterStatusId BIGINT,
	@UserRole VARCHAR(50),
	@Band VARCHAR(50),
	@UserPermission VARCHAR(50),
	@StationId BIGINT,
	@DebugInd CHAR(1) = 'N'
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
    SELECT
        u.UserId,
		dbo.FN_GetUserDisplayName(u.UserId) AS UserDisplayName,
		CASE
			WHEN u.CRCManagerInd = ''Y'' THEN ''CRC Manger''
			WHEN u.AdministratorInd = ''Y'' THEN ''Administrator''
			WHEN s.PrimaryUserId = u.UserId THEN ''Primary User''
			WHEN su.GridWritePermissionsInd = ''Y'' THEN ''Grid Write''
			ELSE ''Station User''
		END AS UserPermission,
		CASE
			WHEN u.DisabledDate IS NULL THEN ''Yes''
			ELSE ''No''
		END AS UserEnabled,
		s.StationId,
		s.CallLetters + ''-'' + b.BandName AS StationDisplayName,
		rs.RepeaterStatusName AS RepeaterStatus,
		s.FlagshipStationId,
		fs.CallLetters + ''-'' + fsb.BandName AS FlagshipStationDisplayName,
		u.Email,
		u.Phone

    FROM
        dbo.CRCUser u

		LEFT JOIN dbo.StationUser su
			ON su.UserId = u.UserId

		LEFT JOIN dbo.Station s
			ON s.StationId = su.StationId

		LEFT JOIN dbo.Band b
			ON b.BandId = s.BandId

		LEFT JOIN dbo.RepeaterStatus rs
			ON rs.RepeaterStatusId = s.RepeaterStatusId

		LEFT JOIN dbo.Station fs
			ON fs.StationId = s.FlagshipStationId

		LEFT JOIN dbo.Band fsb
			ON fsb.BandId = fs.BandId

	WHERE 1=1
	'

	IF @UserEnabled = 'YES'
		SET @DynSql = @DynSql + ' AND u.DisabledDate IS NULL'
	ELSE IF @UserEnabled = 'NO'
		SET @DynSql = @DynSql + ' AND u.DisabledDate IS NOT NULL'

	IF @StationEnabled = 'YES'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NULL'
	ELSE IF @StationEnabled = 'NO'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NOT NULL'

	IF LEN(@UserName) > 0
		SET @DynSql = @DynSql + ' AND REPLACE(u.FirstName + u.LastName, '' '', '''') LIKE ''%'' + REPLACE(@UserName, '' '', '''') + ''%'''

	IF @RepeaterStatusId IS NOT NULL
		SET @DynSql = @DynSql + ' AND rs.RepeaterStatusId = @RepeaterStatusId'

	IF @UserRole LIKE '%Station%'
		SET @DynSql = @DynSql + ' AND u.AdministratorInd = ''N'''
	ELSE IF @UserRole LIKE '%Admin%'
		SET @DynSql = @DynSql + ' AND u.AdministratorInd = ''Y'''

	IF @Band = 'Terrestrial'
		SET @DynSql = @DynSql + ' AND b.BandName IN (''AM'', ''FM'')'
	ELSE IF @Band = 'HD'
		SET @DynSql = @DynSql + ' AND b.BandName LIKE ''%HD%'''

	IF @UserPermission LIKE '%Primary%'
		SET @DynSql = @DynSql + ' AND s.PrimaryUserId = u.UserId'
	ELSE IF @UserPermission LIKE '%Write%'
		SET @DynSql = @DynSql + ' AND su.GridWritePermissionsInd = ''Y'''

	IF @StationId IS NOT NULL
		SET @DynSql = @DynSql + ' AND s.StationId = @StationId'


	DECLARE @DynParams NVARCHAR(MAX) =
	'
	@UserName VARCHAR(50),
	@RepeaterStatusId BIGINT,
	@StationId BIGINT
	'

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		EXEC dbo.sp_executesql
		@DynSql,
		@DynParams,
		@UserName = @UserName,
		@RepeaterStatusId = @RepeaterStatusId,
		@StationId = @StationId

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_CRCUserValidateEmailIsUnique_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_CRCUserValidateEmailIsUnique_Get]
(
	@UserId BIGINT,
    @Email VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT *
			FROM dbo.CRCUser
			WHERE Email = @Email
			AND (UserId <> @UserId OR @UserId IS NULL)
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_DMAMarket_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_DMAMarket_Get]
(
    @DMAMarketId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        DMAMarketId,
		MarketName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.DMAMarket

    WHERE
        DMAMarketId = @DMAMarketId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_DMAMarket_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_DMAMarket_Save]
(
    @DMAMarketId BIGINT,
	@MarketName VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.DMAMarket
    SET
        MarketName = @MarketName,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        DMAMarketId = @DMAMarketId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.DMAMarket
        (
            MarketName,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @MarketName,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @DMAMarketId = SCOPE_IDENTITY()

    END

    SELECT @DMAMarketId AS DMAMarketId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_DMAMarket_Update]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PSP_DMAMarket_Update]
(
    @CallLetters VARCHAR(100),
	@Band VARCHAR(10),
	@DMAMarket VARCHAR(50),
	@DMAMarketRank INT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

        UPDATE s
    SET        
		DMAMarketId = (SELECT DMAMarketId FROM DMAMarket WHERE MarketName = @DMAMarket),
		DMAMarketRank = @DMAMarketRank,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
		
		FROM dbo.Station s
		JOIN dbo.Band b on b.BandId = s.BandId		

    WHERE
        CallLetters = @CallLetters AND b.BandName = @Band

    SELECT @@ROWCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_DMAMarkets_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_DMAMarkets_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        DMAMarketId,
		MarketName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.DMAMarket
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_FlagshipStationsList_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PSP_FlagshipStationsList_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        s.StationId,
		s.CallLetters + '-' + b.BandName AS DisplayName

    FROM
        dbo.Station s

		JOIN dbo.Band b
			ON b.BandId = s.BandId

		JOIN dbo.RepeaterStatus rs
			ON rs.RepeaterStatusId = s.RepeaterStatusId

	WHERE
		rs.RepeaterStatusName = 'Flagship'
    
END



GO
/****** Object:  StoredProcedure [dbo].[PSP_FormatCalculationReport_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_FormatCalculationReport_Get]
(
@StartTime VARCHAR(20),
@EndTime VARCHAR(20),
@SundayInd VARCHAR(1),
@MondayInd VARCHAR(1),
@TuesdayInd VARCHAR(1),
@WednesdayInd VARCHAR(1),
@ThursdayInd VARCHAR(1),
@FridayInd VARCHAR(1),
@SaturdayInd VARCHAR(1),
@Month BIGINT,
@Year BIGINT,
@RepeaterStatusId BIGINT,
@MemberStatusId CHAR(1),
@StationId BIGINT,
@DebugInd CHAR(1)
)

WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) = '

	DECLARE @rawData TABLE (
		TableId INT IDENTITY,
		Station VARCHAR(100),
		Abbreviation CHAR(2),
		City VARCHAR(100),
		MemberStatusName VARCHAR(100),
		Metro INT,
		DMA INT,
		MajorFormatSum INT,
		MajorFormatCode VARCHAR(10)
	)

	DECLARE @TotalQuarterHours NUMERIC(18, 2);

	SET @TotalQuarterHours = 0.0;

	INSERT INTO @rawData (Station, Abbreviation, City, MemberStatusName, Metro, DMA, MajorFormatSum, MajorFormatCode)
	SELECT
		st.CallLetters + ''-'' + b.BandName AS Station, 
		s.Abbreviation, 
		st.city, 
		ms.MemberStatusName, 
		st.MetroMarketRank AS Metro,
		st.DMAMarketRank AS DMA,
		(
			CASE WHEN ''' + @SundayInd + ''' = ''Y'' AND sp.SundayInd = ''Y'' THEN
				SUM((DATEDIFF(MINUTE, 
											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''
													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime
													ELSE sp.StartTime
											END,
											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime
													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''
													ELSE sp.EndTime
											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000'' AND ''' + @EndTime + ''' = ''23:59:59.0000000'' THEN 1 ELSE 0 END) 
			ELSE 0 END
			+ 
			CASE WHEN ''' + @MondayInd + ''' = ''Y'' AND sp.MondayInd = ''Y'' THEN
				SUM((DATEDIFF(MINUTE, 
											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''
													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime
													ELSE sp.StartTime
											END,
											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime
													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''
													ELSE sp.EndTime
											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000'' AND ''' + @EndTime + ''' = ''23:59:59.0000000'' THEN 1 ELSE 0 END) 
			ELSE 0 END	
			+ 
			CASE WHEN ''' + @TuesdayInd + ''' = ''Y'' AND sp.TuesdayInd = ''Y'' THEN
				SUM((DATEDIFF(MINUTE, 
											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''
													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime
													ELSE sp.StartTime
											END,
											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime
													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''
													ELSE sp.EndTime
											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000'' AND ''' + @EndTime + ''' = ''23:59:59.0000000'' THEN 1 ELSE 0 END) 
			ELSE 0 END	
			+ 
			CASE WHEN ''' + @WednesdayInd + ''' = ''Y'' AND sp.WednesdayInd = ''Y'' THEN
				SUM((DATEDIFF(MINUTE, 
											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''
													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime
													ELSE sp.StartTime
											END,
											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime
													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''
													ELSE sp.EndTime
											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000'' AND ''' + @EndTime + ''' = ''23:59:59.0000000'' THEN 1 ELSE 0 END) 
			ELSE 0 END	
			+ 
			CASE WHEN ''' + @ThursdayInd + ''' = ''Y'' AND sp.ThursdayInd = ''Y'' THEN
				SUM((DATEDIFF(MINUTE, 
											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''
													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime
													ELSE sp.StartTime
											END,
											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime
													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''
													ELSE sp.EndTime
											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000'' AND ''' + @EndTime + ''' = ''23:59:59.0000000'' THEN 1 ELSE 0 END) 
			ELSE 0 END	
			+ 
			CASE WHEN ''' + @FridayInd + ''' = ''Y'' AND sp.FridayInd = ''Y'' THEN
				SUM((DATEDIFF(MINUTE, 
											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''
													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime
													ELSE sp.StartTime
											END,
											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime
													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''
													ELSE sp.EndTime
											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000'' AND ''' + @EndTime + ''' = ''23:59:59.0000000'' THEN 1 ELSE 0 END) 
			ELSE 0 END	
			+ 
			CASE WHEN ''' + @SaturdayInd + ''' = ''Y'' AND sp.SaturdayInd = ''Y'' THEN
				SUM((DATEDIFF(MINUTE, 
											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''
													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime
													ELSE sp.StartTime
											END,
											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime
													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''
													ELSE sp.EndTime
											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000'' AND ''' + @EndTime + ''' = ''23:59:59.0000000'' THEN 1 ELSE 0 END) 
			ELSE 0 END
		) As MajorFormatSum,
		mf.MajorFormatCode
	FROM 
		dbo.Schedule as sc INNER JOIN 
		dbo.Station st ON st.StationId = sc.StationId INNER JOIN 
		(
			SELECT * FROM ScheduleProgram sp1 WHERE ScheduleProgramId IN 
			(
				SELECT 
					ScheduleProgramId 
				FROM 
					ScheduleProgram sp2
				WHERE 
					((StartTime <= ''' + @StartTime + ''' AND EndTime > ''' + @StartTime + ''') OR (StartTime < ''' + @EndTime + ''' AND EndTime >= ''' + @EndTime + ''') OR (StartTime >= ''' + @StartTime + ''' AND EndTime <= ''' + @EndTime + '''))
				AND sp2.ScheduleId = sp1.ScheduleId
			)
		) sp ON sc.ScheduleId = sp.ScheduleId INNER JOIN 
		dbo.RepeaterStatus rs ON st.RepeaterStatusId = rs.RepeaterStatusId INNER JOIN
		dbo.Program p ON p.ProgramId = sp.ProgramId INNER JOIN 
		dbo.ProgramFormatType pft ON pft.ProgramFormatTypeId = p.ProgramFormatTypeId INNER JOIN 
		dbo.MajorFormat mf ON mf.MajorFormatId = pft.MajorFormatId INNER JOIN 
		dbo.[State] s ON s.StateId = st.StateId INNER JOIN 
		dbo.Band b ON b.bandid = st.BandId INNER JOIN 
		dbo.MemberStatus ms ON ms.MemberStatusId = st.MemberStatusId
	WHERE 
		sc.[Month] = ' + CONVERT(VARCHAR, @Month) + ' AND sc.[Year] = ' + CONVERT(VARCHAR, @Year) + '
		AND mf.MajorFormatCode <> ''OFF'''

	IF @StationId IS NOT NULL
		SET @DynSql = @DynSql + ' AND st.stationId = ' + CONVERT(VARCHAR, @StationId)

	IF @RepeaterStatusId = 1
		SET @DynSql = @DynSql + ' AND rs.RepeaterStatusName IN (''Flagship'', ''Non-100% (Partial)'')'

	IF @RepeaterStatusId = 2
		SET @DynSql = @DynSql + ' AND rs.RepeaterStatusName = ''100% Repeater'''

	IF @MemberStatusId = 'Y'
		SET @DynSql = @DynSql + ' AND ms.NPRMembershipInd = ''Y'''

	IF @MemberStatusId = 'N'
		SET @DynSql = @DynSql + ' AND ms.NPRMembershipInd = ''N'''

--AND
--(st.RepeaterStatusId = ISNULL(@RepeaterStatusId OR @RepeaterStatusId=0)  
--AND
--(ms.NPRMembershipInd = @NPRMembershipInd OR @NPRMembershipInd='')
--AND
 --(sc.Status=''Accepted'')
	SET @DynSql = @DynSql + '
	 GROUP BY 
		st.CallLetters, 
		b.BandName,
		s.Abbreviation, 
		st.City, 
		mf.MajorFormatCode, 
		ms.MemberStatusName , 
		st.MetroMarketRank, 
		st.DMAMarketRank,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd

	SELECT @TotalQuarterHours = SUM(MajorFormatSum) FROM @rawData;

	--SELECT @TotalQuarterHours;

	SELECT 
		Station, Abbreviation, City, MemberStatusName As ''Member Status'', Metro, DMA, 
		SUM(CASE WHEN MajorFormatCode = ''CLS'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''CLS'',
		SUM(CASE WHEN MajorFormatCode = ''ELC'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''ELC'',
		SUM(CASE WHEN MajorFormatCode = ''ENT'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''ENT'',
		SUM(CASE WHEN MajorFormatCode = ''FLK'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''FLK'',
		SUM(CASE WHEN MajorFormatCode = ''JZZ'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''JZZ'',
		SUM(CASE WHEN MajorFormatCode = ''NWS'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''NWS'',
		SUM(CASE WHEN MajorFormatCode = ''POP'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''POP'',
		SUM(CASE WHEN MajorFormatCode = ''TRG'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''TRG'',
		SUM(CASE WHEN MajorFormatCode = ''WLD'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''WLD''
	FROM
		@rawData
	GROUP BY
		Station, Abbreviation, City, MemberStatusName, Metro, DMA
	ORDER BY 
		Station, Abbreviation, City

	--SELECT *,  CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) As FormatPtgCalc
	--FROM @rawData
	--ORDER BY Abbreviation, City '

	IF @DebugInd = 'Y'
		PRINT CAST(@DynSql As NTEXT)
	ELSE
		EXEC dbo.sp_executesql @DynSql 

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_GridDataReport_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_GridDataReport_Get]
(
@BandSpan VARCHAR(200),
@DeletedInd CHAR(1),
@RepeaterStatus CHAR(1),
@RegularNewscastInd VARCHAR(25),
@Month BIGINT,
@Year BIGINT,
@DebugInd CHAR(1)
)

WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON

	DECLARE @RepeaterStatusName VARCHAR(100);

	SELECT  @RepeaterStatusName = 
		CASE @RepeaterStatus 
			WHEN 'F' THEN 'FlagShip'
			WHEN 'R' THEN '100% Repeater'
			WHEN 'N' THEN 'Non-100% (Partial) Repeater'
			WHEN 'A' THEN 'Flagship'', ''Non-100% (Partial) Repeater'', ''100% Repeater'
		END

	DECLARE @DynSql NVARCHAR(MAX) 
	
	IF @RegularNewscastInd = 'Regular'
	BEGIN
		SET @DynSql = '
		SELECT
			st.CallLetters + ''-'' + b.BandName As Station, ' +
			CONVERT(VARCHAR, @Year) 

			IF LEN(@Month) = 1
				SET @DynSql = @DynSql + '0' +
			
			CONVERT(VARCHAR, @Month) + ' As YearMonth,  
			pr.ProgramName, 
			pFT.ProgramFormatTypeCode,
			pS.ProgramSourceCode,
			CASE schP.SundayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.MondayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.TuesdayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.WednesdayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.ThursdayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.FridayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.SaturdayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END As DaysInd,
			SUBSTRING(REPLACE(REPLACE(CONVERT(VARCHAR, schP.StartTime), '':'', ''''), ''.'', ''''), 0, 5) As StartTime,
			SUBSTRING(REPLACE(REPLACE(CONVERT(VARCHAR, CASE schP.EndTime WHEN ''23:59:59.0000000'' THEN ''00:00:00.0000000'' ELSE schP.EndTime END), '':'', ''''), ''.'', ''''), 0, 5) As EndTime,
			CONVERT(INT,
				CASE schP.SundayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END +
				CASE schP.MondayInd WHEN ''Y'' THEN  schP.QuarterHours ELSE 0 END +
				CASE schP.TuesdayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END +
				CASE schP.WednesdayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END +
				CASE schP.ThursdayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END +
				CASE schP.FridayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END +
				CASE schP.SaturdayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END) As ProgramQuarterHours,
TotalQHours
		FROM
			dbo.Schedule sch INNER JOIN
			dbo.ScheduleProgram schP ON sch.ScheduleId = schP.ScheduleId INNER JOIN
			dbo.Program pr ON schP.ProgramId = pr.ProgramId INNER JOIN
			dbo.ProgramFormatType pFT ON pr.ProgramFormatTypeId = pFT.ProgramFormatTypeId INNER JOIN
			dbo.ProgramSource pS ON pr.ProgramSourceId = pS.ProgramSourceId INNER JOIN
			dbo.Station st ON sch.StationId = st.StationId INNER JOIN
			dbo.Band b ON st.BandId = b.BandId INNER JOIN
			dbo.RepeaterStatus rS ON st.RepeaterStatusId = rS.RepeaterStatusId LEFT JOIN
			(
				SELECT 
					sch.StationId, 
					SUM(
						CASE WHEN SundayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END + 
						CASE WHEN MondayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END +
						CASE WHEN TuesdayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END +
						CASE WHEN WednesdayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END +
						CASE WHEN ThursdayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END +
						CASE WHEN FridayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END +
						CASE WHEN SaturdayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END
						) As TotalQHours
				FROM
					dbo.Schedule sch INNER JOIN
					dbo.ScheduleProgram schP ON sch.ScheduleId = schP.ScheduleId
				WHERE
					sch.[Month] = ' + CONVERT(VARCHAR, @Month) + ' AND sch.[Year] = ' + CONVERT(VARCHAR, @Year) + '
				GROUP BY
					sch.StationId
			) As stQHours ON sch.StationId = stQHours.StationId
		WHERE
			--stQHours.TotalQHours = 672 AND
			b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ') AND
			sch.[Month] = ' + CONVERT(VARCHAR, @Month) + ' AND sch.[Year] = ' + CONVERT(VARCHAR, @Year) + ' AND
			rS.RepeaterStatusName IN (''' + @RepeaterStatusName + ''') '

		IF @DeletedInd = 'N'
			SET @DynSql = @DynSql + ' AND st.DisabledUserId IS NULL'
	
		IF @DeletedInd = 'Y'
			SET @DynSql = @DynSql + ' AND st.DisabledUserId IS NOT NULL'
	END

	IF @DebugInd = 'Y'
		PRINT CAST(@DynSql As NTEXT)
	ELSE
		EXEC dbo.sp_executesql @DynSql 

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_InfEmail_Insert]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_InfEmail_Insert]
(
	@FromAddress VARCHAR(50),
	@ToAddress VARCHAR(MAX),
	@CcAddress VARCHAR(MAX),
	@BccAddress VARCHAR(MAX),
	@Subject VARCHAR(500),
	@Body VARCHAR(MAX),
	@HtmlInd CHAR(1),
	@Priority VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

	SET NOCOUNT ON

	INSERT INTO dbo.InfEmail
	(
		FromAddress,
		ToAddress,
		CcAddress,
		BccAddress,
		Subject,
		Body,
		HtmlInd,
		Priority,
		SentDate,
		RetryCount,
		LastError,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	)
	VALUES
	(
		@FromAddress,
		@ToAddress,
		@CcAddress,
		@BccAddress,
		@Subject,
		@Body,
		@HtmlInd,
		@Priority,
		NULL,
		0,
		NULL,
		GETUTCDATE(),
		@LastUpdatedUserId,
		GETUTCDATE(),
		@LastUpdatedUserId
	)

	DECLARE @InfEmailId INT
	SET @InfEmailId = SCOPE_IDENTITY()

	SELECT @InfEmailId AS InfEmailId

END





GO
/****** Object:  StoredProcedure [dbo].[PSP_InfEmailAttachment_Insert]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_InfEmailAttachment_Insert]
(
	@InfEmailAttachmentId BIGINT,
	@InfEmailId BIGINT,
	@AttachmentName VARCHAR(100),
	@AttachmentBytes VARBINARY(MAX),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

	SET NOCOUNT ON

	INSERT INTO dbo.InfEmailAttachment
	(
		InfEmailId,
		AttachmentName,
		AttachmentBytes,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	)
	VALUES
	(
		@InfEmailId,
		@AttachmentName,
		@AttachmentBytes,
		GETUTCDATE(),
		@LastUpdatedUserId,
		GETUTCDATE(),
		@LastUpdatedUserId
	)

	SET @InfEmailAttachmentId = SCOPE_IDENTITY()

	SELECT @InfEmailAttachmentId AS InfEmailAttachmentId

END



GO
/****** Object:  StoredProcedure [dbo].[PSP_InfEmailAttachmentsForEmail_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_InfEmailAttachmentsForEmail_Get]
(
	@InfEmailId BIGINT
)
AS BEGIN

	SET NOCOUNT ON

	SELECT
		InfEmailAttachmentId,
		InfEmailId,
		AttachmentName,
		AttachmentBytes,
		AttachmentSize,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	FROM
		dbo.InfEmailAttachment
	WHERE
		InfEmailId = @InfEmailId
	ORDER BY
		AttachmentName

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_InfEmailError_Update]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_InfEmailError_Update]
(
	@InfEmailId BIGINT,
	@LastError VARCHAR(MAX)
)
AS BEGIN

	SET NOCOUNT ON

	UPDATE dbo.InfEmail
	SET
		RetryCount = RetryCount + 1,
		LastError = @LastError,
		LastUpdatedDate = GETUTCDATE()
	WHERE
		InfEmailId = @InfEmailId

END




GO
/****** Object:  StoredProcedure [dbo].[PSP_InfEmailSuccess_Update]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_InfEmailSuccess_Update]
(
	@InfEmailId BIGINT
)
AS BEGIN

	SET NOCOUNT ON

	UPDATE dbo.InfEmail
	SET
		SentDate = GETUTCDATE(),
		LastUpdatedDate = GETUTCDATE()
	WHERE
		InfEmailId = @InfEmailId

END




GO
/****** Object:  StoredProcedure [dbo].[PSP_InfEmailTemplateByName_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_InfEmailTemplateByName_Get]
(
	@TemplateName VARCHAR(50)
)
AS BEGIN

	SET NOCOUNT ON

	SELECT
		InfEmailTemplateId,
		TemplateName,
		FromAddress,
		ToAddress,
		CcAddress,
		BccAddress,
		Subject,
		Body,
		HtmlInd,
		Priority,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	FROM
		dbo.InfEmailTemplate
	WHERE
		TemplateName = @TemplateName

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_InfEmailUnsent_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_InfEmailUnsent_Get]
(
	@MaxRetryAttempts INT
)
AS BEGIN

	SET NOCOUNT ON

	SELECT
		InfEmailId,
		FromAddress,
		ToAddress,
		CcAddress,
		BccAddress,
		Priority,
		Subject,
		Body,
		HtmlInd,
		SentDate,
		RetryCount,
		LastError,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	FROM
		dbo.InfEmail
	WHERE
		SentDate IS NULL
		AND
		RetryCount < @MaxRetryAttempts
	ORDER BY
		CreatedDate

END



GO
/****** Object:  StoredProcedure [dbo].[PSP_InfIsValueUnique_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_InfIsValueUnique_Get]
(
	@Value SQL_VARIANT,
	@TableName SYSNAME,
	@ColumnName SYSNAME,
	@Id BIGINT
)
WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @IdColumnName SYSNAME
	DECLARE @HasDeletedInd CHAR(1)

	SELECT
		@IdColumnName = col.name,
		@HasDeletedInd =
			CASE WHEN EXISTS
			(
				SELECT *
				FROM sys.columns col_d
				WHERE col_d.object_id = ix.object_id
				AND col_d.name = 'DeletedInd'
			)
			THEN 'Y'
			ELSE 'N'
			END
	FROM
		sys.indexes ix
	JOIN sys.index_columns ixc
		ON ixc.object_id = ix.object_id
		AND ixc.index_id = ix.index_id
	JOIN sys.columns col
		ON col.object_id = ixc.object_id
		AND col.column_id = ixc.column_id
	WHERE
		OBJECT_NAME(ix.object_id) = @TableName
		AND ix.is_primary_key = 1
		AND ixc.index_column_id = 1
		AND EXISTS
		(
			SELECT *
			FROM sys.columns
			WHERE OBJECT_NAME(object_id) = @TableName
			AND name = @ColumnName
		)

	IF LEN(@IdColumnName) > 0
	BEGIN
		DECLARE @DynSql NVARCHAR(MAX) =
		'
		SELECT
			CASE WHEN EXISTS
			(
				SELECT *
				FROM ' + @TableName + '
				WHERE ' + @ColumnName + ' = @Value
				AND (' + @IdColumnName + ' <> @Id OR @Id IS NULL) 
				' +
				CASE @HasDeletedInd
					WHEN 'Y' THEN 'AND DeletedInd = ''N'''
					ELSE ''
					END + '
			)
			THEN ''N''
			ELSE ''Y''
			END AS IsUniqueInd
		'

		PRINT @DynSql

		DECLARE @DynParams NVARCHAR(MAX) =
		'
			@Value SQL_VARIANT,
			@Id BIGINT
		'

		EXEC dbo.sp_executesql
			@DynSql,
			@DynParams,
			@Value = @Value,
			@Id = @Id

	END

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_InfLog_Insert]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_InfLog_Insert]
(
	@LogLevel INT,
	@Source VARCHAR(250),
	@Message VARCHAR(MAX),
	@UserName VARCHAR(50),
	@ServerAddress VARCHAR(50),
	@ServerHostname VARCHAR(50),
	@ClientAddress VARCHAR(50),
	@ClientHostname VARCHAR(50),
	@SerialNumber VARCHAR(50)
)
AS BEGIN

	SET NOCOUNT ON

	INSERT INTO dbo.InfLog
	(
		LogDate,
		LogLevel,
		Source,
		Message,
		UserName,
		ServerAddress,
		ServerHostname,
		ClientAddress,
		ClientHostname,
		SerialNumber
	)
	VALUES
	(
		GETUTCDATE(),
		@LogLevel,
		@Source,
		@Message,
		@UserName,
		@ServerAddress,
		@ServerHostname,
		@ClientAddress,
		@ClientHostname,
		@SerialNumber
	)

	SELECT CAST(SCOPE_IDENTITY() AS BIGINT)

END



GO
/****** Object:  StoredProcedure [dbo].[PSP_InfLookupById_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_InfLookupById_Get]
(
	@LookupTableName VARCHAR(50),
	@Id BIGINT,
	@ValueColumnName VARCHAR(50)
)
WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	-- get the name of the ID key column
	-- while at the same time verifying that the specified combination of lookup table and value column name is valid
	-- this effectively protects the dynamic SQL below from sql injection
	DECLARE @IdColumnName VARCHAR(50)
	SELECT @IdColumnName = col.name
	FROM sys.indexes ix
	JOIN sys.index_columns ixc
		ON ixc.object_id = ix.object_id
		AND ixc.index_id = ix.index_id
	JOIN sys.columns col
		ON col.object_id = ixc.object_id
		AND col.column_id = ixc.column_id
	WHERE OBJECT_NAME(ix.object_id) = @LookupTableName
	AND ix.is_primary_key = 1
	AND ixc.index_column_id = 1
	AND EXISTS
	(
		SELECT *
		FROM sys.columns
		WHERE OBJECT_NAME(object_id) = @LookupTableName
		AND name = @ValueColumnName
	)

	IF LEN(@IdColumnName) > 0
	BEGIN

		DECLARE @DynamicSql NVARCHAR(MAX) =
			'SELECT ' + @ValueColumnName +
			' FROM ' + @LookupTableName +
			' WHERE ' + @IdColumnName + ' = @Id'

		DECLARE @DynamicParams NVARCHAR(MAX) =
			'@Id BIGINT'

		EXEC dbo.sp_executesql
			@DynamicSql,
			@DynamicParams,
			@Id = @Id

	END


END

GO
/****** Object:  StoredProcedure [dbo].[PSP_InfLookupList_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_InfLookupList_Get]
(
    @TableName SYSNAME,
	@IdColumnName SYSNAME,
	@DisplayColumnName SYSNAME
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

	IF EXISTS
	(
		SELECT *
		FROM sys.tables tbl
		JOIN sys.columns id_col ON id_col.object_id = tbl.object_id
		JOIN sys.columns disp_col ON disp_col.object_id = tbl.object_id
		WHERE tbl.name = @TableName
		AND id_col.name = @IdColumnName
		AND disp_col.name = @DisplayColumnName
	)
	BEGIN

		DECLARE @DynSql NVARCHAR(500) =
			'SELECT ' + @IdColumnName + ', '  + @DisplayColumnName +
			' FROM ' + @TableName +
			' ORDER BY ' + @DisplayColumnName

		EXEC dbo.sp_executesql @DynSql

	END

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_InfReverseLookup_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_InfReverseLookup_Get]
(
	@LookupTableName VARCHAR(50),
	@LookupColumnName VARCHAR(50),
	@LookupValue VARCHAR(50)
)
WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	-- get the name of the ID key column
	-- while at the same time verifying that the specified combination of lookup table and column names is valid
	-- this effectively protects the dynamic SQL below from sql injection
	DECLARE @IdColumnName VARCHAR(50)
	SELECT @IdColumnName = col.name
	FROM sys.indexes ix
	JOIN sys.index_columns ixc
		ON ixc.object_id = ix.object_id
		AND ixc.index_id = ix.index_id
	JOIN sys.columns col
		ON col.object_id = ixc.object_id
		AND col.column_id = ixc.column_id
	WHERE OBJECT_NAME(ix.object_id) = @LookupTableName
	AND ix.is_primary_key = 1
	AND ixc.index_column_id = 1
	AND EXISTS
	(
		SELECT *
		FROM sys.columns
		WHERE OBJECT_NAME(object_id) = @LookupTableName
		AND name = @LookupColumnName
	)

	IF LEN(@IdColumnName) > 0
	BEGIN

		DECLARE @DynamicSql NVARCHAR(MAX) =
			'SELECT ' + @IdColumnName +
			' FROM ' + @LookupTableName +
			' WHERE ' + @LookupColumnName + ' = @LookupValue'

		DECLARE @DynamicParams NVARCHAR(MAX) =
			'@LookupValue VARCHAR(50)'

		EXEC dbo.sp_executesql
			@DynamicSql,
			@DynamicParams,
			@LookupValue = @LookupValue

	END


END

GO
/****** Object:  StoredProcedure [dbo].[PSP_LicenseeType_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_LicenseeType_Get]
(
    @LicenseeTypeId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        LicenseeTypeId,
		LicenseeTypeName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.LicenseeType

    WHERE
        LicenseeTypeId = @LicenseeTypeId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_LicenseeType_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_LicenseeType_Save]
(
    @LicenseeTypeId BIGINT,
	@LicenseeTypeName VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.LicenseeType
    SET
        LicenseeTypeName = @LicenseeTypeName,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        LicenseeTypeId = @LicenseeTypeId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.LicenseeType
        (
            LicenseeTypeName,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @LicenseeTypeName,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @LicenseeTypeId = SCOPE_IDENTITY()

    END

    SELECT @LicenseeTypeId AS LicenseeTypeId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_LicenseeTypes_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_LicenseeTypes_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        LicenseeTypeId,
		LicenseeTypeName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.LicenseeType
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MajorFormat_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MajorFormat_Get]
(
    @MajorFormatId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MajorFormatId,
		MajorFormatName,
		MajorFormatCode,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MajorFormat

    WHERE
        MajorFormatId = @MajorFormatId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MajorFormat_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MajorFormat_Save]
(
    @MajorFormatId BIGINT,
	@MajorFormatName VARCHAR(50),
	@MajorFormatCode VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.MajorFormat
    SET
        MajorFormatName = @MajorFormatName,
		MajorFormatCode = @MajorFormatCode,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        MajorFormatId = @MajorFormatId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.MajorFormat
        (
            MajorFormatName,
			MajorFormatCode,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @MajorFormatName,
			@MajorFormatCode,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @MajorFormatId = SCOPE_IDENTITY()

    END

    SELECT @MajorFormatId AS MajorFormatId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MajorFormats_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_MajorFormats_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MajorFormatId,
		MajorFormatName,
		MajorFormatCode,
		CASE
			WHEN DisabledDate IS NULL
			THEN 'Yes'
			ELSE 'No'
		END AS EnabledInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MajorFormat
    
END


GO
/****** Object:  StoredProcedure [dbo].[PSP_MajorFormatValidateCodeIsUnique_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MajorFormatValidateCodeIsUnique_Get]
(
	@MajorFormatId BIGINT,
    @MajorFormatCode VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT *
			FROM dbo.MajorFormat
			WHERE MajorFormatCode = @MajorFormatCode
			AND (MajorFormatId <> @MajorFormatId OR @MajorFormatId IS NULL)
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_MajorFormatValidateNameIsUnique_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MajorFormatValidateNameIsUnique_Get]
(
	@MajorFormatId BIGINT,
    @MajorFormatName VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT *
			FROM dbo.MajorFormat
			WHERE MajorFormatName = @MajorFormatName
			AND (MajorFormatId <> @MajorFormatId OR @MajorFormatId IS NULL)
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_MemberStatus_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MemberStatus_Get]
(
    @MemberStatusId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MemberStatusId,
		MemberStatusName,
		NPRMembershipInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MemberStatus

    WHERE
        MemberStatusId = @MemberStatusId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MemberStatus_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MemberStatus_Save]
(
    @MemberStatusId BIGINT,
	@MemberStatusName VARCHAR(50),
	@NPRMembershipInd CHAR(1),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.MemberStatus
    SET
        MemberStatusName = @MemberStatusName,
		NPRMembershipInd = @NPRMembershipInd,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        MemberStatusId = @MemberStatusId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.MemberStatus
        (
            MemberStatusName,
			NPRMembershipInd,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @MemberStatusName,
			@NPRMembershipInd,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @MemberStatusId = SCOPE_IDENTITY()

    END

    SELECT @MemberStatusId AS MemberStatusId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MemberStatusEnabled_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[PSP_MemberStatusEnabled_Get]
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

    SELECT
        
		MemberStatusName
	FROM
        dbo.MemberStatus

    WHERE
        NPRMembershipInd='Y'

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_MemberStatuses_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MemberStatuses_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MemberStatusId,
		MemberStatusName,
		NPRMembershipInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MemberStatus
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MetroMarket_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MetroMarket_Get]
(
    @MetroMarketId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MetroMarketId,
		MarketName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MetroMarket

    WHERE
        MetroMarketId = @MetroMarketId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MetroMarket_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MetroMarket_Save]
(
    @MetroMarketId BIGINT,
	@MarketName VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.MetroMarket
    SET
        MarketName = @MarketName,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        MetroMarketId = @MetroMarketId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.MetroMarket
        (
            MarketName,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @MarketName,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @MetroMarketId = SCOPE_IDENTITY()

    END

    SELECT @MetroMarketId AS MetroMarketId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MetroMarket_Update]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PSP_MetroMarket_Update]
(
    @CallLetters VARCHAR(100),
	@Band VARCHAR(10),
	@MetroMarket VARCHAR(50),
	@MetroMarketRank INT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

        UPDATE s
    SET        
		MetroMarketId = (SELECT MetroMarketId FROM MetroMarket WHERE MarketName = @MetroMarket),
		MetroMarketRank = @MetroMarketRank,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
		
		FROM dbo.Station s
		JOIN dbo.Band b on b.BandId = s.BandId		

    WHERE
        CallLetters = @CallLetters AND b.BandName = @Band

    SELECT @@ROWCOUNT

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MetroMarkets_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MetroMarkets_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MetroMarketId,
		MarketName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MetroMarket
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MinorityStatus_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MinorityStatus_Get]
(
    @MinorityStatusId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MinorityStatusId,
		MinorityStatusName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MinorityStatus

    WHERE
        MinorityStatusId = @MinorityStatusId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MinorityStatus_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MinorityStatus_Save]
(
    @MinorityStatusId BIGINT,
	@MinorityStatusName VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.MinorityStatus
    SET
        MinorityStatusName = @MinorityStatusName,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        MinorityStatusId = @MinorityStatusId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.MinorityStatus
        (
            MinorityStatusName,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @MinorityStatusName,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @MinorityStatusId = SCOPE_IDENTITY()

    END

    SELECT @MinorityStatusId AS MinorityStatusId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MinorityStatuses_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_MinorityStatuses_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MinorityStatusId,
		MinorityStatusName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MinorityStatus
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_MonthsList_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_MonthsList_Get]
AS BEGIN

	SET NOCOUNT ON

	;WITH Months AS
	(
		SELECT 1 AS MonthNumber
		UNION ALL
		SELECT MonthNumber + 1
		FROM Months
		WHERE MonthNumber < 12
	)
	SELECT
		MonthNumber,
		DATENAME(MONTH, DATEADD(MONTH, MonthNumber - 1, '1900-1-1')) AS MonthName,
		LEFT(DATENAME(MONTH, DATEADD(MONTH, MonthNumber - 1, '1900-1-1')), 3) AS MonthAbbreviation
	FROM
		Months

END
GO
/****** Object:  StoredProcedure [dbo].[PSP_Producer_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Producer_Get]
(
    @ProducerId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProducerId,
		SalutationId,
		FirstName,
		MiddleName,
		LastName,
		Suffix,
		[Role],
		Email,
		Phone,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Producer

    WHERE
        ProducerId = @ProducerId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Producer_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Producer_Save]
(
    @ProducerId BIGINT,
	@SalutationId BIGINT,
	@FirstName VARCHAR(50),
	@MiddleName VARCHAR(50),
	@LastName VARCHAR(50),
	@Suffix VARCHAR(50),
	@Role VARCHAR(50),
	@Email VARCHAR(100),
	@Phone VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Producer
    SET
        SalutationId = @SalutationId,
		FirstName = @FirstName,
		MiddleName = @MiddleName,
		LastName = @LastName,
		Suffix = @Suffix,
		[Role] = @Role,
		Email = @Email,
		Phone = @Phone,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ProducerId = @ProducerId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Producer
        (
            SalutationId,
			FirstName,
			MiddleName,
			LastName,
			Suffix,
			[Role],
			Email,
			Phone,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @SalutationId,
			@FirstName,
			@MiddleName,
			@LastName,
			@Suffix,
			@Role,
			@Email,
			@Phone,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @ProducerId = SCOPE_IDENTITY()

    END

    SELECT @ProducerId AS ProducerId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Producers_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Producers_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProducerId,
		SalutationId,
		FirstName,
		MiddleName,
		LastName,
		(FirstName + ' ' + LastName) As FullName,
		Suffix,
		[Role],
		Email,
		Phone,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Producer
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProducersList_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ProducersList_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProducerId,
		FirstName + ' ' + LastName AS ProducerDisplayName

    FROM
        dbo.Producer
    
END


GO
/****** Object:  StoredProcedure [dbo].[PSP_Program_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Program_Get]
(
    @ProgramId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramId,
		ProgramName,
		ProgramSourceId,
		ProgramFormatTypeId,
		ProgramCode,
		CarriageTypeId,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Program

    WHERE
        ProgramId = @ProgramId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Program_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Program_Save]
(
    @ProgramId BIGINT,
	@ProgramName VARCHAR(100),
	@ProgramSourceId BIGINT,
	@ProgramFormatTypeId BIGINT,
	@ProgramCode VARCHAR(50),
	@CarriageTypeId BIGINT,
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Program
    SET
        ProgramName = @ProgramName,
		ProgramSourceId = @ProgramSourceId,
		ProgramFormatTypeId = @ProgramFormatTypeId,
		ProgramCode = @ProgramCode,
		CarriageTypeId = @CarriageTypeId,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ProgramId = @ProgramId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Program
        (
            ProgramName,
			ProgramSourceId,
			ProgramFormatTypeId,
			ProgramCode,
			CarriageTypeId,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @ProgramName,
			@ProgramSourceId,
			@ProgramFormatTypeId,
			@ProgramCode,
			@CarriageTypeId,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @ProgramId = SCOPE_IDENTITY()

    END

    SELECT @ProgramId AS ProgramId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramEnabledList_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ProgramEnabledList_Get]

AS BEGIN

    SET NOCOUNT ON

    SELECT
        
		ProgramName
		
    FROM
        dbo.Program

    WHERE
	
        DisabledDate is null

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramFormatType_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ProgramFormatType_Get]
(
    @ProgramFormatTypeId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramFormatTypeId,
		ProgramFormatTypeName,
		ProgramFormatTypeCode,
		MajorFormatId,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.ProgramFormatType

    WHERE
        ProgramFormatTypeId = @ProgramFormatTypeId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramFormatType_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ProgramFormatType_Save]
(
    @ProgramFormatTypeId BIGINT,
	@ProgramFormatTypeName VARCHAR(50),
	@ProgramFormatTypeCode VARCHAR(50),
	@MajorFormatId BIGINT,
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.ProgramFormatType
    SET
        ProgramFormatTypeName = @ProgramFormatTypeName,
		ProgramFormatTypeCode = @ProgramFormatTypeCode,
		MajorFormatId = @MajorFormatId,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ProgramFormatTypeId = @ProgramFormatTypeId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.ProgramFormatType
        (
            ProgramFormatTypeName,
			ProgramFormatTypeCode,
			MajorFormatId,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @ProgramFormatTypeName,
			@ProgramFormatTypeCode,
			@MajorFormatId,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @ProgramFormatTypeId = SCOPE_IDENTITY()

    END

    SELECT @ProgramFormatTypeId AS ProgramFormatTypeId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramFormatTypes_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ProgramFormatTypes_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramFormatTypeId,
		ProgramFormatTypeName,
		ProgramFormatTypeCode,
		MajorFormatId,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.ProgramFormatType
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramLineUpReport_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ProgramLineUpReport_Get]
(
	@ProgramId BIGINT,
	@MonthSpan VARCHAR(50),
	@Year INT,
	@BandSpan VARCHAR(200),
	@DeletedInd CHAR(1),
	@MemberStatusId BIGINT,
	@DebugInd CHAR(1)
)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	/** Creating the dynamic sql and executing VIA EXEC instead of dbo.sp_executesql because IN clause is being used for months and bands. **/
	/** No threat of sql injection because input is being strictly controlled via controller **/

	DECLARE @Month1 INT,
				 @Month2 INT,
				 @Month3 INT

	SELECT 
			@Month1 = 
			CASE @MonthSpan 
					WHEN '1, 2, 3' THEN 1
					WHEN '4, 5, 6' THEN 4
					WHEN '7, 8, 9' THEN 7
					WHEN '10, 11, 12' THEN 8
			END,
			@Month2 = 
			CASE @MonthSpan 
					WHEN '1, 2, 3' THEN 2
					WHEN '4, 5, 6' THEN 5
					WHEN '7, 8, 9' THEN 8
					WHEN '10, 11, 12' THEN 11 
			END,
			@Month3 = 
			CASE @MonthSpan 
					WHEN '1, 2, 3' THEN 3
					WHEN '4, 5, 6' THEN 6
					WHEN '7, 8, 9' THEN 9
					WHEN '10, 11, 12' THEN 12
			END

	DECLARE @MonthOne TABLE 
	(
		/*TableId INT IDENTITY,*/
		ScheduleProgramId BIGINT,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		ProgramName VARCHAR(100),
		StationId BIGINT,
		Station VARCHAR(50),
		[Month] INT,
		[Year] INT,
		StartTime TIME,
		EndTime TIME,
		QuarterHours FLOAT,
		DaysOfWeek VARCHAR(100),
		SundayInd CHAR(1),
		MondayInd CHAR(1),
		TuesdayInd CHAR(1),
		WednesdayInd CHAR(1),
		ThursdayInd CHAR(1),
		FridayInd CHAR(1),
		SaturdayInd CHAR(1),
		MemberStatusId BIGINT,
		MemberStatusName VARCHAR(50)
	)

	DECLARE @MonthTwo TABLE 
	(
		/*TableId INT IDENTITY,*/
		ScheduleProgramId BIGINT,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		ProgramName VARCHAR(100),
		StationId BIGINT,
		Station VARCHAR(50),
		[Month] INT,
		[Year] INT,
		StartTime TIME,
		EndTime TIME,
		QuarterHours FLOAT,
		DaysOfWeek VARCHAR(100),
		SundayInd CHAR(1),
		MondayInd CHAR(1),
		TuesdayInd CHAR(1),
		WednesdayInd CHAR(1),
		ThursdayInd CHAR(1),
		FridayInd CHAR(1),
		SaturdayInd CHAR(1),
		MemberStatusId BIGINT,
		MemberStatusName VARCHAR(50)
	)

	DECLARE @MonthThree TABLE 
	(
		/*TableId INT IDENTITY,*/
		ScheduleProgramId BIGINT,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		ProgramName VARCHAR(100),
		StationId BIGINT,
		Station VARCHAR(50),
		[Month] INT,
		[Year] INT,
		StartTime TIME,
		EndTime TIME,
		QuarterHours FLOAT,
		DaysOfWeek VARCHAR(100),
		SundayInd CHAR(1),
		MondayInd CHAR(1),
		TuesdayInd CHAR(1),
		WednesdayInd CHAR(1),
		ThursdayInd CHAR(1),
		FridayInd CHAR(1),
		SaturdayInd CHAR(1),
		MemberStatusId BIGINT,
		MemberStatusName VARCHAR(50)
	)

	DECLARE @DynSql NVARCHAR(MAX) =
	'
	SELECT 
		sp.ScheduleProgramId, 
		sch.ScheduleId,
		p.ProgramId,
		p.ProgramName,
		sta.StationId,
		sta.CallLetters + ''-'' + b.BandName As Station,
		sch.[Month],
		sch.[Year],
		StartTime,
		EndTime,
		QuarterHours,
		CASE WHEN SundayInd = ''Y'' THEN ''Sun '' ELSE '''' END +
		CASE WHEN MondayInd = ''Y'' THEN ''Mon '' ELSE '''' END +
		CASE WHEN TuesdayInd = ''Y'' THEN ''Tue '' ELSE '''' END +
		CASE WHEN WednesdayInd = ''Y'' THEN ''Wed '' ELSE '''' END +
		CASE WHEN ThursdayInd = ''Y'' THEN ''Thu '' ELSE '''' END +
		CASE WHEN FridayInd = ''Y'' THEN ''Fri '' ELSE '''' END +
		CASE WHEN SaturdayInd = ''Y'' THEN ''Sat '' ELSE '''' END		
		As DaysOfWeek,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		ms.MemberStatusId,
		MemberStatusName
	FROM
		dbo.Program p INNER JOIN
		dbo.ScheduleProgram sp ON p.ProgramId = sp.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId INNER JOIN
		dbo.Station sta ON sch.StationId = sta.StationId INNER JOIN
		dbo.Band b ON sta.BandId = b.BandId INNER JOIN
		dbo.MemberStatus ms ON sta.MemberStatusId = ms.MemberStatusId
	WHERE
		p.ProgramId = ' + CONVERT(VARCHAR, @ProgramId) + ' ' +
		'AND (sch.[Month] IN (' + @MonthSpan + ') AND sch.[Year] = ' + CONVERT(VARCHAR, @Year) + ')' +
		'AND b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'

	IF @DeletedInd = 'N'
		SET @DynSql = @DynSql + ' AND sta.DisabledUserId IS NULL'
	
	IF @DeletedInd = 'Y'
		SET @DynSql = @DynSql + ' AND sta.DisabledUserId IS NOT NULL'

	IF @MemberStatusId IS NOT NULL
		SET @DynSql = @DynSql + ' AND ms.MemberStatusId = ' + CONVERT(VARCHAR, @MemberStatusId)

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
	BEGIN
		INSERT INTO @MonthOne
		EXEC dbo.sp_executesql @DynSql 

		Delete FROM @MonthOne WHERE Month <> @Month1;

		INSERT INTO @MonthTwo
		EXEC dbo.sp_executesql @DynSql 

		Delete FROM @MonthTwo WHERE Month <> @Month2;

		INSERT INTO @MonthThree
		EXEC dbo.sp_executesql @DynSql 

		Delete FROM @MonthThree WHERE Month <> @Month3
	END
	/** 33.3.1.4 **/
	SELECT
		Station, /*StartTime, EndTime,*/
		CASE DaysOfWeek
			WHEN 'Sun Mon Tue Wed Thu Fri Sat ' THEN 'Sun - Sat'
			WHEN 'Mon Tue Wed Thu Fri ' THEN 'Mon - Fri'
			ELSE RTRIM(DaysOfWeek)
		END + CONVERT(VARCHAR(15), StartTime, 100) + CONVERT(VARCHAR(15), EndTime, 100) As AirInfo
	FROM 
		@MonthThree
	
	UNION
	/** 33.3.1.5 **/
	SELECT
		m1.Station, /*m1.StartTime, m1.EndTime, */
		CASE m1.DaysOfWeek
			WHEN 'Sun Mon Tue Wed Thu Fri Sat ' THEN 'Sun - Sat'
			WHEN 'Mon Tue Wed Thu Fri ' THEN 'Mon - Fri'
			ELSE RTRIM(m1.DaysOfWeek)
		END + CONVERT(VARCHAR(15), m1.StartTime, 100) + CONVERT(VARCHAR(15), m1.EndTime, 100) As AirInfo
	FROM 
		@MonthOne m1,
		@MonthTwo m2
	WHERE
		m1.StationId = m2.StationId AND
		m1.StartTime = m2.StartTime AND 
		m1.EndTime = m2.EndTime AND 
		m1.DaysOfWeek = m2.DaysOfWeek
	ORDER BY 1, 2
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramMulticast_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[PSP_ProgramMulticast_Get]

WITH EXECUTE AS OWNER

AS BEGIN

    SET NOCOUNT ON

 SELECT DISTINCT 
 p.ProgramName from dbo.ScheduleNewscast AS snc
INNER JOIN dbo.ScheduleProgram AS sp ON sp.ScheduleId = snc.ScheduleId
INNER JOIN dbo.Program AS p ON p.ProgramId = sp.ProgramId
WHERE p.ProgramName NOT LIKE '%Off Air%'

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramProducer_DELETE]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ProgramProducer_DELETE]
(
	@ProgramProducerId BIGINT	
)
AS BEGIN

    SET NOCOUNT ON

	DELETE FROM dbo.ProgramProducer
	WHERE
	ProgramProducerId = @ProgramProducerId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramProducer_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ProgramProducer_Save]
(
	@ProgramId BIGINT,
	@ProducerId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    INSERT INTO dbo.ProgramProducer
    (
        ProgramId,
		ProducerId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
    )
    SELECT
        @ProgramId,
		@ProducerId,
		GETUTCDATE(),
		@LastUpdatedUserId,
		GETUTCDATE(),
		@LastUpdatedUserId
	WHERE
		NOT EXISTS
		(
			SELECT *
			FROM dbo.ProgramProducer
			WHERE ProgramId = @ProgramId
			AND ProducerId = @ProducerId
		)

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramProducersByProducerId_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ProgramProducersByProducerId_Get]
(
    @ProducerId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramProducerId,
		ProgramId,
		ProducerId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.ProgramProducer

    WHERE
        ProducerId = @ProducerId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramProducersByProgramId_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_ProgramProducersByProgramId_Get]
(
    @ProgramId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        pp.ProgramProducerId,
		pp.ProgramId,
		pp.ProducerId,
		p.FirstName + ' ' + p.LastName AS ProducerDisplayName,
		p.Role,
		pp.CreatedDate,
		pp.CreatedUserId,
		pp.LastUpdatedDate,
		pp.LastUpdatedUserId

    FROM
        dbo.ProgramProducer pp

		JOIN dbo.Producer p
			ON p.ProducerId = pp.ProducerId

    WHERE
        pp.ProgramId = @ProgramId

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramProducerSearch_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ProgramProducerSearch_Get]
(
	@ProgramId BIGINT,
	@ProducerId BIGINT,
	@DebugInd CHAR(1)
)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
		DECLARE @tempOne TABLE (
			ColumnName VARCHAR(20),
			ProgramProducerId BIGINT,
			ProgramId BIGINT,
			ProducerId BIGINT
		)
		
		DECLARE @tempTwo TABLE (
			ColumnName VARCHAR(20),
			ProgramProducerId BIGINT,
			ProgramId BIGINT,
			ProducerId BIGINT
		)
		
		DECLARE @tempThree TABLE (
			ColumnName VARCHAR(20),
			ProgramProducerId BIGINT,
			ProgramId BIGINT,
			ProducerId BIGINT
		)
		
		DECLARE @temp TABLE (
			ColumnName VARCHAR(20),
			ProgramProducerId BIGINT,
			ProgramId BIGINT,
			ProducerId BIGINT
		)
		
		INSERT INTO @tempOne 
		SELECT ''ProgramOne'' As ''Col'', ProgramProducerId, ProgramId,  ProducerId FROM dbo.ProgramProducer pp WHERE 
			ProgramId IN (
			SELECT TOP 1 ProgramId FROM dbo.ProgramProducer pp1 WHERE pp.ProducerId = pp1.ProducerId ' 
		
		IF @ProgramId IS NOT NULL
			SET @DynSql = @DynSql + ' AND pp1.ProgramId = ' + CONVERT(VARCHAR, @ProgramId)

		SET @DynSql = @DynSql + 
		' ORDER BY LastUpdatedDate Desc)
		
		INSERT INTO @tempTwo 
		SELECT ''ProgramTwo'' As ''Col'', ProgramProducerId, ProgramId,  ProducerId FROM dbo.ProgramProducer pp WHERE 
			ProgramId IN (
			SELECT TOP 1 ProgramId FROM dbo.ProgramProducer pp2 WHERE pp.ProducerId = pp2.ProducerId 
			AND ProgramProducerId NOT IN (SELECT ProgramProducerId FROM @tempOne UNION SELECT ProgramProducerId FROM @tempThree) ORDER BY LastUpdatedDate Desc
		 )
		
		INSERT INTO @tempThree
		SELECT ''ProgramThree'' As ''Col'', ProgramProducerId, ProgramId,  ProducerId FROM dbo.ProgramProducer pp WHERE 
			ProgramId IN (
			SELECT TOP 1 ProgramId FROM dbo.ProgramProducer pp3 WHERE pp.ProducerId = pp3.ProducerId
			AND ProgramProducerId NOT IN (SELECT ProgramProducerId FROM @tempOne UNION SELECT ProgramProducerId FROM @tempTwo) ORDER BY LastUpdatedDate Desc
		)
		
		INSERT INTO @temp
		select * from @tempOne
		UNION ALL
		select * from @tempTwo
		UNION ALL
		select * from @tempThree
		
		SELECT
			pr.ProducerId,
			pr.FirstName + ISNULL('' '' + pr.MiddleName + '' '', '' '') + pr.LastName + ISNULL('' '' + pr.Suffix, '''') As ProducerName,
			pr.[Role],
			pr.Email,
			pr.Phone,
			pp.ProgramOneId,
			p1.ProgramName As ProgramNameOne,
			pp.ProgramTwoId,
			p2.ProgramName As ProgramNameTwo,
			pp.ProgramThreeId,
			p3.ProgramName As ProgramNameThree
		FROM
			dbo.Producer pr LEFT JOIN
			(select ProducerId,
				MAX(CASE WHEN ColumnName = ''ProgramOne'' THEN ProgramId ELSE null END) As ProgramOneId,
				MAX(CASE WHEN ColumnName = ''ProgramTwo'' THEN ProgramId ELSE null END) As ProgramTwoId,
				MAX(CASE WHEN ColumnName = ''ProgramThree'' THEN ProgramId ELSE null END) As ProgramThreeId
			FROM @temp
			Group by ProducerId) pp ON pr.ProducerId = pp.ProducerId LEFT JOIN
			dbo.Program p1 ON pp.ProgramOneId = p1.ProgramId LEFT JOIN
			dbo.Program p2 ON pp.ProgramTwoId = p2.ProgramId LEFT JOIN
			dbo.Program p3 ON pp.ProgramThreeId = p3.ProgramId
		
		WHERE 1 = 1'

	IF @ProducerId IS NOT NULL
		SET @DynSql = @DynSql + ' AND pr.ProducerId = ' + CONVERT(VARCHAR, @ProducerId)

	IF @ProgramId IS NOT NULL
		SET @DynSql = @DynSql + ' AND ISNULL(pp.ProgramOneId, 0) = ' + CONVERT(VARCHAR, @ProgramId)

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
	BEGIN
		EXEC dbo.sp_executesql @DynSql 
	END
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramRegular_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[PSP_ProgramRegular_Get]

WITH EXECUTE AS OWNER

AS BEGIN

SET NOCOUNT ON
SELECT DISTINCT 
p.ProgramName from dbo.ScheduleProgram AS sp
INNER JOIN dbo.Program AS p ON p.ProgramId = sp.ProgramId
LEFT JOIN dbo.ScheduleNewscast AS sn ON sn.ScheduleId = sp.ScheduleId
WHERE p.ProgramName NOT LIKE '%Off Air%' AND sn.ScheduleNewscastId IS NULL

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramRegularMulticast_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[PSP_ProgramRegularMulticast_Get]

WITH EXECUTE AS OWNER

AS BEGIN

    SET NOCOUNT ON

    SELECT
        
		ProgramName
	FROM
        dbo.Program

    WHERE
        ProgramName not like '%Off Air%' 

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_Programs_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Programs_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramId,
		ProgramName,
		ProgramSourceId,
		ProgramFormatTypeId,
		ProgramCode,
		CarriageTypeId,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Program
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramsByName_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ProgramsByName_Get]
(
	@ProgramName VARCHAR(100),
	@StartsWithInd CHAR(1)
)
AS BEGIN

    SET NOCOUNT ON

	SET @ProgramName =
		CASE @StartsWithInd
		WHEN 'Y' THEN @ProgramName + '%'
		ELSE '%' + @ProgramName + '%'
		END

    SELECT
        ProgramId,
		ProgramName,
		ProgramSourceId,
		ProgramFormatTypeId,
		ProgramCode,
		CarriageTypeId,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Program

	WHERE
		ProgramName LIKE @ProgramName
    
END


GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramScheduleByMonth_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ProgramScheduleByMonth_Get]
(
	@StationId BIGINT,
	@Year INT,
	@Month INT
)
AS BEGIN

	SET NOCOUNT ON

	SELECT
		schP.ScheduleProgramId,
		schP.ProgramId,
		p.ProgramName,
		sch.Year,
		sch.Month,
		CASE 
			WHEN schP.SundayInd = 'Y' THEN 'Sunday'
			WHEN schP.MondayInd = 'Y' THEN 'Monday'
			WHEN schP.TuesdayInd = 'Y' THEN 'Tuesday'
			WHEN schP.WednesdayInd = 'Y' THEN 'Wednesday'
			WHEN schP.ThursdayInd = 'Y' THEN 'Thursday'
			WHEN schP.FridayInd = 'Y' THEN 'Friday'
			WHEN schP.SaturdayInd = 'Y' THEN 'Saturday'
		END As [DayOfWeek],
		schP.StartTime,
		schP.EndTime
	FROM
		dbo.ScheduleProgram schP INNER JOIN 
		dbo.Program p ON p.ProgramId = schP.ProgramId INNER JOIN
		dbo.Schedule sch ON schP.ScheduleId = sch.ScheduleId
	WHERE
		sch.StationId = @StationId AND
		sch.[Year] = @Year AND 
		sch.[Month] = @Month
	ORDER BY
		sch.[Year],
		sch.[Month],
		schP.StartTime
END
GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramSearch_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ProgramSearch_Get]
(
	@ProgramName VARCHAR(250),
	@SearchType VARCHAR(50) = 'Wildcard' -- options are 'Wildcard' and 'StartsWith'
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

	IF @SearchType = 'StartsWith'
		BEGIN
			IF rtrim(ltrim(@ProgramName)) = '*'
				BEGIN
					SELECT TOP 100 ProgramId, ProgramName
					FROM dbo.Program
					ORDER BY ProgramName			
				END
			ELSE
				BEGIN
					SELECT TOP 100 ProgramId, ProgramName
					FROM dbo.Program
					WHERE ProgramName LIKE (rtrim(ltrim(@ProgramName)) + '%')
					ORDER BY ProgramName
				END
		END
	ELSE
		BEGIN
			SELECT TOP 100 ProgramId, ProgramName
			FROM dbo.Program
			WHERE ProgramName LIKE ('%' + rtrim(ltrim(@ProgramName)) + '%')
			ORDER BY ProgramName
		END
	
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramSource_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ProgramSource_Get]
(
    @ProgramSourceId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramSourceId,
		ProgramSourceName,
		ProgramSourceCode,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.ProgramSource

    WHERE
        ProgramSourceId = @ProgramSourceId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramSource_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ProgramSource_Save]
(
    @ProgramSourceId BIGINT,
	@ProgramSourceName VARCHAR(50),
	@ProgramSourceCode VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.ProgramSource
    SET
        ProgramSourceName = @ProgramSourceName,
		ProgramSourceCode = @ProgramSourceCode,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ProgramSourceId = @ProgramSourceId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.ProgramSource
        (
            ProgramSourceName,
			ProgramSourceCode,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @ProgramSourceName,
			@ProgramSourceCode,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @ProgramSourceId = SCOPE_IDENTITY()

    END

    SELECT @ProgramSourceId AS ProgramSourceId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramSources_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ProgramSources_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramSourceId,
		ProgramSourceName,
		ProgramSourceCode,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.ProgramSource
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ProgramsSearch_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ProgramsSearch_Get]
(
	@ProgramId BIGINT,
	@ProgramSourceId BIGINT,
	@ProgramFormatTypeId BIGINT,
	@MajorFormatId BIGINT,
	@Enabled VARCHAR(50),
	@DebugInd CHAR(1) = 'N'
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
    SELECT
        p.ProgramId,
		p.ProgramName,
		p.ProgramSourceId,
		ps.ProgramSourceName,
		p.ProgramFormatTypeId,
		pft.ProgramFormatTypeName,
		mf.MajorFormatName,
		p.ProgramCode,
		CASE
			WHEN p.DisabledDate IS NULL
			THEN ''Yes''
			ELSE ''No''
		END AS Enabled

    FROM
        dbo.Program p

		JOIN dbo.ProgramSource ps
			ON ps.ProgramSourceId = p.ProgramSourceId

		JOIN dbo.ProgramFormatType pft
			ON pft.ProgramFormatTypeId = p.ProgramFormatTypeId

		JOIN dbo.MajorFormat mf
			ON mf.MajorFormatId = pft.MajorFormatId

	WHERE 1=1
	'

	IF @ProgramId IS NOT NULL
		SET @DynSql = @DynSql + ' AND p.ProgramId = @ProgramId'

	IF @ProgramSourceId IS NOT NULL
		SET @DynSql = @DynSql + ' AND p.ProgramSourceId = @ProgramSourceId'

	IF @ProgramFormatTypeId IS NOT NULL
		SET @DynSql = @DynSql + ' AND p.ProgramFormatTypeId = @ProgramFormatTypeId'

	IF @MajorFormatId IS NOT NULL
		SET @DynSql = @DynSql + ' AND pft.MajorFormatId = @MajorFormatId'

	IF @Enabled = 'YES'
		SET @DynSql = @DynSql + ' AND p.DisabledDate IS NULL'
	ELSE IF @Enabled = 'NO'
		SET @DynSql = @DynSql + ' AND p.DisabledDate IS NOT NULL'
    
	DECLARE @DynParams NVARCHAR(MAX) =
	'
	@ProgramId BIGINT,
	@ProgramSourceId BIGINT,
	@ProgramFormatTypeId BIGINT,
	@MajorFormatId BIGINT
	'

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		EXEC dbo.sp_executesql
			@DynSql,
			@DynParams,
			@ProgramId = @ProgramId,
			@ProgramSourceId = @ProgramSourceId,
			@ProgramFormatTypeId = @ProgramFormatTypeId,
			@MajorFormatId = @MajorFormatId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_RepeaterStationReport_GET]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_RepeaterStationReport_GET]
(
	@StationEnabled VARCHAR(2),
	@BandSpan VARCHAR(MAX)
)
WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON
DECLARE
		@DynSql NVARCHAR(MAX)=
	'
			SELECT s.CallLetters + ''-'' +b.BandName Station,r.RepeaterStatusName,st.StateName, s.City,s.Frequency,m.MemberStatusName, s.MetroMarketRank, s.DmaMarketRank
			From dbo.Station AS s
			INNER JOIN dbo.Band AS b ON b.BandId=s.BandId
			INNER JOIN dbo.State AS st ON st.StateId=s.StateId
			INNER JOIN dbo.MemberStatus AS m ON m.MemberStatusId=s.MemberStatusId
			INNER JOIN dbo.RepeaterStatus AS r ON r.RepeaterStatusId=s.RepeaterStatusId
			WHERE 
			b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'
			IF(@StationEnabled='Y')
				BEGIN
					SET @DynSql= @DynSql + ' AND s.DisabledDate IS NULL'
				END
			ELSE IF (@StationEnabled='N')
				BEGIN
					SET @DynSql= @DynSql + ' AND s.DisabledDate IS NOT NULL'
				END
				
				
			SET @DynSql=@DynSql + ' Order By Station,st.StateNAme , s.City'	

		EXEC(@DynSql)
		
	END

GO
/****** Object:  StoredProcedure [dbo].[PSP_RepeaterStatus_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_RepeaterStatus_Get]
(
    @RepeaterStatusId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        RepeaterStatusId,
		RepeaterStatusName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.RepeaterStatus

    WHERE
        RepeaterStatusId = @RepeaterStatusId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_RepeaterStatus_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_RepeaterStatus_Save]
(
    @RepeaterStatusId BIGINT,
	@RepeaterStatusName VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.RepeaterStatus
    SET
        RepeaterStatusName = @RepeaterStatusName,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        RepeaterStatusId = @RepeaterStatusId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.RepeaterStatus
        (
            RepeaterStatusName,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @RepeaterStatusName,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @RepeaterStatusId = SCOPE_IDENTITY()

    END

    SELECT @RepeaterStatusId AS RepeaterStatusId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_RepeaterStatuses_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_RepeaterStatuses_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        RepeaterStatusId,
		RepeaterStatusName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.RepeaterStatus
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Salutation_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Salutation_Get]
(
    @SalutationId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        SalutationId,
		SalutationName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Salutation

    WHERE
        SalutationId = @SalutationId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Salutation_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Salutation_Save]
(
    @SalutationId BIGINT,
	@SalutationName VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Salutation
    SET
        SalutationName = @SalutationName,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        SalutationId = @SalutationId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Salutation
        (
            SalutationName,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @SalutationName,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @SalutationId = SCOPE_IDENTITY()

    END

    SELECT @SalutationId AS SalutationId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Salutations_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Salutations_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        SalutationId,
		SalutationName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Salutation
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Schedule_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_Schedule_Get]
(
    @ScheduleId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        sch.ScheduleId,
		sch.StationId,
		sta.CallLetters + '-' + b.BandName AS StationDisplayName,
		sch.[Year],
		sch.[Month],
		DATENAME(MONTH, DATEADD(MONTH, sch.[Month] - 1, '1900-1-1')) AS [MonthName],
		CASE 
			WHEN rs.RepeaterStatusName = '100% Repeater' THEN 'Y' 
			WHEN AcceptedDate IS NOT NULL THEN 'Y' 
			ELSE 'N' 
		END As [ReadOnly],		
		sch.SubmittedDate,
		sch.SubmittedUserId,
		sch.AcceptedDate,
		sch.AcceptedUserId,
		sch.CreatedDate,
		sch.CreatedUserId,
		sch.LastUpdatedDate,
		sch.LastUpdatedUserId

    FROM
        dbo.Schedule sch JOIN 
		dbo.Station sta ON sta.StationId = sch.StationId JOIN 
		dbo.Band b ON b.BandId = sta.BandId JOIN 
		dbo.RepeaterStatus rs ON sta.RepeaterStatusId = rs.RepeaterStatusId

    WHERE
        sch.ScheduleId = @ScheduleId

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_Schedule_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Schedule_Save]
(
    @ScheduleId BIGINT,
	@StationId BIGINT,
	@Year INT,
	@Month INT,
	@SubmittedDate DATETIME,
	@SubmittedUserId BIGINT,
	@AcceptedDate DATETIME,
	@AcceptedUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Schedule
    SET
        StationId = @StationId,
		[Year] = @Year,
		[Month] = @Month,
		SubmittedDate = @SubmittedDate,
		SubmittedUserId = @SubmittedUserId,
		AcceptedDate = @AcceptedDate,
		AcceptedUserId = @AcceptedUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ScheduleId = @ScheduleId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Schedule
        (
            StationId,
			[Year],
			[Month],
			SubmittedDate,
			SubmittedUserId,
			AcceptedDate,
			AcceptedUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @StationId,
			@Year,
			@Month,
			@SubmittedDate,
			@SubmittedUserId,
			@AcceptedDate,
			@AcceptedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @ScheduleId = SCOPE_IDENTITY()

    END

    SELECT @ScheduleId AS ScheduleId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ScheduleCalendar_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ScheduleCalendar_Save]
(
    @ScheduleId BIGINT,
	@DNAInd char(1),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	DECLARE @Today DateTime;

	SET @Today = GETUTCDATE();

    UPDATE dbo.Schedule
    SET
		SubmittedUserId = @LastUpdatedUserId,
		SubmittedDate = @Today,
		LastUpdatedDate = @Today,
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ScheduleId = @ScheduleId

/****** Begin logic to update 100% repeater station Schedule submitted information ******/	
	DECLARE @FlagshipStationId BIGINT,
			 @RepeaterScheduleId BIGINT,
			 @FlagShipYear INT,
			 @FlagShipMonth INT,
			 @NumRows INT,
			 @Incr INT
	
	DECLARE @RepeaterStationSchedule TABLE
	(
		TableId INT IDENTITY,
		StationId BIGINT,
		ScheduleId BIGINT,
		[Year] INT,
		[Month] INT
	)
	
	/** Retrieve Flagship values **/
	SELECT 
		@FlagshipStationId = sch.StationId,
		@FlagshipYear = sch.[Year],
		@FlagShipMonth = sch.[Month]
	FROM
		dbo.Schedule sch
	WHERE
		sch.ScheduleId = @ScheduleId
	
	/** Retrieve associated repeater stations **/
	INSERT INTO @RepeaterStationSchedule
	SELECT 
		st.StationId,
		sch.ScheduleId,
		@FlagshipYear,
		@FlagShipMonth
	FROM
		dbo.Station st INNER JOIN
		dbo.RepeaterStatus rs ON st.RepeaterStatusId = rs.RepeaterStatusId LEFT JOIN
		/** Retrieve only records with same month and year from schedule **/
		(SELECT * FROM dbo.Schedule WHERE [Year] = @FlagshipYear AND [Month] = @FlagShipMonth) sch ON st.StationId = sch.StationId
	WHERE
		st.FlagshipStationId = @FlagshipStationId AND 
		rs.RepeaterStatusName = '100% Repeater'
	
	/** Set initial values for repeater stations **/
	SET @Incr = 1;
	SELECT @NumRows = COUNT(*) FROM @RepeaterStationSchedule;
	
	WHILE @Incr <= @NumRows
	BEGIN
		SELECT 
			@RepeaterScheduleId = ScheduleId
		FROM
			@RepeaterStationSchedule
		WHERE 
			TableId = @Incr;

		UPDATE dbo.Schedule
		SET
			SubmittedUserId = @LastUpdatedUserId,
			SubmittedDate = @Today,
			LastUpdatedDate = @Today,
			LastUpdatedUserId = @LastUpdatedUserId
		WHERE
		    ScheduleId = @RepeaterScheduleId

		SET @Incr = @Incr + 1;
	END

	/****** End logic to update 100% repeater station Schedule submitted information ******/	

	IF @DNAInd = 'Y' /** Delete Newscast schedule and associated 100% repeater stations **/
	BEGIN
		/** Delete currently submitted newscast schedule records **/
		DELETE FROM dbo.ScheduleNewscast WHERE ScheduleId = @ScheduleId;

		SET @Incr = 1;

		/** Delete all associated 100% Repeater station newscast schedule records **/
		WHILE @Incr <= @NumRows
		BEGIN
			SELECT
				@RepeaterScheduleId = ScheduleId
			FROM
				@RepeaterStationSchedule
			WHERE
				TableId = @Incr

			DELETE FROM dbo.ScheduleNewscast WHERE ScheduleId = @RepeaterScheduleId;

			SET @Incr = @Incr + 1;
		END
	END
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ScheduleCalendarStatus_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ScheduleCalendarStatus_Save]
(
    @ScheduleId BIGINT,
	@ScheduleStatus char(1),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	DECLARE @Today DateTime;

	SET @Today = GETUTCDATE();

    UPDATE dbo.Schedule
    SET
		AcceptedUserId = CASE WHEN @ScheduleStatus = 'A' THEN @LastUpdatedUserId ELSE NULL END,
		AcceptedDate = CASE WHEN @ScheduleStatus = 'A' THEN @Today ELSE NULL END,
		LastUpdatedDate = @Today,
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ScheduleId = @ScheduleId

/****** Begin logic to update 100% repeater station Schedule status information ******/	
	DECLARE @FlagshipStationId BIGINT,
			 @RepeaterScheduleId BIGINT,
			 @FlagShipYear INT,
			 @FlagShipMonth INT,
			 @NumRows INT,
			 @Incr INT
	
	DECLARE @RepeaterStationSchedule TABLE
	(
		TableId INT IDENTITY,
		StationId BIGINT,
		ScheduleId BIGINT,
		[Year] INT,
		[Month] INT
	)
	
	/** Retrieve Flagship values **/
	SELECT 
		@FlagshipStationId = sch.StationId,
		@FlagshipYear = sch.[Year],
		@FlagShipMonth = sch.[Month]
	FROM
		dbo.Schedule sch
	WHERE
		sch.ScheduleId = @ScheduleId
	
	/** Retrieve associated repeater stations **/
	INSERT INTO @RepeaterStationSchedule
	SELECT 
		st.StationId,
		sch.ScheduleId,
		@FlagshipYear,
		@FlagShipMonth
	FROM
		dbo.Station st INNER JOIN
		dbo.RepeaterStatus rs ON st.RepeaterStatusId = rs.RepeaterStatusId LEFT JOIN
		/** Retrieve only records with same month and year from schedule **/
		(SELECT * FROM dbo.Schedule WHERE [Year] = @FlagshipYear AND [Month] = @FlagShipMonth) sch ON st.StationId = sch.StationId
	WHERE
		st.FlagshipStationId = @FlagshipStationId AND 
		rs.RepeaterStatusName = '100% Repeater'
	
	/** Set initial values for repeater stations **/
	SET @Incr = 1;
	SELECT @NumRows = COUNT(*) FROM @RepeaterStationSchedule;
	
	WHILE @Incr <= @NumRows
	BEGIN
		SELECT 
			@RepeaterScheduleId = ScheduleId
		FROM
			@RepeaterStationSchedule
		WHERE 
			TableId = @Incr;

		UPDATE dbo.Schedule
		SET
			AcceptedUserId = CASE WHEN @ScheduleStatus = 'A' THEN @LastUpdatedUserId ELSE NULL END,
			AcceptedDate = CASE WHEN @ScheduleStatus = 'A' THEN @Today ELSE NULL END,
			LastUpdatedDate = @Today,
			LastUpdatedUserId = @LastUpdatedUserId
		WHERE
		    ScheduleId = @RepeaterScheduleId

		SET @Incr = @Incr + 1;
	END

	/****** End logic to update 100% repeater station Schedule status information ******/	

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ScheduleCreate_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ScheduleCreate_Save]
(
	@StationId BIGINT,
	@Month INT,
	@Year INT,
	@MonthToCopy INT,
	@YearToCopy INT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

	SET NOCOUNT ON

	DECLARE @NewScheduleId BIGINT
	DECLARE @ScheduleIdToCopy BIGINT

	-- first check if a schedule for the specified month and year already exists
	SELECT @NewScheduleId = ScheduleId
	FROM dbo.Schedule
	WHERE StationId = @StationId
	AND Month = @Month
	AND Year = @Year

	IF @NewScheduleId IS NULL
	BEGIN

		DECLARE @Now DATETIME = GETUTCDATE()

		BEGIN TRY
			BEGIN TRAN

			INSERT INTO dbo.Schedule
			(
				StationId,
				Year,
				Month,
				CreatedDate,
				CreatedUserId,
				LastUpdatedDate,
				LastUpdatedUserId
			)
			VALUES
			(
				@StationId,
				@Year,
				@Month,
				@Now,
				@LastUpdatedUserId,
				@Now,
				@LastUpdatedUserId
			)

			SET @NewScheduleId = SCOPE_IDENTITY()
		
			-- if @MonthToCopy or @YearToCopy are null
			-- then assume we want to copy the most recent month for which a schedule exists
			IF (@MonthToCopy IS NULL) OR (@YearToCopy IS NULL)
			BEGIN
		
				SET @ScheduleIdToCopy =
				(
					SELECT TOP 1 ScheduleId
					FROM dbo.Schedule
					WHERE StationId = @StationId
					AND Year <= @Year
					AND Month < @Month
					ORDER BY
						Year DESC,
						Month DESC
				)

			END
			ELSE BEGIN

				SET @ScheduleIdToCopy =
				(
					SELECT ScheduleId
					FROM dbo.Schedule
					WHERE Year = @YearToCopy
					AND Month = @MonthToCopy
				)

			END

			-- copy programs
			INSERT INTO dbo.ScheduleProgram
			(
				ScheduleId,
				ProgramId,
				StartTime,
				EndTime,
				SundayInd,
				MondayInd,
				TuesdayInd,
				WednesdayInd,
				ThursdayInd,
				FridayInd,
				SaturdayInd,
				CreatedDate,
				CreatedUserId,
				LastUpdatedDate,
				LastUpdatedUserId
			)
			SELECT
				@NewScheduleId,
				ProgramId,
				StartTime,
				EndTime,
				SundayInd,
				MondayInd,
				TuesdayInd,
				WednesdayInd,
				ThursdayInd,
				FridayInd,
				SaturdayInd,
				@Now,
				@LastUpdatedUserId,
				@Now,
				@LastUpdatedUserId
			FROM
				dbo.ScheduleProgram
			WHERE
				ScheduleId = @ScheduleIdToCopy

			-- copy newscasts
			INSERT INTO dbo.ScheduleNewscast
			(
				ScheduleId,
				StartTime,
				EndTime,
				HourlyInd,
				DurationMinutes,
				SundayInd,
				MondayInd,
				TuesdayInd,
				WednesdayInd,
				ThursdayInd,
				FridayInd,
				SaturdayInd,
				CreatedDate,
				CreatedUserId,
				LastUpdatedDate,
				LastUpdatedUserId
			)
			SELECT
				@NewScheduleId,
				StartTime,
				EndTime,
				HourlyInd,
				DurationMinutes,
				SundayInd,
				MondayInd,
				TuesdayInd,
				WednesdayInd,
				ThursdayInd,
				FridayInd,
				SaturdayInd,
				@Now,
				@LastUpdatedUserId,
				@Now,
				@LastUpdatedUserId
			FROM
				dbo.ScheduleNewscast
			WHERE
				ScheduleId = @ScheduleIdToCopy

			COMMIT TRAN
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK

			DECLARE
				@ErrorMessage NVARCHAR(4000),
				@ErrorSeverity INT,
				@ErrorState INT

			SELECT
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();

			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
		END CATCH

	END

	SELECT @NewScheduleId AS ScheduleId

END
GO
/****** Object:  StoredProcedure [dbo].[PSP_ScheduleNewscast_Del]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ScheduleNewscast_Del]
(
	@ScheduleNewscastId BIGINT
)
AS BEGIN
    SET NOCOUNT ON
	
	DELETE
	FROM 
		dbo.ScheduleNewscast 
	WHERE 
		ScheduleNewscastId = @ScheduleNewscastId;
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ScheduleNewscast_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ScheduleNewscast_Get]
(
    @ScheduleNewscastId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ScheduleNewscastId,
		ScheduleId,
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.ScheduleNewscast

    WHERE
        ScheduleNewscastId = @ScheduleNewscastId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ScheduleNewscast_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ScheduleNewscast_Save]
(
    @ScheduleNewscastId BIGINT,
	@ScheduleId BIGINT,
	@StartTime TIME,
	@EndTime TIME,
	@HourlyInd CHAR(1),
	@DurationMinutes INT,
	@SundayInd CHAR(1),
	@MondayInd CHAR(1),
	@TuesdayInd CHAR(1),
	@WednesdayInd CHAR(1),
	@ThursdayInd CHAR(1),
	@FridayInd CHAR(1),
	@SaturdayInd CHAR(1),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	IF @HourlyInd = 'N'
	BEGIN

		UPDATE dbo.ScheduleNewscast
		SET
			ScheduleId = @ScheduleId,
			StartTime = @StartTime,
			EndTime = @EndTime,
			HourlyInd = @HourlyInd,
			DurationMinutes = @DurationMinutes,
			SundayInd = @SundayInd,
			MondayInd = @MondayInd,
			TuesdayInd = @TuesdayInd,
			WednesdayInd = @WednesdayInd,
			ThursdayInd = @ThursdayInd,
			FridayInd = @FridayInd,
			SaturdayInd = @SaturdayInd,
			LastUpdatedDate = GETUTCDATE(),
			LastUpdatedUserId = @LastUpdatedUserId
		WHERE
			ScheduleNewscastId = @ScheduleNewscastId
	
		IF @@ROWCOUNT < 1
		BEGIN
	
			INSERT INTO dbo.ScheduleNewscast
			(
				ScheduleId,
				StartTime,
				EndTime,
				HourlyInd,
				DurationMinutes,
				SundayInd,
				MondayInd,
				TuesdayInd,
				WednesdayInd,
				ThursdayInd,
				FridayInd,
				SaturdayInd,
				CreatedDate,
				CreatedUserId,
				LastUpdatedDate,
				LastUpdatedUserId
			)
			VALUES
			(
				@ScheduleId,
				@StartTime,
				@EndTime,
				@HourlyInd,
				@DurationMinutes,
				@SundayInd,
				@MondayInd,
				@TuesdayInd,
				@WednesdayInd,
				@ThursdayInd,
				@FridayInd,
				@SaturdayInd,
				GETUTCDATE(),
				@LastUpdatedUserId,
				GETUTCDATE(),
				@LastUpdatedUserId
			)
	
			SET @ScheduleNewscastId = SCOPE_IDENTITY()
		END

	END
	ELSE
	BEGIN
		DECLARE @CurrentHour	TIME;

		/** Delete overlapping newscast records **/
		DELETE
		FROM
			dbo.ScheduleNewscast
		WHERE
			ScheduleId = @ScheduleId AND
			StartTime BETWEEN @StartTime AND @EndTime AND
			SundayInd = @SundayInd AND
			MondayInd = @MondayInd AND
			TuesdayInd = @TuesdayInd AND
			WednesdayInd = @WednesdayInd AND
			ThursdayInd = @ThursdayInd AND
			FridayInd = @FridayInd AND
			SaturdayInd = @SaturdayInd

		SET @CurrentHour = @StartTime;

		WHILE @CurrentHour <= @EndTime
		BEGIN
			INSERT INTO dbo.ScheduleNewscast
			(
				ScheduleId,
				StartTime,
				EndTime,
				HourlyInd,
				DurationMinutes,
				SundayInd,
				MondayInd,
				TuesdayInd,
				WednesdayInd,
				ThursdayInd,
				FridayInd,
				SaturdayInd,
				CreatedDate,
				CreatedUserId,
				LastUpdatedDate,
				LastUpdatedUserId
			)
			VALUES
			(
				@ScheduleId,
				@CurrentHour,
				DATEADD(MINUTE, @DurationMinutes, @CurrentHour),
				@HourlyInd,
				@DurationMinutes,
				@SundayInd,
				@MondayInd,
				@TuesdayInd,
				@WednesdayInd,
				@ThursdayInd,
				@FridayInd,
				@SaturdayInd,
				GETUTCDATE(),
				@LastUpdatedUserId,
				GETUTCDATE(),
				@LastUpdatedUserId
			)

			SET @CurrentHour = DATEADD(MINUTE, 60, @CurrentHour);

			IF @CurrentHour = @StartTime
			BEGIN
				SET @ScheduleNewscastId = SCOPE_IDENTITY();
			END

		END
	END

	/****** Begin logic to add/update 100% repeater station Newscast Schedule records ******/
	DECLARE @FlagshipStationId BIGINT,
			 @RepeaterScheduleId BIGINT,
			 @FlagShipYear INT,
			 @FlagShipMonth INT,
			 @NumRows INT,
			 @NumRows2 INT,
			 @Incr INT,
			 @Incr2 INT
	
	DECLARE @FlagshipStationSchedule TABLE
	(
		TableId INT IDENTITY,
		ScheduleNewscastId BIGINT,
		ScheduleId BIGINT,
		StartTime TIME,
		EndTime TIME,
		HourlyInd CHAR(1),
		DurationMinutes INT,
		SundayInd CHAR(1),
		MondayInd CHAR(1),
		TuesdayInd CHAR(1),
		WednesdayInd CHAR(1),
		ThursdayInd CHAR(1),
		FridayInd CHAR(1),
		SaturdayInd CHAR(1),
		CreatedDate DATETIME,
		CreatedUserId BIGINT,
		LastUpdatedDate DATETIME,
		LastUpdatedUserId BIGINT	
	)
	
	DECLARE @RepeaterStations TABLE
	(
		TableId INT IDENTITY,
		StationId BIGINT,
		ScheduleId BIGINT,
		[Year] INT,
		[Month] INT
	)
	
	/** Retrieve records for flagship station schedule **/
	INSERT INTO @FlagshipStationSchedule
	SELECT
		ScheduleNewscastId,
		ScheduleId,
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	FROM 
		dbo.ScheduleNewscast sn
	WHERE
		sn.ScheduleId = @ScheduleId
	
	/** Retrieve Flagship default values **/
	SELECT 
		@FlagshipStationId = sch.StationId,
		@FlagshipYear = sch.[Year],
		@FlagShipMonth = sch.[Month]
	FROM
		dbo.Schedule sch INNER JOIN
		dbo.ScheduleNewscast sn ON sch.ScheduleId = sn.ScheduleId
	WHERE
		sn.ScheduleNewscastId = @ScheduleNewscastId
	
	/** Retrieve associated repeater stations **/
	INSERT INTO @RepeaterStations
	SELECT 
		st.StationId,
		sch.ScheduleId,
		@FlagshipYear,
		@FlagShipMonth
	FROM
		dbo.Station st INNER JOIN
		dbo.RepeaterStatus rs ON st.RepeaterStatusId = rs.RepeaterStatusId LEFT JOIN
		/** Retrieve only records with same month and year from schedule **/
		(SELECT * FROM dbo.Schedule WHERE [Year] = @FlagshipYear AND [Month] = @FlagShipMonth) sch ON st.StationId = sch.StationId LEFT JOIN
		dbo.ScheduleNewscast sn ON sch.ScheduleId = sn.ScheduleNewscastId
	WHERE
		st.FlagshipStationId = @FlagshipStationId AND 
		rs.RepeaterStatusName = '100% Repeater'
	
	/** Set initial values for repeater stations **/
	SET @Incr = 1;
	SELECT @NumRows = COUNT(*) FROM @RepeaterStations;
	
	WHILE @Incr <= @NumRows /** Loop through @RepeaterStations table **/
	BEGIN
		IF (SELECT ScheduleId FROM @RepeaterStations WHERE TableId = @Incr) IS NULL
			/** Insert into Schedule table if record does not exist for repeater station **/
			BEGIN
				INSERT INTO dbo.Schedule (StationId, [Year], [Month], SubmittedDate, SubmittedUserId, AcceptedDate, AcceptedUserId, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
				SELECT StationId, [Year], [Month], NULL, NULL, NULL, NULL, GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId  FROM @RepeaterStations WHERE TableId = @Incr
			
				SET @RepeaterScheduleId = SCOPE_IDENTITY();
				
				/** Update temporary table ScheduleId to be used later **/
				UPDATE @RepeaterStations
				SET ScheduleId = @RepeaterScheduleId
				WHERE TableId = @Incr
			END
	        ELSE
			/** Update Schedule table **/
			BEGIN
				SET @RepeaterScheduleId = (SELECT ScheduleId FROM @RepeaterStations WHERE TableId = @Incr)	
							
				UPDATE dbo.Schedule
				SET LastUpdatedDate = GETUTCDATE(),
					  LastUpdatedUserId = @LastUpdatedUserId
				WHERE Schedule.ScheduleId = @RepeaterScheduleId
			END
	
		/** Delete all ScheduleNewscast records for current repeater station **/
		DELETE FROM dbo.ScheduleNewscast WHERE ScheduleId = @RepeaterScheduleId;
	
		SET @Incr2 = 1;
		SELECT @NumRows2 = COUNT(*) FROM @FlagshipStationSchedule;
	
		WHILE @Incr2 <= @NumRows2 /** Loop through @FlagshipStationSchedule table **/
			BEGIN
			/*TODO: Add time zone logic */
				INSERT INTO dbo.ScheduleNewscast (ScheduleId, StartTime, EndTime, HourlyInd, DurationMinutes, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
				SELECT 
					@RepeaterScheduleId, StartTime, EndTime, HourlyInd, DurationMinutes, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId		
				FROM 
					@FlagshipStationSchedule 
				WHERE TableId = @Incr2
	
				 SET @Incr2 = @Incr2 + 1;
			END
	
		SET @Incr = @Incr + 1;
	END
	/****** End logic to add/update 100% repeater station Program Schedule records ******/

    SELECT @ScheduleNewscastId AS ScheduleNewscastId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ScheduleNewscasts_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ScheduleNewscasts_Get]
(
	@ScheduleId BIGINT,
	@GridInd CHAR(1)
)
AS BEGIN

    SET NOCOUNT ON

	IF @GridInd = 'N'
	BEGIN
		SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		0 DayOfWeekNo,
		'Sunday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		SundayInd = 'Y'

	UNION ALL
    
    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		1 DayOfWeekNo,
		'Monday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		MondayInd = 'Y'

	UNION ALL

    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		2 DayOfWeekNo,
		'Tuesday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId
	WHERE
		sn.ScheduleId = @ScheduleId AND
		TuesdayInd = 'Y'

	UNION ALL

    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		3 DayOfWeekNo,
		'Wednesday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		WednesdayInd = 'Y'

	UNION ALL

    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		4 DayOfWeekNo,
		'Thursday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		ThursdayInd = 'Y'

	UNION ALL

    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		5 DayOfWeekNo,
		'Friday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		FridayInd = 'Y'

	UNION ALL

    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		6 DayOfWeekNo,
		'Saturday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		SaturdayInd = 'Y'
	END
	ELSE
	BEGIN
		SELECT
			ScheduleNewscastId,
			sn.ScheduleId,
			'NPR Newscast Service' ProgramName,
			sch.[Month],
			sch.[Year],
			CASE WHEN SundayInd = 'Y' THEN 'Sun ' ELSE + '' END + 
			CASE WHEN MondayInd = 'Y' THEN 'Mon ' ELSE + '' END + 
			CASE WHEN TuesdayInd = 'Y' THEN 'Tue ' ELSE + '' END + 
			CASE WHEN WednesdayInd = 'Y' THEN 'Wed ' ELSE + '' END + 
			CASE WHEN ThursdayInd = 'Y' THEN 'Thu ' ELSE + '' END + 
			CASE WHEN FridayInd = 'Y' THEN 'Fri ' ELSE + '' END + 
			CASE WHEN SaturdayInd = 'Y' THEN 'Sat ' ELSE + '' END As [DaysOfWeek],
			StartTime,
			EndTime,
			HourlyInd,
			DurationMinutes,
			SundayInd,
			MondayInd,
			TuesdayInd,
			WednesdayInd,
			ThursdayInd,
			FridayInd,
			SaturdayInd,
			sn.CreatedDate,
			sn.CreatedUserId,
			sn.LastUpdatedDate,
			sn.LastUpdatedUserId
		FROM
			dbo.ScheduleNewscast sn INNER JOIN
			dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

		WHERE
			sn.ScheduleId = @ScheduleId
	END
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ScheduleProgram_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_ScheduleProgram_Get]
(
    @ScheduleProgramId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ScheduleProgramId,
		ScheduleId,
		ProgramId,
		StartTime,
		EndTime,
		QuarterHours,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.ScheduleProgram

    WHERE
        ScheduleProgramId = @ScheduleProgramId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ScheduleProgram_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ScheduleProgram_Save]
(
    @ScheduleProgramId BIGINT,
	@ScheduleId BIGINT,
	@ProgramId BIGINT,
	@StartTime TIME,
	@EndTime TIME,
	@SundayInd CHAR(1),
	@MondayInd CHAR(1),
	@TuesdayInd CHAR(1),
	@WednesdayInd CHAR(1),
	@ThursdayInd CHAR(1),
	@FridayInd CHAR(1),
	@SaturdayInd CHAR(1),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	DECLARE @SameScheduleInd CHAR(1);

    UPDATE dbo.ScheduleProgram
    SET
        ScheduleId = @ScheduleId,
		ProgramId = @ProgramId,
		StartTime = @StartTime,
		EndTime = @EndTime,
		SundayInd = @SundayInd,
		MondayInd = @MondayInd,
		TuesdayInd = @TuesdayInd,
		WednesdayInd = @WednesdayInd,
		ThursdayInd = @ThursdayInd,
		FridayInd = @FridayInd,
		SaturdayInd = @SaturdayInd,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ScheduleProgramId = @ScheduleProgramId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.ScheduleProgram
        (
            ScheduleId,
			ProgramId,
			StartTime,
			EndTime,
			SundayInd,
			MondayInd,
			TuesdayInd,
			WednesdayInd,
			ThursdayInd,
			FridayInd,
			SaturdayInd,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @ScheduleId,
			@ProgramId,
			@StartTime,
			@EndTime,
			@SundayInd,
			@MondayInd,
			@TuesdayInd,
			@WednesdayInd,
			@ThursdayInd,
			@FridayInd,
			@SaturdayInd,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @ScheduleProgramId = SCOPE_IDENTITY();
    END

	/****** Begin logic to adjust Program Schedule based on Section 13.5.2.2 of requirements document ******/
	DECLARE @numEvents INT,
				 @incrTableId INT,
				@cScheduleProgramId BIGINT, 
				@cScheduleId BIGINT, 
				@cProgramId BIGINT, 
				@cStartTime TIME, 
				@cEndTime TIME, 
				@cSundayInd CHAR(1), 
				@cMondayInd CHAR(1), 
				@cTuesdayInd CHAR(1), 
				@cWednesdayInd CHAR(1), 
				@cThursdayInd CHAR(1), 
				@cFridayInd CHAR(1), 
				@cSaturdayInd  CHAR(1)

	DECLARE @OverlappingEvents TABLE
	(
		TableId INT IDENTITY,
		ScheduleProgramId BIGINT,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		StartTime TIME,
		EndTime TIME,
		SundayInd CHAR(1),
		MondayInd CHAR(1),
		TuesdayInd CHAR(1),
		WednesdayInd CHAR(1),
		ThursdayInd CHAR(1),
		FridayInd CHAR(1),
		SaturdayInd CHAR(1),
		CreatedDate DATETIME,
		CreatedUserId BIGINT,
		LastUpdatedDate DATETIME,
		LastUpdatedUserId BIGINT	
	)

	DECLARE @CombineEvents TABLE
	(
		TableId INT IDENTITY,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		StartTime TIME,
		EndTime TIME,
		SundayInd CHAR(1),
		MondayInd CHAR(1),
		TuesdayInd CHAR(1),
		WednesdayInd CHAR(1),
		ThursdayInd CHAR(1),
		FridayInd CHAR(1),
		SaturdayInd CHAR(1),
		CreatedUserId BIGINT,
		LastUpdatedUserId BIGINT	
	)

	/** Retrieve all overlapping events to newly inserted event (regardless of days indicated) **/
	INSERT INTO @OverlappingEvents
	SELECT 
		ScheduleProgramId, ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId
	FROM 
		dbo.ScheduleProgram sp
	WHERE
		sp.ScheduleId = @ScheduleId AND 
		((StartTime <= @StartTime AND EndTime >= @StartTime ) OR (StartTime <= @EndTime AND EndTime >= @EndTime) OR (StartTime >= @StartTime AND EndTime <= @EndTime)) AND
		ScheduleProgramId <> @ScheduleProgramId

	SET @incrTableId = 1;
	SET @numEvents = (SELECT COUNT(*) FROM @OverlappingEvents);

	WHILE @incrTableId <= @numEvents
	BEGIN
		SELECT
			@cScheduleProgramId = ScheduleProgramId, 
			@cScheduleId = ScheduleId, 
			@cProgramId = ProgramId, 
			@cStartTime = StartTime, 
			@cEndTime = EndTime, 
			@cSundayInd = SundayInd, 
			@cMondayInd = MondayInd, 
			@cTuesdayInd = TuesdayInd, 
			@cWednesdayInd = WednesdayInd, 
			@cThursdayInd = ThursdayInd, 
			@cFridayInd = FridayInd, 
			@cSaturdayInd = SaturdayInd
		FROM	
			@OverlappingEvents
		WHERE 
			TableId = @incrTableId

		/** Set indicator to determine if newly inserted event has same day indicators as current overlapping event **/
		IF 	(@cSundayInd = @SundayInd AND @cMondayInd = @MondayInd AND @cTuesdayInd = @TuesdayInd AND @cWednesdayInd = @WednesdayInd AND 
			 @cThursdayInd = @ThursdayInd AND @cFridayInd =@FridayInd AND @cSaturdayInd = @SaturdayInd)
			SET @SameScheduleInd = 'Y'; /** Identical days indicators between new event and current overlapping event **/
		ELSE IF ((@cSundayInd = 'Y' AND @SundayInd = 'Y') OR (@cMondayInd = 'Y' AND @MondayInd = 'Y') OR (@cTuesdayInd = 'Y' AND @TuesdayInd = 'Y') OR 
					(@cWednesdayInd = 'Y' AND @WednesdayInd = 'Y') OR (@cThursdayInd = 'Y' AND @ThursdayInd = 'Y') OR (@cFridayInd = 'Y' AND @FridayInd = 'Y') OR 
					(@cSaturdayInd = 'Y' AND @SaturdayInd = 'Y'))
			SET @SameScheduleInd = 'O'; /** At least one day indicator is the same between new event and current overlapping event **/
		ELSE
			SET @SameScheduleInd = 'N'; /** No days indicators same between new event and current overlapping event **/
		
		IF @SameScheduleInd = 'O'
		BEGIN
			/** Duplicate current overlapping event with days indicator unchecked where new event is checked **/
			INSERT INTO dbo.ScheduleProgram (
				ScheduleId, 
				ProgramId, 
				StartTime, 
				EndTime, 
				SundayInd, 
				MondayInd, 
				TuesdayInd, 
				WednesdayInd, 
				ThursdayInd, 
				FridayInd, 
				SaturdayInd, 
				CreatedDate, 
				CreatedUserId, 
				LastUpdatedDate, 
				LastUpdatedUserId
			)
			VALUES(
				@cScheduleId, 
				@cProgramId, 
				@cStartTime,
				@cEndTime,
				CASE WHEN @Sundayind = 'Y' AND @cSundayind = 'Y' THEN 'N' ELSE @cSundayInd END, 
				CASE WHEN @MondayInd = 'Y' AND @cMondayInd = 'Y' THEN 'N' ELSE @cMondayInd END, 
				CASE WHEN @TuesdayInd = 'Y' AND @cTuesdayInd = 'Y' THEN 'N' ELSE @cTuesdayInd END, 
				CASE WHEN @WednesdayInd = 'Y' AND @cWednesdayInd = 'Y' THEN 'N' ELSE @cWednesdayInd END, 
				CASE WHEN @ThursdayInd = 'Y' AND @cThursdayInd = 'Y' THEN 'N' ELSE @cThursdayInd END, 
				CASE WHEN @FridayInd = 'Y' AND @cFridayInd = 'Y' THEN 'N' ELSE @cFridayInd END, 
				CASE WHEN @SaturdayInd = 'Y' AND @cSaturdayInd = 'Y' THEN 'N' ELSE @cSaturdayInd END, 
				GETUTCDATE(), 
				@LastUpdatedUserId, 
				GETUTCDATE(), 
				@LastUpdatedUserId
			)

			UPDATE dbo.ScheduleProgram 
			SET SundayInd = CASE WHEN @SundayInd = 'N' AND @cSundayInd = 'Y' THEN 'N' ELSE SundayInd END,
				  MondayInd = CASE WHEN @MondayInd = 'N' AND @cMondayInd = 'Y' THEN 'N' ELSE MondayInd END,
				  TuesdayInd = CASE WHEN @TuesdayInd = 'N' AND @cTuesdayInd = 'Y' THEN 'N' ELSE TuesdayInd END,
				  WednesdayInd = CASE WHEN @WednesdayInd = 'N' AND @cWednesdayInd = 'Y' THEN 'N' ELSE WednesdayInd END,
				  ThursdayInd = CASE WHEN @ThursdayInd = 'N' AND @cThursdayInd = 'Y' THEN 'N' ELSE ThursdayInd END,
				  FridayInd = CASE WHEN @FridayInd = 'N' AND @cFridayInd = 'Y' THEN 'N' ELSE FridayInd END,
				  SaturdayInd = CASE WHEN @SaturdayInd = 'N' AND @cSaturdayInd = 'Y' THEN 'N' ELSE SaturdayInd END
			WHERE ScheduleProgramId = @cScheduleProgramId;
		END

		IF @SameScheduleInd = 'Y' OR @SameScheduleInd = 'O'
			BEGIN
				IF @StartTime <= @cStartTime AND @EndTime >= @cEndTime /* 1 */
				/** Delete current overlapping event, regardless of Program  **/
				BEGIN
					DELETE FROM dbo.ScheduleProgram WHERE ScheduleProgramId = @cScheduleProgramId;
				END
				ELSE IF @StartTime < @cStartTime AND @EndTime >= @cStartTime AND @EndTime <= @cEndTime AND @ProgramId = @cProgramId /* 2 */
				/** End time of new event overlaps start time of current overlapping event. Adjust the new record end time and delete current overlapping event **/
				BEGIN 
					UPDATE dbo.ScheduleProgram
					SET EndTime = @cEndTime
					WHERE ScheduleProgramId = @ScheduleProgramId;

					DELETE FROM dbo.ScheduleProgram WHERE ScheduleProgramId = @cScheduleProgramId;
				END
				ELSE IF @StartTime >= @cStartTime AND @StartTime <= @cEndTime AND @EndTime > @cEndTime AND @ProgramId = @cProgramId /* 3 */
				/** End time of current overlapping event overlaps start time of new event. Adjust the new record start time and delete current overlapping event **/
				BEGIN
					UPDATE dbo.ScheduleProgram
					SET StartTime = @cStartTime
					WHERE ScheduleProgramId = @ScheduleProgramId;

					DELETE FROM dbo.ScheduleProgram WHERE ScheduleProgramId = @cScheduleProgramId;
				END
				ELSE IF @StartTime >= @cStartTime AND @EndTime <= @cEndTime AND @ProgramId = @cProgramId /* 4 */
				BEGIN
					UPDATE dbo.ScheduleProgram
					SET StartTime = @cStartTime,
						  EndTime = @cEndTime
					WHERE ScheduleProgramId = @ScheduleProgramId;

					DELETE FROM dbo.ScheduleProgram WHERE ScheduleProgramId = @cScheduleProgramId;
				END
				ELSE IF @StartTime <= @cStartTime AND @EndTime > @cStartTime AND @EndTime < @cEndTime AND @ProgramId <> @cProgramId /* 5 */
				/** End time of new event overlaps start time of current overlapping event. Adjust the new record end time and delete current overlapping event **/ 
				BEGIN
					UPDATE dbo.ScheduleProgram
					SET StartTime = @EndTime
					WHERE ScheduleProgramId = @cScheduleProgramId;
				END
				ELSE IF @StartTime > @cStartTime AND @StartTime < @cEndTime AND @EndTime >= @cEndTime AND @ProgramId <> @cProgramId /* 6 */
				/** **/
				BEGIN
					UPDATE dbo.ScheduleProgram
					SET EndTime = @StartTime
					WHERE ScheduleProgramId = @cScheduleProgramId;
				END
				ELSE IF @StartTime > @cStartTime AND @EndTime < @cEndTime AND @ProgramId <> @cProgramId /* 7 */
				/** Insert new record for split event and adjust end time for current overlapping event **/
				BEGIN
					INSERT INTO dbo.ScheduleProgram (
						ScheduleId, 
						ProgramId, 
						StartTime, 
						EndTime, 
						SundayInd, 
						MondayInd, 
						TuesdayInd, 
						WednesdayInd, 
						ThursdayInd, 
						FridayInd, 
						SaturdayInd, 
						CreatedDate, 
						CreatedUserId, 
						LastUpdatedDate, 
						LastUpdatedUserId
					)
					VALUES(
						@cScheduleId, 
						@cProgramId, 
						@EndTime, /** Start time assigned end time for new event **/
						@cEndTime, /** End time assigned end time for current overlapping event **/ 
						CASE WHEN @SundayInd = 'Y' THEN 'Y' ELSE 'N' END, 
						CASE WHEN @MondayInd = 'Y' THEN 'Y' ELSE 'N' END, 
						CASE WHEN @TuesdayInd = 'Y' THEN 'Y' ELSE 'N' END, 
						CASE WHEN @WednesdayInd = 'Y' THEN 'Y' ELSE 'N' END, 
						CASE WHEN @ThursdayInd = 'Y' THEN 'Y' ELSE 'N' END, 
						CASE WHEN @FridayInd = 'Y' THEN 'Y' ELSE 'N' END, 
						CASE WHEN @SaturdayInd = 'Y' THEN 'Y' ELSE 'N' END, 
						GETUTCDATE(), 
						@LastUpdatedUserId, 
						GETUTCDATE(), 
						@LastUpdatedUserId
					)
			
					/** Update current overlapping event end time **/
					UPDATE dbo.ScheduleProgram
					SET EndTime = @StartTime
					WHERE ScheduleProgramId = @cScheduleProgramId;						
				END
			END

		SET @incrTableId = @incrTableId + 1;
	END

	/** Housecleaning. Delete record if all day indicators have been flagged 'N' due to processing. **/
	DELETE FROM dbo.ScheduleProgram WHERE SundayInd = 'N' AND MondayInd = 'N' AND TuesdayInd = 'N' AND WednesdayInd = 'N' AND ThursdayInd = 'N' AND FridayInd = 'N' AND SaturdayInd = 'N' AND ScheduleId = @ScheduleId

	/** Housecleaning. Combine events that have same start time, end time and program id. This can be caused by users creating/updating distinct events with same program and start and end time. **/
	INSERT INTO @CombineEvents
	SELECT 
		ScheduleId, 
		ProgramId, 
		StartTime, 
		EndTime, 
		MAX(SundayInd) SundayInd, 
		MAX(MondayInd) MondayInd, 
		MAX(TuesdayInd) TuesdayInd, 
		MAX(WednesdayInd) WednesdayInd, 
		MAX(ThursdayInd) ThursdayInd, 
		MAX(FridayInd) FridayInd, 
		MAX(SaturdayInd) SaturdayInd, 
		MAX(CreatedUserId) CreatedUserId, 
		MAX(LastUpdatedUserId) LastUpdatedUserId
	FROM 
		dbo.ScheduleProgram
	WHERE
		ScheduleId = @ScheduleId
	GROUP BY ScheduleId, ProgramId, StartTime, EndTime
	HAVING COUNT(ProgramId) > 1

	SET @incrTableId = 1;
	SET @numEvents = (SELECT COUNT(*) FROM @CombineEvents);

	WHILE @incrTableId <= @numEvents
	BEGIN
		SELECT @ScheduleId = ScheduleId, @ProgramId = ProgramId, @StartTime = StartTime, @EndTime = EndTime
		FROM @CombineEvents 
		WHERE TableId = @incrTableId;

		/** Delete individual events with same program, start time, and end time **/
		DELETE FROM ScheduleProgram WHERE ScheduleId = @ScheduleId AND ProgramId = @ProgramId AND StartTime = @StartTime AND EndTime = @EndTime;

		/** Insert new event with combined days indicator **/
		INSERT INTO dbo.ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
		SELECT ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, GETUTCDATE(), CreatedUserId, GETUTCDATE(), LastUpdatedUserId
		FROM @CombineEvents
		WHERE TableId = @incrTableId;

		SET @incrTableId = @incrTableId + 1;
	END

	/****** End logic to adjust Program Schedule based on Section 13.5.2.2 of requirements document ******/

	/****** Begin logic to add/update 100% repeater station Program Schedule records ******/
	DECLARE @FlagshipStationId BIGINT,
			 @RepeaterScheduleId BIGINT,
			 @RepeaterScheduleProgramId BIGINT,
			 @FlagShipYear INT,
			 @FlagShipMonth INT,
			 @NumRows INT,
			 @NumRows2 INT,
			 @Incr INT,
			 @Incr2 INT

	DECLARE @FlagshipStationSchedule TABLE
	(
		TableId INT IDENTITY,
		ScheduleProgramId BIGINT,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		StartTime TIME,
		EndTime TIME,
		SundayInd CHAR(1),
		MondayInd CHAR(1),
		TuesdayInd CHAR(1),
		WednesdayInd CHAR(1),
		ThursdayInd CHAR(1),
		FridayInd CHAR(1),
		SaturdayInd CHAR(1),
		CreatedDate DATETIME,
		CreatedUserId BIGINT,
		LastUpdatedDate DATETIME,
		LastUpdatedUserId BIGINT	
	)

	DECLARE @RepeaterStations TABLE
	(
		TableId INT IDENTITY,
		StationId BIGINT,
		ScheduleId BIGINT,
		[Year] INT,
		[Month] INT
	)

	/** Retrieve records for flagship station schedule **/
	INSERT INTO @FlagshipStationSchedule
	SELECT
		ScheduleProgramId,
		ScheduleId,
		ProgramId,
		StartTime,
		EndTime,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	FROM 
		dbo.ScheduleProgram sp
	WHERE
		sp.ScheduleId = @ScheduleId

	/** Retrieve Flagship default values **/
	SELECT 
		@FlagshipStationId = sch.StationId,
		@FlagshipYear = sch.[Year],
		@FlagShipMonth = sch.[Month]
	FROM
		dbo.Schedule sch INNER JOIN
		dbo.ScheduleProgram sp ON sch.ScheduleId = sp.ScheduleId
	WHERE
		sp.ScheduleProgramId = @ScheduleProgramId

	/** Retrieve associated repeater stations **/
	INSERT INTO @RepeaterStations
	SELECT 
		st.StationId,
		sch.ScheduleId,
		@FlagshipYear,
		@FlagShipMonth
	FROM
		dbo.Station st INNER JOIN
		dbo.RepeaterStatus rs ON st.RepeaterStatusId = rs.RepeaterStatusId LEFT JOIN
		/** Retrieve only records with same month and year from schedule **/
		(SELECT * FROM dbo.Schedule WHERE [Year] = @FlagshipYear AND [Month] = @FlagShipMonth) sch ON st.StationId = sch.StationId LEFT JOIN
		dbo.ScheduleProgram sp ON sch.ScheduleId = sp.ScheduleId
	WHERE
		st.FlagshipStationId = @FlagshipStationId AND 
		rs.RepeaterStatusName = '100% Repeater'

	/** Set initial values for repeater stations **/
	SET @Incr = 1;
	SELECT @NumRows = COUNT(*) FROM @RepeaterStations;

	WHILE @Incr <= @NumRows /** Loop through @RepeaterStations table **/
	BEGIN
		IF (SELECT ScheduleId FROM @RepeaterStations WHERE TableId = @Incr) IS NULL
			/** Insert into Schedule table if record does not exist for repeater station **/
			BEGIN
				INSERT INTO dbo.Schedule (StationId, [Year], [Month], SubmittedDate, SubmittedUserId, AcceptedDate, AcceptedUserId, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
				SELECT StationId, [Year], [Month], NULL, NULL, NULL, NULL, GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId  FROM @RepeaterStations WHERE TableId = @Incr
			
				SET @RepeaterScheduleId = SCOPE_IDENTITY();
				
				/** Update temporary table ScheduleId to be used later **/
				UPDATE @RepeaterStations
				SET ScheduleId = @RepeaterScheduleId
				WHERE TableId = @Incr
			END
            ELSE
			/** Update Schedule table **/
			BEGIN
				SET @RepeaterScheduleId = (SELECT ScheduleId FROM @RepeaterStations WHERE TableId = @Incr)	
							
				UPDATE dbo.Schedule
				SET LastUpdatedDate = GETUTCDATE(),
					  LastUpdatedUserId = @LastUpdatedUserId
				WHERE Schedule.ScheduleId = @RepeaterScheduleId
			END

		/** Delete all ScheduleProgram records for current repeater station **/
		DELETE FROM dbo.ScheduleProgram WHERE ScheduleId = @RepeaterScheduleId;

		SET @Incr2 = 1;
		SELECT @NumRows2 = COUNT(*) FROM @FlagshipStationSchedule;

		WHILE @Incr2 <= @NumRows2 /** Loop through @FlagshipStationSchedule table **/
			BEGIN
			/*TODO: Add time zone logic */
				INSERT INTO dbo.ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
				SELECT 
					@RepeaterScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId		
				FROM 
					@FlagshipStationSchedule 
				WHERE TableId = @Incr2

				 SET @Incr2 = @Incr2 + 1;
			END

		SET @Incr = @Incr + 1;
	END
	/****** End logic to add/update 100% repeater station Program Schedule records ******/
	
    SELECT @ScheduleProgramId AS ScheduleProgramId;

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_SchedulePrograms_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_SchedulePrograms_Get]
(
	@ScheduleId BIGINT,
	@GridInd CHAR(1)
)
AS BEGIN

    SET NOCOUNT ON
	IF @GridInd = 'N'
	BEGIN
		SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		0 DayOfWeekNo,
		'Sunday' [DayOfWeek],
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND SundayInd = 'Y'

	UNION ALL

	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		1,
		'Monday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND MondayInd = 'Y'
	
	UNION ALL
	
	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		2,
		'Tuesday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND TuesdayInd = 'Y'
	
	UNION ALL
	
	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		3,
		'Wednesday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND WednesdayInd = 'Y'
	
	UNION ALL
	
	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		4,
		'Thursday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND ThursdayInd = 'Y'
	
	UNION ALL
	
	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		5,
		'Friday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND FridayInd = 'Y'
	
	UNION ALL
	
	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		6,
		'Saturday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND SaturdayInd = 'Y'

	Order By ScheduleProgramId, DayOfWeekNo
    END
	ELSE
	BEGIN
		SELECT
			sp.ScheduleProgramId,
			sp.ScheduleId,
			sp.ProgramId,
			p.ProgramName,
			sch.[Month],
			sch.[Year],
			CASE WHEN SundayInd = 'Y' THEN 'Sun ' ELSE + '' END + 
			CASE WHEN MondayInd = 'Y' THEN 'Mon ' ELSE + '' END + 
			CASE WHEN TuesdayInd = 'Y' THEN 'Tue ' ELSE + '' END + 
			CASE WHEN WednesdayInd = 'Y' THEN 'Wed ' ELSE + '' END + 
			CASE WHEN ThursdayInd = 'Y' THEN 'Thu ' ELSE + '' END + 
			CASE WHEN FridayInd = 'Y' THEN 'Fri ' ELSE + '' END + 
			CASE WHEN SaturdayInd = 'Y' THEN 'Sat ' ELSE + '' END As [DaysOfWeek],
			sp.StartTime,
			sp.EndTime,
			sp.QuarterHours,
			CASE WHEN SundayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN MondayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN TuesdayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN WednesdayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN ThursdayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN FridayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN SaturdayInd = 'Y' THEN QuarterHours ELSE + 0 END As [TotalQuarterHours],
			sp.SundayInd,
			sp.MondayInd,
			sp.TuesdayInd,
			sp.WednesdayInd,
			sp.ThursdayInd,
			sp.FridayInd,
			sp.SaturdayInd,
			sp.CreatedDate,
			sp.CreatedUserId,
			sp.LastUpdatedDate,
			sp.LastUpdatedUserId
		FROM
			dbo.ScheduleProgram sp INNER JOIN
			dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
			dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
		WHERE
			sp.ScheduleId = @ScheduleId
	END
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Schedules_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Schedules_Get]
(
	@StationId BIGINT,
	@Year INT,
	@Month INT,
	@Status VARCHAR(50)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ScheduleId,
		StationId,
		[Year],
		[Month],
		SubmittedDate,
		SubmittedUserId,
		AcceptedDate,
		AcceptedUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Schedule

	WHERE
		StationId = @StationId
		AND
		(Year = @Year OR @Year IS NULL)
		AND
		(Month = @Month OR @Month IS NULL)
		-- todo: status
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ScheduleSearch_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ScheduleSearch_Get]
(
	@StationId BIGINT,
	@Month INT,
	@Year INT,
	@Status VARCHAR(50),
	@DebugInd CHAR(1) = 'N'
)
WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
	SELECT
		sch.ScheduleId,
		sta.StationId,
		sta.CallLetters + ''-'' + b.BandName AS StationDisplayName,
		ISNULL(sch.Month, @Month) AS Month,
		(
			Select DateName( month , DateAdd( month , ISNULL(sch.Month, @Month) , 0 ) - 1 )
		) As MonthName,
		ISNULL(sch.Year, @Year) AS Year,
		sch.ScheduleId,

		LEFT(DATENAME(MONTH, DATEADD(MONTH, ISNULL(sch.Month, @Month) - 1 , ''1900-01-01'' )), 3) +
			''. '' +
			CAST(ISNULL(sch.Year, @Year) AS VARCHAR(50))
			AS ScheduleDisplayName,
		
		CAST(
			CAST(ISNULL(sch.Year, @Year) AS VARCHAR(50)) +
			''-'' +
			CAST(ISNULL(sch.Month, @Month) AS VARCHAR(50)) +
			''-1''
			AS DATE) AS ScheduleStartDate,

		sch.Status,
		sch.SubmittedDate,
		sch.SubmittedUserId,
		dbo.FN_GetUserDisplayName(sch.SubmittedUserId) AS SubmittedUserDisplayName,
		sch.AcceptedDate,
		sch.AcceptedUserId,
		dbo.FN_GetUserDisplayName(sch.AcceptedUserId) AS AcceptedUserDisplayName,
		sta.PrimaryUserId,
		dbo.FN_GetUserDisplayName(pu.UserId) AS PrimaryUserDisplayName,
		pu.Email AS PrimaryUserEmail,
		pu.Phone AS PrimaryUserPhone

	FROM
		dbo.Station sta

		JOIN dbo.Band b
			ON b.BandId = sta.BandId

		JOIN dbo.RepeaterStatus rs
			ON sta.RepeaterStatusId = rs.RepeaterStatusId

		LEFT JOIN dbo.CRCUser pu
			ON pu.UserId = sta.PrimaryUserId

		LEFT JOIN dbo.Schedule sch
			ON sch.StationId = sta.StationId
	'

	IF @Month IS NOT NULL
		SET @DynSql = @DynSql + ' AND sch.Month = @Month'

	IF @Year IS NOT NULL
		SET @DynSql = @DynSql + ' AND sch.Year = @Year'

	IF @Status IS NOT NULL AND @Status <> 'All'
		SET @DynSql = @DynSql + ' AND sch.Status = @Status'

	SET @DynSql = @DynSql + ' WHERE rs.RepeaterStatusName <> ''100% Repeater'' '

	IF @StationId IS NOT NULL
		SET @DynSql = @DynSql + ' AND sta.StationId = @StationId'

	DECLARE @DynParams NVARCHAR(MAX) =
	'
	@StationId BIGINT,
	@Month INT,
	@Year INT,
	@Status VARCHAR(50)
	'

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		EXEC dbo.sp_executesql
		@DynSql,
		@DynParams,
		@StationId = @StationId,
		@Month = @Month,
		@Year = @Year,
		@Status = @Status

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_ScheduleYearsList_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_ScheduleYearsList_Get]
(
	@FutureYears INT
)
AS BEGIN

	SET NOCOUNT ON

	DECLARE @FirstYear INT =
	(
		SELECT MIN(Year)
		FROM dbo.Schedule
	)
	SET @FirstYear = ISNULL(@FirstYear, DATEPART(YEAR, GETUTCDATE()))

	DECLARE @LastYear INT = DATEPART(YEAR, DATEADD(YEAR, @FutureYears, GETUTCDATE()))

	;WITH YearsList AS
	(
		SELECT @FirstYear AS Year
		UNION ALL
		SELECT Year + 1
		FROM YearsList
		WHERE Year < @LastYear
	)
	SELECT Year
	FROM YearsList

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_State_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_State_Get]
(
    @StateId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StateId,
		StateName,
		Abbreviation,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.[State]

    WHERE
        StateId = @StateId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_State_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_State_Save]
(
    @StateId BIGINT,
	@StateName VARCHAR(50),
	@Abbreviation VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.[State]
    SET
        StateName = @StateName,
		Abbreviation = @Abbreviation,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        StateId = @StateId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.[State]
        (
            StateName,
			Abbreviation,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @StateName,
			@Abbreviation,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @StateId = SCOPE_IDENTITY()

    END

    SELECT @StateId AS StateId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_States_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_States_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StateId,
		StateName,
		Abbreviation,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.[State]
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Station_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_Station_Get]
(
    @StationId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        s.StationId,
		s.CallLetters,
		s.BandId,
		s.CallLetters + '-' + b.BandName AS StationDisplayName,
		s.Frequency,
		s.RepeaterStatusId,
		s.FlagshipStationId,
		s.PrimaryUserId,
		dbo.FN_GetUserDisplayName(s.PrimaryUserId) AS PrimaryUserDisplayName,
		u.Phone AS PrimaryUserPhone,
		u.Email AS PrimaryUserEmail,
		s.MemberStatusId,
		s.MinorityStatusId,
		s.StatusDate,
		s.LicenseeTypeId,
		s.LicenseeName,
		s.AddressLine1,
		s.AddressLine2,
		s.City,
		s.StateId,
		s.County,
		s.Country,
		s.ZipCode,
		s.Phone,
		s.Fax,
		s.Email,
		s.WebPage,
		s.TSACume,
		s.TSAAQH,
		s.MetroMarketId,
		s.MetroMarketRank,
		s.DMAMarketId,
		s.DMAMarketRank,
		s.TimeZoneId,
		s.HoursFromFlagship,
		s.MaxNumberOfUsers,
		s.DisabledDate,
		s.DisabledUserId,
		s.CreatedDate,
		s.CreatedUserId,
		s.LastUpdatedDate,
		s.LastUpdatedUserId

    FROM
        dbo.Station s

		JOIN dbo.Band b
			ON b.BandId = s.BandId

		LEFT JOIN dbo.CRCUser u
			ON u.UserId = s.PrimaryUserId

    WHERE
        StationId = @StationId

END



GO
/****** Object:  StoredProcedure [dbo].[PSP_Station_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PSP_Station_Save]
(
    @StationId BIGINT,
	@CallLetters VARCHAR(50),
	@BandId BIGINT,
	@Frequency VARCHAR(50),
	@RepeaterStatusId BIGINT,
	@FlagshipStationId BIGINT,
	@MemberStatusId BIGINT,
	@MinorityStatusId BIGINT,
	@StatusDate DATE,
	@LicenseeTypeId BIGINT,
	@LicenseeName VARCHAR(50),
	@AddressLine1 VARCHAR(50),
	@AddressLine2 VARCHAR(50),
	@City VARCHAR(50),
	@StateId BIGINT,
	@County VARCHAR(50),
	@Country VARCHAR(50),
	@ZipCode VARCHAR(50),
	@Phone VARCHAR(50),
	@Fax VARCHAR(50),
	@Email VARCHAR(50),
	@WebPage VARCHAR(100),
	@TSACume VARCHAR(50),
	@TSAAQH VARCHAR(50),
	@MetroMarketId BIGINT,
	@MetroMarketRank INT,
	@DMAMarketId BIGINT,
	@DMAMarketRank INT,
	@TimeZoneId BIGINT,
	@HoursFromFlagship INT,
	@MaxNumberOfUsers INT,
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Station
    SET
        CallLetters = @CallLetters,
		BandId = @BandId,
		Frequency = @Frequency,
		RepeaterStatusId = @RepeaterStatusId,
		FlagshipStationId = @FlagshipStationId,
		MemberStatusId = @MemberStatusId,
		MinorityStatusId = @MinorityStatusId,
		StatusDate = @StatusDate,
		LicenseeTypeId = @LicenseeTypeId,
		LicenseeName = @LicenseeName,
		AddressLine1 = @AddressLine1,
		AddressLine2 = @AddressLine2,
		City = @City,
		StateId = @StateId,
		County = @County,
		Country = @Country,
		ZipCode = @ZipCode,
		Phone = @Phone,
		Fax = @Fax,
		Email = @Email,
		WebPage = @WebPage,
		TSACume = @TSACume,
		TSAAQH = @TSAAQH,
		MetroMarketId = @MetroMarketId,
		MetroMarketRank = @MetroMarketRank,
		DMAMarketId = @DMAMarketId,
		DMAMarketRank = @DMAMarketRank,
		TimeZoneId = @TimeZoneId,
		HoursFromFlagship = @HoursFromFlagship,
		MaxNumberOfUsers = @MaxNumberOfUsers,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        StationId = @StationId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Station
        (
            CallLetters,
			BandId,
			Frequency,
			RepeaterStatusId,
			FlagshipStationId,
			MemberStatusId,
			MinorityStatusId,
			StatusDate,
			LicenseeTypeId,
			LicenseeName,
			AddressLine1,
			AddressLine2,
			City,
			StateId,
			County,
			Country,
			ZipCode,
			Phone,
			Fax,
			Email,
			WebPage,
			TSACume,
			TSAAQH,
			MetroMarketId,
			MetroMarketRank,
			DMAMarketId,
			DMAMarketRank,
			TimeZoneId,
			HoursFromFlagship,
			MaxNumberOfUsers,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @CallLetters,
			@BandId,
			@Frequency,
			@RepeaterStatusId,
			@FlagshipStationId,
			@MemberStatusId,
			@MinorityStatusId,
			@StatusDate,
			@LicenseeTypeId,
			@LicenseeName,
			@AddressLine1,
			@AddressLine2,
			@City,
			@StateId,
			@County,
			@Country,
			@ZipCode,
			@Phone,
			@Fax,
			@Email,
			@WebPage,
			@TSACume,
			@TSAAQH,
			@MetroMarketId,
			@MetroMarketRank,
			@DMAMarketId,
			@DMAMarketRank,
			@TimeZoneId,
			@HoursFromFlagship,
			@MaxNumberOfUsers,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @StationId = SCOPE_IDENTITY()

    END

    SELECT @StationId AS StationId

END



GO
/****** Object:  StoredProcedure [dbo].[PSP_StationAffiliate_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_StationAffiliate_Get]
(
    @StationAffiliateId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StationAffiliateId,
		StationId,
		AffiliateId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.StationAffiliate

    WHERE
        StationAffiliateId = @StationAffiliateId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationAffiliate_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_StationAffiliate_Save]
(
    @StationAffiliateId BIGINT,
	@StationId BIGINT,
	@AffiliateId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.StationAffiliate
    SET
        StationId = @StationId,
		AffiliateId = @AffiliateId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        StationAffiliateId = @StationAffiliateId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.StationAffiliate
        (
            StationId,
			AffiliateId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @StationId,
			@AffiliateId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @StationAffiliateId = SCOPE_IDENTITY()

    END

    SELECT @StationAffiliateId AS StationAffiliateId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationAffiliates_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_StationAffiliates_Get]
(
	@StationId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StationAffiliateId,
		StationId,
		AffiliateId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.StationAffiliate

	WHERE
		StationId = @StationId
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationAQHCume_Update]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_StationAQHCume_Update]
(
    @CallLetters VARCHAR(100),
	@Band VARCHAR(10),
	@AQH INT,
	@Cume INT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	UPDATE st
    SET        
		st.TSAAQH = @AQH,
		st.TSACume = @Cume,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
		
	FROM 
		dbo.Station st INNER JOIN 
		dbo.Band b ON b.BandId = st.BandId		
    WHERE
        CallLetters = @CallLetters AND b.BandName = @Band

    SELECT @@ROWCOUNT
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationAssociates_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_StationAssociates_Get]
(
    @StationId BIGINT,
	@HDFlag CHAR(1)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        s.StationId,
		s.CallLetters + '-' + b.BandName As CallLetters,
		s.BandId,
		b.BandName,
		s.Frequency,
		s.RepeaterStatusId,
		RepeaterStatusName,
		s.FlagshipStationId,
		flagSS.CallLetters + '-' + b1.BandName As FlagshipStationName,
		/*s.PrimaryUserId,*/
		s.MemberStatusId,
		memS.MemberStatusName,
		/*minS.MinorityStatusId,
		MinorityStatusName,
		StatusDate,*/
		s.LicenseeTypeId,
		lType.LicenseeTypeName,
		s.LicenseeName,
		/*s.AddressLine1,
		s.AddressLine2,*/
		s.City,
		s.StateId,
		[State].Abbreviation As StateAbbreviation,
		/*County,
		Country,
		ZipCode,
		Phone,
		Fax,
		Email,
		WebPage,
		TSACume,
		TSAAQH,
		s.MetroMarketId,
		metM.MarketName As MetroMarketName,*/
		s.MetroMarketRank,
		/*s.DMAMarketId,
		dmaM.MarketName As DMAMarketName,*/
		s.DMAMarketRank,
		/*s.TimeZoneId,
		tZone.DisplayName As TimeZoneName,
		HoursFromFlagship,
		MaxNumberOfUsers,*/
		STUFF(
			(
				SELECT ', ' + a.AffiliateCode
				FROM dbo.Affiliate a
				JOIN dbo.StationAffiliate sa ON sa.AffiliateId = a.AffiliateId
				WHERE sa.StationId = s.StationId
				ORDER BY a.AffiliateCode
				FOR XML PATH('')
			), 1, 1, '') AS AffiliateCodesList,
		CASE WHEN s.DisabledDate IS NULL THEN 'Enabled' ELSE 'Disabled' END As EnabledInd,
		s.DisabledDate,
		s.DisabledUserId,
		s.CreatedDate,
		s.CreatedUserId,
		s.LastUpdatedDate,
		s.LastUpdatedUserId

    FROM
		dbo.Station s INNER JOIN
		dbo.Station FlagSS ON s.FlagshipStationId = FlagSS.StationId INNER JOIN 
		dbo.Band b ON s.BandId = b.BandId INNER JOIN
		dbo.RepeaterStatus rs ON s.RepeaterStatusId = rs.RepeaterStatusId INNER JOIN
		dbo.MemberStatus memS ON s.MemberStatusId = memS.MemberStatusId INNER JOIN
		dbo.MinorityStatus minS ON s.MinorityStatusId = minS.MinorityStatusId INNER JOIN
		dbo.LicenseeType lType ON s.LicenseeTypeId = lType.LicenseeTypeId LEFT JOIN
		dbo.[State] ON s.StateId = [State].StateId LEFT JOIN
		dbo.MetroMarket metM ON s.MetroMarketId = metM.MetroMarketId LEFT JOIN
		dbo.DMAMarket dmaM ON s.DMAMarketId = dmaM.DMAMarketId INNER JOIN
		dbo.TimeZone tZone ON s.TimeZoneId = tZone.TimeZoneId LEFT JOIN
		dbo.Band b1 ON FlagSS.BandId = b1.BandId
    WHERE
        s.FlagshipStationId = @StationId AND 
		/* Retrieve HD vs non-HD stations */
		s.BandId IN (
			SELECT 
				BandId
			FROM
				dbo.Band
			WHERE
				BandName like CASE WHEN @HDFlag = 'Y' THEN '%HD%' ELSE '%M' END)
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationDataReport_GET]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_StationDataReport_GET]
(
	@StationEnabled VARCHAR(2),
	@BandSpan VARCHAR(MAX),
	@RepeaterStatus VARCHAR(50)
)
WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON
DECLARE
		@DynSql NVARCHAR(MAX)=
	'
			SELECT s.CallLetters + ''-'' +b.BandName Station,st.StateName, s.City,s.Frequency,m.MemberStatusName, s.MetroMarketRank, s.DmaMarketRank
			From dbo.Station AS s
			INNER JOIN dbo.Band AS b ON b.BandId=s.BandId
			INNER JOIN dbo.State AS st ON st.StateId=s.StateId
			INNER JOIN dbo.MemberStatus AS m ON m.MemberStatusId=s.MemberStatusId
			INNER JOIN dbo.RepeaterStatus AS r ON r.RepeaterStatusId=s.RepeaterStatusId
			WHERE 
			b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'
			IF(@StationEnabled='Y')
				BEGIN
					SET @DynSql= @DynSql + ' AND s.DisabledDate IS NULL'
				END
			ELSE IF (@StationEnabled='N')
				BEGIN
					SET @DynSql= @DynSql + ' AND s.DisabledDate IS NOT NULL'
				END
				
			IF(@RepeaterStatus='1' OR @RepeaterStatus='2' OR @RepeaterStatus='3' )
				BEGIN
					SET @DynSql= @DynSql + ' AND s.RepeaterStatusId= '''+ CONVERT(VARCHAR, @RepeaterStatus) +'''' 
				END	
			ELSE
			SET @DynSql= @DynSql + ' AND s.RepeaterStatusId IN (' + REPLACE(@RepeaterStatus, '|', '''') + ') '
				
						
		SET @DynSql=@DynSql + ' Order By Station,st.StateNAme , s.City'

		Print @DynSql
		EXEC(@DynSql )
		
	END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationDetail_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_StationDetail_Get]
(
    @StationId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StationId,
		CallLetters,
		S.BandId,
		BandName,
		Frequency,
		s.RepeaterStatusId,
		RepeaterStatusName,
		FlagshipStationId,
		s.CallLetters + '-' + b.BandName As FlagshipStationName,
		PrimaryUserId,
		s.MemberStatusId,
		memS.MemberStatusName,
		minS.MinorityStatusId,
		MinorityStatusName,
		StatusDate,
		s.LicenseeTypeId,
		lType.LicenseeTypeName,
		LicenseeName,
		AddressLine1,
		AddressLine2,
		City,
		s.StateId,
		[State].Abbreviation As StateAbbreviation,
		County,
		Country,
		ZipCode,
		Phone,
		Fax,
		Email,
		WebPage,
		TSACume,
		TSAAQH,
		s.MetroMarketId,
		metM.MarketName As MetroMarketName,
		MetroMarketRank,
		s.DMAMarketId,
		dmaM.MarketName As DMAMarketName,
		DMAMarketRank,
		s.TimeZoneId,
		tZone.DisplayName As TimeZoneName,
		HoursFromFlagship,
		MaxNumberOfUsers,
		STUFF(
			(
				SELECT ', ' + a.AffiliateCode
				FROM dbo.Affiliate a
				JOIN dbo.StationAffiliate sa ON sa.AffiliateId = a.AffiliateId
				WHERE sa.StationId = s.StationId
				ORDER BY a.AffiliateCode
				FOR XML PATH('')
			), 1, 1, '') AS AffiliateCodesList,
		s.DisabledDate,
		s.DisabledUserId,
		s.CreatedDate,
		s.CreatedUserId,
		s.LastUpdatedDate,
		s.LastUpdatedUserId

    FROM
		dbo.Station s INNER JOIN
		dbo.Band b ON s.BandId = b.BandId INNER JOIN
		dbo.RepeaterStatus rs ON s.RepeaterStatusId = rs.RepeaterStatusId INNER JOIN
		dbo.MemberStatus memS ON s.MemberStatusId = memS.MemberStatusId INNER JOIN
		dbo.MinorityStatus minS ON s.MinorityStatusId = minS.MinorityStatusId INNER JOIN
		dbo.LicenseeType lType ON s.LicenseeTypeId = lType.LicenseeTypeId LEFT JOIN
		dbo.[State] ON s.StateId = [State].StateId LEFT JOIN
		dbo.MetroMarket metM ON s.MetroMarketId = metM.MetroMarketId LEFT JOIN
		dbo.DMAMarket dmaM ON s.DMAMarketId = dmaM.DMAMarketId INNER JOIN
		dbo.TimeZone tZone ON s.TimeZoneId = tZone.TimeZoneId
    WHERE
        StationId = @StationId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationLinkPrimaryUser_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[PSP_StationLinkPrimaryUser_Get]

	@StationId BIGINT
	
AS BEGIN

    SET NOCOUNT ON

    SELECT
        
		FirstName , MiddleName , LastName 
		
	FROM
	
        dbo.CRCUser

     WHERE
	 
        UserId 
		 
		 in
		 
		( select primaryuserid from dbo.station where StationId = @StationId )	

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_StationLinkStatus_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[PSP_StationLinkStatus_Get]

	@StationId BIGINT,
	@UserId BIGINT

AS BEGIN

    SET NOCOUNT ON

    SELECT
        
		StationUserId
		
	FROM
        dbo.StationUser

     WHERE
	 
        StationId = @StationId
		AND
		UserId = @UserId

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_StationListAsMemberBand_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_StationListAsMemberBand_Get]
(
	@BandSpan VARCHAR(220),
	@MemberStatusName VARCHAR(100),
	@StationEnabled VARCHAR(50)
)

WITH EXECUTE AS OWNER

AS BEGIN
    
		SET NOCOUNT ON
	
	DECLARE 
	@DynSql NVARCHAR(MAX) =
	
	'SELECT s.CallLetters + ''-'' +b.BandName  Station from dbo.Station as s
		INNER JOIN dbo.Band As b on b.BandId=s.BandId
		INNER JOIN dbo.MemberStatus As m on m.MemberStatusId=s.MemberStatusId
		WHERE b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'
		IF (@MemberStatusName <> '')
			SET @DynSql= @DynSql + ' AND m.MemberStatusName= '''+ CONVERT(VARCHAR, @MemberStatusName) +'''' 
								
		IF(@StationEnabled='Y')
		
		set @DynSql= @DynSql + ' AND s.DisabledDate IS NULL'
		
		ELSE IF (@StationEnabled='N')
		
				SET @DynSql= @DynSql + ' AND s.DisabledDate IS NOT NULL'
		
		EXEC(@DynSql)
END
GO
/****** Object:  StoredProcedure [dbo].[PSP_StationListForGrid_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


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
/****** Object:  StoredProcedure [dbo].[PSP_StationNote_Del]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_StationNote_Del]
(
	@StationNoteId BIGINT,
	@DeletedDate Datetime,
	@DeletedUserId BIGINT
)
AS BEGIN
    SET NOCOUNT ON

    UPDATE
		dbo.StationNote
	SET
		DeletedDate = @DeletedDate,
		DeletedUserId = @DeletedUserId,
		LastUpdatedDate = @DeletedDate,
		LastUpdatedUserId = @DeletedUserId
	WHERE
		StationNoteId = @StationNoteId
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationNote_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_StationNote_Get]
(
    @StationNoteId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StationNoteId,
		StationId,
		NoteText,
		DeletedDate,
		DeletedUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
    FROM
        dbo.StationNote
    WHERE
        StationNoteId = @StationNoteId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationNote_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_StationNote_Save]
(
    @StationNoteId BIGINT,
	@StationId BIGINT,
	@NoteText VARCHAR(MAX),
	@DeletedDate DATETIME,
	@DeletedUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.StationNote
    SET
        StationId = @StationId,
		NoteText = @NoteText,
		DeletedDate = @DeletedDate,
		DeletedUserId = @DeletedUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        StationNoteId = @StationNoteId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.StationNote
        (
            StationId,
			NoteText,
			DeletedDate,
			DeletedUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @StationId,
			@NoteText,
			@DeletedDate,
			@DeletedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @StationNoteId = SCOPE_IDENTITY()

    END

    SELECT @StationNoteId AS StationNoteId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationNotes_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_StationNotes_Get]
(
	@StationId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StationNoteId,
		StationId,
		NoteText,
		DeletedDate,
		DeletedUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.StationNote

	WHERE
		StationId = @StationId AND
		DeletedDate IS NULL
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationNotesReport_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_StationNotesReport_Get]
(
	@StationId BIGINT,
	@Keyword VARCHAR(50),
	@LastUpdatedFromDate DateTime,
	@LastUpdatedToDate DateTime,
	@DeletedInd CHAR(1),
	@DebugInd CHAR(1)
)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
	SELECT
		staN.StationId,
		staN.StationNoteId,
		CallLetters + ''-'' + BandName As StationName,
		NoteText,
		staN.LastUpdatedDate,
		staN.LastUpdatedUserId,
		dbo.FN_GetUserDisplayName(staN.LastUpdatedUserId) As LastUpdatedUser,
		staN.DeletedDate,
		staN.DeletedUserId

	FROM
		dbo.StationNote staN INNER JOIN
		dbo.Station sta ON staN.StationId = sta.StationId INNER JOIN
		dbo.Band b ON sta.BandId = b.BandId
	WHERE '

	IF @DeletedInd = 'Y'
		SET @DynSql = @DynSql + ' DeletedUserId IS NOT NULL'
	ELSE
		SET @DynSql = @DynSql + ' DeletedUserId IS NULL'

	IF @StationId IS NOT NULL
		SET @DynSql = @DynSql + ' AND staN.StationId = @StationId'

	IF @Keyword IS NOT NULL
		SET @DynSql = @DynSql + ' AND staN.NoteText LIKE ''%'' + RTRIM(LTRIM(@Keyword)) + ''%'''

	IF @LastUpdatedFromDate IS NOT NULL AND @LastUpdatedToDate IS NOT NULL
		SET @DynSql = @DynSql + ' AND CONVERT(DateTime, CONVERT(VARCHAR(10), staN.LastUpdatedDate, 112)) >= @LastUpdatedFromDate AND CONVERT(DateTime, CONVERT(VARCHAR(10), staN.LastUpdatedDate, 112)) <= @LastUpdatedToDate'

	DECLARE @DynParams NVARCHAR(MAX) =
	'
	@StationId BIGINT,
	@Keyword VARCHAR(50),
	@LastUpdatedFromDate DateTime,
	@LastUpdatedToDate DateTime,
	@DeletedInd CHAR(1)
	'

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		EXEC dbo.sp_executesql
		@DynSql,
		@DynParams,
		@StationId = @StationId,
		@Keyword = @Keyword,
		@LastUpdatedFromDate = @LastUpdatedFromDate,
		@LastUpdatedToDate = @LastUpdatedToDate,
		@DeletedInd = @DeletedInd
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Stations_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_Stations_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StationId,
		CallLetters,
		BandId,
		Frequency,
		RepeaterStatusId,
		FlagshipStationId,
		PrimaryUserId,
		MemberStatusId,
		MinorityStatusId,
		StatusDate,
		LicenseeTypeId,
		LicenseeName,
		AddressLine1,
		AddressLine2,
		City,
		StateId,
		County,
		Country,
		Phone,
		Fax,
		Email,
		WebPage,
		TSACume,
		TSAAQH,
		MetroMarketId,
		MetroMarketRank,
		DMAMarketId,
		DMAMarketRank,
		TimeZoneId,
		HoursFromFlagship,
		MaxNumberOfUsers,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Station
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationSearch_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_StationSearch_Get]
(
	@SearchTerm VARCHAR(250)
)

AS BEGIN

    SET NOCOUNT ON

	SELECT
		StationId,
		CallLetters + '-' + BandName AS CallLetters
	FROM
		dbo.Station sta INNER JOIN
		dbo.Band band ON sta.BandId = band.BandId
	WHERE
		CallLetters + '-' + BandName LIKE '%' + REPLACE(@SearchTerm, ' ', '') + '%'
	ORDER BY
		CallLetters
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_StationsEnabledList_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_StationsEnabledList_Get]
(
	@UserId BIGINT
)

AS BEGIN
	
    SET NOCOUNT ON

    SELECT
      
		s.StationId,
		s.CallLetters + '-' + b.BandName AS DisplayName

    FROM
        dbo.Station s

		JOIN dbo.Band b
			ON b.BandId = s.BandId

	WHERE
		(@UserId IS NULL 
		
		OR
		
		EXISTS
		(
			SELECT *
			FROM dbo.StationUser su
			WHERE su.StationId = s.StationId
			AND su.UserId = @UserId
		)
		
		OR
		
		EXISTS
		(
			SELECT *
			FROM dbo.CRCUser
			WHERE UserId = @UserId
			AND AdministratorInd = 'Y'
		))
		
		AND
		s.RepeaterStatusID!=1 And s.DisabledDate is null

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_StationsForUserId_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PSP_StationsForUserId_Get]
(
	@UserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        s.StationId,
		su.UserId,
		CASE
			WHEN s.PrimaryUserId = su.UserId
			THEN 'Y'
			ELSE 'N'
		END AS PrimaryUserInd,
		su.GridWritePermissionsInd,
		s.CallLetters,
		s.BandId,
		s.CallLetters + '-' + b.BandName AS StationDisplayName,
		s.Frequency,
		s.RepeaterStatusId,
		s.FlagshipStationId,
		s.PrimaryUserId,
		s.MemberStatusId,
		s.MinorityStatusId,
		s.StatusDate,
		s.LicenseeTypeId,
		s.LicenseeName,
		s.AddressLine1,
		s.AddressLine2,
		s.City,
		s.StateId,
		s.County,
		s.Country,
		s.Phone,
		s.Fax,
		s.Email,
		s.WebPage,
		s.TSACume,
		s.TSAAQH,
		s.MetroMarketId,
		s.MetroMarketRank,
		s.DMAMarketId,
		s.DMAMarketRank,
		s.TimeZoneId,
		s.HoursFromFlagship,
		s.MaxNumberOfUsers,
		s.DisabledDate,
		s.DisabledUserId,
		s.CreatedDate,
		s.CreatedUserId,
		s.LastUpdatedDate,
		s.LastUpdatedUserId

    FROM
        dbo.Station s

		JOIN dbo.Band b
			ON b.BandId = s.BandId

		JOIN dbo.StationUser su
			ON su.StationId = s.StationId

	WHERE
		su.UserId = @UserId

END



GO
/****** Object:  StoredProcedure [dbo].[PSP_StationsList_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_StationsList_Get]
(
	@UserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        s.StationId,
		s.CallLetters + '-' + b.BandName AS DisplayName

    FROM
        dbo.Station s

		JOIN dbo.Band b
			ON b.BandId = s.BandId

	WHERE
		@UserId IS NULL
		OR
		EXISTS
		(
			SELECT *
			FROM dbo.StationUser su
			WHERE su.StationId = s.StationId
			AND su.UserId = @UserId
		)
		OR
		EXISTS
		(
			SELECT *
			FROM dbo.CRCUser
			WHERE UserId = @UserId
			AND AdministratorInd = 'Y'
		)

END



GO
/****** Object:  StoredProcedure [dbo].[PSP_StationsSearch_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_StationsSearch_Get]
(
	@StationId BIGINT,
	@RepeaterStatusId BIGINT,
	@MetroMarketId BIGINT,
	@Enabled VARCHAR(50),
	@MemberStatusId BIGINT,
	@DMAMarketId BIGINT,
	@BandId BIGINT,
	@StateId BIGINT,
	@LicenseeTypeId BIGINT,
	@AffiliateId BIGINT,
	@DebugInd CHAR(1) = 'N'
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
    SELECT
        s.StationId,
		s.CallLetters + ''-'' + b.BandName AS StationDisplayName,
		rs.RepeaterStatusName,
		s.FlagshipStationId,
		fs.CallLetters + ''-'' + fsb.BandName AS FlagshipStationDisplayName,
		s.City,
		st.Abbreviation AS StateAbbreviation,
		s.Frequency,
		ms.MemberStatusName,
		s.MetroMarketRank,
		s.DMAMarketRank,
		lt.LicenseeTypeName,
		STUFF(
			(
				SELECT '', '' + a.AffiliateCode
				FROM dbo.Affiliate a
				JOIN dbo.StationAffiliate sa ON sa.AffiliateId = a.AffiliateId
				WHERE sa.StationId = s.StationId
				ORDER BY a.AffiliateCode
				FOR XML PATH('''')
			), 1, 1, '''') AS AffiliateCodesList,
		CASE
			WHEN s.DisabledDate IS NULL
			THEN ''Yes''
			ELSE ''No''
		END AS EnabledInd

    FROM
        dbo.Station s

		JOIN dbo.Band b
			ON b.BandId = s.BandId

		JOIN dbo.RepeaterStatus rs
			ON rs.RepeaterStatusId = s.RepeaterStatusId
    
		LEFT JOIN dbo.Station fs
			ON fs.StationId = s.FlagshipStationId

		LEFT JOIN dbo.Band fsb
			ON fsb.BandId = fs.BandId

		LEFT JOIN dbo.State st
			ON st.StateId = s.StateId

		JOIN dbo.MemberStatus ms
			ON ms.MemberStatusId = s.MemberStatusId

		JOIN dbo.LicenseeType lt
			ON lt.LicenseeTypeId = s.LicenseeTypeId

	WHERE 1=1
	'
	
	IF @Enabled = 'YES'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NULL'
	ELSE IF @Enabled = 'NO'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NOT NULL'

	IF @StationId IS NOT NULL
		SET @DynSql = @DynSql + ' AND s.StationId = @StationId'

	IF @RepeaterStatusId IS NOT NULL
		SET @DynSql = @DynSql + ' AND s.RepeaterStatusId = @RepeaterStatusId'

	IF @MemberStatusId IS NOT NULL
		SET @DynSql = @DynSql + ' AND s.MemberStatusId = @MemberStatusId'

	IF @MetroMarketId IS NOT NULL
		SET @DynSql = @DynSql + ' AND s.MetroMarketId = @MetroMarketId'

	IF @DMAMarketId IS NOT NULL
		SET @DynSql = @DynSql + ' AND s.DMAMarketId = @DMAMarketId'

	IF @BandId IS NOT NULL
		SET @DynSql = @DynSql + ' AND s.BandId = @BandId'

	IF @StateId IS NOT NULL
		SET @DynSql = @DynSql + ' AND s.StateId = @StateId'

	IF @LicenseeTypeId IS NOT NULL
		SET @DynSql = @DynSql + ' AND s.LicenseeTypeId = @LicenseeTypeId'

	IF @AffiliateId IS NOT NULL
		SET @DynSql = @DynSql +
		'
		AND EXISTS
		(
			SELECT *
			FROM dbo.StationAffiliate sa
			WHERE sa.StationId = s.StationId
			AND sa.AffiliateId = @AffiliateId
		)
		'


	DECLARE @DynParams NVARCHAR(MAX) =
	'
	@StationId BIGINT,
	@RepeaterStatusId BIGINT,
	@MetroMarketId BIGINT,
	@MemberStatusId BIGINT,
	@DMAMarketId BIGINT,
	@BandId BIGINT,
	@StateId BIGINT,
	@LicenseeTypeId BIGINT,
	@AffiliateId BIGINT
	'

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		EXEC dbo.sp_executesql
			@DynSql,
			@DynParams,
			@StationId = @StationId,
			@RepeaterStatusId = @RepeaterStatusId,
			@MetroMarketId = @MetroMarketId,
			@MemberStatusId = @MemberStatusId,
			@DMAMarketId = @DMAMarketId,
			@BandId = @BandId,
			@StateId = @StateId,
			@LicenseeTypeId = @LicenseeTypeId,
			@AffiliateId = @AffiliateId

END



GO
/****** Object:  StoredProcedure [dbo].[PSP_StationUser_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_StationUser_Get]
(
    @StationId BIGINT,
	@UserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        su.StationUserId,
		su.StationId,
		su.UserId,
		su.GridWritePermissionsInd,
		CASE
			WHEN su.UserId =
			(
				SELECT s.PrimaryUserId
				FROM dbo.Station s
				WHERE s.StationId = su.StationId
			)
			THEN 'Y'
			ELSE 'N'
		END AS PrimaryUserInd,
		su.CreatedDate,
		su.CreatedUserId,
		su.LastUpdatedDate,
		su.LastUpdatedUserId

    FROM
        dbo.StationUser su

    WHERE
        su.StationId = @StationId
		AND
		su.UserId = @UserId

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_StationUser_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_StationUser_Save]
(
	@StationId BIGINT,
	@UserId BIGINT,
	@PrimaryUserInd CHAR(1),
	@GridWritePermissionsInd CHAR(1),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.StationUser
    SET
		GridWritePermissionsInd = @GridWritePermissionsInd,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        StationId = @StationId
		AND
		UserId = @UserId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.StationUser
        (
            StationId,
			UserId,
			GridWritePermissionsInd,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @StationId,
			@UserId,
			@GridWritePermissionsInd,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

    END

	IF @PrimaryUserInd = 'Y'
	BEGIN
		UPDATE dbo.Station
		SET PrimaryUserId = @UserId
		WHERE StationId = @StationId
	END
	ELSE BEGIN
		UPDATE dbo.Station
		SET PrimaryUserId = NULL
		WHERE StationId = @StationId
		AND PrimaryUserId = @UserId
	END

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_StationUsers_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_StationUsers_Get]
(
	@StationId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StationUserId,
		StationId,
		su.UserId,
		su.UserId As UserName,
		dbo.FN_GetUserDisplayName(crcu.UserId) As CRCName,
		crcu.Email,
		crcu.Phone,
		CASE 
			WHEN GridWritePermissionsInd IS NOT NULL OR GridWritePermissionsInd = 'Y'
			THEN 'Yes'
			ELSE 'No'
		END As GridWritePermissionsInd,
		CASE
			WHEN su.UserId =
			(
				SELECT s.PrimaryUserId
				FROM dbo.Station s
				WHERE s.StationId = @StationId
			)
			THEN 'Yes'
			ELSE 'No'
		END AS PrimaryUserInd,
		su.CreatedDate,
		su.CreatedUserId,
		su.LastUpdatedDate,
		su.LastUpdatedUserId

    FROM
        dbo.StationUser su INNER JOIN
		dbo.CRCUser crcu ON su.UserId = crcu.UserId

	WHERE
		StationId = @StationId
    
END


GO
/****** Object:  StoredProcedure [dbo].[PSP_StationUsersReport_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PSP_StationUsersReport_Get]
(
	@UserPermission CHAR(1),
	@BandSpan VARCHAR(100),
	@RepeaterStatus CHAR(1),
	@DebugInd CHAR(1)
)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @RepeaterStatusName VARCHAR(100);

	SELECT  @RepeaterStatusName = 
		CASE @RepeaterStatus 
			WHEN 'F' THEN 'FlagShip'
			WHEN 'R' THEN '100% Repeater'
			WHEN 'N' THEN 'Non-100% Repeater'
			WHEN 'A' THEN 'Flagship'', ''Non-100% (Partial) Repeater'
		END

	DECLARE @DynSql NVARCHAR(MAX) =
	'
	SELECT
		sta.CallLetters + ''-'' + b.BandName As Station,
		r.RepeaterStatusName As [Repeater Status],
		crcU.FirstName + ISNULL('' '' + crcU.MiddleName, '' '' ) + crcU.LastName + ISNULL('' '' + crcU.Suffix, '''') As [Name],
		crcU.Email As [User Name],
		crcU.Phone As Telephone,
		crcU.Fax,
		crcU.Email
	FROM 
		dbo.StationUser staU INNER JOIN
		dbo.CRCUser crcU ON staU.UserId = crcU.UserId INNER JOIN
		dbo.Station sta ON staU.StationId = sta.StationId INNER JOIN
		dbo.Band b ON sta.BandId = b.BandId INNER JOIN
		dbo.RepeaterStatus r ON sta.RepeaterStatusId = r.RepeaterStatusId
	WHERE
		staU.GridWritePermissionsInd = ''Y''
		AND crcU.DisabledUserId IS NULL'
	
		IF @UserPermission = 'P'
			SET @DynSql = @DynSql + ' AND sta.PrimaryUserId = staU.UserId'
	
		SET @DynSql = @DynSql + 
		' AND b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')' +
		' AND r.RepeaterStatusName IN (''' + @RepeaterStatusName + ''')
		
		ORDER BY sta.CallLetters + ''-'' + b.BandName
		'
	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		EXEC dbo.sp_executesql @DynSql 
	
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_Test]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_Test]

	AS BEGIN

    	
		DECLARE

		@sql NVARCHAR(MAX);

		set @sql = 'SELECT

	
		st.CallLetters, b.BandName AS Station,
	 
		s.Abbreviation , st.city , ms.MemberStatusName , st.MetroMarketRank , st.DMAMarketRank 
  
  FROM dbo.Schedule as sc
  
	LEFT JOIN Station as st ON st.StationId = sc.StationId
	
	LEFT JOIN ScheduleProgram as sp ON sp.ScheduleId = sc.ScheduleId
	
	INNER JOIN State as s ON s.StateId = st.StateId
	
	LEFT JOIN Band as b ON b.bandid = st.BandId
	
	INNER JOIN MemeberState ms ON ms.MemberStateId = st.MemberStatusId
	
	WHERE 
	
		sc.Year = 2014';

		set @sql = @sql + ' AND sc.Month = 2';

END


GO
/****** Object:  StoredProcedure [dbo].[PSP_TestCarriageListByProgramReport_GET]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	
CREATE PROCEDURE [dbo].[PSP_TestCarriageListByProgramReport_GET]
(
	@ProgramType VARCHAR(50),
	@BandSpan VARCHAR(MAX),
	@StationEnabled VARCHAR(2),
	@MemberStatusName VARCHAR(50)
	
)
WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON
DECLARE
		@DynSql NVARCHAR(MAX)=
'		
	SELECT DISTINCT
	p.ProgramName, ps.ProgramSourceName, pf.ProgramFormatTypeName, mf.MajorFormatName, sp.StartTime, sp.EndTime
	FROM dbo.Program AS p
	INNER JOIN  dbo.ProgramSource AS ps ON ps.ProgramSourceId = p.ProgramSourceId
	INNER JOIN  dbo.ProgramFormatType AS pf ON pf.ProgramFormatTypeId = p.ProgramFormatTypeId	
	INNER JOIN  dbo.MajorFormat AS mf ON mf.MajorFormatId = pf.MajorFormatId
	INNER JOIN  dbo.ScheduleProgram AS sp ON sp.ProgramId = p.ProgramId
	LEFT JOIN  dbo.ScheduleNewscast AS sc ON sc.ScheduleId = sp.ScheduleId
	INNER JOIN  dbo.Schedule AS s ON s.ScheduleId = sp.ScheduleId
	INNER JOIN  dbo.Station AS st ON st.StationId = s.StationId
	INNER JOIN 	dbo.Band AS b ON b.BandId=st.BandId
	INNER JOIN  dbo.MemberStatus As m ON m.MemberStatusId = st.MemberStatusId
	WHERE 
	p.ProgramName NOT LIKE ''%Off Air%'' AND b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'
	
	IF(@ProgramType='Regular')
		BEGIN 
			SET @DynSql= @DynSql +' AND sc.ScheduleNewscastId IS NULL' 
		END
	ELSE IF(@ProgramType='NprNewsCast')
		BEGIN 
			SET @DynSql= @DynSql +' AND sc.ScheduleNewscastId IS NOT NULL' 
		END
		
	IF(@MemberStatusName <> '')	
		BEGIN
			SET @DynSql = @DynSql + ' AND m.MemberStatusName= '''+ CONVERT(VARCHAR, @MemberStatusName) +'''' 
		END
		
	IF(@StationEnabled='Y')
		SET @DynSql= @DynSql + ' AND st.DisabledDate IS NULL'
	ELSE IF (@StationEnabled='N')
		SET @DynSql= @DynSql + ' AND st.DisabledDate IS NOT NULL'	
		
		Print @DynSql
	END
GO
/****** Object:  StoredProcedure [dbo].[PSP_TimeZone_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_TimeZone_Get]
(
    @TimeZoneId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        TimeZoneId,
		TimeZoneCode,
		DisplayName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.TimeZone

    WHERE
        TimeZoneId = @TimeZoneId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_TimeZone_Save]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_TimeZone_Save]
(
    @TimeZoneId BIGINT,
	@TimeZoneCode VARCHAR(50),
	@DisplayName VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.TimeZone
    SET
        TimeZoneCode = @TimeZoneCode,
		DisplayName = @DisplayName,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        TimeZoneId = @TimeZoneId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.TimeZone
        (
            TimeZoneCode,
			DisplayName,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @TimeZoneCode,
			@DisplayName,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @TimeZoneId = SCOPE_IDENTITY()

    END

    SELECT @TimeZoneId AS TimeZoneId

END

GO
/****** Object:  StoredProcedure [dbo].[PSP_TimeZones_Get]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PSP_TimeZones_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        TimeZoneId,
		TimeZoneCode,
		DisplayName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.TimeZone
    
END

GO
/****** Object:  StoredProcedure [dbo].[PSP_UpdateStationPrimaryId]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PSP_UpdateStationPrimaryId]
(
	
	@StationId BIGINT
)
AS BEGIN

    SET NOCOUNT ON
		
		UPDATE dbo.Station set PrimaryUserId=NULL where StationId=@StationId
END


GO
/****** Object:  StoredProcedure [dbo].[PSP_UserStationLink_Del]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE [dbo].[PSP_UserStationLink_Del]
(
	@UserId BIGINT,
	@StationId BIGINT	
)
AS BEGIN

    SET NOCOUNT ON

	DELETE FROM dbo.StationUser
	WHERE
	UserId = @UserId
	AND
	StationId=@StationId
END

GO
/****** Object:  StoredProcedure [dbo].[Station_Off]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Station_Off]
(
@StartTime VARCHAR(20),
@EndTime VARCHAR(20),
@SundayInd VARCHAR(1),
@MondayInd VARCHAR(1),
@TuesdayInd VARCHAR(1),
@WednesdayInd VARCHAR(1),
@ThursdayInd VARCHAR(1),
@FridayInd VARCHAR(1),
@SaturdayInd VARCHAR(1),
@Monthh BIGINT,
@Yearr BIGINT,
@RepeaterStatusId BIGINT,
@NPRMemberShipInd varchar(1),
@StationId BIGINT
)
AS BEGIN
SET NOCOUNT ON
SELECT
	 
		st.CallLetters + '-' + b.BandName AS Station, 
		s.Abbreviation , st.city , ms.MemberStatusName , st.MetroMarketRank AS Metro , st.DMAMarketRank AS DMA
  	,SUM(DATEDIFF(MINUTE, sp.StartTime, sp.EndTime)/15) AS OffAirProgram 
	
		FROM dbo.Schedule as sc
		INNER JOIN Station as st ON st.StationId = sc.StationId
		INNER JOIN ScheduleProgram as sp ON sp.ScheduleId = sc.ScheduleId
		INNER JOIN Program as p ON p.ProgramId = sp.ProgramId
		INNER JOIN ProgramFormatType as pft ON pft.ProgramFormatTypeId = p.ProgramFormatTypeId
		INNER JOIN MajorFormat as mf ON mf.MajorFormatId = pft.MajorFormatId
		INNER JOIN State as s ON s.StateId = st.StateId
		INNER JOIN Band as b ON b.bandid = st.BandId
		INNER JOIN MemberStatus ms ON ms.MemberStatusId = st.MemberStatusId
		
WHERE

(sp.SundayInd=@SundayInd OR @SundayInd='') AND (sp.MondayInd=@MondayInd OR @MondayInd='') AND (sp.TuesdayInd=@TuesdayInd OR @TuesdayInd='') AND (sp.WednesdayInd=@WednesdayInd OR @WednesdayInd='') AND (sp.ThursdayInd=@ThursdayInd OR @ThursdayInd='') AND (sp.FridayInd=@FridayInd OR @FridayInd='') AND (sp.SaturdayInd=@SaturdayInd OR
 @SaturdayInd='') 
AND
(sp.StartTime>=@StartTime OR @StartTime='') AND (sp.EndTime<=@EndTime OR @EndTime='') 
AND
(sc.Month=@Monthh OR @Monthh='') 
AND
(sc.Year=@Yearr OR @Yearr='')
AND
(st.RepeaterStatusId = @RepeaterStatusId OR @RepeaterStatusId='')  
AND
(ms.NPRMembershipInd = @NPRMembershipInd OR @NPRMembershipInd='')
AND
(st.StationId = @StationId OR @StationId ='')
AND
(sc.Status='Accepted') AND p.ProgramName like '%Off Air%' OR p.ProgramName like '%Off-Air%'
 
GROUP BY st.CallLetters, b.BandName,
s.Abbreviation, st.City, ms.MemberStatusName , 
st.MetroMarketRank , st.DMAMarketRank
ORDER BY s.Abbreviation, st.City
END


GO
/****** Object:  StoredProcedure [dbo].[Station_Regular]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Station_Regular]
(
@StartTime VARCHAR(20),
@EndTime VARCHAR(20),
@SundayInd VARCHAR(1),
@MondayInd VARCHAR(1),
@TuesdayInd VARCHAR(1),
@WednesdayInd VARCHAR(1),
@ThursdayInd VARCHAR(1),
@FridayInd VARCHAR(1),
@SaturdayInd VARCHAR(1),
@Monthh BIGINT,
@Yearr BIGINT,
@RepeaterStatusId BIGINT,
@NPRMemberShipInd varchar(1),
@StationId BIGINT
)
AS BEGIN
SET NOCOUNT ON
SELECT
	 
		st.CallLetters + '-' + b.BandName AS Station, 
	 
		s.Abbreviation , st.city , ms.MemberStatusName , st.MetroMarketRank AS Metro , st.DMAMarketRank AS DMA ,

		SUM(DATEDIFF(MINUTE, sp.StartTime, sp.EndTime)/15) AS RegularProgram
  
		FROM dbo.Schedule as sc
  
		INNER JOIN Station as st ON st.StationId = sc.StationId
		INNER JOIN 
		(
			SELECT * FROM ScheduleProgram sp1 WHERE ScheduleProgramId IN 
			(
				SELECT 
					ScheduleProgramId 
				FROM 
					ScheduleProgram sp2
				WHERE 
					((StartTime <= @StartTime AND EndTime >= @StartTime ) OR (StartTime < @EndTime AND EndTime >= @EndTime) OR (StartTime >= @StartTime AND EndTime <= @EndTime))
			)
		) sp ON sp.ScheduleId = sc.ScheduleId
		INNER JOIN Program as p ON p.ProgramId = sp.ProgramId
		INNER JOIN ProgramFormatType as pft ON pft.ProgramFormatTypeId = p.ProgramFormatTypeId
		INNER JOIN MajorFormat as mf ON mf.MajorFormatId = pft.MajorFormatId
		INNER JOIN State as s ON s.StateId = st.StateId
		INNER JOIN Band as b ON b.bandid = st.BandId
		INNER JOIN MemberStatus ms ON ms.MemberStatusId = st.MemberStatusId
WHERE 
(st.stationId = @StationId OR @StationId=0)
AND
(st.RepeaterStatusId = @RepeaterStatusId OR @RepeaterStatusId=0)  
AND
(ms.NPRMembershipInd = @NPRMembershipInd OR @NPRMembershipInd='')
AND
(sc.Status='Accepted')
AND 
p.ProgramName not like '%Off-Air%' 

GROUP BY st.CallLetters, b.BandName,
s.Abbreviation, st.City, ms.MemberStatusName , 
st.MetroMarketRank , st.DMAMarketRank

ORDER BY s.Abbreviation, st.City
END

GO
/****** Object:  StoredProcedure [dbo].[Test]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Test]
(
	@BandSpan VARCHAR(200),
	@MemberStatusName VARCHAR(100),
	@StationEnabled VARCHAR(50)
)
WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
	SELECT s.CallLetters  + ''-'' + b.BandName from dbo.Station as s
		INNER JOIN dbo.Band As b on b.BandId=s.BandId
		INNER JOIN dbo.MemberStatus As m on m.MemberStatusId=s.MemberStatusId
	WHERE
		m.MemberStatusName= @MemberStatusName ' + 
		'AND
		b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'
		
	IF @StationEnabled='Y'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NULL'
	IF @StationEnabled='N'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NOT NULL'
	IF @StationEnabled='B'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NOT NULL OR s.DisabledDate IS NULL'
	
	EXECUTE @DynSql

END



GO
/****** Object:  StoredProcedure [dbo].[Test_Dynamic]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[Test_Dynamic]
(
	@TableName varchar(200)
)
WITH EXECUTE AS OWNER
 AS BEGIN

 SET NOCOUNT ON
 DECLARE
 @DynSql NVARCHAR(MAX)=
 
				'Select * from ' + @TableName

	EXEC(@DynSql)		
	END

GO
/****** Object:  StoredProcedure [dbo].[Test_Dynamic1]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Test_Dynamic1]
(
	@TableName varchar(200)
)	
WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON
DECLARE 
@DynSql NVARCHAR(MAX)
set @DynSql=''
If(@TableName='Program')
BEGIN
	SET @DynSql='Select * from ' + @TableName
END
ELSE
		SET @DynSql='Select * from ' + @TableName + 'WHERE ProgramName not like'+'%Off Air%'

EXEC(@DynSql)
END

GO
/****** Object:  StoredProcedure [dbo].[Test_Station]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Test_Station]
(
@StartTime VARCHAR(20),
@EndTime VARCHAR(20),
@SundayInd VARCHAR(1),
@MondayInd VARCHAR(1),
@TuesdayInd VARCHAR(1),
@WednesdayInd VARCHAR(1),
@ThursdayInd VARCHAR(1),
@FridayInd VARCHAR(1),
@SaturdayInd VARCHAR(1),
@Monthh BIGINT,
@Yearr BIGINT,
@RepeaterStatusId BIGINT,
@NPRMemberShipInd varchar(1),
@StationId BIGINT
)
AS BEGIN
SET NOCOUNT ON
	SELECT
		st.CallLetters + '-' + b.BandName AS Station, 
		s.Abbreviation, 
		st.city, 
		ms.MemberStatusName, 
		st.MetroMarketRank AS Metro,
		st.DMAMarketRank AS DMA,
		SUM(DATEDIFF(MINUTE, sp.StartTime, sp.EndTime)/15) AS Summation, 
		mf.MajorFormatCode 
  
	FROM 
		dbo.Schedule as sc INNER JOIN 
		dbo.Station st ON st.StationId = sc.StationId INNER JOIN 
		(
			SELECT * FROM ScheduleProgram sp1 WHERE ScheduleProgramId IN 
			(
				SELECT 
					ScheduleProgramId 
				FROM 
					ScheduleProgram sp2
				WHERE 
					((StartTime <= @StartTime AND EndTime >= @StartTime ) OR (StartTime < @EndTime AND EndTime >= @EndTime) OR (StartTime >= @StartTime AND EndTime <= @EndTime))
			)
		) sp ON sp.ScheduleId = sc.ScheduleId INNER JOIN 
		dbo.Program p ON p.ProgramId = sp.ProgramId INNER JOIN 
		dbo.ProgramFormatType pft ON pft.ProgramFormatTypeId = p.ProgramFormatTypeId INNER JOIN 
		dbo.MajorFormat mf ON mf.MajorFormatId = pft.MajorFormatId INNER JOIN 
		dbo.[State] s ON s.StateId = st.StateId INNER JOIN 
		dbo.Band b ON b.bandid = st.BandId INNER JOIN 
		dbo.MemberStatus ms ON ms.MemberStatusId = st.MemberStatusId
	WHERE
		sc.Status='Accepted'
		 AND
		(st.stationId = @StationId OR @StationId=0)
AND
st.RepeaterStatusId = @RepeaterStatusId OR @RepeaterStatusId=0
AND
(ms.NPRMembershipInd = @NPRMembershipInd OR @NPRMembershipInd='')
AND
 (sc.Status='Accepted')

	 GROUP BY 
		st.CallLetters, 
		b.BandName,
		s.Abbreviation, 
		st.City, 
		mf.MajorFormatCode, 
		ms.MemberStatusName , 
		st.MetroMarketRank, 
		st.DMAMarketRank

	ORDER BY s.Abbreviation, st.City
END

GO
/****** Object:  UserDefinedFunction [dbo].[FN_CalculateQuarterHours]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_CalculateQuarterHours](@StartTime varchar(20), @EndTime varchar(20))
RETURNS Numeric(17, 6)
AS
BEGIN
	DECLARE @QuarterHours Numeric(17, 6);

	IF @StartTime = '00:00:00.0000000' AND @EndTime = '23:59:59.0000000'
		SET @QuarterHours = 96;
	ELSE
		SET @QuarterHours = CEILING(datediff(minute, @StartTime, @EndTime)/(15.0));
	RETURN @QuarterHours;
END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GetUserDisplayName]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_GetUserDisplayName]
(
	@UserId BIGINT
)
RETURNS VARCHAR(100)
AS BEGIN

	DECLARE @UserDisplayName VARCHAR(100)

	SELECT @UserDisplayName =
		ISNULL(s.SalutationName + ' ', '') +
		ISNULL(u.FirstName + ' ', '') +
		ISNULL(u.MiddleName + ' ', '') +
		ISNULL(u.LastName + ' ', '') +
		ISNULL(u.Suffix, '')

	FROM
		dbo.CRCUser u

		LEFT JOIN dbo.Salutation s
			ON s.SalutationId = u.SalutationId

	WHERE
		UserId = @UserId

	RETURN @UserDisplayName

END
GO
/****** Object:  Table [dbo].[Affiliate]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Affiliate](
	[AffiliateId] [bigint] IDENTITY(1,1) NOT NULL,
	[AffiliateName] [varchar](50) NOT NULL,
	[AffiliateCode] [varchar](50) NOT NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_Affiliate] PRIMARY KEY CLUSTERED 
(
	[AffiliateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Band]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Band](
	[BandId] [bigint] IDENTITY(1,1) NOT NULL,
	[BandName] [varchar](50) NOT NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_Band] PRIMARY KEY CLUSTERED 
(
	[BandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CarriageType]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CarriageType](
	[CarriageTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[CarriageTypeName] [varchar](50) NOT NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_CarriageType] PRIMARY KEY CLUSTERED 
(
	[CarriageTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CRCUser]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CRCUser](
	[UserId] [bigint] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[PasswordHash] [varbinary](50) NOT NULL,
	[PasswordSalt] [varchar](50) NOT NULL,
	[ResetPasswordHash] [varbinary](50) NULL,
	[SalutationId] [bigint] NULL,
	[FirstName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NOT NULL,
	[Suffix] [varchar](50) NULL,
	[JobTitle] [varchar](50) NULL,
	[AddressLine1] [varchar](50) NULL,
	[AddressLine2] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[StateId] [bigint] NULL,
	[County] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[ZipCode] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[AdministratorInd] [char](1) NOT NULL,
	[CRCManagerInd] [char](1) NOT NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_CRCUser] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DMAMarket]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DMAMarket](
	[DMAMarketId] [bigint] IDENTITY(1,1) NOT NULL,
	[MarketName] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_DMAMarket] PRIMARY KEY CLUSTERED 
(
	[DMAMarketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InfEmail]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InfEmail](
	[InfEmailId] [bigint] IDENTITY(1,1) NOT NULL,
	[FromAddress] [varchar](50) NOT NULL,
	[ToAddress] [varchar](max) NOT NULL,
	[CcAddress] [varchar](max) NULL,
	[BccAddress] [varchar](max) NULL,
	[Priority] [varchar](50) NOT NULL,
	[Subject] [varchar](500) NOT NULL,
	[Body] [varchar](max) NOT NULL,
	[HtmlInd] [char](1) NOT NULL,
	[SentDate] [datetime] NULL,
	[RetryCount] [int] NOT NULL,
	[LastError] [varchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_InfEmail] PRIMARY KEY CLUSTERED 
(
	[InfEmailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InfEmailAttachment]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[InfEmailAttachment](
	[InfEmailAttachmentId] [bigint] IDENTITY(1,1) NOT NULL,
	[InfEmailId] [bigint] NOT NULL,
	[AttachmentName] [varchar](100) NOT NULL,
	[AttachmentBytes] [varbinary](max) NOT NULL,
	[AttachmentSize]  AS (datalength([AttachmentBytes])),
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_InfEmailAttachment] PRIMARY KEY CLUSTERED 
(
	[InfEmailAttachmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InfEmailTemplate]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InfEmailTemplate](
	[InfEmailTemplateId] [bigint] IDENTITY(1,1) NOT NULL,
	[TemplateName] [varchar](50) NOT NULL,
	[FromAddress] [varchar](50) NOT NULL,
	[ToAddress] [varchar](max) NOT NULL,
	[CcAddress] [varchar](max) NULL,
	[BccAddress] [varchar](max) NULL,
	[Subject] [varchar](500) NOT NULL,
	[Body] [varchar](max) NOT NULL,
	[HtmlInd] [char](1) NOT NULL,
	[Priority] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_InfEmailTemplate] PRIMARY KEY NONCLUSTERED 
(
	[InfEmailTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InfLog]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InfLog](
	[InfLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[LogLevel] [int] NOT NULL,
	[Source] [varchar](250) NOT NULL,
	[Message] [varchar](max) NOT NULL,
	[UserName] [varchar](50) NULL,
	[ServerAddress] [varchar](50) NULL,
	[ServerHostname] [varchar](50) NULL,
	[ClientAddress] [varchar](50) NULL,
	[ClientHostname] [varchar](50) NULL,
	[SerialNumber] [varchar](50) NOT NULL,
 CONSTRAINT [PK_InfLog] PRIMARY KEY CLUSTERED 
(
	[InfLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LicenseeType]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LicenseeType](
	[LicenseeTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[LicenseeTypeName] [varchar](50) NOT NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_LicenseeType] PRIMARY KEY CLUSTERED 
(
	[LicenseeTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MajorFormat]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MajorFormat](
	[MajorFormatId] [bigint] IDENTITY(1,1) NOT NULL,
	[MajorFormatName] [varchar](50) NOT NULL,
	[MajorFormatCode] [varchar](50) NOT NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_MajorFormat] PRIMARY KEY CLUSTERED 
(
	[MajorFormatId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MemberStatus]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MemberStatus](
	[MemberStatusId] [bigint] IDENTITY(1,1) NOT NULL,
	[MemberStatusName] [varchar](50) NOT NULL,
	[NPRMembershipInd] [char](1) NOT NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_MemberStatus] PRIMARY KEY CLUSTERED 
(
	[MemberStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MetroMarket]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MetroMarket](
	[MetroMarketId] [bigint] IDENTITY(1,1) NOT NULL,
	[MarketName] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_MetroMarket] PRIMARY KEY CLUSTERED 
(
	[MetroMarketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MinorityStatus]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MinorityStatus](
	[MinorityStatusId] [bigint] IDENTITY(1,1) NOT NULL,
	[MinorityStatusName] [varchar](50) NOT NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_MinorityStatus] PRIMARY KEY CLUSTERED 
(
	[MinorityStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Producer]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Producer](
	[ProducerId] [bigint] IDENTITY(1,1) NOT NULL,
	[SalutationId] [bigint] NULL,
	[FirstName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NOT NULL,
	[Suffix] [varchar](50) NULL,
	[Role] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[Phone] [varchar](50) NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_Producer] PRIMARY KEY CLUSTERED 
(
	[ProducerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Program]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Program](
	[ProgramId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProgramName] [varchar](100) NOT NULL,
	[ProgramSourceId] [bigint] NOT NULL,
	[ProgramFormatTypeId] [bigint] NOT NULL,
	[ProgramCode] [varchar](50) NOT NULL,
	[CarriageTypeId] [bigint] NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_Program] PRIMARY KEY CLUSTERED 
(
	[ProgramId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProgramFormatType]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProgramFormatType](
	[ProgramFormatTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProgramFormatTypeName] [varchar](50) NOT NULL,
	[ProgramFormatTypeCode] [varchar](50) NOT NULL,
	[MajorFormatId] [bigint] NOT NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_ProgramFormatType] PRIMARY KEY CLUSTERED 
(
	[ProgramFormatTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProgramProducer]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramProducer](
	[ProgramProducerId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProgramId] [bigint] NOT NULL,
	[ProducerId] [bigint] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_ProgramProducer] PRIMARY KEY CLUSTERED 
(
	[ProgramProducerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProgramSource]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProgramSource](
	[ProgramSourceId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProgramSourceName] [varchar](50) NOT NULL,
	[ProgramSourceCode] [varchar](50) NOT NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_ProgramSource] PRIMARY KEY CLUSTERED 
(
	[ProgramSourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RepeaterStatus]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RepeaterStatus](
	[RepeaterStatusId] [bigint] IDENTITY(1,1) NOT NULL,
	[RepeaterStatusName] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_RepeaterStatus] PRIMARY KEY CLUSTERED 
(
	[RepeaterStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Salutation]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Salutation](
	[SalutationId] [bigint] IDENTITY(1,1) NOT NULL,
	[SalutationName] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_Salutation] PRIMARY KEY CLUSTERED 
(
	[SalutationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Schedule]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Schedule](
	[ScheduleId] [bigint] IDENTITY(1,1) NOT NULL,
	[StationId] [bigint] NOT NULL,
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Status]  AS (case when [AcceptedDate] IS NOT NULL then 'Accepted' when [SubmittedDate] IS NOT NULL then 'Unaccepted' else 'Unsubmitted' end),
	[SubmittedDate] [datetime] NULL,
	[SubmittedUserId] [bigint] NULL,
	[AcceptedDate] [datetime] NULL,
	[AcceptedUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ScheduleNewscast]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ScheduleNewscast](
	[ScheduleNewscastId] [bigint] IDENTITY(1,1) NOT NULL,
	[ScheduleId] [bigint] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[HourlyInd] [char](1) NOT NULL,
	[DurationMinutes] [int] NULL,
	[SundayInd] [char](1) NOT NULL,
	[MondayInd] [char](1) NOT NULL,
	[TuesdayInd] [char](1) NOT NULL,
	[WednesdayInd] [char](1) NOT NULL,
	[ThursdayInd] [char](1) NOT NULL,
	[FridayInd] [char](1) NOT NULL,
	[SaturdayInd] [char](1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_ScheduleNewscast] PRIMARY KEY CLUSTERED 
(
	[ScheduleNewscastId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ScheduleProgram]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ScheduleProgram](
	[ScheduleProgramId] [bigint] IDENTITY(1,1) NOT NULL,
	[ScheduleId] [bigint] NOT NULL,
	[ProgramId] [bigint] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[QuarterHours]  AS ([dbo].[FN_CalculateQuarterHours]([StartTime],[EndTime])),
	[SundayInd] [char](1) NOT NULL,
	[MondayInd] [char](1) NOT NULL,
	[TuesdayInd] [char](1) NOT NULL,
	[WednesdayInd] [char](1) NOT NULL,
	[ThursdayInd] [char](1) NOT NULL,
	[FridayInd] [char](1) NOT NULL,
	[SaturdayInd] [char](1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_ScheduleProgram] PRIMARY KEY CLUSTERED 
(
	[ScheduleProgramId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[State]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[State](
	[StateId] [bigint] IDENTITY(1,1) NOT NULL,
	[StateName] [varchar](50) NOT NULL,
	[Abbreviation] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED 
(
	[StateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Station]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Station](
	[StationId] [bigint] IDENTITY(1,1) NOT NULL,
	[CallLetters] [varchar](50) NOT NULL,
	[BandId] [bigint] NOT NULL,
	[Frequency] [varchar](50) NOT NULL,
	[RepeaterStatusId] [bigint] NOT NULL,
	[FlagshipStationId] [bigint] NULL,
	[PrimaryUserId] [bigint] NULL,
	[MemberStatusId] [bigint] NOT NULL,
	[MinorityStatusId] [bigint] NOT NULL,
	[StatusDate] [date] NOT NULL,
	[LicenseeTypeId] [bigint] NOT NULL,
	[LicenseeName] [varchar](50) NULL,
	[AddressLine1] [varchar](50) NULL,
	[AddressLine2] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[StateId] [bigint] NULL,
	[County] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[ZipCode] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[WebPage] [varchar](100) NULL,
	[TSACume] [varchar](50) NULL,
	[TSAAQH] [varchar](50) NULL,
	[MetroMarketId] [bigint] NULL,
	[MetroMarketRank] [int] NULL,
	[DMAMarketId] [bigint] NULL,
	[DMAMarketRank] [int] NULL,
	[TimeZoneId] [bigint] NOT NULL,
	[HoursFromFlagship] [int] NULL,
	[MaxNumberOfUsers] [int] NULL,
	[DisabledDate] [datetime] NULL,
	[DisabledUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_Station] PRIMARY KEY CLUSTERED 
(
	[StationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StationAffiliate]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StationAffiliate](
	[StationAffiliateId] [bigint] IDENTITY(1,1) NOT NULL,
	[StationId] [bigint] NOT NULL,
	[AffiliateId] [bigint] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_StationAffiliate] PRIMARY KEY CLUSTERED 
(
	[StationAffiliateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StationNote]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StationNote](
	[StationNoteId] [bigint] IDENTITY(1,1) NOT NULL,
	[StationId] [bigint] NOT NULL,
	[NoteText] [varchar](max) NOT NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedUserId] [bigint] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_StationNote] PRIMARY KEY CLUSTERED 
(
	[StationNoteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StationUser]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StationUser](
	[StationUserId] [bigint] IDENTITY(1,1) NOT NULL,
	[StationId] [bigint] NOT NULL,
	[UserId] [bigint] NOT NULL,
	[GridWritePermissionsInd] [char](1) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_StationUser] PRIMARY KEY CLUSTERED 
(
	[StationUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TimeZone]    Script Date: 5/28/2014 12:00:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TimeZone](
	[TimeZoneId] [bigint] IDENTITY(1,1) NOT NULL,
	[TimeZoneCode] [varchar](50) NOT NULL,
	[DisplayName] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedUserId] [bigint] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
	[LastUpdatedUserId] [bigint] NOT NULL,
 CONSTRAINT [PK_TimeZone] PRIMARY KEY CLUSTERED 
(
	[TimeZoneId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Affiliate_AffiliateCode]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Affiliate_AffiliateCode] ON [dbo].[Affiliate]
(
	[AffiliateCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Affiliate_AffiliateName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Affiliate_AffiliateName] ON [dbo].[Affiliate]
(
	[AffiliateName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Affiliate_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Affiliate_CreatedUserId] ON [dbo].[Affiliate]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Affiliate_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Affiliate_DisabledUserId] ON [dbo].[Affiliate]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Affiliate_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Affiliate_LastUpdatedUserId] ON [dbo].[Affiliate]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Band_BandName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Band_BandName] ON [dbo].[Band]
(
	[BandName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Band_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Band_CreatedUserId] ON [dbo].[Band]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Band_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Band_DisabledUserId] ON [dbo].[Band]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Band_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Band_LastUpdatedUserId] ON [dbo].[Band]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_CarriageType_CarriageTypeName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_CarriageType_CarriageTypeName] ON [dbo].[CarriageType]
(
	[CarriageTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CarriageType_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_CarriageType_CreatedUserId] ON [dbo].[CarriageType]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CarriageType_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_CarriageType_DisabledUserId] ON [dbo].[CarriageType]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CarriageType_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_CarriageType_LastUpdatedUserId] ON [dbo].[CarriageType]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CRCUser_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_CRCUser_CreatedUserId] ON [dbo].[CRCUser]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CRCUser_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_CRCUser_DisabledUserId] ON [dbo].[CRCUser]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_CRCUser_Email]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_CRCUser_Email] ON [dbo].[CRCUser]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_CRCUser_Email_PasswordHash]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_CRCUser_Email_PasswordHash] ON [dbo].[CRCUser]
(
	[Email] ASC,
	[PasswordHash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CRCUser_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_CRCUser_LastUpdatedUserId] ON [dbo].[CRCUser]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CRCUser_SalutationId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_CRCUser_SalutationId] ON [dbo].[CRCUser]
(
	[SalutationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CRCUser_StateId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_CRCUser_StateId] ON [dbo].[CRCUser]
(
	[StateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DMAMarket_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_DMAMarket_CreatedUserId] ON [dbo].[DMAMarket]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DMAMarket_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_DMAMarket_LastUpdatedUserId] ON [dbo].[DMAMarket]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_DMAMarket_MarketName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_DMAMarket_MarketName] ON [dbo].[DMAMarket]
(
	[MarketName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InfEmail_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_InfEmail_CreatedUserId] ON [dbo].[InfEmail]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InfEmail_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_InfEmail_LastUpdatedUserId] ON [dbo].[InfEmail]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InfEmailAttachment_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_InfEmailAttachment_CreatedUserId] ON [dbo].[InfEmailAttachment]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InfEmailAttachment_InfEmailId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_InfEmailAttachment_InfEmailId] ON [dbo].[InfEmailAttachment]
(
	[InfEmailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InfEmailAttachment_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_InfEmailAttachment_LastUpdatedUserId] ON [dbo].[InfEmailAttachment]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InfEmailTemplate_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_InfEmailTemplate_CreatedUserId] ON [dbo].[InfEmailTemplate]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_InfEmailTemplate_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_InfEmailTemplate_LastUpdatedUserId] ON [dbo].[InfEmailTemplate]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LicenseeType_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_LicenseeType_CreatedUserId] ON [dbo].[LicenseeType]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LicenseeType_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_LicenseeType_DisabledUserId] ON [dbo].[LicenseeType]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LicenseeType_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_LicenseeType_LastUpdatedUserId] ON [dbo].[LicenseeType]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_LicenseeType_LicenseeTypeName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_LicenseeType_LicenseeTypeName] ON [dbo].[LicenseeType]
(
	[LicenseeTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MajorFormat_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_MajorFormat_CreatedUserId] ON [dbo].[MajorFormat]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MajorFormat_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_MajorFormat_DisabledUserId] ON [dbo].[MajorFormat]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MajorFormat_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_MajorFormat_LastUpdatedUserId] ON [dbo].[MajorFormat]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MajorFormat_MajorFormatCode]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MajorFormat_MajorFormatCode] ON [dbo].[MajorFormat]
(
	[MajorFormatCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MajorFormat_MajorFormatName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MajorFormat_MajorFormatName] ON [dbo].[MajorFormat]
(
	[MajorFormatName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MemberStatus_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_MemberStatus_CreatedUserId] ON [dbo].[MemberStatus]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MemberStatus_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_MemberStatus_DisabledUserId] ON [dbo].[MemberStatus]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MemberStatus_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_MemberStatus_LastUpdatedUserId] ON [dbo].[MemberStatus]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MemberStatus_MemberStatusName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MemberStatus_MemberStatusName] ON [dbo].[MemberStatus]
(
	[MemberStatusName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MetroMarket_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_MetroMarket_CreatedUserId] ON [dbo].[MetroMarket]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MetroMarket_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_MetroMarket_LastUpdatedUserId] ON [dbo].[MetroMarket]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MetroMarket_MarketName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MetroMarket_MarketName] ON [dbo].[MetroMarket]
(
	[MarketName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MinorityStatus_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_MinorityStatus_CreatedUserId] ON [dbo].[MinorityStatus]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MinorityStatus_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_MinorityStatus_DisabledUserId] ON [dbo].[MinorityStatus]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MinorityStatus_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_MinorityStatus_LastUpdatedUserId] ON [dbo].[MinorityStatus]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MinorityStatus_MinorityStatusName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MinorityStatus_MinorityStatusName] ON [dbo].[MinorityStatus]
(
	[MinorityStatusName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Producer_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Producer_CreatedUserId] ON [dbo].[Producer]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Producer_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Producer_DisabledUserId] ON [dbo].[Producer]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Producer_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Producer_LastUpdatedUserId] ON [dbo].[Producer]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Producer_SalutationId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Producer_SalutationId] ON [dbo].[Producer]
(
	[SalutationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Program_CarriageTypeId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Program_CarriageTypeId] ON [dbo].[Program]
(
	[CarriageTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Program_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Program_CreatedUserId] ON [dbo].[Program]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Program_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Program_DisabledUserId] ON [dbo].[Program]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Program_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Program_LastUpdatedUserId] ON [dbo].[Program]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Program_ProgramCode]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Program_ProgramCode] ON [dbo].[Program]
(
	[ProgramCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Program_ProgramFormatTypeId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Program_ProgramFormatTypeId] ON [dbo].[Program]
(
	[ProgramFormatTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Program_ProgramName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Program_ProgramName] ON [dbo].[Program]
(
	[ProgramName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Program_ProgramSourceId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Program_ProgramSourceId] ON [dbo].[Program]
(
	[ProgramSourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramFormatType_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProgramFormatType_CreatedUserId] ON [dbo].[ProgramFormatType]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramFormatType_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProgramFormatType_DisabledUserId] ON [dbo].[ProgramFormatType]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramFormatType_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProgramFormatType_LastUpdatedUserId] ON [dbo].[ProgramFormatType]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramFormatType_MajorFormatId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProgramFormatType_MajorFormatId] ON [dbo].[ProgramFormatType]
(
	[MajorFormatId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ProgramFormatType_ProgramFormatTypeCode]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProgramFormatType_ProgramFormatTypeCode] ON [dbo].[ProgramFormatType]
(
	[ProgramFormatTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ProgramFormatType_ProgramFormatTypeName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProgramFormatType_ProgramFormatTypeName] ON [dbo].[ProgramFormatType]
(
	[ProgramFormatTypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramProducer_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProgramProducer_CreatedUserId] ON [dbo].[ProgramProducer]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramProducer_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProgramProducer_LastUpdatedUserId] ON [dbo].[ProgramProducer]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramProducer_ProducerId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProgramProducer_ProducerId] ON [dbo].[ProgramProducer]
(
	[ProducerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramProducer_ProducerId_ProgramId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProgramProducer_ProducerId_ProgramId] ON [dbo].[ProgramProducer]
(
	[ProducerId] ASC,
	[ProgramId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramProducer_ProgramId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProgramProducer_ProgramId] ON [dbo].[ProgramProducer]
(
	[ProgramId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramProducer_ProgramId_ProducerId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProgramProducer_ProgramId_ProducerId] ON [dbo].[ProgramProducer]
(
	[ProgramId] ASC,
	[ProducerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramSource_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProgramSource_CreatedUserId] ON [dbo].[ProgramSource]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramSource_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProgramSource_DisabledUserId] ON [dbo].[ProgramSource]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProgramSource_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProgramSource_LastUpdatedUserId] ON [dbo].[ProgramSource]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RepeaterStatus_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_RepeaterStatus_CreatedUserId] ON [dbo].[RepeaterStatus]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RepeaterStatus_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_RepeaterStatus_LastUpdatedUserId] ON [dbo].[RepeaterStatus]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_RepeaterStatus_RepeaterStatusName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_RepeaterStatus_RepeaterStatusName] ON [dbo].[RepeaterStatus]
(
	[RepeaterStatusName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Salutation_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Salutation_CreatedUserId] ON [dbo].[Salutation]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Salutation_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Salutation_LastUpdatedUserId] ON [dbo].[Salutation]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Salutation_SalutationName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Salutation_SalutationName] ON [dbo].[Salutation]
(
	[SalutationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Schedule_AcceptedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Schedule_AcceptedUserId] ON [dbo].[Schedule]
(
	[AcceptedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Schedule_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Schedule_CreatedUserId] ON [dbo].[Schedule]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Schedule_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Schedule_LastUpdatedUserId] ON [dbo].[Schedule]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Schedule_StationId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Schedule_StationId] ON [dbo].[Schedule]
(
	[StationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Schedule_StationId_Year_Month]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Schedule_StationId_Year_Month] ON [dbo].[Schedule]
(
	[StationId] ASC,
	[Year] ASC,
	[Month] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Schedule_SubmittedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Schedule_SubmittedUserId] ON [dbo].[Schedule]
(
	[SubmittedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScheduleNewscast_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ScheduleNewscast_CreatedUserId] ON [dbo].[ScheduleNewscast]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScheduleNewscast_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ScheduleNewscast_LastUpdatedUserId] ON [dbo].[ScheduleNewscast]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScheduleNewscast_ScheduleId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ScheduleNewscast_ScheduleId] ON [dbo].[ScheduleNewscast]
(
	[ScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScheduleProgram_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ScheduleProgram_CreatedUserId] ON [dbo].[ScheduleProgram]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScheduleProgram_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ScheduleProgram_LastUpdatedUserId] ON [dbo].[ScheduleProgram]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScheduleProgram_ProgramId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ScheduleProgram_ProgramId] ON [dbo].[ScheduleProgram]
(
	[ProgramId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScheduleProgram_ScheduleId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_ScheduleProgram_ScheduleId] ON [dbo].[ScheduleProgram]
(
	[ScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_State_Abbreviation]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_State_Abbreviation] ON [dbo].[State]
(
	[Abbreviation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_State_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_State_CreatedUserId] ON [dbo].[State]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_State_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_State_LastUpdatedUserId] ON [dbo].[State]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_State_StateName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_State_StateName] ON [dbo].[State]
(
	[StateName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_BandId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_BandId] ON [dbo].[Station]
(
	[BandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Station_CallLetters_BandId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Station_CallLetters_BandId] ON [dbo].[Station]
(
	[CallLetters] ASC,
	[BandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_CreatedUserId] ON [dbo].[Station]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_DisabledUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_DisabledUserId] ON [dbo].[Station]
(
	[DisabledUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_DMAMarketId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_DMAMarketId] ON [dbo].[Station]
(
	[DMAMarketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_FlagshipStationId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_FlagshipStationId] ON [dbo].[Station]
(
	[FlagshipStationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_LastUpdatedUserId] ON [dbo].[Station]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_LicenseeTypeId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_LicenseeTypeId] ON [dbo].[Station]
(
	[LicenseeTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_MemberStatusId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_MemberStatusId] ON [dbo].[Station]
(
	[MemberStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_MetroMarketId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_MetroMarketId] ON [dbo].[Station]
(
	[MetroMarketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_MinorityStatusId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_MinorityStatusId] ON [dbo].[Station]
(
	[MinorityStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_PrimaryUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_PrimaryUserId] ON [dbo].[Station]
(
	[PrimaryUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_RepeaterStatusId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_RepeaterStatusId] ON [dbo].[Station]
(
	[RepeaterStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_StateId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_StateId] ON [dbo].[Station]
(
	[StateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Station_TimeZoneId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_Station_TimeZoneId] ON [dbo].[Station]
(
	[TimeZoneId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationAffiliate_AffiliateId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationAffiliate_AffiliateId] ON [dbo].[StationAffiliate]
(
	[AffiliateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationAffiliate_AffiliateId_StationId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_StationAffiliate_AffiliateId_StationId] ON [dbo].[StationAffiliate]
(
	[AffiliateId] ASC,
	[StationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationAffiliate_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationAffiliate_CreatedUserId] ON [dbo].[StationAffiliate]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationAffiliate_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationAffiliate_LastUpdatedUserId] ON [dbo].[StationAffiliate]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationAffiliate_StationId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationAffiliate_StationId] ON [dbo].[StationAffiliate]
(
	[StationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationAffiliate_StationId_AffiliateId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_StationAffiliate_StationId_AffiliateId] ON [dbo].[StationAffiliate]
(
	[StationId] ASC,
	[AffiliateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationNote_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationNote_CreatedUserId] ON [dbo].[StationNote]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationNote_DeletedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationNote_DeletedUserId] ON [dbo].[StationNote]
(
	[DeletedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationNote_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationNote_LastUpdatedUserId] ON [dbo].[StationNote]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationNote_StationId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationNote_StationId] ON [dbo].[StationNote]
(
	[StationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationUser_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationUser_CreatedUserId] ON [dbo].[StationUser]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationUser_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationUser_LastUpdatedUserId] ON [dbo].[StationUser]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationUser_StationId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationUser_StationId] ON [dbo].[StationUser]
(
	[StationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationUser_StationId_UserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_StationUser_StationId_UserId] ON [dbo].[StationUser]
(
	[StationId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationUser_UserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_StationUser_UserId] ON [dbo].[StationUser]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StationUser_UserId_StationId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_StationUser_UserId_StationId] ON [dbo].[StationUser]
(
	[UserId] ASC,
	[StationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TimeZone_CreatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_TimeZone_CreatedUserId] ON [dbo].[TimeZone]
(
	[CreatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_TimeZone_DisplayName]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_TimeZone_DisplayName] ON [dbo].[TimeZone]
(
	[DisplayName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TimeZone_LastUpdatedUserId]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE NONCLUSTERED INDEX [IX_TimeZone_LastUpdatedUserId] ON [dbo].[TimeZone]
(
	[LastUpdatedUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_TimeZone_TimeZoneCode]    Script Date: 5/28/2014 12:00:40 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_TimeZone_TimeZoneCode] ON [dbo].[TimeZone]
(
	[TimeZoneCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Affiliate] ADD  CONSTRAINT [DEF_Affiliate_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Affiliate] ADD  CONSTRAINT [DEF_Affiliate_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[Band] ADD  CONSTRAINT [DEF_Band_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Band] ADD  CONSTRAINT [DEF_Band_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[CarriageType] ADD  CONSTRAINT [DEF_CarriageType_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[CarriageType] ADD  CONSTRAINT [DEF_CarriageType_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[CRCUser] ADD  CONSTRAINT [DEF_CRCUser_AdministratorInd]  DEFAULT ('N') FOR [AdministratorInd]
GO
ALTER TABLE [dbo].[CRCUser] ADD  CONSTRAINT [DEF_CRCUser_CRCManagerInd]  DEFAULT ('N') FOR [CRCManagerInd]
GO
ALTER TABLE [dbo].[CRCUser] ADD  CONSTRAINT [DEF_CRCUser_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[CRCUser] ADD  CONSTRAINT [DEF_CRCUser_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[DMAMarket] ADD  CONSTRAINT [DEF_DMAMarket_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[DMAMarket] ADD  CONSTRAINT [DEF_DMAMarket_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[InfEmail] ADD  CONSTRAINT [DEF_InfEmail_HtmlInd]  DEFAULT ('N') FOR [HtmlInd]
GO
ALTER TABLE [dbo].[InfEmailTemplate] ADD  CONSTRAINT [DEF_InfEmailTemplate_HtmlInd]  DEFAULT ('N') FOR [HtmlInd]
GO
ALTER TABLE [dbo].[LicenseeType] ADD  CONSTRAINT [DEF_LicenseeType_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[LicenseeType] ADD  CONSTRAINT [DEF_LicenseeType_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[MajorFormat] ADD  CONSTRAINT [DEF_MajorFormat_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[MajorFormat] ADD  CONSTRAINT [DEF_MajorFormat_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[MemberStatus] ADD  CONSTRAINT [DEF_MemberStatus_NPRMembershipInd]  DEFAULT ('N') FOR [NPRMembershipInd]
GO
ALTER TABLE [dbo].[MemberStatus] ADD  CONSTRAINT [DEF_MemberStatus_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[MemberStatus] ADD  CONSTRAINT [DEF_MemberStatus_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[MetroMarket] ADD  CONSTRAINT [DEF_MetroMarket_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[MetroMarket] ADD  CONSTRAINT [DEF_MetroMarket_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[MinorityStatus] ADD  CONSTRAINT [DEF_MinorityStatus_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[MinorityStatus] ADD  CONSTRAINT [DEF_MinorityStatus_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[Producer] ADD  CONSTRAINT [DEF_Producer_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Producer] ADD  CONSTRAINT [DEF_Producer_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[Program] ADD  CONSTRAINT [DEF_Program_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Program] ADD  CONSTRAINT [DEF_Program_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[ProgramFormatType] ADD  CONSTRAINT [DEF_ProgramFormatType_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProgramFormatType] ADD  CONSTRAINT [DEF_ProgramFormatType_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[ProgramProducer] ADD  CONSTRAINT [DEF_ProgramProducer_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProgramProducer] ADD  CONSTRAINT [DEF_ProgramProducer_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[ProgramSource] ADD  CONSTRAINT [DEF_ProgramSource_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProgramSource] ADD  CONSTRAINT [DEF_ProgramSource_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[RepeaterStatus] ADD  CONSTRAINT [DEF_RepeaterStatus_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[RepeaterStatus] ADD  CONSTRAINT [DEF_RepeaterStatus_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[Salutation] ADD  CONSTRAINT [DEF_Salutation_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Salutation] ADD  CONSTRAINT [DEF_Salutation_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[Schedule] ADD  CONSTRAINT [DEF_Schedule_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Schedule] ADD  CONSTRAINT [DEF_Schedule_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[ScheduleNewscast] ADD  CONSTRAINT [DEF_ScheduleNewscast_HourlyInd]  DEFAULT ('N') FOR [HourlyInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast] ADD  CONSTRAINT [DEF_ScheduleNewscast_SundayInd]  DEFAULT ('N') FOR [SundayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast] ADD  CONSTRAINT [DEF_ScheduleNewscast_MondayInd]  DEFAULT ('N') FOR [MondayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast] ADD  CONSTRAINT [DEF_ScheduleNewscast_TuesdayInd]  DEFAULT ('N') FOR [TuesdayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast] ADD  CONSTRAINT [DEF_ScheduleNewscast_WednesdayInd]  DEFAULT ('N') FOR [WednesdayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast] ADD  CONSTRAINT [DEF_ScheduleNewscast_ThursdayInd]  DEFAULT ('N') FOR [ThursdayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast] ADD  CONSTRAINT [DEF_ScheduleNewscast_FridayInd]  DEFAULT ('N') FOR [FridayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast] ADD  CONSTRAINT [DEF_ScheduleNewscast_SaturdayInd]  DEFAULT ('N') FOR [SaturdayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast] ADD  CONSTRAINT [DEF_ScheduleNewscast_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ScheduleNewscast] ADD  CONSTRAINT [DEF_ScheduleNewscast_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[ScheduleProgram] ADD  CONSTRAINT [DEF_ScheduleProgram_SundayInd]  DEFAULT ('N') FOR [SundayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram] ADD  CONSTRAINT [DEF_ScheduleProgram_MondayInd]  DEFAULT ('N') FOR [MondayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram] ADD  CONSTRAINT [DEF_ScheduleProgram_TuesdayInd]  DEFAULT ('N') FOR [TuesdayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram] ADD  CONSTRAINT [DEF_ScheduleProgram_WednesdayInd]  DEFAULT ('N') FOR [WednesdayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram] ADD  CONSTRAINT [DEF_ScheduleProgram_ThursdayInd]  DEFAULT ('N') FOR [ThursdayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram] ADD  CONSTRAINT [DEF_ScheduleProgram_FridayInd]  DEFAULT ('N') FOR [FridayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram] ADD  CONSTRAINT [DEF_ScheduleProgram_SaturdayInd]  DEFAULT ('N') FOR [SaturdayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram] ADD  CONSTRAINT [DEF_ScheduleProgram_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ScheduleProgram] ADD  CONSTRAINT [DEF_ScheduleProgram_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[State] ADD  CONSTRAINT [DEF_State_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[State] ADD  CONSTRAINT [DEF_State_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[Station] ADD  CONSTRAINT [DEF_Station_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Station] ADD  CONSTRAINT [DEF_Station_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[StationAffiliate] ADD  CONSTRAINT [DEF_StationAffiliate_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[StationAffiliate] ADD  CONSTRAINT [DEF_StationAffiliate_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[StationNote] ADD  CONSTRAINT [DEF_StationNote_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[StationNote] ADD  CONSTRAINT [DEF_StationNote_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[StationUser] ADD  CONSTRAINT [DEF_StationUser_GridWritePermissionsInd]  DEFAULT ('N') FOR [GridWritePermissionsInd]
GO
ALTER TABLE [dbo].[StationUser] ADD  CONSTRAINT [DEF_StationUser_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[StationUser] ADD  CONSTRAINT [DEF_StationUser_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[TimeZone] ADD  CONSTRAINT [DEF_TimeZone_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[TimeZone] ADD  CONSTRAINT [DEF_TimeZone_LastUpdatedDate]  DEFAULT (getutcdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[Affiliate]  WITH CHECK ADD  CONSTRAINT [FK_Affiliate_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Affiliate] CHECK CONSTRAINT [FK_Affiliate_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[Affiliate]  WITH CHECK ADD  CONSTRAINT [FK_Affiliate_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Affiliate] CHECK CONSTRAINT [FK_Affiliate_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[Affiliate]  WITH CHECK ADD  CONSTRAINT [FK_Affiliate_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Affiliate] CHECK CONSTRAINT [FK_Affiliate_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[Band]  WITH CHECK ADD  CONSTRAINT [FK_Band_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Band] CHECK CONSTRAINT [FK_Band_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[Band]  WITH CHECK ADD  CONSTRAINT [FK_Band_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Band] CHECK CONSTRAINT [FK_Band_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[Band]  WITH CHECK ADD  CONSTRAINT [FK_Band_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Band] CHECK CONSTRAINT [FK_Band_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[CarriageType]  WITH CHECK ADD  CONSTRAINT [FK_CarriageType_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[CarriageType] CHECK CONSTRAINT [FK_CarriageType_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[CarriageType]  WITH CHECK ADD  CONSTRAINT [FK_CarriageType_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[CarriageType] CHECK CONSTRAINT [FK_CarriageType_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[CarriageType]  WITH CHECK ADD  CONSTRAINT [FK_CarriageType_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[CarriageType] CHECK CONSTRAINT [FK_CarriageType_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[CRCUser]  WITH CHECK ADD  CONSTRAINT [FK_CRCUser_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[CRCUser] CHECK CONSTRAINT [FK_CRCUser_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[CRCUser]  WITH CHECK ADD  CONSTRAINT [FK_CRCUser_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[CRCUser] CHECK CONSTRAINT [FK_CRCUser_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[CRCUser]  WITH CHECK ADD  CONSTRAINT [FK_CRCUser_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[CRCUser] CHECK CONSTRAINT [FK_CRCUser_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[CRCUser]  WITH CHECK ADD  CONSTRAINT [FK_CRCUser_Salutation_SalutationId] FOREIGN KEY([SalutationId])
REFERENCES [dbo].[Salutation] ([SalutationId])
GO
ALTER TABLE [dbo].[CRCUser] CHECK CONSTRAINT [FK_CRCUser_Salutation_SalutationId]
GO
ALTER TABLE [dbo].[CRCUser]  WITH CHECK ADD  CONSTRAINT [FK_CRCUser_State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[CRCUser] CHECK CONSTRAINT [FK_CRCUser_State_StateId]
GO
ALTER TABLE [dbo].[DMAMarket]  WITH CHECK ADD  CONSTRAINT [FK_DMAMarket_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[DMAMarket] CHECK CONSTRAINT [FK_DMAMarket_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[DMAMarket]  WITH CHECK ADD  CONSTRAINT [FK_DMAMarket_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[DMAMarket] CHECK CONSTRAINT [FK_DMAMarket_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[InfEmail]  WITH CHECK ADD  CONSTRAINT [FK_InfEmail_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[InfEmail] CHECK CONSTRAINT [FK_InfEmail_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[InfEmail]  WITH CHECK ADD  CONSTRAINT [FK_InfEmail_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[InfEmail] CHECK CONSTRAINT [FK_InfEmail_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[InfEmailAttachment]  WITH CHECK ADD  CONSTRAINT [FK_InfEmailAttachment_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[InfEmailAttachment] CHECK CONSTRAINT [FK_InfEmailAttachment_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[InfEmailAttachment]  WITH CHECK ADD  CONSTRAINT [FK_InfEmailAttachment_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[InfEmailAttachment] CHECK CONSTRAINT [FK_InfEmailAttachment_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[InfEmailAttachment]  WITH CHECK ADD  CONSTRAINT [FK_InfEmailAttachment_InfEmail_InfEmailId] FOREIGN KEY([InfEmailId])
REFERENCES [dbo].[InfEmail] ([InfEmailId])
GO
ALTER TABLE [dbo].[InfEmailAttachment] CHECK CONSTRAINT [FK_InfEmailAttachment_InfEmail_InfEmailId]
GO
ALTER TABLE [dbo].[InfEmailTemplate]  WITH CHECK ADD  CONSTRAINT [FK_InfEmailTemplate_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[InfEmailTemplate] CHECK CONSTRAINT [FK_InfEmailTemplate_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[InfEmailTemplate]  WITH CHECK ADD  CONSTRAINT [FK_InfEmailTemplate_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[InfEmailTemplate] CHECK CONSTRAINT [FK_InfEmailTemplate_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[LicenseeType]  WITH CHECK ADD  CONSTRAINT [FK_LicenseeType_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[LicenseeType] CHECK CONSTRAINT [FK_LicenseeType_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[LicenseeType]  WITH CHECK ADD  CONSTRAINT [FK_LicenseeType_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[LicenseeType] CHECK CONSTRAINT [FK_LicenseeType_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[LicenseeType]  WITH CHECK ADD  CONSTRAINT [FK_LicenseeType_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[LicenseeType] CHECK CONSTRAINT [FK_LicenseeType_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[MajorFormat]  WITH CHECK ADD  CONSTRAINT [FK_MajorFormat_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[MajorFormat] CHECK CONSTRAINT [FK_MajorFormat_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[MajorFormat]  WITH CHECK ADD  CONSTRAINT [FK_MajorFormat_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[MajorFormat] CHECK CONSTRAINT [FK_MajorFormat_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[MajorFormat]  WITH CHECK ADD  CONSTRAINT [FK_MajorFormat_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[MajorFormat] CHECK CONSTRAINT [FK_MajorFormat_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[MemberStatus]  WITH CHECK ADD  CONSTRAINT [FK_MemberStatus_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[MemberStatus] CHECK CONSTRAINT [FK_MemberStatus_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[MemberStatus]  WITH CHECK ADD  CONSTRAINT [FK_MemberStatus_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[MemberStatus] CHECK CONSTRAINT [FK_MemberStatus_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[MemberStatus]  WITH CHECK ADD  CONSTRAINT [FK_MemberStatus_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[MemberStatus] CHECK CONSTRAINT [FK_MemberStatus_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[MetroMarket]  WITH CHECK ADD  CONSTRAINT [FK_MetroMarket_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[MetroMarket] CHECK CONSTRAINT [FK_MetroMarket_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[MetroMarket]  WITH CHECK ADD  CONSTRAINT [FK_MetroMarket_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[MetroMarket] CHECK CONSTRAINT [FK_MetroMarket_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[MinorityStatus]  WITH CHECK ADD  CONSTRAINT [FK_MinorityStatus_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[MinorityStatus] CHECK CONSTRAINT [FK_MinorityStatus_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[MinorityStatus]  WITH CHECK ADD  CONSTRAINT [FK_MinorityStatus_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[MinorityStatus] CHECK CONSTRAINT [FK_MinorityStatus_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[MinorityStatus]  WITH CHECK ADD  CONSTRAINT [FK_MinorityStatus_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[MinorityStatus] CHECK CONSTRAINT [FK_MinorityStatus_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[Producer]  WITH CHECK ADD  CONSTRAINT [FK_Producer_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Producer] CHECK CONSTRAINT [FK_Producer_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[Producer]  WITH CHECK ADD  CONSTRAINT [FK_Producer_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Producer] CHECK CONSTRAINT [FK_Producer_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[Producer]  WITH CHECK ADD  CONSTRAINT [FK_Producer_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Producer] CHECK CONSTRAINT [FK_Producer_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[Producer]  WITH CHECK ADD  CONSTRAINT [FK_Producer_Salutation_SalutationId] FOREIGN KEY([SalutationId])
REFERENCES [dbo].[Salutation] ([SalutationId])
GO
ALTER TABLE [dbo].[Producer] CHECK CONSTRAINT [FK_Producer_Salutation_SalutationId]
GO
ALTER TABLE [dbo].[Program]  WITH CHECK ADD  CONSTRAINT [FK_Program_CarriageType_CarriageTypeId] FOREIGN KEY([CarriageTypeId])
REFERENCES [dbo].[CarriageType] ([CarriageTypeId])
GO
ALTER TABLE [dbo].[Program] CHECK CONSTRAINT [FK_Program_CarriageType_CarriageTypeId]
GO
ALTER TABLE [dbo].[Program]  WITH CHECK ADD  CONSTRAINT [FK_Program_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Program] CHECK CONSTRAINT [FK_Program_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[Program]  WITH CHECK ADD  CONSTRAINT [FK_Program_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Program] CHECK CONSTRAINT [FK_Program_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[Program]  WITH CHECK ADD  CONSTRAINT [FK_Program_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Program] CHECK CONSTRAINT [FK_Program_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[Program]  WITH CHECK ADD  CONSTRAINT [FK_Program_ProgramFormatType_ProgramFormatTypeId] FOREIGN KEY([ProgramFormatTypeId])
REFERENCES [dbo].[ProgramFormatType] ([ProgramFormatTypeId])
GO
ALTER TABLE [dbo].[Program] CHECK CONSTRAINT [FK_Program_ProgramFormatType_ProgramFormatTypeId]
GO
ALTER TABLE [dbo].[Program]  WITH CHECK ADD  CONSTRAINT [FK_Program_ProgramSource_ProgramSourceId] FOREIGN KEY([ProgramSourceId])
REFERENCES [dbo].[ProgramSource] ([ProgramSourceId])
GO
ALTER TABLE [dbo].[Program] CHECK CONSTRAINT [FK_Program_ProgramSource_ProgramSourceId]
GO
ALTER TABLE [dbo].[ProgramFormatType]  WITH CHECK ADD  CONSTRAINT [FK_ProgramFormatType_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ProgramFormatType] CHECK CONSTRAINT [FK_ProgramFormatType_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[ProgramFormatType]  WITH CHECK ADD  CONSTRAINT [FK_ProgramFormatType_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ProgramFormatType] CHECK CONSTRAINT [FK_ProgramFormatType_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[ProgramFormatType]  WITH CHECK ADD  CONSTRAINT [FK_ProgramFormatType_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ProgramFormatType] CHECK CONSTRAINT [FK_ProgramFormatType_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[ProgramFormatType]  WITH CHECK ADD  CONSTRAINT [FK_ProgramFormatType_MajorFormat_MajorFormatId] FOREIGN KEY([MajorFormatId])
REFERENCES [dbo].[MajorFormat] ([MajorFormatId])
GO
ALTER TABLE [dbo].[ProgramFormatType] CHECK CONSTRAINT [FK_ProgramFormatType_MajorFormat_MajorFormatId]
GO
ALTER TABLE [dbo].[ProgramProducer]  WITH CHECK ADD  CONSTRAINT [FK_ProgramProducer_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ProgramProducer] CHECK CONSTRAINT [FK_ProgramProducer_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[ProgramProducer]  WITH CHECK ADD  CONSTRAINT [FK_ProgramProducer_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ProgramProducer] CHECK CONSTRAINT [FK_ProgramProducer_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[ProgramProducer]  WITH CHECK ADD  CONSTRAINT [FK_ProgramProducer_Producer_ProducerId] FOREIGN KEY([ProducerId])
REFERENCES [dbo].[Producer] ([ProducerId])
GO
ALTER TABLE [dbo].[ProgramProducer] CHECK CONSTRAINT [FK_ProgramProducer_Producer_ProducerId]
GO
ALTER TABLE [dbo].[ProgramProducer]  WITH CHECK ADD  CONSTRAINT [FK_ProgramProducer_Program_ProgramId] FOREIGN KEY([ProgramId])
REFERENCES [dbo].[Program] ([ProgramId])
GO
ALTER TABLE [dbo].[ProgramProducer] CHECK CONSTRAINT [FK_ProgramProducer_Program_ProgramId]
GO
ALTER TABLE [dbo].[ProgramSource]  WITH CHECK ADD  CONSTRAINT [FK_ProgramSource_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ProgramSource] CHECK CONSTRAINT [FK_ProgramSource_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[ProgramSource]  WITH CHECK ADD  CONSTRAINT [FK_ProgramSource_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ProgramSource] CHECK CONSTRAINT [FK_ProgramSource_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[ProgramSource]  WITH CHECK ADD  CONSTRAINT [FK_ProgramSource_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ProgramSource] CHECK CONSTRAINT [FK_ProgramSource_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[RepeaterStatus]  WITH CHECK ADD  CONSTRAINT [FK_RepeaterStatus_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[RepeaterStatus] CHECK CONSTRAINT [FK_RepeaterStatus_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[RepeaterStatus]  WITH CHECK ADD  CONSTRAINT [FK_RepeaterStatus_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[RepeaterStatus] CHECK CONSTRAINT [FK_RepeaterStatus_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[Salutation]  WITH CHECK ADD  CONSTRAINT [FK_Salutation_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Salutation] CHECK CONSTRAINT [FK_Salutation_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[Salutation]  WITH CHECK ADD  CONSTRAINT [FK_Salutation_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Salutation] CHECK CONSTRAINT [FK_Salutation_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_CRCUser_AcceptedUserId] FOREIGN KEY([AcceptedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [FK_Schedule_CRCUser_AcceptedUserId]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [FK_Schedule_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [FK_Schedule_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_CRCUser_SubmittedUserId] FOREIGN KEY([SubmittedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [FK_Schedule_CRCUser_SubmittedUserId]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_Station_StationId] FOREIGN KEY([StationId])
REFERENCES [dbo].[Station] ([StationId])
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [FK_Schedule_Station_StationId]
GO
ALTER TABLE [dbo].[ScheduleNewscast]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleNewscast_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ScheduleNewscast] CHECK CONSTRAINT [FK_ScheduleNewscast_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[ScheduleNewscast]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleNewscast_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ScheduleNewscast] CHECK CONSTRAINT [FK_ScheduleNewscast_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[ScheduleNewscast]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleNewscast_Schedule_ScheduleId] FOREIGN KEY([ScheduleId])
REFERENCES [dbo].[Schedule] ([ScheduleId])
GO
ALTER TABLE [dbo].[ScheduleNewscast] CHECK CONSTRAINT [FK_ScheduleNewscast_Schedule_ScheduleId]
GO
ALTER TABLE [dbo].[ScheduleProgram]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProgram_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ScheduleProgram] CHECK CONSTRAINT [FK_ScheduleProgram_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[ScheduleProgram]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProgram_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[ScheduleProgram] CHECK CONSTRAINT [FK_ScheduleProgram_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[ScheduleProgram]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProgram_Program_ProgramId] FOREIGN KEY([ProgramId])
REFERENCES [dbo].[Program] ([ProgramId])
GO
ALTER TABLE [dbo].[ScheduleProgram] CHECK CONSTRAINT [FK_ScheduleProgram_Program_ProgramId]
GO
ALTER TABLE [dbo].[ScheduleProgram]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleProgram_Schedule_ScheduleId] FOREIGN KEY([ScheduleId])
REFERENCES [dbo].[Schedule] ([ScheduleId])
GO
ALTER TABLE [dbo].[ScheduleProgram] CHECK CONSTRAINT [FK_ScheduleProgram_Schedule_ScheduleId]
GO
ALTER TABLE [dbo].[State]  WITH CHECK ADD  CONSTRAINT [FK_State_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[State] CHECK CONSTRAINT [FK_State_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[State]  WITH CHECK ADD  CONSTRAINT [FK_State_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[State] CHECK CONSTRAINT [FK_State_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_Band_BandId] FOREIGN KEY([BandId])
REFERENCES [dbo].[Band] ([BandId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_Band_BandId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_CRCUser_DisabledUserId] FOREIGN KEY([DisabledUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_CRCUser_DisabledUserId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_CRCUser_PrimaryUserId] FOREIGN KEY([PrimaryUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_CRCUser_PrimaryUserId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_DMAMarket_DMAMarketId] FOREIGN KEY([DMAMarketId])
REFERENCES [dbo].[DMAMarket] ([DMAMarketId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_DMAMarket_DMAMarketId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_LicenseeType_LicenseeTypeId] FOREIGN KEY([LicenseeTypeId])
REFERENCES [dbo].[LicenseeType] ([LicenseeTypeId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_LicenseeType_LicenseeTypeId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_MemberStatus_MemberStatusId] FOREIGN KEY([MemberStatusId])
REFERENCES [dbo].[MemberStatus] ([MemberStatusId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_MemberStatus_MemberStatusId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_MetroMarket_MetroMarketId] FOREIGN KEY([MetroMarketId])
REFERENCES [dbo].[MetroMarket] ([MetroMarketId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_MetroMarket_MetroMarketId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_MinorityStatus_MinorityStatusId] FOREIGN KEY([MinorityStatusId])
REFERENCES [dbo].[MinorityStatus] ([MinorityStatusId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_MinorityStatus_MinorityStatusId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_RepeaterStatus_RepeaterStatusId] FOREIGN KEY([RepeaterStatusId])
REFERENCES [dbo].[RepeaterStatus] ([RepeaterStatusId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_RepeaterStatus_RepeaterStatusId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_State_StateId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_Station_FlagshipStationId] FOREIGN KEY([FlagshipStationId])
REFERENCES [dbo].[Station] ([StationId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_Station_FlagshipStationId]
GO
ALTER TABLE [dbo].[Station]  WITH CHECK ADD  CONSTRAINT [FK_Station_TimeZone_TimeZoneId] FOREIGN KEY([TimeZoneId])
REFERENCES [dbo].[TimeZone] ([TimeZoneId])
GO
ALTER TABLE [dbo].[Station] CHECK CONSTRAINT [FK_Station_TimeZone_TimeZoneId]
GO
ALTER TABLE [dbo].[StationAffiliate]  WITH CHECK ADD  CONSTRAINT [FK_StationAffiliate_Affiliate_AffiliateId] FOREIGN KEY([AffiliateId])
REFERENCES [dbo].[Affiliate] ([AffiliateId])
GO
ALTER TABLE [dbo].[StationAffiliate] CHECK CONSTRAINT [FK_StationAffiliate_Affiliate_AffiliateId]
GO
ALTER TABLE [dbo].[StationAffiliate]  WITH CHECK ADD  CONSTRAINT [FK_StationAffiliate_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[StationAffiliate] CHECK CONSTRAINT [FK_StationAffiliate_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[StationAffiliate]  WITH CHECK ADD  CONSTRAINT [FK_StationAffiliate_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[StationAffiliate] CHECK CONSTRAINT [FK_StationAffiliate_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[StationAffiliate]  WITH CHECK ADD  CONSTRAINT [FK_StationAffiliate_Station_StationId] FOREIGN KEY([StationId])
REFERENCES [dbo].[Station] ([StationId])
GO
ALTER TABLE [dbo].[StationAffiliate] CHECK CONSTRAINT [FK_StationAffiliate_Station_StationId]
GO
ALTER TABLE [dbo].[StationNote]  WITH CHECK ADD  CONSTRAINT [FK_StationNote_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[StationNote] CHECK CONSTRAINT [FK_StationNote_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[StationNote]  WITH CHECK ADD  CONSTRAINT [FK_StationNote_CRCUser_DeletedUserId] FOREIGN KEY([DeletedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[StationNote] CHECK CONSTRAINT [FK_StationNote_CRCUser_DeletedUserId]
GO
ALTER TABLE [dbo].[StationNote]  WITH CHECK ADD  CONSTRAINT [FK_StationNote_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[StationNote] CHECK CONSTRAINT [FK_StationNote_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[StationNote]  WITH CHECK ADD  CONSTRAINT [FK_StationNote_Station_StationId] FOREIGN KEY([StationId])
REFERENCES [dbo].[Station] ([StationId])
GO
ALTER TABLE [dbo].[StationNote] CHECK CONSTRAINT [FK_StationNote_Station_StationId]
GO
ALTER TABLE [dbo].[StationUser]  WITH CHECK ADD  CONSTRAINT [FK_StationUser_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[StationUser] CHECK CONSTRAINT [FK_StationUser_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[StationUser]  WITH CHECK ADD  CONSTRAINT [FK_StationUser_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[StationUser] CHECK CONSTRAINT [FK_StationUser_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[StationUser]  WITH CHECK ADD  CONSTRAINT [FK_StationUser_CRCUser_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[StationUser] CHECK CONSTRAINT [FK_StationUser_CRCUser_UserId]
GO
ALTER TABLE [dbo].[StationUser]  WITH CHECK ADD  CONSTRAINT [FK_StationUser_Station_StationId] FOREIGN KEY([StationId])
REFERENCES [dbo].[Station] ([StationId])
GO
ALTER TABLE [dbo].[StationUser] CHECK CONSTRAINT [FK_StationUser_Station_StationId]
GO
ALTER TABLE [dbo].[TimeZone]  WITH CHECK ADD  CONSTRAINT [FK_TimeZone_CRCUser_CreatedUserId] FOREIGN KEY([CreatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[TimeZone] CHECK CONSTRAINT [FK_TimeZone_CRCUser_CreatedUserId]
GO
ALTER TABLE [dbo].[TimeZone]  WITH CHECK ADD  CONSTRAINT [FK_TimeZone_CRCUser_LastUpdatedUserId] FOREIGN KEY([LastUpdatedUserId])
REFERENCES [dbo].[CRCUser] ([UserId])
GO
ALTER TABLE [dbo].[TimeZone] CHECK CONSTRAINT [FK_TimeZone_CRCUser_LastUpdatedUserId]
GO
ALTER TABLE [dbo].[CRCUser]  WITH CHECK ADD  CONSTRAINT [CHK_CRCUser_AdministratorInd] CHECK  ((([AdministratorInd]='N' OR [AdministratorInd]='Y') AND NOT ([AdministratorInd]='N' AND [CRCManagerInd]='Y')))
GO
ALTER TABLE [dbo].[CRCUser] CHECK CONSTRAINT [CHK_CRCUser_AdministratorInd]
GO
ALTER TABLE [dbo].[CRCUser]  WITH CHECK ADD  CONSTRAINT [CHK_CRCUser_CRCManagerInd] CHECK  ((([CRCManagerInd]='N' OR [CRCManagerInd]='Y') AND NOT ([AdministratorInd]='N' AND [CRCManagerInd]='Y')))
GO
ALTER TABLE [dbo].[CRCUser] CHECK CONSTRAINT [CHK_CRCUser_CRCManagerInd]
GO
ALTER TABLE [dbo].[InfEmail]  WITH CHECK ADD  CONSTRAINT [CHK_InfEmail_HtmlInd] CHECK  (([HtmlInd]='N' OR [HtmlInd]='Y'))
GO
ALTER TABLE [dbo].[InfEmail] CHECK CONSTRAINT [CHK_InfEmail_HtmlInd]
GO
ALTER TABLE [dbo].[InfEmail]  WITH CHECK ADD  CONSTRAINT [CHK_InfEmail_Priority] CHECK  (([Priority]='High' OR [Priority]='Normal' OR [Priority]='Low'))
GO
ALTER TABLE [dbo].[InfEmail] CHECK CONSTRAINT [CHK_InfEmail_Priority]
GO
ALTER TABLE [dbo].[InfEmail]  WITH CHECK ADD  CONSTRAINT [CHK_InfEmail_RetryCount] CHECK  (([RetryCount]>=(0)))
GO
ALTER TABLE [dbo].[InfEmail] CHECK CONSTRAINT [CHK_InfEmail_RetryCount]
GO
ALTER TABLE [dbo].[InfEmailTemplate]  WITH CHECK ADD  CONSTRAINT [CHK_InfEmailTemplate_HtmlInd] CHECK  (([HtmlInd]='N' OR [HtmlInd]='Y'))
GO
ALTER TABLE [dbo].[InfEmailTemplate] CHECK CONSTRAINT [CHK_InfEmailTemplate_HtmlInd]
GO
ALTER TABLE [dbo].[InfEmailTemplate]  WITH CHECK ADD  CONSTRAINT [CHK_InfEmailTemplate_Priority] CHECK  (([Priority]='High' OR [Priority]='Normal' OR [Priority]='Low'))
GO
ALTER TABLE [dbo].[InfEmailTemplate] CHECK CONSTRAINT [CHK_InfEmailTemplate_Priority]
GO
ALTER TABLE [dbo].[MemberStatus]  WITH CHECK ADD  CONSTRAINT [CHK_MemberStatus_NPRMembershipInd] CHECK  (([NPRMembershipInd]='N' OR [NPRMembershipInd]='Y'))
GO
ALTER TABLE [dbo].[MemberStatus] CHECK CONSTRAINT [CHK_MemberStatus_NPRMembershipInd]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [CHK_Schedule_AcceptedDate] CHECK  (([AcceptedDate] IS NULL OR [SubmittedDate] IS NOT NULL AND [AcceptedDate]>=[SubmittedDate]))
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [CHK_Schedule_AcceptedDate]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [CHK_Schedule_Month] CHECK  (([Month]>=(1) AND [Month]<=(12)))
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [CHK_Schedule_Month]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [CHK_Schedule_Year] CHECK  (([Year]>=(1990) AND [Year]<=(2199)))
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [CHK_Schedule_Year]
GO
ALTER TABLE [dbo].[ScheduleNewscast]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleNewscast_FridayInd] CHECK  (([FridayInd]='N' OR [FridayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleNewscast] CHECK CONSTRAINT [CHK_ScheduleNewscast_FridayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleNewscast_HourlyInd] CHECK  (([HourlyInd]='N' OR [HourlyInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleNewscast] CHECK CONSTRAINT [CHK_ScheduleNewscast_HourlyInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleNewscast_MondayInd] CHECK  (([MondayInd]='N' OR [MondayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleNewscast] CHECK CONSTRAINT [CHK_ScheduleNewscast_MondayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleNewscast_SaturdayInd] CHECK  (([SaturdayInd]='N' OR [SaturdayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleNewscast] CHECK CONSTRAINT [CHK_ScheduleNewscast_SaturdayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleNewscast_SundayInd] CHECK  (([SundayInd]='N' OR [SundayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleNewscast] CHECK CONSTRAINT [CHK_ScheduleNewscast_SundayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleNewscast_ThursdayInd] CHECK  (([ThursdayInd]='N' OR [ThursdayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleNewscast] CHECK CONSTRAINT [CHK_ScheduleNewscast_ThursdayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleNewscast_TuesdayInd] CHECK  (([TuesdayInd]='N' OR [TuesdayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleNewscast] CHECK CONSTRAINT [CHK_ScheduleNewscast_TuesdayInd]
GO
ALTER TABLE [dbo].[ScheduleNewscast]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleNewscast_WednesdayInd] CHECK  (([WednesdayInd]='N' OR [WednesdayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleNewscast] CHECK CONSTRAINT [CHK_ScheduleNewscast_WednesdayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleProgram_FridayInd] CHECK  (([FridayInd]='N' OR [FridayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleProgram] CHECK CONSTRAINT [CHK_ScheduleProgram_FridayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleProgram_MondayInd] CHECK  (([MondayInd]='N' OR [MondayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleProgram] CHECK CONSTRAINT [CHK_ScheduleProgram_MondayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleProgram_SaturdayInd] CHECK  (([SaturdayInd]='N' OR [SaturdayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleProgram] CHECK CONSTRAINT [CHK_ScheduleProgram_SaturdayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleProgram_SundayInd] CHECK  (([SundayInd]='N' OR [SundayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleProgram] CHECK CONSTRAINT [CHK_ScheduleProgram_SundayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleProgram_ThursdayInd] CHECK  (([ThursdayInd]='N' OR [ThursdayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleProgram] CHECK CONSTRAINT [CHK_ScheduleProgram_ThursdayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleProgram_TuesdayInd] CHECK  (([TuesdayInd]='N' OR [TuesdayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleProgram] CHECK CONSTRAINT [CHK_ScheduleProgram_TuesdayInd]
GO
ALTER TABLE [dbo].[ScheduleProgram]  WITH CHECK ADD  CONSTRAINT [CHK_ScheduleProgram_WednesdayInd] CHECK  (([WednesdayInd]='N' OR [WednesdayInd]='Y'))
GO
ALTER TABLE [dbo].[ScheduleProgram] CHECK CONSTRAINT [CHK_ScheduleProgram_WednesdayInd]
GO
ALTER TABLE [dbo].[StationUser]  WITH CHECK ADD  CONSTRAINT [CHK_StationUser_GridWritePermissionsInd] CHECK  (([GridWritePermissionsInd]='N' OR [GridWritePermissionsInd]='Y'))
GO
ALTER TABLE [dbo].[StationUser] CHECK CONSTRAINT [CHK_StationUser_GridWritePermissionsInd]
GO
USE [master]
GO
ALTER DATABASE [CRC] SET  READ_WRITE 
GO
