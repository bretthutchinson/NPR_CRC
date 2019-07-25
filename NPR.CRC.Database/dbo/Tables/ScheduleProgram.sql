CREATE TABLE [dbo].[ScheduleProgram] (
    [ScheduleProgramId] BIGINT   IDENTITY (1, 1) NOT NULL,
    [ScheduleId]        BIGINT   NOT NULL,
    [ProgramId]         BIGINT   NOT NULL,
    [StartTime]         TIME (7) NOT NULL,
    [EndTime]           TIME (7) NOT NULL,
    [QuarterHours]      AS       ([dbo].[FN_CalculateQuarterHours]([StartTime],[EndTime])),
    [SundayInd]         CHAR (1) CONSTRAINT [DEF_ScheduleProgram_SundayInd] DEFAULT ('N') NOT NULL,
    [MondayInd]         CHAR (1) CONSTRAINT [DEF_ScheduleProgram_MondayInd] DEFAULT ('N') NOT NULL,
    [TuesdayInd]        CHAR (1) CONSTRAINT [DEF_ScheduleProgram_TuesdayInd] DEFAULT ('N') NOT NULL,
    [WednesdayInd]      CHAR (1) CONSTRAINT [DEF_ScheduleProgram_WednesdayInd] DEFAULT ('N') NOT NULL,
    [ThursdayInd]       CHAR (1) CONSTRAINT [DEF_ScheduleProgram_ThursdayInd] DEFAULT ('N') NOT NULL,
    [FridayInd]         CHAR (1) CONSTRAINT [DEF_ScheduleProgram_FridayInd] DEFAULT ('N') NOT NULL,
    [SaturdayInd]       CHAR (1) CONSTRAINT [DEF_ScheduleProgram_SaturdayInd] DEFAULT ('N') NOT NULL,
    [CreatedDate]       DATETIME CONSTRAINT [DEF_ScheduleProgram_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT   NOT NULL,
    [LastUpdatedDate]   DATETIME CONSTRAINT [DEF_ScheduleProgram_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT   NOT NULL,
    CONSTRAINT [PK_ScheduleProgram] PRIMARY KEY CLUSTERED ([ScheduleProgramId] ASC),
    CONSTRAINT [CHK_ScheduleProgram_FridayInd] CHECK ([FridayInd]='N' OR [FridayInd]='Y'),
    CONSTRAINT [CHK_ScheduleProgram_MondayInd] CHECK ([MondayInd]='N' OR [MondayInd]='Y'),
    CONSTRAINT [CHK_ScheduleProgram_SaturdayInd] CHECK ([SaturdayInd]='N' OR [SaturdayInd]='Y'),
    CONSTRAINT [CHK_ScheduleProgram_SundayInd] CHECK ([SundayInd]='N' OR [SundayInd]='Y'),
    CONSTRAINT [CHK_ScheduleProgram_ThursdayInd] CHECK ([ThursdayInd]='N' OR [ThursdayInd]='Y'),
    CONSTRAINT [CHK_ScheduleProgram_TuesdayInd] CHECK ([TuesdayInd]='N' OR [TuesdayInd]='Y'),
    CONSTRAINT [CHK_ScheduleProgram_WednesdayInd] CHECK ([WednesdayInd]='N' OR [WednesdayInd]='Y'),
    CONSTRAINT [FK_ScheduleProgram_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_ScheduleProgram_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_ScheduleProgram_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([ProgramId]),
    CONSTRAINT [FK_ScheduleProgram_Schedule_ScheduleId] FOREIGN KEY ([ScheduleId]) REFERENCES [dbo].[Schedule] ([ScheduleId])
);






GO
CREATE NONCLUSTERED INDEX [IX_ScheduleProgram_ScheduleId]
    ON [dbo].[ScheduleProgram]([ScheduleId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ScheduleProgram_ProgramId]
    ON [dbo].[ScheduleProgram]([ProgramId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ScheduleProgram_LastUpdatedUserId]
    ON [dbo].[ScheduleProgram]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ScheduleProgram_CreatedUserId]
    ON [dbo].[ScheduleProgram]([CreatedUserId] ASC);

