CREATE TABLE [dbo].[Station] (
    [StationId]         BIGINT        IDENTITY (1, 1) NOT NULL,
    [CallLetters]       VARCHAR (50)  NOT NULL,
    [BandId]            BIGINT        NOT NULL,
    [Frequency]         VARCHAR (50)  NOT NULL,
    [RepeaterStatusId]  BIGINT        NOT NULL,
    [FlagshipStationId] BIGINT        NULL,
    [PrimaryUserId]     BIGINT        NULL,
    [MemberStatusId]    BIGINT        NOT NULL,
    [MinorityStatusId]  BIGINT        NOT NULL,
    [StatusDate]        DATE          NOT NULL,
    [LicenseeTypeId]    BIGINT        NOT NULL,
    [LicenseeName]      VARCHAR (50)  NULL,
    [AddressLine1]      VARCHAR (50)  NULL,
    [AddressLine2]      VARCHAR (50)  NULL,
    [City]              VARCHAR (50)  NULL,
    [StateId]           BIGINT        NULL,
    [County]            VARCHAR (50)  NULL,
    [Country]           VARCHAR (50)  NULL,
    [ZipCode]           VARCHAR (50)  NULL,
    [Phone]             VARCHAR (50)  NULL,
    [Fax]               VARCHAR (50)  NULL,
    [Email]             VARCHAR (50)  NULL,
    [WebPage]           VARCHAR (100) NULL,
    [TSACume]           VARCHAR (50)  NULL,
    [TSAAQH]            VARCHAR (50)  NULL,
    [MetroMarketId]     BIGINT        NULL,
    [MetroMarketRank]   INT           NULL,
    [DMAMarketId]       BIGINT        NULL,
    [DMAMarketRank]     INT           NULL,
    [TimeZoneId]        BIGINT        NOT NULL,
    [HoursFromFlagship] INT           NULL,
    [MaxNumberOfUsers]  INT           NULL,
    [DisabledDate]      DATETIME      NULL,
    [DisabledUserId]    BIGINT        NULL,
    [CreatedDate]       DATETIME      CONSTRAINT [DEF_Station_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT        NOT NULL,
    [LastUpdatedDate]   DATETIME      CONSTRAINT [DEF_Station_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT        NOT NULL,
    CONSTRAINT [PK_Station] PRIMARY KEY CLUSTERED ([StationId] ASC),
    CONSTRAINT [FK_Station_Band_BandId] FOREIGN KEY ([BandId]) REFERENCES [dbo].[Band] ([BandId]),
    CONSTRAINT [FK_Station_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Station_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Station_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Station_CRCUser_PrimaryUserId] FOREIGN KEY ([PrimaryUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Station_DMAMarket_DMAMarketId] FOREIGN KEY ([DMAMarketId]) REFERENCES [dbo].[DMAMarket] ([DMAMarketId]),
    CONSTRAINT [FK_Station_LicenseeType_LicenseeTypeId] FOREIGN KEY ([LicenseeTypeId]) REFERENCES [dbo].[LicenseeType] ([LicenseeTypeId]),
    CONSTRAINT [FK_Station_MemberStatus_MemberStatusId] FOREIGN KEY ([MemberStatusId]) REFERENCES [dbo].[MemberStatus] ([MemberStatusId]),
    CONSTRAINT [FK_Station_MetroMarket_MetroMarketId] FOREIGN KEY ([MetroMarketId]) REFERENCES [dbo].[MetroMarket] ([MetroMarketId]),
    CONSTRAINT [FK_Station_MinorityStatus_MinorityStatusId] FOREIGN KEY ([MinorityStatusId]) REFERENCES [dbo].[MinorityStatus] ([MinorityStatusId]),
    CONSTRAINT [FK_Station_RepeaterStatus_RepeaterStatusId] FOREIGN KEY ([RepeaterStatusId]) REFERENCES [dbo].[RepeaterStatus] ([RepeaterStatusId]),
    CONSTRAINT [FK_Station_State_StateId] FOREIGN KEY ([StateId]) REFERENCES [dbo].[State] ([StateId]),
    CONSTRAINT [FK_Station_Station_FlagshipStationId] FOREIGN KEY ([FlagshipStationId]) REFERENCES [dbo].[Station] ([StationId]),
    CONSTRAINT [FK_Station_TimeZone_TimeZoneId] FOREIGN KEY ([TimeZoneId]) REFERENCES [dbo].[TimeZone] ([TimeZoneId])
);






GO



GO
CREATE NONCLUSTERED INDEX [IX_Station_TimeZoneId]
    ON [dbo].[Station]([TimeZoneId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_StateId]
    ON [dbo].[Station]([StateId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_RepeaterStatusId]
    ON [dbo].[Station]([RepeaterStatusId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_PrimaryUserId]
    ON [dbo].[Station]([PrimaryUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_MinorityStatusId]
    ON [dbo].[Station]([MinorityStatusId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_MetroMarketId]
    ON [dbo].[Station]([MetroMarketId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_MemberStatusId]
    ON [dbo].[Station]([MemberStatusId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_LicenseeTypeId]
    ON [dbo].[Station]([LicenseeTypeId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_LastUpdatedUserId]
    ON [dbo].[Station]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_FlagshipStationId]
    ON [dbo].[Station]([FlagshipStationId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_DMAMarketId]
    ON [dbo].[Station]([DMAMarketId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_DisabledUserId]
    ON [dbo].[Station]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_CreatedUserId]
    ON [dbo].[Station]([CreatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Station_BandId]
    ON [dbo].[Station]([BandId] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Station_CallLetters_BandId]
    ON [dbo].[Station]([CallLetters] ASC, [BandId] ASC);

