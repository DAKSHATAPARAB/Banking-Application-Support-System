
USE BankingApplicationSupportDB;
GO

CREATE TABLE Ticket_Updates
(
    UpdateID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NOT NULL,
    UpdatedBy INT NOT NULL,
    UpdateType VARCHAR(20) NOT NULL,
    UpdateNotes VARCHAR(1000) NOT NULL,
    OldStatus VARCHAR(20) NULL,
    NewStatus VARCHAR(20) NULL,
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_TicketUpdates_Ticket
        FOREIGN KEY (TicketID)
        REFERENCES Support_Tickets(TicketID),

    CONSTRAINT FK_TicketUpdates_User
        FOREIGN KEY (UpdatedBy)
        REFERENCES Application_Users(UserID),

    CONSTRAINT CK_TicketUpdates_Type
        CHECK (UpdateType IN
        ('INVESTIGATION', 'WORKAROUND',
         'ESCALATION', 'RESOLUTION', 'STATUS_CHANGE'))
);
GO



INSERT INTO Ticket_Updates
(
    TicketID, UpdatedBy, UpdateType,
    UpdateNotes, OldStatus, NewStatus
)
VALUES
(1, 1, 'INVESTIGATION',
 'Checked transaction reference TXN1002. Status found as FAILED.',
 'OPEN', 'OPEN'),

(1, 1, 'ESCALATION',
 'Escalated to L2 to verify whether the amount was actually debited.',
 'OPEN', 'ESCALATED'),

(2, 2, 'INVESTIGATION',
 'Checked transaction TXN1004. Status is still PENDING in sample data.',
 'IN_PROGRESS', 'IN_PROGRESS'),

(3, 1, 'INVESTIGATION',
 'Login issue reported. Application and authentication logs need checking.',
 'OPEN', 'OPEN'),

(4, 3, 'ESCALATION',
 'L2 investigation required for failed transaction.',
 'ESCALATED', 'ESCALATED');
GO


select * from Ticket_Updates;

-------------------------------------

SELECT
    tu.UpdateID,
    tu.TicketID,
    c.FullName AS CustomerName,
    au.FullName AS UpdatedBy,
    au.SupportLevel,
    tu.UpdateType,
    tu.UpdateNotes,
    tu.OldStatus,
    tu.NewStatus,
    tu.UpdatedAt
FROM Ticket_Updates tu
INNER JOIN Support_Tickets st
    ON tu.TicketID = st.TicketID
INNER JOIN Customers c
    ON st.CustomerID = c.CustomerID
INNER JOIN Application_Users au
    ON tu.UpdatedBy = au.UserID
WHERE tu.TicketID = 1
ORDER BY tu.UpdatedAt, tu.UpdateID;
GO
