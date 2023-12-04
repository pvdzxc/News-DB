CREATE DATABASE IF NOT EXISTS newspaper_department;

USE newspaper_department;

-- DROP TABLE BILL;
-- DROP TABLE AUTHOR;
-- DROP TABLE Manager;
-- DROP TABLE Editor;
-- DROP TABLE accountant;

CREATE TABLE IF NOT EXISTS newspaper_department (
    BranchID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    DAddress VARCHAR(255) NOT NULL,
    DName VARCHAR(127) NOT NULL
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS employee (
    EmployeeID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    EEmailAddress VARCHAR(100) NOT NULL UNIQUE,
    EName VARCHAR(100) NOT NULL,
    EPhoneNum VARCHAR(15) NULL UNIQUE,
    EType ENUM("Author", "Editor", "Accountant", "Manager"),
    EBankAccount VARCHAR(100) NULL UNIQUE,
    BranchID INT NOT NULL,
    EStartDate DATE NOT NULL,
    CONSTRAINT fk_branch_employee FOREIGN KEY (BranchID)
        REFERENCES newspaper_department (BranchID)
)  ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS accountant (
    AccountantID INT,
    CONSTRAINT fk_employee_accountant FOREIGN KEY (AccountantID)
        REFERENCES employee (EmployeeID)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS manager (
    ManagerID INT NOT NULL,
    BranchID INT NOT NULL,
    CONSTRAINT fk_manager_branch FOREIGN KEY (BranchID)
        REFERENCES newspaper_department (BranchID),
    CONSTRAINT fk_employee_manager FOREIGN KEY (ManagerID)
        REFERENCES employee (EmployeeID)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS editor (
    EditorID INT,
    EUsername VARCHAR(31),
    ETotalReviewedArticle INT DEFAULT 0,
    -- EUsername
    CONSTRAINT fk_employee_editor FOREIGN KEY (EditorID)
        REFERENCES employee (EmployeeID)
    -- CONSTRAINT fk_user_editor FOREIGN KEY (EUsername)
    --    REFERENCES user (Username)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS author (
    AuthorID INT,
    AUsername VARCHAR(31),
    ATotalPublishedArticle INT DEFAULT 0,
    ATotalView INT DEFAULT 0,
    ATotalLike INT DEFAULT 0,
    ATotalFollower INT DEFAULT 0,
    ARank ENUM('Bronze','Silver', 'Gold', 'Platinum'),
    CONSTRAINT fk_employee_author FOREIGN KEY (AuthorID)
        REFERENCES employee (EmployeeID)
    -- CONSTRAINT fk_user_editor FOREIGN KEY (AUsername)
    --    REFERENCES user (Username)
)  ENGINE=INNODB;

CREATE TABLE bill (
    BillID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    BPayDate DATE NOT NULL,
    BTotalAmount INT NOT NULL,
    BUnpaidAmount INT DEFAULT 0,
    BStatus ENUM('Paid', 'Unpaid') NOT NULL,
    BAccountantID INT NOT NULL,
    -- BIArticleID INT NOT NULL,
    CONSTRAINT fk_accountant_bill FOREIGN KEY (BAccountantID)
        REFERENCES accountant (AccountantID)
    -- CONSTRAINT fk_article_bill FOREIGN KEY (BIArticleID)
	--   REFERENCES article (ArticleID)
)  ENGINE=INNODB;
