
DROP PROCEDURE IF EXISTS ProcInsertArticle;
DROP PROCEDURE IF EXISTS ProcInsertArticleDebug;
DROP PROCEDURE IF EXISTS ProcDeleteArticle;

DROP PROCEDURE IF EXISTS ProcInsertEditLog;
DROP PROCEDURE IF EXISTS ProcDeleteEditLog;

DROP PROCEDURE IF EXISTS ProcInsertReviewLog;
DROP PROCEDURE IF EXISTS ProcDeleteReviewLog;
DROP PROCEDURE IF EXISTS ProcInsertComment;
DROP PROCEDURE IF EXISTS ProcDeleteComment;
DROP PROCEDURE IF EXISTS ProcInsertCommentReply;
DROP PROCEDURE IF EXISTS ProcDeleteCommentReply;
DROP PROCEDURE IF EXISTS ProcUpdateBill;
DROP PROCEDURE IF EXISTS ProcDeleteBill;
DROP PROCEDURE IF EXISTS ProcDeletePublishedArticle;

DELIMITER //
CREATE PROCEDURE ProcInsertArticle(
	IN ArTitle VARCHAR(255),
    IN ArContent TEXT,
    IN Genre VARCHAR(255),
    IN AuthorID INT
)
BEGIN
	DECLARE Gvalue INT;
	SET Gvalue = -1;
    SELECT GenreID
    INTO Gvalue
    FROM genre
    WHERE GTitle = Genre;
	IF Gvalue = -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid Genre/ Genre is not found';
	END IF;
    INSERT INTO article (ArTitle, ArContent, GenreID, AuthorID)
    VALUES (ArTitle, ArContent, Gvalue, AuthorID);
    
END;

CREATE PROCEDURE ProcInsertArticleDebug(
	IN ArID INT,
	IN ArTitle VARCHAR(255),
    IN ArContent TEXT,
    IN Genre VARCHAR(255),
    IN AuthorID INT
)
BEGIN
	DECLARE Gvalue INT;
	SET Gvalue = -1;
    SELECT GenreID
    INTO Gvalue
    FROM genre
    WHERE GTitle = Genre;
	IF Gvalue = -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid Genre/ Genre is not found';
	END IF;
    INSERT INTO article (ArticleID, ArTitle, ArContent, GenreID, AuthorID)
    VALUES (ArID, ArTitle, ArContent, Gvalue, AuthorID);
    
END;
//
DELIMITER ;

DELIMITER //

CREATE PROCEDURE ProcInsertComment(
	IN ArID INT,
    IN Content TEXT,
    IN RUName TEXT
)
BEGIN
    INSERT INTO comment (PublishedArticleID, CContent, RUserName)
    VALUES (ArID, Content, RUName);
END;

CREATE PROCEDURE ProcInsertCommentReply(
	IN ArID INT,
    IN Content TEXT,
    IN RUName TEXT,
    IN ParentID INT
)
BEGIN
    DECLARE comment_replies INT;

    -- Calculate the CTotalReplies for the corresponding comment
    SELECT COUNT(*) INTO comment_replies
    FROM Comment
    WHERE ParentCommentID = NEW.CommentID;

    -- Update the CTotalReplies in Comment
    UPDATE Comment
    SET CTotalReplies = comment_replies
    WHERE CommentID = NEW.CommentID;
    INSERT INTO comment (PublishedArticleID, CContent, RUserName, ParentCommentID)
    VALUES (ArID, Content, RUName, ParentID);
END;

CREATE PROCEDURE ProcDeleteComment(
	IN CID INT
)
BEGIN
    DELETE FROM comment WHERE CommentID = CID;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ProcInsertEditLog(
	IN ArID INT,
    IN ArEditContent TEXT
)
BEGIN
	DECLARE NumberOfEditBefore INT;

    SELECT COUNT(*)
    INTO NumberOfEditBefore
    FROM Edit_log
    WHERE ArticleID = ArID;

    INSERT INTO Edit_log(ArticleID, EditPhase, EditContent)
    VALUES (ArID, NumberOfEditBefore, ArEditContent);
    
    IF ROW_COUNT() > 0 THEN
		UPDATE Article
		SET ArStatus = 'Wait'
		WHERE ArticleID = ArID;
        SELECT 'Insert and Update Successful' AS result;
    ELSE
        SELECT 'Insert Failed' AS result;
    END IF;
    
