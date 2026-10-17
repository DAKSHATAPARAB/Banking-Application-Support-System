------- Step 13 — Views
----- Create Ticket Summary View
USE BankingApplicationSupportDB;
GO

CREATE OR ALTER VIEW dbo.vw_TicketSummary
AS
SELECT
    st.TicketID,
    c.FullName AS CustomerName,
    st.IssueCategory,
    st.Priority,
    st.TicketStatus,
    au.FullName AS AssignedEngineer,
    au.SupportLevel,
    t.ReferenceNumber,
    t.Amount,
    ts.StatusName AS TransactionStatus,
    st.CreatedAt
FROM dbo.Support_Tickets st
INNER JOIN dbo.Customers c
    ON st.CustomerID = c.CustomerID
LEFT JOIN dbo.Application_Users au
    ON st.AssignedUserID = au.UserID
LEFT JOIN dbo.Transactions t
    ON st.TransactionID = t.TransactionID
LEFT JOIN dbo.Transaction_Status ts
    ON t.StatusID = ts.StatusID;
GO

SELECT *
FROM dbo.vw_TicketSummary
ORDER BY TicketID;
GO

---- Transaction Error Report View


CREATE OR ALTER VIEW dbo.vw_TransactionErrorReport
AS
SELECT
    t.TransactionID,
    t.ReferenceNumber,
    t.TransactionType,
    t.Amount,
    ts.StatusName AS TransactionStatus,
    st.TicketID,
    st.Priority AS TicketPriority,
    st.TicketStatus,
    e.ErrorCode,
    e.ErrorMessage,
    e.ErrorSource,
    e.ErrorSeverity,
    e.LoggedAt
FROM dbo.Transactions t
INNER JOIN dbo.Transaction_Status ts
    ON t.StatusID = ts.StatusID
LEFT JOIN dbo.Support_Tickets st
    ON t.TransactionID = st.TransactionID
LEFT JOIN dbo.Error_Log e
    ON t.TransactionID = e.TransactionID
WHERE ts.StatusName IN ('FAILED', 'PENDING');
GO

---- 
SELECT *
FROM dbo.vw_TransactionErrorReport
ORDER BY TransactionID;
GO

-----------


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Error_Log'
ORDER BY ORDINAL_POSITION;
GO