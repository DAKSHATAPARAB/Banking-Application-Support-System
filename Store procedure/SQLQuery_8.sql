----------- Stored Procedure: Ticket Investigation ------------------

USE BankingApplicationSupportDB;
GO

CREATE PROCEDURE usp_GetTicketInvestigation
    @TicketID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        st.TicketID,
        c.FullName AS CustomerName,
        c.Phone AS CustomerPhone,
        st.IssueCategory,
        st.Description AS TicketDescription,
        st.Priority,
        st.TicketStatus,
        t.ReferenceNumber,
        t.TransactionType,
        t.Amount,
        ts.StatusName AS TransactionStatus,
        e.ErrorCode,
        e.ErrorMessage,
        e.ErrorSource,
        au.FullName AS AssignedEngineer,
        au.SupportLevel,
        st.CreatedAt AS TicketCreatedAt
    FROM Support_Tickets st
    INNER JOIN Customers c
        ON st.CustomerID = c.CustomerID
    LEFT JOIN Transactions t
        ON st.TransactionID = t.TransactionID
    LEFT JOIN Transaction_Status ts
        ON t.StatusID = ts.StatusID
    LEFT JOIN Error_Log e
        ON st.TicketID = e.TicketID
    LEFT JOIN Application_Users au
        ON st.AssignedUserID = au.UserID
    WHERE st.TicketID = @TicketID;
END;
GO



EXEC usp_GetTicketInvestigation @TicketID = 1;
GO


EXEC usp_GetTicketInvestigation @TicketID = 3;
GO


USE BankingApplicationSupportDB;
GO

SELECT DB_NAME() AS CurrentDatabase;
GO

SELECT name
FROM sys.procedures
WHERE name = 'usp_GetTicketInvestigation';
GO

EXEC dbo.usp_GetTicketInvestigation @TicketID = 1;
GO

EXEC dbo.usp_GetTicketInvestigation @TicketID = 3;
GO