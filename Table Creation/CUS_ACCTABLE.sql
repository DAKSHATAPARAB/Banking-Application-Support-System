-------- DATABASE CREATION

CREATE DATABASE BankingApplicationSupportDB;
GO

USE BankingApplicationSupportDB;
GO
SELECT DB_NAME() AS CurrentDatabase;



-------- customer table --------------
CREATE TABLE Customers
(
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    City VARCHAR(50),
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

--------- account table ------------

CREATE TABLE Accounts
(
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    AccountNumber VARCHAR(20) NOT NULL UNIQUE,
    AccountType VARCHAR(20) NOT NULL,
    Balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    AccountStatus VARCHAR(20) NOT NULL DEFAULT 'Active',
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Accounts_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    CONSTRAINT CK_Accounts_Balance
        CHECK (Balance >= 0),

    CONSTRAINT CK_Accounts_Type
        CHECK (AccountType IN ('Savings', 'Current')),

    CONSTRAINT CK_Accounts_Status
        CHECK (AccountStatus IN ('Active', 'Inactive', 'Frozen'))
);
GO
-----------------------------
INSERT INTO Customers (FullName, Email, Phone, City)
VALUES
('Aarav Sharma', 'aarav@example.com', '9000000001', 'Mumbai'),
('Priya Patel', 'priya@example.com', '9000000002', 'Thane'),
('Rahul Mehta', 'rahul@example.com', '9000000003', 'Mumbai'),
('Sneha Shah', 'sneha@example.com', '9000000004', 'Navi Mumbai'),
('Neha Verma', 'neha@example.com', '9000000005', 'Mumbai');
GO
--------------------------------
INSERT INTO Accounts
    (CustomerID, AccountNumber, AccountType, Balance, AccountStatus)
VALUES
(1, 'BA100001', 'Savings', 25000.00, 'Active'),
(1, 'BA100002', 'Current', 50000.00, 'Active'),
(2, 'BA100003', 'Savings', 18000.00, 'Active'),
(3, 'BA100004', 'Savings', 12000.00, 'Frozen'),
(4, 'BA100005', 'Current', 40000.00, 'Active'),
(5, 'BA100006', 'Savings',  8000.00, 'Inactive');
GO

SELECT * FROM Customers;

SELECT * FROM Accounts;
GO

SELECT
    c.CustomerID,
    c.FullName,
    a.AccountNumber,
    a.AccountType,
    a.Balance,
    a.AccountStatus
FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID;
GO