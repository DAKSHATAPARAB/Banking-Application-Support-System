--- Step 14 — Indexes

USE BankingApplicationSupportDB;
GO

EXEC sp_helpindex 'dbo.Support_Tickets';
GO

----
USE BankingApplicationSupportDB;
GO

CREATE NONCLUSTERED INDEX IX_Transactions_ReferenceNumber
ON dbo.Transactions (ReferenceNumber);
GO

------
EXEC sp_helpindex 'dbo.Transactions';
GO