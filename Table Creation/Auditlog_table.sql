
USE BankingApplicationSupportDB;
GO

CREATE TABLE Audit_Log
(
    AuditID BIGINT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NULL,
    TransactionID INT NULL,
    ChangedBy INT NULL,
    ActionType VARCHAR(20) NOT NULL,
    TableName VARCHAR(100) NOT NULL,
    RecordID VARCHAR(50) NOT NULL,
    OldValue VARCHAR(1000) NULL,
    NewValue VARCHAR(1000) NULL,
    ChangeDescription VARCHAR(500),
    ChangedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_AuditLog_Ticket
        FOREIGN KEY (TicketID)
        REFERENCES Support_Tickets(TicketID),

    CONSTRAINT FK_AuditLog_Transaction
        FOREIGN KEY (TransactionID)
        REFERENCES Transactions(TransactionID),

    CONSTRAINT FK_AuditLog_User
        FOREIGN KEY (ChangedBy)
        REFERENCES Application_Users(UserID),

    CONSTRAINT CK_AuditLog_Action
        CHECK (ActionType IN ('INSERT', 'UPDATE', 'DELETE', 'STATUS_CHANGE'))
);
GO


INSERT INTO Audit_Log
(
    TicketID, TransactionID, ChangedBy,
    ActionType, TableName, RecordID,
    OldValue, NewValue, ChangeDescription
)
VALUES
(
    1, 2, 1,
    'STATUS_CHANGE', 'Support_Tickets', '1',
    'OPEN', 'ESCALATED',
    'Ticket escalated to L2 for transaction investigation'
),
(
    2, 4, 2,
    'UPDATE', 'Ticket_Updates', '3',
    'Transaction status not checked',
    'Transaction status checked: PENDING',
    'L1 investigation note updated'
),
(
    4, 5, 3,
    'STATUS_CHANGE', 'Support_Tickets', '4',
    'IN_PROGRESS', 'ESCALATED',
    'Ticket requires L2 investigation'
);
GO

SELECT * FROM Audit_Log;
-------------------------------------

SELECT
    al.AuditID,
    al.TicketID,
    al.TableName,
    al.RecordID,
    al.ActionType,
    au.FullName AS ChangedBy,
    al.OldValue,
    al.NewValue,
    al.ChangeDescription,
    al.ChangedAt
FROM Audit_Log al
LEFT JOIN Application_Users au
    ON al.ChangedBy = au.UserID
WHERE al.TicketID = 1
ORDER BY al.ChangedAt DESC;
GO

