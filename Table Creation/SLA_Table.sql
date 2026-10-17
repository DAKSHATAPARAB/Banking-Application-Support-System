
USE BankingApplicationSupportDB;
GO


CREATE TABLE dbo.SLA_Tracking
(
    SLAID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NOT NULL UNIQUE,
    ResponseTargetMinutes INT NOT NULL,
    ResolutionTargetHours INT NOT NULL,
    FirstResponseAt DATETIME2 NULL,
    ResolutionDeadline DATETIME2 NOT NULL,
    SLACreatedAt DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),

    CONSTRAINT FK_SLA_Ticket
        FOREIGN KEY (TicketID)
        REFERENCES dbo.Support_Tickets (TicketID),

    CONSTRAINT CK_SLA_Response
        CHECK (ResponseTargetMinutes > 0),

    CONSTRAINT CK_SLA_Resolution
        CHECK (ResolutionTargetHours > 0)
);
GO

---------------------


INSERT INTO SLA_Tracking
(
    TicketID,
    ResponseTargetMinutes,
    ResolutionTargetHours,
    FirstResponseAt,
    ResolutionDeadline
)
SELECT
    TicketID,
    CASE Priority
        WHEN 'CRITICAL' THEN 15
        WHEN 'HIGH' THEN 30
        WHEN 'MEDIUM' THEN 120
        WHEN 'LOW' THEN 240
    END,
    CASE Priority
        WHEN 'CRITICAL' THEN 4
        WHEN 'HIGH' THEN 8
        WHEN 'MEDIUM' THEN 24
        WHEN 'LOW' THEN 48
    END,
    NULL,
    DATEADD
    (
        HOUR,
        CASE Priority
            WHEN 'CRITICAL' THEN 4
            WHEN 'HIGH' THEN 8
            WHEN 'MEDIUM' THEN 24
            WHEN 'LOW' THEN 48
        END,
        CreatedAt
    )
FROM Support_Tickets;
GO

SELECT * FROM SLA_Tracking;
----------------------------------------

SELECT
    st.TicketID,
    st.Priority,
    st.TicketStatus,
    st.CreatedAt,
    sla.ResolutionDeadline,
    DATEDIFF
    (
        MINUTE,
        sla.ResolutionDeadline,
        SYSDATETIME()
    ) AS MinutesPastDeadline
FROM Support_Tickets st
INNER JOIN SLA_Tracking sla
    ON st.TicketID = sla.TicketID
WHERE sla.ResolutionDeadline < SYSDATETIME()
  AND st.TicketStatus NOT IN ('RESOLVED', 'CLOSED')
ORDER BY sla.ResolutionDeadline;
GO