END;

CREATE PROCEDURE ProcInsertReviewLog(
	IN ArID INT,
    IN ArReviewContent TEXT,
    IN NewArStatus TEXT
)
BEGIN
	DECLARE NumberOfReviewBefore INT; 

    SELECT COUNT(*)
    INTO NumberOfReviewBefore
    FROM Review_log
    WHERE ArticleID = ArID;
	IF NewArStatus <> 'Accept' AND NewArStatus <> 'Reject' AND NewArStatus <> 'Edit' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Status Fail: the status need to be \'Accept\', \'Reject\' or \'Edit\'';
    END IF;

    INSERT INTO Review_log(ArticleID, ReviewPhase, ReviewContent)
    VALUES (ArID, NumberOfReviewBefore, ArReviewContent);
    
    IF ROW_COUNT() > 0 THEN
		UPDATE Article
		SET ArStatus = NewArStatus
		WHERE ArticleID = ArID;
        SELECT 'Insert and Update Successful' AS result;
    ELSE
        SELECT 'Insert Failed' AS result;
    END IF;
    
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ProcUpdateBill(
IN BID INT,
IN PayAmount INT
)
BEGIN
	DECLARE RemainAmount INT;
	SELECT BRemainAmount
    INTO RemainAmount
    FROM BILL
    WHERE BillID = BID;
    IF RemainAmount = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The Bill is already completed';
	END IF;
    IF PayAmount > RemainAmount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The Amount is too much';
	END IF;
    IF PayAmount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient Amount';
	END IF;
    START TRANSACTION;
        UPDATE Bill
        SET BRemainAmount = RemainAmount - PayAmount
        WHERE BillID = BID;
	COMMIT;
END;
//
DELIMITER ;


DELIMITER //

CREATE PROCEDURE ProcDeleteBill(
    IN BID INT
)
BEGIN
	DECLARE RAmount INT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Handle errors (rollback transaction, log, etc.)
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error occured when deleting Bill';
    END;
    START TRANSACTION;
    SELECT BRemainAmount
    INTO RAmount
    FROM Bill
    WHERE BillID = BID;
    IF RAmount > 0 THEN
		ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The Bill is not completly paid';
    END IF;
    DELETE FROM Bill WHERE BillID = BID;
    
    COMMIT;
END;

//
DELIMITER ;

DELIMITER //

CREATE PROCEDURE ProcDeletePublishedArticle(
    IN ArticleIDval INT
)
BEGIN    
	DECLARE CID INT;
	DECLARE BID INT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Handle errors (rollback transaction, log, etc.)
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error occured when deleting the Published Article';
    END;
    
    SELECT CommentID INTO CID
    FROM comment WHERE PublishedArticleID = ArticleIDval;
    SELECT BillID INTO BID
    FROM Bill WHERE PublishedArticleID = ArticleIDval;
    
    START TRANSACTION;
    CALL ProcDeleteBill(BID);
    CALL ProcDeleteComment(CID);
    DELETE FROM PublishedArticle WHERE PublishedArticleID = ArticleIDval;
    COMMIT;
END;

