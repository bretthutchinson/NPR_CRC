CREATE TABLE [dbo].[Producer] (
    [ProducerId]        BIGINT        IDENTITY (1, 1) NOT NULL,
    [SalutationId]      BIGINT        NULL,
    [FirstName]         VARCHAR (50)  NOT NULL,
    [MiddleName]        VARCHAR (50)  NULL,
    [LastName]          VARCHAR (50)  NOT NULL,
    [Suffix]            VARCHAR (50)  NULL,
    [Role]              VARCHAR (50)  NULL,
    [Email]             VARCHAR (100) NULL,
    [Phone]             VARCHAR (50)  NULL,
    [DisabledDate]      DATETIME      NULL,
    [DisabledUserId]    BIGINT        NULL,
    [CreatedDate]       DATETIME      CONSTRAINT [DEF_Producer_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT        NOT NULL,
    [LastUpdatedDate]   DATETIME      CONSTRAINT [DEF_Producer_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT        NOT NULL,
    CONSTRAINT [PK_Producer] PRIMARY KEY CLUSTERED ([ProducerId] ASC),
    CONSTRAINT [FK_Producer_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Producer_CRCUser_DisabledUserId] FOREIGN KEY ([DisabledUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Producer_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Producer_Salutation_SalutationId] FOREIGN KEY ([SalutationId]) REFERENCES [dbo].[Salutation] ([SalutationId])
);


GO
CREATE NONCLUSTERED INDEX [IX_Producer_SalutationId]
    ON [dbo].[Producer]([SalutationId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Producer_LastUpdatedUserId]
    ON [dbo].[Producer]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Producer_DisabledUserId]
    ON [dbo].[Producer]([DisabledUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Producer_CreatedUserId]
    ON [dbo].[Producer]([CreatedUserId] ASC);

