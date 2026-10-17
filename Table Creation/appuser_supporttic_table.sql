
USE BankingApplicationSupportDB;
GO

CREATE TABLE Application_Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    SupportLevel VARCHAR(10) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    IsActive BIT NOT NULL DEFAULT 1,

    CONSTRAINT CK_ApplicationUsers_Level
        CHECK (SupportLevel IN ('L1', 'L2'))
);
GO

INSERT INTO Application_Users
    (FullName, SupportLevel, Email)
VALUES
('Amit Shah', 'L1', 'amit.support@example.com'),
('Priya Nair', 'L1', 'priya.support@example.com'),
('Rahul Joshi', 'L2', 'rahul.support@example.com');
GO

SELECT * FROM Application_Users;
-----------------------------------------------------------

CREATE TABLE Support_Tickets
(
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    TransactionID INT NULL,
    AssignedUserID INT NULL,
    IssueCategory VARCHAR(30) NOT NULL,
    Description VARCHAR(500) NOT NULL,
    Priority VARCHAR(10) NOT NULL DEFAULT 'MEDIUM',
    TicketStatus VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    ResolvedAt DATETIME2 NULL,

    CONSTRAINT FK_Tickets_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    CONSTRAINT FK_Tickets_Transactions
        FOREIGN KEY (TransactionID)
        REFERENCES Transactions(TransactionID),

    CONSTRAINT FK_Tickets_AssignedUser
        FOREIGN KEY (AssignedUserID)
        REFERENCES Application_Users(UserID),

    CONSTRAINT CK_Tickets_Priority
        CHECK (Priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),

    CONSTRAINT CK_Tickets_Status
        CHECK (TicketStatus IN
        ('OPEN', 'IN_PROGRESS', 'ESCALATED', 'RESOLVED', 'CLOSED'))
);
GO


INSERT INTO Support_Tickets
(
    CustomerID, TransactionID, AssignedUserID,
    IssueCategory, Description, Priority, TicketStatus
)
VALUES
(1, 2, 1, 'TRANSACTION',
 'Amount debit query raised for failed transaction',
 'HIGH', 'OPEN'),

(2, 4, 2, 'TRANSACTION',
 'Transaction pending for a long time',
 'MEDIUM', 'IN_PROGRESS'),

(3, NULL, 1, 'LOGIN',
 'Customer unable to log in to banking application',
 'MEDIUM', 'OPEN'),

(4, 5, 3, 'TRANSACTION',
 'Failed transaction requires further investigation',
 'CRITICAL', 'ESCALATED'),

(5, NULL, NULL, 'BALANCE',
 'Customer reported a balance mismatch',
 'HIGH', 'OPEN');
GO

select * from Support_Tickets;

-----------------------------------------

SELECT
    st.TicketID,
    c.FullName AS CustomerName,
    st.IssueCategory,
    t.ReferenceNumber,
    st.Priority,
    st.TicketStatus,
    au.FullName AS AssignedEngineer,
    au.SupportLevel
FROM Support_Tickets st
INNER JOIN Customers c
    ON st.CustomerID = c.CustomerID
LEFT JOIN Transactions t
    ON st.TransactionID = t.TransactionID
LEFT JOIN Application_Users au
    ON st.AssignedUserID = au.UserID
WHERE st.TicketStatus IN ('OPEN', 'ESCALATED')
ORDER BY
    CASE st.Priority
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH' THEN 2
        WHEN 'MEDIUM' THEN 3
        WHEN 'LOW' THEN 4
    END,
    st.CreatedAt;
GO
