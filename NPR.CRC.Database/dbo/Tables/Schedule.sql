CREATE TABLE [dbo].[Schedule] (
    [ScheduleId]        BIGINT   IDENTITY (1, 1) NOT NULL,
    [StationId]         BIGINT   NOT NULL,
    [Year]              INT      NOT NULL,
    [Month]             INT      NOT NULL,
    [Status]            AS       (case when [AcceptedDate] IS NOT NULL then 'Accepted' when [SubmittedDate] IS NOT NULL then 'Unaccepted' else 'Unsubmitted' end),
    [SubmittedDate]     DATETIME NULL,
    [SubmittedUserId]   BIGINT   NULL,
    [AcceptedDate]      DATETIME NULL,
    [AcceptedUserId]    BIGINT   NULL,
    [CreatedDate]       DATETIME CONSTRAINT [DEF_Schedule_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT   NOT NULL,
    [LastUpdatedDate]   DATETIME CONSTRAINT [DEF_Schedule_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT   NOT NULL,
    CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED ([ScheduleId] ASC),
    CONSTRAINT [CHK_Schedule_Month] CHECK ([Month]>=(1) AND [Month]<=(12)),
    CONSTRAINT [CHK_Schedule_Year] CHECK ([Year]>=(1990) AND [Year]<=(2199)),
    CONSTRAINT [FK_Schedule_CRCUser_AcceptedUserId] FOREIGN KEY ([AcceptedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Schedule_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Schedule_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Schedule_CRCUser_SubmittedUserId] FOREIGN KEY ([SubmittedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Schedule_Station_StationId] FOREIGN KEY ([StationId]) REFERENCES [dbo].[Station] ([StationId])
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Schedule_StationId_Year_Month]
    ON [dbo].[Schedule]([StationId] ASC, [Year] ASC, [Month] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Schedule_SubmittedUserId]
    ON [dbo].[Schedule]([SubmittedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Schedule_StationId]
    ON [dbo].[Schedule]([StationId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Schedule_LastUpdatedUserId]
    ON [dbo].[Schedule]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Schedule_CreatedUserId]
    ON [dbo].[Schedule]([CreatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Schedule_AcceptedUserId]
    ON [dbo].[Schedule]([AcceptedUserId] ASC);

