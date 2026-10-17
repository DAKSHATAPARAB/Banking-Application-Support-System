
USE BankingApplicationSupportDB;
GO

CREATE TABLE Transaction_Status
(
    StatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName VARCHAR(20) NOT NULL UNIQUE,
    Description VARCHAR(200)
);
GO

INSERT INTO Transaction_Status (StatusName, Description)
VALUES
('SUCCESS', 'Transaction completed successfully'),
('FAILED', 'Transaction failed'),
('PENDING', 'Transaction awaiting completion'),
('REVERSED', 'Transaction amount reversed');
GO

SELECT * FROM Transaction_Status;

---------------------------------

CREATE TABLE Transactions
(
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT NOT NULL,
    StatusID INT NOT NULL,
    TransactionType VARCHAR(10) NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    TransactionDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    ReferenceNumber VARCHAR(30) NOT NULL UNIQUE,

    CONSTRAINT FK_Transactions_Accounts
        FOREIGN KEY (AccountID)
        REFERENCES Accounts(AccountID),

    CONSTRAINT FK_Transactions_Status
        FOREIGN KEY (StatusID)
        REFERENCES Transaction_Status(StatusID),

    CONSTRAINT CK_Transactions_Type
        CHECK (TransactionType IN ('DEBIT', 'CREDIT')),

    CONSTRAINT CK_Transactions_Amount
        CHECK (Amount > 0)
);
GO

INSERT INTO Transactions
    (AccountID, StatusID, TransactionType, Amount, ReferenceNumber)
VALUES
(1, 1, 'DEBIT',  5000.00, 'TXN1001'),
(1, 2, 'DEBIT',  2000.00, 'TXN1002'),
(2, 1, 'CREDIT', 10000.00, 'TXN1003'),
(3, 3, 'DEBIT',  1500.00, 'TXN1004'),
(4, 2, 'DEBIT',  3000.00, 'TXN1005'),
(5, 1, 'CREDIT', 7000.00, 'TXN1006'),
(6, 4, 'CREDIT', 2000.00, 'TXN1007');
GO

select * from Transactions;
--------------------------------------
SELECT
    c.FullName,
    a.AccountNumber,
    t.TransactionID,
    t.ReferenceNumber,
    t.TransactionType,
    t.Amount,
    s.StatusName,
    t.TransactionDate
FROM Transactions t
INNER JOIN Accounts a
    ON t.AccountID = a.AccountID
INNER JOIN Customers c
    ON a.CustomerID = c.CustomerID
INNER JOIN Transaction_Status s
    ON t.StatusID = s.StatusID
WHERE t.ReferenceNumber = 'TXN1002';
GO
