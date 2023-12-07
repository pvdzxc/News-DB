CREATE DATABASE IF NOT EXISTS newspaper_database CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE newspaper_database;
-- DROP DATABASE IF EXISTS newspaper_database;

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

CREATE TABLE IF NOT EXISTS accountant (
    AccountantID INT NOT NULL,
	AcTotalApprovedBills INT default 0,
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
    CONSTRAINT fk_employee_editor FOREIGN KEY (EditorID)
        REFERENCES employee (EmployeeID),
    CONSTRAINT fk_user_editor FOREIGN KEY (EUsername)
		REFERENCES user (Username)
)  ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS author (
    AuthorID INT,
    AUsername VARCHAR(31),
    ATotalPublishedArticle INT DEFAULT 0,
    ATotalView INT DEFAULT 0,
    ATotalLike INT DEFAULT 0,
    ATotalFollower INT DEFAULT 0,
    ARank ENUM('Bronze','Silver', 'Gold', 'Platinum') DEFAULT 'Bronze',
    CONSTRAINT fk_employee_author FOREIGN KEY (AuthorID)
        REFERENCES employee (EmployeeID),
    CONSTRAINT fk_user_author FOREIGN KEY (AUsername)
		REFERENCES user (Username)
)  ENGINE=INNODB;
CREATE TABLE IF NOT EXISTS Genre (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GTitle VARCHAR(127) NOT NULL
) ENGINE=INNODB;

