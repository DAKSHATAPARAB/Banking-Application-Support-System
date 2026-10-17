------ Step 15 — Automatic Audit Logging Trigger complete.
---- Step 16.1 — Incident 1: Failed transaction complaint

---Query 1 — Transaction details check karo
USE BankingApplicationSupportDB;
GO

SELECT
    t.ReferenceNumber,
    t.TransactionType,
    t.Amount,
    ts.StatusName AS TransactionStatus,
    t.AccountID
FROM dbo.Transactions t
INNER JOIN dbo.Transaction_Status ts
    ON t.StatusID = ts.StatusID
WHERE t.ReferenceNumber = 'TXN1002';
GO

---- Query 2 — Related ticket aur error check karo
SELECT
    st.TicketID,
    st.Priority,
    st.TicketStatus,
    e.ErrorCode,
    e.ErrorMessage,
    e.ErrorSource,
    e.ErrorSeverity
FROM dbo.Support_Tickets st
LEFT JOIN dbo.Error_Log e
    ON st.TicketID = e.TicketID
WHERE st.TransactionID =
(
    SELECT TransactionID
    FROM dbo.Transactions
    WHERE ReferenceNumber = 'TXN1002'
);
GO


---- Step 16.2 — Incident 2: Transaction Pending for Too Long karte hain.
--- Query 1 — Transaction status check karo
SELECT
    t.ReferenceNumber,
    t.TransactionType,
    t.Amount,
    ts.StatusName AS TransactionStatus
FROM dbo.Transactions t
INNER JOIN dbo.Transaction_Status ts
    ON t.StatusID = ts.StatusID
WHERE t.ReferenceNumber = 'TXN1004';
GO

---Query 2 — Related ticket aur error log check karo
SELECT
    st.TicketID,
    st.Priority,
    st.TicketStatus,
    e.ErrorCode,
    e.ErrorMessage,
    e.ErrorSource,
    e.ErrorSeverity,
    e.LoggedAt
FROM dbo.Support_Tickets st
LEFT JOIN dbo.Error_Log e
    ON st.TicketID = e.TicketID
WHERE st.TransactionID =
(
    SELECT TransactionID
    FROM dbo.Transactions
    WHERE ReferenceNumber = 'TXN1004'
);
GO

---- Step 16.3 — Incident 3: Customer Account Balance Mismatch karte hain.
---Query 1 — Account details check karo
SELECT
    AccountID,
    AccountNumber,
    AccountType,
    Balance,
    AccountStatus
FROM dbo.Accounts
WHERE AccountID = 1;
GO

---Query 2 — Account ki transaction history check karo
SELECT
    t.ReferenceNumber,
    t.TransactionType,
    t.Amount,
    ts.StatusName AS TransactionStatus,
    t.TransactionDate
FROM dbo.Transactions t
INNER JOIN dbo.Transaction_Status ts
    ON t.StatusID = ts.StatusID
WHERE t.AccountID = 1
ORDER BY t.TransactionDate DESC;
GO

---- Step 16.4 — Incident 4: Login Failure karte hain.
--- Query 1 — Ticket details check karo
SELECT
    TicketID,
    CustomerID,
    IssueCategory,
    Description,
    Priority,
    TicketStatus,
    AssignedUserID
FROM dbo.Support_Tickets
WHERE TicketID = 3;
GO
---- Query 2 — Authentication error check karo
SELECT
    ErrorCode,
    ErrorMessage,
    ErrorSource,
    ErrorSeverity,
    LoggedAt
FROM dbo.Error_Log
WHERE TicketID = 3
ORDER BY LoggedAt DESC;
GO

----Step 16.5 — Incident 5: Critical Database Error

-- Query 1 — Transaction aur ticket details
SELECT
    t.ReferenceNumber,
    t.Amount,
    ts.StatusName AS TransactionStatus,
    st.TicketID,
    st.Priority,
    st.TicketStatus,
    au.FullName AS AssignedEngineer,
    au.SupportLevel
FROM dbo.Transactions t
INNER JOIN dbo.Transaction_Status ts
    ON t.StatusID = ts.StatusID
LEFT JOIN dbo.Support_Tickets st
    ON t.TransactionID = st.TransactionID
LEFT JOIN dbo.Application_Users au
    ON st.AssignedUserID = au.UserID
WHERE t.ReferenceNumber = 'TXN1005';
GO

---- Query 2 — Database error log
SELECT
    ErrorCode,
    ErrorMessage,
    ErrorSource,
    ErrorSeverity,
    LoggedAt
FROM dbo.Error_Log
WHERE TransactionID =
(
    SELECT TransactionID
    FROM dbo.Transactions
    WHERE ReferenceNumber = 'TXN1005'
)
ORDER BY LoggedAt DESC;
GO