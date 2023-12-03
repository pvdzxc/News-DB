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
CREATE TABLE IF NOT EXISTS `user` (
	Username VARCHAR(31) NOT NULL,
    UCreatedDate DATE NOT NULL,
    ULastLogin DATE NOT NULL,
    UName VARCHAR(255) NOT NULL,
    UBirthDate DATE NOT NULL,
    Utype VARCHAR (100) NOT NULL,
    UHasedPassword VARCHAR (255) NOT NULL,
    PRIMARY KEY (Username)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS reader (
	RUserName VARCHAR(31) NOT NULL,
    RTotalViewedArticles INT,
    CONSTRAINT fk_user_reader FOREIGN KEY (RUserName)
        REFERENCES `user` (UserName)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS follow (
	RUserName VARCHAR (31) NOT NULL,
    AUserName VARCHAR (31) NOT NULL,
    FStartDate DATE NOT NULL,
    CONSTRAINT fk_reader_follow FOREIGN KEY (RUserName)
		REFERENCES reader (RUserName),
	CONSTRAINT fk_author_follow FOREIGN KEY (AUserName)
		REFERENCES author (AUserName)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS `comment` (
	CommentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CPostDate DATE NOT NULL,
    CContent VARCHAR (500),
    PublishedArticleID INT NOT NULL,
    RUserName VARCHAR (31) NOT NULL,
    CTotalLikes INT,
    CTotalReplies INT,
    ParentCommentID INT
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS comment_edit (
	CommentID INT NOT NULL,
    CEditDate DATE,
    CEditContent VARCHAR (500),
    CONSTRAINT fk_comment_edit FOREIGN KEY (CommentID)
		REFERENCES `comment` (CommentID)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS comment_like (
	CommentID INT NOT NULL,
    RUserName VARCHAR (31) NOT NULL,
    CONSTRAINT fk_comment_like_id FOREIGN KEY (CommentID)
		REFERENCES `comment` (CommentID),
	CONSTRAINT fk_comment_like_reader FOREIGN KEY (RUserName)
		REFERENCES reader (RUserName)
) ENGINE = INNODB;

