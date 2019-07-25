CREATE TABLE [dbo].[ProgramProducer] (
    [ProgramProducerId] BIGINT   IDENTITY (1, 1) NOT NULL,
    [ProgramId]         BIGINT   NOT NULL,
    [ProducerId]        BIGINT   NOT NULL,
    [CreatedDate]       DATETIME CONSTRAINT [DEF_ProgramProducer_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT   NOT NULL,
    [LastUpdatedDate]   DATETIME CONSTRAINT [DEF_ProgramProducer_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT   NOT NULL,
    CONSTRAINT [PK_ProgramProducer] PRIMARY KEY CLUSTERED ([ProgramProducerId] ASC),
    CONSTRAINT [FK_ProgramProducer_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_ProgramProducer_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_ProgramProducer_Producer_ProducerId] FOREIGN KEY ([ProducerId]) REFERENCES [dbo].[Producer] ([ProducerId]),
    CONSTRAINT [FK_ProgramProducer_Program_ProgramId] FOREIGN KEY ([ProgramId]) REFERENCES [dbo].[Program] ([ProgramId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProgramProducer_ProducerId_ProgramId]
    ON [dbo].[ProgramProducer]([ProducerId] ASC, [ProgramId] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProgramProducer_ProgramId_ProducerId]
    ON [dbo].[ProgramProducer]([ProgramId] ASC, [ProducerId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProgramProducer_ProgramId]
    ON [dbo].[ProgramProducer]([ProgramId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProgramProducer_ProducerId]
    ON [dbo].[ProgramProducer]([ProducerId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProgramProducer_LastUpdatedUserId]
    ON [dbo].[ProgramProducer]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_ProgramProducer_CreatedUserId]
    ON [dbo].[ProgramProducer]([CreatedUserId] ASC);

