CREATE TABLE [dbo].[State] (
    [StateId]           BIGINT       IDENTITY (1, 1) NOT NULL,
    [StateName]         VARCHAR (50) NOT NULL,
    [Abbreviation]      VARCHAR (50) NOT NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_State_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_State_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED ([StateId] ASC),
    CONSTRAINT [FK_State_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_State_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_State_Abbreviation]
    ON [dbo].[State]([Abbreviation] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_State_StateName]
    ON [dbo].[State]([StateName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_State_LastUpdatedUserId]
    ON [dbo].[State]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_State_CreatedUserId]
    ON [dbo].[State]([CreatedUserId] ASC);

