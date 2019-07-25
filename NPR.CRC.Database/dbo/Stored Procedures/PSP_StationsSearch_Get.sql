CREATE PROCEDURE [dbo].[PSP_StationsSearch_Get] --null,null,null,'YES',null,null,'3, 4, 5, 6, 7, 10, 11, 12, 13, 14',null,null,null,'Y'
(
	@StationId BIGINT,
	@RepeaterStatusId BIGINT,
	@MetroMarketId BIGINT,
	@Enabled VARCHAR(50),
	@MemberStatusId BIGINT,
	@DMAMarketId BIGINT,
	@BandId VARCHAR(100),
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
		SET @DynSql = @DynSql + ' AND s.BandId IN('+ @BandId+')'
		--SET @DynSql = @DynSql + ' AND s.BandId = @BandId'

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
	--@BandId BIGINT,
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
			--@BandId = @BandId,
			@StateId = @StateId,
			@LicenseeTypeId = @LicenseeTypeId,
			@AffiliateId = @AffiliateId

END
GO


