USE BankingApplicationSupportDB;
GO

-- Check tables
SELECT name AS TableName
FROM sys.tables
ORDER BY name;

-- Check views
SELECT name AS ViewName
FROM sys.views
ORDER BY name;
GO

-------------
-- Stored procedures
SELECT name AS ProcedureName
FROM sys.procedures
WHERE name IN
(
    'usp_GetTicketInvestigation',
    'usp_UpdateTicketStatus'
);

-- Trigger
SELECT name AS TriggerName
FROM sys.triggers
WHERE name = 'trg_SupportTickets_AuditStatus';
GO

----------
SELECT * FROM dbo.vw_TicketSummary;

SELECT * FROM dbo.vw_TransactionErrorReport;

EXEC dbo.usp_GetTicketInvestigation @TicketID = 1;
GO