CREATE PROCEDURE ProcDeleteArticle(
    IN ArticleIDval INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Handle errors (rollback transaction, log, etc.)
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'An error occurred during the transaction.';
    END;
    
    START TRANSACTION;
    CALL ProcDeletePublishedArticle(ArticleIDval);
    DELETE FROM Edit_log WHERE ArticleID = ArticleIDval;
    DELETE FROM Review_log WHERE ArticleID = ArticleIDval;
    DELETE FROM Article WHERE ArticleID = ArticleIDval;
    
    COMMIT;
END;
//
DELIMITER ;

-- DELIMITER //
-- CREATE PROCEDURE ProcDeleteEditLog(
-- 	IN ArID INT,
--     IN ArEditContent TEXT
-- )
-- BEGIN
-- 	DECLARE NumberOfEditBefore INT;

--     SELECT COUNT(*)
--     INTO NumberOfEditBefore
--     FROM Edit_log
--     WHERE ArticleID = ArID;

--     INSERT INTO Edit_log(ArticleID, EditPhase, EditContent)
--     VALUES (ArID, NumberOfEditBefore, ArEditContent);
--     
-- END;

-- CREATE PROCEDURE ProcInsertReviewLog(
-- 	IN ArID INT,
--     IN ArReviewContent TEXT,
--     IN NewArStatus TEXT
-- )
-- BEGIN
-- 	DECLARE NumberOfReviewBefore INT; 

--     SELECT COUNT(*)
--     INTO NumberOfReviewBefore
--     FROM Review_log
--     WHERE ArticleID = ArID;

--     INSERT INTO Review_log(ArticleID, ReviewPhase, ReviewContent)
--     VALUES (ArID, NumberOfReviewBefore, ArReviewContent);
--     SET new_id = LAST_INSERT_ID();
--     
-- END;
-- //
-- DELIMITER ;CREATE PROCEDURE ProcDeleteBill(     IN BID INT ) BEGIN  DECLARE RAmount INT;  DECLARE EXIT HANDLER FOR SQLEXCEPTION     BEGIN         -- Handle errors (rollback transaction, log, etc.)         ROLLBACK;         SIGNAL SQLSTATE '45000'         SET MESSAGE_TEXT = 'Error occured when deleting Bill';     END;     START TRANSACTION;     SELECT BRemainAmount     INTO RAmount     FROM Bill     WHERE BillID = BID;     IF RAmount > 0 THEN   ROLLBACK;         SIGNAL SQLSTATE '45000'         SET MESSAGE_TEXT = 'The Bill is not completly paid';     END IF;     DELETE FROM Bill WHERE BillID = BID;          COMMIT; END;  CREATE PROCEDURE ProcDeleteComment(     IN ArticleIDval INT ) BEGIN      DECLARE EXIT HANDLER FOR SQLEXCEPTION     BEGIN         -- Handle errors (rollback transaction, log, etc.)         ROLLBACK;         SIGNAL SQLSTATE '45000'         SET MESSAGE_TEXT = 'Error occured when deleting the Published Article';     END;          START TRANSACTION;     DELETE FROM COMMENT WHERE PublishedArticleID = ArticleIDval;     COMMIT; END;  CREATE PROCEDURE ProcDeletePublishedArticle(     IN ArticleIDval INT ) BEGIN      DECLARE EXIT HANDLER FOR SQLEXCEPTION     BEGIN         -- Handle errors (rollback transaction, log, etc.)         ROLLBACK;         SIGNAL SQLSTATE '45000'         SET MESSAGE_TEXT = 'Error occured when deleting the Published Article';     END;          START TRANSACTION;     CALL ProcDeleteBill(BID);     CALL ProcDeleteComment(ArticleIDval);     DELETE FROM PublishedArticle WHERE ArticleID = ArticleIDval;     COMMIT; END;  CREATE PROCEDURE ProcDeleteArticle(     IN ArticleIDval INT ) BEGIN     START TRANSACTION;  DECLARE EXIT HANDLER FOR SQLEXCEPTION     BEGIN         -- Handle errors (rollback transaction, log, etc.)         ROLLBACK;         SIGNAL SQLSTATE '45000'         SET MESSAGE_TEXT = 'An error occurred during the transaction.';     END;          CALL ProcDeletePublishedArticle(ArticleIDval);     DELETE FROM Edit_log WHERE ArticleID = ArticleIDval;     DELETE FROM Review_log WHERE ArticleID = ArticleIDval;     DELETE FROM Article WHERE ArticleID = ArticleIDval;          COMMIT; END;
