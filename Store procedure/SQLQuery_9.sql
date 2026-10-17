----- Step 11 — Ticket Status Update Stored Procedure banayenge.


USE BankingApplicationSupportDB;
GO

CREATE OR ALTER PROCEDURE dbo.usp_UpdateTicketStatus
    @TicketID INT,
    @UpdatedBy INT,
    @NewStatus VARCHAR(20),
    @UpdateNotes VARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @OldStatus VARCHAR(20);

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @OldStatus = TicketStatus
        FROM Support_Tickets WITH (UPDLOCK, HOLDLOCK)
        WHERE TicketID = @TicketID;

        IF @OldStatus IS NULL
            THROW 50001, 'Ticket does not exist.', 1;

        IF NOT EXISTS
        (
            SELECT 1
            FROM Application_Users
            WHERE UserID = @UpdatedBy
              AND IsActive = 1
        )
            THROW 50002, 'Active support user not found.', 1;

        IF @NewStatus NOT IN
        ('OPEN', 'IN_PROGRESS', 'ESCALATED', 'RESOLVED', 'CLOSED')
            THROW 50003, 'Invalid ticket status.', 1;

        IF @NewStatus = 'CLOSED'
           AND @OldStatus <> 'RESOLVED'
            THROW 50004, 'Resolve the ticket before closing it.', 1;

        UPDATE Support_Tickets
        SET TicketStatus = @NewStatus,
            ResolvedAt =
                CASE
                    WHEN @NewStatus = 'RESOLVED'
                        THEN COALESCE(ResolvedAt, SYSDATETIME())
                    WHEN @NewStatus IN ('OPEN', 'IN_PROGRESS', 'ESCALATED')
                        THEN NULL
                    ELSE ResolvedAt
                END
        WHERE TicketID = @TicketID;

        INSERT INTO Ticket_Updates
        (
            TicketID, UpdatedBy, UpdateType,
            UpdateNotes, OldStatus, NewStatus
        )
        VALUES
        (
            @TicketID, @UpdatedBy, 'STATUS_CHANGE',
            @UpdateNotes, @OldStatus, @NewStatus
        );

        COMMIT TRANSACTION;

        SELECT
            @TicketID AS TicketID,
            @OldStatus AS PreviousStatus,
            @NewStatus AS CurrentStatus,
            'Status updated successfully' AS Result;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

--- Procedure test karo
SELECT TicketID, TicketStatus
FROM Support_Tickets
WHERE TicketID = 1;

EXEC dbo.usp_UpdateTicketStatus
    @TicketID = 1,
    @UpdatedBy = 1,
    @NewStatus = 'IN_PROGRESS',
    @UpdateNotes = 'L1 started further investigation.';
GO

SELECT TicketID, TicketStatus, ResolvedAt
FROM Support_Tickets
WHERE TicketID = 1;

SELECT *
FROM Ticket_Updates
WHERE TicketID = 1
ORDER BY UpdateID;
GO

