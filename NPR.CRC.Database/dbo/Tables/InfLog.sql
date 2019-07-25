CREATE TABLE [dbo].[InfLog] (
    [InfLogId]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [LogDate]        DATETIME      NOT NULL,
    [LogLevel]       INT           NOT NULL,
    [Source]         VARCHAR (250) NOT NULL,
    [Message]        VARCHAR (MAX) NOT NULL,
    [UserName]       VARCHAR (50)  NULL,
    [ServerAddress]  VARCHAR (50)  NULL,
    [ServerHostname] VARCHAR (50)  NULL,
    [ClientAddress]  VARCHAR (50)  NULL,
    [ClientHostname] VARCHAR (50)  NULL,
    [SerialNumber]   VARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_InfLog] PRIMARY KEY CLUSTERED ([InfLogId] ASC)
);

