DROP DATABASE IF EXISTS newspaper_database;
CREATE DATABASE IF NOT EXISTS newspaper_database CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE newspaper_database;
<<<<<<< Updated upstream

-- DROP TABLE BILL;
-- DROP TABLE AUTHOR;
-- DROP TABLE Manager;
-- DROP TABLE Editor;
-- DROP TABLE accountant;

=======
DROP TABLE IF EXISTS Accountant;
DROP TABLE IF EXISTS Article;
DROP TABLE IF EXISTS Attach;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS Bankaccount;
DROP TABLE IF EXISTS Bill;
DROP TABLE IF EXISTS Comment;
DROP TABLE IF EXISTS Comment_edit;
DROP TABLE IF EXISTS Comment_like;
DROP TABLE IF EXISTS Edit_log;
DROP TABLE IF EXISTS Editor;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Follow;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS Interact;
DROP TABLE IF EXISTS Label;
DROP TABLE IF EXISTS Manager;
DROP TABLE IF EXISTS Media;
DROP TABLE IF EXISTS Newspaper_database;
DROP TABLE IF EXISTS PublishedArticle;
DROP TABLE IF EXISTS Reader;
DROP TABLE IF EXISTS Review_log;
DROP TABLE IF EXISTS Specialize;
DROP TABLE IF EXISTS Tag;
DROP TABLE IF EXISTS Topic;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Bill;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS Manager;
DROP TABLE IF EXISTS Editor;
DROP TABLE IF EXISTS accountant;

