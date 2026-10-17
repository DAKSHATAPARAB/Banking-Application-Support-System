
USE BankingApplicationSupportDB;
GO

CREATE TABLE Error_Log
(
    ErrorID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NULL,
    TransactionID INT NULL,
    ErrorCode VARCHAR(50) NOT NULL,
    ErrorMessage VARCHAR(1000) NOT NULL,
    ErrorSource VARCHAR(100) NOT NULL,
    ErrorSeverity VARCHAR(20) NOT NULL,
    LoggedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    IsInvestigated BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_ErrorLog_Ticket
        FOREIGN KEY (TicketID)
        REFERENCES Support_Tickets(TicketID),

    CONSTRAINT FK_ErrorLog_Transaction
        FOREIGN KEY (TransactionID)
        REFERENCES Transactions(TransactionID),

    CONSTRAINT CK_ErrorLog_Severity
        CHECK (ErrorSeverity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL'))
);
GO



INSERT INTO Error_Log
(
    TicketID, TransactionID, ErrorCode,
    ErrorMessage, ErrorSource, ErrorSeverity
)
VALUES
(1, 2, 'TXN-500',
 'Transaction processing failed. Further investigation required.',
 'PaymentService', 'HIGH'),

(2, 4, 'API-408',
 'Payment status response timed out.',
 'PaymentAPI', 'MEDIUM'),

(4, 5, 'DB-500',
 'Database operation failed during transaction processing.',
 'TransactionService', 'CRITICAL'),

(3, NULL, 'AUTH-401',
 'Authentication failed during login attempt.',
 'AuthenticationService', 'MEDIUM'),

(NULL, NULL, 'SYS-503',
 'Banking service temporarily unavailable.',
 'BankingApplication', 'HIGH');
GO

SELECT * FROM Error_Log;
----------------------------------

SELECT
    st.TicketID,
    st.Description AS TicketDescription,
    t.ReferenceNumber,
    s.StatusName AS TransactionStatus,
    e.ErrorCode,
    e.ErrorMessage,
    e.ErrorSource,
    e.ErrorSeverity,
    e.LoggedAt,
    e.IsInvestigated
FROM Support_Tickets st
LEFT JOIN Transactions t
    ON st.TransactionID = t.TransactionID
LEFT JOIN Transaction_Status s
    ON t.StatusID = s.StatusID
LEFT JOIN Error_Log e
    ON st.TicketID = e.TicketID
WHERE st.TicketID = 1
ORDER BY e.LoggedAt DESC;
GO

