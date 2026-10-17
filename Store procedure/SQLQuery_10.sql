---- Step 12 — Error Handling (TRY...CATCH) and Safe Transaction Handling

USE BankingApplicationSupportDB;
GO

SELECT DB_NAME() AS CurrentDatabase;

SELECT name
FROM sys.procedures
WHERE name = 'usp_UpdateTicketStatus';
GO

-----------

EXEC dbo.usp_UpdateTicketStatus
    @TicketID = 999,
    @UpdatedBy = 1,
    @NewStatus = 'IN_PROGRESS',
    @UpdateNotes = 'Testing invalid ticket error.';
GO

-------
USE [BankingApplicationSupportDB];
GO

EXEC [dbo].[usp_UpdateTicketStatus]
    @TicketID = 999,
    @UpdatedBy = 1,
    @NewStatus = 'IN_PROGRESS',
    @UpdateNotes = 'Testing invalid ticket error';
GO

SELECT
    DB_NAME() AS CurrentDatabase,
    SCHEMA_NAME(schema_id) AS ProcedureSchema,
    name AS ProcedureName
FROM sys.procedures
WHERE name = 'usp_UpdateTicketStatus';
GO