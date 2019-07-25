CREATE TABLE [dbo].[Salutation] (
    [SalutationId]      BIGINT       IDENTITY (1, 1) NOT NULL,
    [SalutationName]    VARCHAR (50) NOT NULL,
    [CreatedDate]       DATETIME     CONSTRAINT [DEF_Salutation_CreatedDate] DEFAULT (getutcdate()) NOT NULL,
    [CreatedUserId]     BIGINT       NOT NULL,
    [LastUpdatedDate]   DATETIME     CONSTRAINT [DEF_Salutation_LastUpdatedDate] DEFAULT (getutcdate()) NOT NULL,
    [LastUpdatedUserId] BIGINT       NOT NULL,
    CONSTRAINT [PK_Salutation] PRIMARY KEY CLUSTERED ([SalutationId] ASC),
    CONSTRAINT [FK_Salutation_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_Salutation_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Salutation_SalutationName]
    ON [dbo].[Salutation]([SalutationName] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Salutation_LastUpdatedUserId]
    ON [dbo].[Salutation]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Salutation_CreatedUserId]
    ON [dbo].[Salutation]([CreatedUserId] ASC);

