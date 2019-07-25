CREATE TABLE [dbo].[ScheduleNewscast] (
    [ScheduleNewscastId] BIGINT   IDENTITY (1, 1) NOT NULL,
    [ScheduleId]         BIGINT   NOT NULL,
    [StartTime]          TIME (7) NOT NULL,
    [EndTime]            TIME (7) NOT NULL,
    [HourlyInd]          CHAR (1) CONSTRAINT [DEF_ScheduleNewscast_HourlyInd] DEFAULT ('N') NOT NULL,
    [DurationMinutes]    INT      NULL,
    [SundayInd]          CHAR (1) CONSTRAINT [DEF_ScheduleNewscast_SundayInd] DEFAULT ('N') NOT NULL,
    [MondayInd]          CHAR (1) CONSTRAINT [DEF_ScheduleNewscast_MondayInd] DEFAULT ('N') NOT NULL,
    [TuesdayInd]         CHAR (1) CONSTRAINT [DEF_ScheduleNewscast_TuesdayInd] DEFAULT ('N') NOT NULL,
    [WednesdayInd]       CHAR (1) CONSTRAINT [DEF_ScheduleNewscast_WednesdayInd] DEFAULT ('N') NOT NULL,
    [ThursdayInd]        CHAR (1) CONSTRAINT [DEF_ScheduleNewscast_ThursdayInd] DEFAULT ('N') NOT NULL,
    [FridayInd]          CHAR (1) CONSTRAINT [DEF_ScheduleNewscast_FridayInd] DEFAULT ('N') NOT NULL,
    [SaturdayInd]        CHAR (1) CONSTRAINT [DEF_ScheduleNewscast_SaturdayInd] DEFAULT ('N') NOT NULL,
    [CreatedDate]        DATETIME CONSTRAINT [DEF_ScheduleNewscast_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]      BIGINT   NOT NULL,
    [LastUpdatedDate]    DATETIME CONSTRAINT [DEF_ScheduleNewscast_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId]  BIGINT   NOT NULL,
    CONSTRAINT [PK_ScheduleNewscast] PRIMARY KEY CLUSTERED ([ScheduleNewscastId] ASC),
    CONSTRAINT [CHK_ScheduleNewscast_FridayInd] CHECK ([FridayInd]='N' OR [FridayInd]='Y'),
    CONSTRAINT [CHK_ScheduleNewscast_HourlyInd] CHECK ([HourlyInd]='N' OR [HourlyInd]='Y'),
    CONSTRAINT [CHK_ScheduleNewscast_MondayInd] CHECK ([MondayInd]='N' OR [MondayInd]='Y'),
    CONSTRAINT [CHK_ScheduleNewscast_SaturdayInd] CHECK ([SaturdayInd]='N' OR [SaturdayInd]='Y'),
    CONSTRAINT [CHK_ScheduleNewscast_SundayInd] CHECK ([SundayInd]='N' OR [SundayInd]='Y'),
    CONSTRAINT [CHK_ScheduleNewscast_ThursdayInd] CHECK ([ThursdayInd]='N' OR [ThursdayInd]='Y'),
    CONSTRAINT [CHK_ScheduleNewscast_TuesdayInd] CHECK ([TuesdayInd]='N' OR [TuesdayInd]='Y'),
    CONSTRAINT [CHK_ScheduleNewscast_WednesdayInd] CHECK ([WednesdayInd]='N' OR [WednesdayInd]='Y'),
    CONSTRAINT [FK_ScheduleNewscast_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_ScheduleNewscast_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_ScheduleNewscast_Schedule_ScheduleId] FOREIGN KEY ([ScheduleId]) REFERENCES [dbo].[Schedule] ([ScheduleId])
);


GO
CREATE NONCLUSTERED INDEX [IX_ScheduleNewscast_ScheduleId]
    ON [dbo].[ScheduleNewscast]([ScheduleId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ScheduleNewscast_LastUpdatedUserId]
    ON [dbo].[ScheduleNewscast]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ScheduleNewscast_CreatedUserId]
    ON [dbo].[ScheduleNewscast]([CreatedUserId] ASC);

