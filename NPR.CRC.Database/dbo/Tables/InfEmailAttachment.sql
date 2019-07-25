CREATE TABLE [dbo].[InfEmailAttachment] (
    [InfEmailAttachmentId] BIGINT          IDENTITY (1, 1) NOT NULL,
    [InfEmailId]           BIGINT          NOT NULL,
    [AttachmentName]       VARCHAR (100)   NOT NULL,
    [AttachmentBytes]      VARBINARY (MAX) NOT NULL,
    [AttachmentSize]       AS              (datalength([AttachmentBytes])),
    [CreatedDate]          DATETIME        NOT NULL,
    [CreatedUserId]        BIGINT          NOT NULL,
    [LastUpdatedDate]      DATETIME        NOT NULL,
    [LastUpdatedUserId]    BIGINT          NOT NULL,
    CONSTRAINT [PK_InfEmailAttachment] PRIMARY KEY CLUSTERED ([InfEmailAttachmentId] ASC),
    CONSTRAINT [FK_InfEmailAttachment_CRCUser_CreatedUserId] FOREIGN KEY ([CreatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_InfEmailAttachment_CRCUser_LastUpdatedUserId] FOREIGN KEY ([LastUpdatedUserId]) REFERENCES [dbo].[CRCUser] ([UserId]),
    CONSTRAINT [FK_InfEmailAttachment_InfEmail_InfEmailId] FOREIGN KEY ([InfEmailId]) REFERENCES [dbo].[InfEmail] ([InfEmailId])
);


GO
CREATE NONCLUSTERED INDEX [IX_InfEmailAttachment_LastUpdatedUserId]
    ON [dbo].[InfEmailAttachment]([LastUpdatedUserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_InfEmailAttachment_InfEmailId]
    ON [dbo].[InfEmailAttachment]([InfEmailId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_InfEmailAttachment_CreatedUserId]
    ON [dbo].[InfEmailAttachment]([CreatedUserId] ASC);

