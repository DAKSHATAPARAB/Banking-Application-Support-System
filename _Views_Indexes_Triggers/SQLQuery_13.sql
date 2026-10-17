------- Step 15 — Trigger for Automatic Audit Logging

-- Step 15.1 — Trigger create karo
USE BankingApplicationSupportDB;
GO

CREATE OR ALTER TRIGGER dbo.trg_SupportTickets_AuditStatus
ON dbo.Support_Tickets
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit_Log
    (
        TicketID,
        ActionType,
        OldValue,
        NewValue,
        ChangedAt
    )
    SELECT
        i.TicketID,
        'STATUS_CHANGE',
        d.TicketStatus,
        i.TicketStatus,
        SYSDATETIME()
    FROM inserted i
    INNER JOIN deleted d
        ON i.TicketID = d.TicketID
    WHERE
        ISNULL(i.TicketStatus, '') <> ISNULL(d.TicketStatus, '');
END;
GO

--- 
SELECT TicketID, TicketStatus
FROM dbo.Support_Tickets
WHERE TicketID = 3;
GO

------
UPDATE dbo.Support_Tickets
SET TicketStatus = 'IN_PROGRESS'
WHERE TicketID = 3;
GO

---
SELECT *
FROM dbo.Audit_Log
WHERE TicketID = 3
ORDER BY ChangedAt DESC;
GO