>>>>>>> Stashed changes
CREATE TABLE IF NOT EXISTS Newspaper_department (
    BranchID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    DAddress VARCHAR(255) NOT NULL,
    DName VARCHAR(127) NOT NULL
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Employee (
    EmployeeID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    EEmailAddress VARCHAR(100) NOT NULL UNIQUE,
    EName VARCHAR(100) NOT NULL,
    EPhoneNum VARCHAR(15) NULL UNIQUE,
    EType ENUM("Author", "Editor", "Accountant", "Manager") NOT NULL,
    EBankAccount VARCHAR(100) NULL UNIQUE,
    BranchID INT NOT NULL,
    EStartDate DATE NOT NULL,
    CONSTRAINT fk_branch_employee FOREIGN KEY (BranchID)
        REFERENCES Newspaper_department (BranchID)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS `User` (
	Username VARCHAR(31) NOT NULL,
    UCreatedDate DATE NOT NULL,
    ULastLogin TIMESTAMP NOT NULL,
    UName VARCHAR(255) NOT NULL,
    UBirthDate DATE NOT NULL,
    UType ENUM("Author", "Editor", "Reader") NOT NULL,
    UHasedPassword VARCHAR (255) NOT NULL,
    PRIMARY KEY (Username)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Accountant (
    AccountantID INT NOT NULL,
	AcTotalApprovedBills INT DEFAULT 0,
    CONSTRAINT fk_employee_accountant 
		FOREIGN KEY (AccountantID) REFERENCES Employee (EmployeeID)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Manager (
    ManagerID INT NOT NULL,
    BranchID INT NOT NULL,
    CONSTRAINT fk_manager_branch 
		FOREIGN KEY (BranchID) REFERENCES Newspaper_department (BranchID),
    CONSTRAINT fk_employee_manager 
		FOREIGN KEY (ManagerID) REFERENCES Employee (EmployeeID)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Editor (
    EditorID INT,
    EUsername VARCHAR(31),
    ETotalReviewedArticles INT DEFAULT 0,
    CONSTRAINT fk_employee_editor 
		FOREIGN KEY (EditorID) REFERENCES Employee (EmployeeID),
    CONSTRAINT fk_user_editor 
		FOREIGN KEY (EUsername) REFERENCES `User` (Username)
)  ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Author (
    AuthorID INT,
    AUsername VARCHAR(31),
    ATotalPublishedArticles INT DEFAULT 0,
    ATotalViews INT DEFAULT 0,
    ATotalLikes INT DEFAULT 0,
    ATotalFollowers INT DEFAULT 0,
    ATotalShares INT DEFAULT 0,
    ARank ENUM('Iron','Bronze','Silver', 'Gold', 'Platinum') DEFAULT 'Iron' NOT NULL,
    CONSTRAINT fk_employee_author
		FOREIGN KEY (AuthorID) REFERENCES Employee (EmployeeID),
    CONSTRAINT fk_user_author 
		FOREIGN KEY (AUsername) REFERENCES `User` (Username)
)  ENGINE=INNODB;
CREATE TABLE IF NOT EXISTS Genre (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GTitle VARCHAR(127) NOT NULL,
    GPaymentMultiplier FLOAT NOT NULL
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
    ArUploadDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ArStatus ENUM('Upload', 'Edit', 'Wait', 'Accept', 'Reject') DEFAULT 'Upload' NOT NULL,
    GenreID INT,
    TopicID INT,
    AuthorID INT,
    EditorID INT,
    CONSTRAINT fk_genre_article 
		FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
    CONSTRAINT fk_topic_article 
		FOREIGN KEY (TopicID) REFERENCES Topic(TopicID),
    CONSTRAINT fk_author_article 
		FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    CONSTRAINT fk_editor_article 
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
    CONSTRAINT fk_article_label 
		FOREIGN KEY (ArticleID) REFERENCES Article(ArticleID),
    CONSTRAINT fk_tag_label 
		FOREIGN KEY (TagID) REFERENCES Tag(TagID)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Media (
    MediaID INT AUTO_INCREMENT,
    MLink VARCHAR(255) ,
    PRIMARY KEY (MediaID, MLink),
    MUploadDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Attach (
    ArticleID INT,
    MediaID INT,
    PRIMARY KEY (ArticleID, MediaID),
    CONSTRAINT fk_article_attach 
		FOREIGN KEY (ArticleID) REFERENCES Article(ArticleID),
    CONSTRAINT fk_media_attach 
		FOREIGN KEY (MediaID) REFERENCES Media(MediaID)
) ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS PublishedArticle (
    PublishedArticleID INT PRIMARY KEY,
    ArPublishDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ArTotalViews INT DEFAULT 0,
    ArTotalLikes INT DEFAULT 0,
    ArTotalShares INT DEFAULT 0,
    CONSTRAINT fk_article_publishedArticle
		FOREIGN KEY (PublishedArticleID) REFERENCES Article(ArticleID)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Review_log (
    ArticleID INT,
    ReviewPhase INT NOT NULL,
    ReviewContent TEXT,
    ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (ArticleID, ReviewPhase),
    CONSTRAINT fk_article_reviewlog
		FOREIGN KEY (ArticleID) REFERENCES Article(ArticleID)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Edit_log (
    ArticleID INT,
    EditPhase INT NOT NULL,
    EditContent TEXT,
    EditDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (ArticleID, EditPhase),
    CONSTRAINT fk_article_editlog
		FOREIGN KEY (ArticleID) REFERENCES Article(ArticleID)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Bill (
    BillID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    BPayDate DATE,
    BTotalAmount INT NOT NULL,
    BRemainAmount INT NOT NULL,
    BStatus ENUM('Full', 'Partial', 'Initial') DEFAULT 'Initial' NOT NULL,
    BAccountantID INT NOT NULL,
    PublishedArticleID INT NOT NULL,
    CONSTRAINT fk_accountant_bill 
		FOREIGN KEY (BAccountantID) REFERENCES Accountant (AccountantID),
    CONSTRAINT fk_article_bill 
		FOREIGN KEY (PublishedArticleID) REFERENCES PublishedArticle (PublishedArticleID)
)  ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Reader (
	RUserName VARCHAR(31) NOT NULL,
    RTotalViewedArticles INT DEFAULT 0,
    CONSTRAINT fk_user_reader 
		FOREIGN KEY (RUserName) REFERENCES `User` (UserName)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS Follow (
	RUserName VARCHAR (31) NOT NULL,
    AUserName VARCHAR (31) NOT NULL,
    FStartDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (RUserName, AUserName),
    CONSTRAINT fk_reader_follow 
		FOREIGN KEY (RUserName) REFERENCES Reader (RUserName),
	CONSTRAINT fk_author_follow 
		FOREIGN KEY (AUserName) REFERENCES Author (AUserName)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS `Comment` (
	CommentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CPostDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CContent TEXT,
    PublishedArticleID INT NOT NULL,
    RUserName VARCHAR (31) NOT NULL,
    CTotalLikes INT DEFAULT 0,
    CTotalReplies INT DEFAULT 0,
    ParentCommentID INT DEFAULT 0,
    CONSTRAINT fk_article_comment 
		FOREIGN KEY (PublishedArticleID) REFERENCES PublishedArticle (PublishedArticleID)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Comment_edit (
	CommentID INT NOT NULL,
    CEditDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CEditContent VARCHAR (500),
    PRIMARY KEY (CommentID, CEditDate),
    CONSTRAINT fk_comment_edit 
		FOREIGN KEY (CommentID) REFERENCES `Comment` (CommentID)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS Comment_like (
	CommentID INT NOT NULL,
    RUserName VARCHAR (31) NOT NULL,
    PRIMARY KEY (CommentID, RUserName),
    CONSTRAINT fk_comment_like_id 
		FOREIGN KEY (CommentID) REFERENCES `Comment` (CommentID),
	CONSTRAINT fk_comment_like_reader 
		FOREIGN KEY (RUserName) REFERENCES Reader (RUserName)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS Specialize (
	EditorID INT NOT NULL,
    TopicID INT NOT NULL,
    PRIMARY KEY (EditorID, TopicID),
    CONSTRAINT fk_specialize_editor 
		FOREIGN KEY (EditorID) REFERENCES Editor (EditorID),
	CONSTRAINT fk_specialize_topic 
		FOREIGN KEY (TopicID) REFERENCES Topic (TopicID)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS Interact (
	PublishedArticleID INT NOT NULL,
    RUserName VARCHAR (31) NOT NULL,
    ILikeFlag INT DEFAULT 0,
    IShareFlag INT DEFAULT 0,
    IView INT DEFAULT 0,
    PRIMARY KEY (PublishedArticleID, RUserName),
    CONSTRAINT fk_interact_article 
		FOREIGN KEY (PublishedArticleID) REFERENCES PublishedArticle (PublishedArticleID),
	CONSTRAINT fk_interact_reader 
		FOREIGN KEY (RUserName) REFERENCES Reader (RUserName)
) ENGINE = INNODB;
CREATE TABLE IF NOT EXISTS BankAccount (
	EmployeeID INT NOT NULL,
    BankAccount INT NOT NULL,
    PRIMARY KEY (EmployeeID, BankAccount),
    CONSTRAINT fk_employee_bankAccount
		FOREIGN KEY (EmployeeID) REFERENCES Employee (EmployeeID)
) ENGINE = INNODB;
SHOW TABLES;


    
    