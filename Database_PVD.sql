CREATE DATABASE IF NOT EXISTS newspaper_department;

USE newspaper_department;

CREATE TABLE IF NOT EXISTS newspaper_department (
    BranchID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    DAddress VARCHAR(255) NOT NULL,
    DName VARCHAR(127) NOT NULL
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS employee (
    EmployeeID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    EEmailAddress VARCHAR(100) NOT NULL,
    EName VARCHAR(100) NOT NULL,
    EPhoneNum VARCHAR(15) NULL,
    EType VARCHAR(100) NOT NULL,
    EBankAccount VARCHAR(100) NULL,
    BranchID INT NOT NULL,
    StartDate DATE NOT NULL,
    CONSTRAINT fk_branch_employee FOREIGN KEY (BranchID)
        REFERENCES newspaper_department (BranchID)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS accountant (
    EmployeeID INT,
    CONSTRAINT fk_employee_accountant FOREIGN KEY (EmployeeID)
        REFERENCES employee (EmployeeID)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS manager (
    EmployeeID INT NOT NULL,
    BranchID INT NOT NULL,
    CONSTRAINT fk_manager_branch FOREIGN KEY (BranchID)
        REFERENCES newspaper_department (BranchID),
    CONSTRAINT fk_employee_manager FOREIGN KEY (EmployeeID)
        REFERENCES employee (EmployeeID)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS editor (
    EmployeeID INT,
    ESpeciality VARCHAR(31),
    EPosition VARCHAR(31),
    CONSTRAINT fk_employee_editor FOREIGN KEY (EmployeeID)
        REFERENCES employee (EmployeeID)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS author (
    EmployeeID INT,
    ESpeciality VARCHAR(31),
    EPosition VARCHAR(31),
    CONSTRAINT fk_employee_author FOREIGN KEY (EmployeeID)
        REFERENCES employee (EmployeeID)
)  ENGINE=INNODB;

CREATE TABLE bill (
    BillID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    PayDate DATE NOT NULL,
    TotalAmount INT NOT NULL,
    UnpaidAmount INT NOT NULL,
    Status VARCHAR(31) NOT NULL,
    BAccountantID INT NOT NULL,
    BIArticleID INT NOT NULL,
    CONSTRAINT fk_accountant_bill FOREIGN KEY (BAccountantID)
        REFERENCES accountant (EmployeeID),
    CONSTRAINT fk_article_bill FOREIGN KEY (BIArticleID)
        REFERENCES article (ArticleID)
)  ENGINE=INNODB;