-- Create Topic table
CREATE TABLE IF NOT EXISTS Topic (
    TopicID INT AUTO_INCREMENT PRIMARY KEY,
    TpTitle VARCHAR(127) NOT NULL
) ENGINE=INNODB;
CREATE TABLE IF NOT EXISTS Article (
    ArticleID INT AUTO_INCREMENT PRIMARY KEY,
    ArTitle VARCHAR(255) NOT NULL,
    ArContent TEXT,
    ArUploadDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ArStatus ENUM('Upload', 'Edit', 'Wait', 'Accept', 'Reject') DEFAULT 'Upload',
    GenreID INT,
    TopicID INT,
    AuthorID INT,
    EditorID INT,
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
    FOREIGN KEY (TopicID) REFERENCES Topic(TopicID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    FOREIGN KEY (EditorID) REFERENCES Editor(EditorID)
)  ENGINE=INNODB;



CREATE TABLE IF NOT EXISTS Tag (
    TagID INT AUTO_INCREMENT PRIMARY KEY,
    TgTitle VARCHAR(127) NOT NULL
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Label (
    ArticleID INT,
    TagID INT,
    PRIMARY KEY (ArticleID, TagID),
    FOREIGN KEY (ArticleID) REFERENCES Article(ArticleID),
    FOREIGN KEY (TagID) REFERENCES Tag(TagID)
) ENGINE=INNODB;

-- Create Genre table


CREATE TABLE IF NOT EXISTS Media (
    MediaID INT AUTO_INCREMENT,
    MLink VARCHAR(255) ,
    PRIMARY KEY (MediaID, MLink),
    MUploadDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Attach (
    ArticleID INT,
    MediaID INT,
    PRIMARY KEY (ArticleID, MediaID),
    FOREIGN KEY (ArticleID) REFERENCES Article(ArticleID),
    FOREIGN KEY (MediaID) REFERENCES Media(MediaID)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS PublishedArticle (
    PublishedArticleID INT PRIMARY KEY,
    ArPublishDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ArTotalViews INT DEFAULT 0,
    ArTotalLikes INT DEFAULT 0,
    ArTotalShares INT DEFAULT 0,
    FOREIGN KEY (PublishedArticleID) REFERENCES Article(ArticleID)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Review_log (
    ArticleID INT NOT NULL,
    ReviewPhase INT NOT NULL,
    ReviewContent TEXT NOT NULL,
    ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ArticleID, ReviewPhase),
    FOREIGN KEY (ArticleID) REFERENCES Article(ArticleID)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Edit_log (
    ArticleID INT NOT NULL,
    EditPhase INT NOT NULL,
    EditContent TEXT NOT NULL,
    EditDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ArticleID, EditPhase),
    FOREIGN KEY (ArticleID) REFERENCES Article(ArticleID)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS bill (
    BillID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    BPayDate DATE NOT NULL,
    BTotalAmount INT NOT NULL,
    BRemainAmount INT DEFAULT 0,
    BStatus ENUM('Paid', 'Unpaid') NOT NULL,
    BAccountantID INT NOT NULL,
    PublishedArticleID INT NOT NULL,
    CONSTRAINT fk_accountant_bill FOREIGN KEY (BAccountantID)
        REFERENCES accountant (AccountantID),
    CONSTRAINT fk_article_bill FOREIGN KEY (PublishedArticleID)
		REFERENCES PublishedArticle (PublishedArticleID)
)  ENGINE=INNODB;


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
    PRIMARY KEY (RUserName, AUserName),
    CONSTRAINT fk_reader_follow FOREIGN KEY (RUserName)
		REFERENCES reader (RUserName),
	CONSTRAINT fk_author_follow FOREIGN KEY (AUserName)
		REFERENCES author (AUserName)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS `comment` (
	CommentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CPostDate DATE NOT NULL,
    CContent TEXT,
    PublishedArticleID INT NOT NULL,
    RUserName VARCHAR (31) NOT NULL,
    CTotalLikes INT,
    CTotalReplies INT,
    ParentCommentID INT,
    CONSTRAINT fk_reader_comment FOREIGN KEY (PublishedArticleID)
		REFERENCES PublishedArticle (PublishedArticleID)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS comment_edit (
	CommentID INT NOT NULL,
    CEditDate DATE,
    CEditContent VARCHAR (500),
    PRIMARY KEY (CommentID, CEditDate, CEditContent),
    CONSTRAINT fk_comment_edit FOREIGN KEY (CommentID)
		REFERENCES `comment` (CommentID)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS comment_like (
	CommentID INT NOT NULL,
    RUserName VARCHAR (31) NOT NULL,
    PRIMARY KEY (CommentID, RUserName),
    CONSTRAINT fk_comment_like_id FOREIGN KEY (CommentID)
		REFERENCES `comment` (CommentID),
	CONSTRAINT fk_comment_like_reader FOREIGN KEY (RUserName)
		REFERENCES reader (RUserName)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS Specialize (
	EditorID INT NOT NULL,
    TopicID INT NOT NULL,
    PRIMARY KEY (EditorID, TopicID),
    CONSTRAINT fk_specialize_editor FOREIGN KEY (EditorID)
		REFERENCES editor (EditorID),
	CONSTRAINT fk_specialize_topic FOREIGN KEY (TopicID)
		REFERENCES Topic (TopicID)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS Interact (
	PublishedArticleID INT NOT NULL,
    RUserName VARCHAR (31) NOT NULL,
    ILikeFlag INT DEFAULT 0,
    IShareFlag INT DEFAULT 0,
    IView INT DEFAULT 0,
    PRIMARY KEY (PublishedArticleID, RUserName),
    CONSTRAINT fk_Interact_PArticleID FOREIGN KEY (PublishedArticleID)
		REFERENCES PublishedArticle (PublishedArticleID),
	CONSTRAINT fk_Interact_Reader FOREIGN KEY (RUserName)
		REFERENCES reader (RUserName)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS BankAccount (
	EmployeeID INT NOT NULL,
    BankAccount INT NOT NULL,
    PRIMARY KEY (EmployeeID, BankAccount),
    CONSTRAINT fk_BankAccount_Employee FOREIGN KEY (EmployeeID)
		REFERENCES employee (EmployeeID)
) ENGINE = INNODB;
SHOW TABLES;


    
    
    