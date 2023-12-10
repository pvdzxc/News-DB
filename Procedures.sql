
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
	IN ArTitle1 VARCHAR(255),
    IN ArContent TEXT,
    IN Genre VARCHAR(255),
    IN Topic1 VARCHAR(255),
    IN UName TEXT,
    IN MediaURL VARCHAR(255)
)
BEGIN
	DECLARE Gvalue INT;
	DECLARE UType INT;
	DECLARE AID INT;
	DECLARE ArID INT;
    DECLARE medID INT;
	DECLARE TopID INT;
    SET TopID = -1;
	SET Gvalue = -1;
    SET AID = -1;
    SELECT GenreID
    INTO Gvalue
    FROM genre
    WHERE GTitle = Genre;
	IF Gvalue = -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Genre Error: Invalid Genre/ Genre not found';
	END IF;
    SELECT TopicID
    INTO TopID
    FROM Topic
    WHERE TpTitle = Topic1;
	IF Gvalue = -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Topic Error: Invalid Topic/ Topic not found';
	END IF;
    SELECT AuthorID
    INTO AID
    FROM Author
    WHERE AUsername = UName;
	IF AID = -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'User Error: Author authority unverified';
	END IF;
    
    INSERT INTO article (ArTitle, ArContent, GenreID, TopicID, AuthorID)
    VALUES (ArTitle1, ArContent, Gvalue, TopID, AID);
    INSERT INTO Media (MLINK)
    VALUE (MediaURL);
    SELECT ArticleID INTO ArID FROM Article WHERE ArTitle = ArTitle1 AND AuthorID = AID;
    SELECT MediaID INTO medID FROM media WHERE MLINK = MediaURL;
    INSERT INTO Attach (ArticleID, MediaID)
    VALUE (ArID, medID);
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
    IN RUName VARCHAR (31)
)
BEGIN
	DECLARE PAID INT;
	DECLARE UID VARCHAR (31);
	SET PAID = -1;
    SET UID = '';
    SELECT PublishedArticleID
    INTO PAID
    FROM PublishedArticle
    WHERE PublishedArticleID = ArID;
    SELECT RUserName
    INTO UID
    FROM Reader
    WHERE RUserName = RUName;
	IF PAID = -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '404 Error: Article not found';
	END IF;
	IF UID = '' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'User Error: Reader authority unverified';
	END IF;
    INSERT INTO comment (PublishedArticleID, CContent, RUserName)
    VALUES (ArID, Content, RUName);
END;

CREATE PROCEDURE ProcInsertCommentReply(
	IN ArID INT,
    IN Content TEXT,
    IN RUName VARCHAR (31),
    IN ParentID INT
)
BEGIN
    DECLARE comment_replies INT;
    DECLARE FatherID INT;
	DECLARE PAID INT;
	DECLARE UID VARCHAR (31);
	SET FatherID = -1;
	SET PAID = -1;
    SET UID = -1;
    SELECT CommentID
    INTO FatherID 
    FROM Comment
    WHERE CommentID = ParentID;
    SELECT PublishedArticleID
    INTO PAID
    FROM PublishedArticle
    WHERE PublishedArticleID = ArID;
    SELECT RUserName
    INTO UID
    FROM Reader
    WHERE RUserName = RUName;
	IF FatherID = -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '404 Error: Parent Comment not found';
	END IF;
	IF PAID = -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '404 Error: Article not found';
	END IF;
	IF UID = '' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'User Error: Reader authority unverified';
	END IF;
	
    -- Update the CTotalReplies in Comment
    INSERT INTO comment (PublishedArticleID, CContent, RUserName, ParentCommentID)
    VALUES (ArID, Content, RUName, ParentID);
    SELECT COUNT(*) INTO comment_replies
    FROM Comment
    WHERE ParentCommentID = ParentID;
    UPDATE Comment
    SET CTotalReplies = comment_replies 
    WHERE CommentID = ParentID;
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
	DECLARE validArID INT;
    SET validArID = -1;
    SELECT PublishedArticleID
    INTO validArID
    FROM PublishedArticle
    WHERE PublishedArticleID = ArID;
	IF validArID <> -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Logic Error: Article has been published';
	END IF;
    SELECT ArticleID
    INTO validArID
    FROM Article
    WHERE ArticleID = ArID;
	IF validArID = -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '404 Error: Article not found';
	END IF;
    
    SELECT COUNT(*)
    INTO NumberOfEditBefore
    FROM Edit_log
    WHERE ArticleID = ArID;

    INSERT INTO Edit_log(ArticleID, EditPhase, EditContent)
    VALUES (ArID, NumberOfEditBefore+ 1, ArEditContent);
    
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
    IN NewArStatus TEXT,
    IN Username TEXT
)
BEGIN
	DECLARE NumberOfReviewBefore INT; 
	DECLARE EID, Spec, ArTopicID INT; 
	DECLARE validArID INT;
    SET validArID = -1;
    SET EID = -1;
    SET Spec = -1;
    Set ArTopicID = -2;
	SELECT EditorID INTO EID FROM Editor WHERE EUsername = Username;
	IF EID = -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'User Error: Editor authority unverified';
	END IF;
    SELECT ArticleID, TopicID INTO validArID,ArTopicID FROM Article WHERE ArticleID = ArID;
	IF validArID = -1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '404 Error: Article not found';
	END IF;
	SELECT TopicID INTO Spec FROM Specialize WHERE EditorID = EID AND TopicID = ArTopicID ;
	IF Spec <> ArTopicID  THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Editor Specialize not match';
	END IF;
    
    
    SELECT COUNT(*) INTO NumberOfReviewBefore FROM Review_log WHERE ArticleID = ArID;
	IF NewArStatus <> 'Accept' AND NewArStatus <> 'Reject' AND NewArStatus <> 'Edit' THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Status Fail: the status need to be \'Accept\', \'Reject\' or \'Edit\'';
    END IF;

    INSERT INTO Review_log(ArticleID, ReviewPhase, ReviewContent)
    VALUES (ArID, NumberOfReviewBefore+1, ArReviewContent);
    
    IF ROW_COUNT() > 0 THEN
		UPDATE Article
		SET ArStatus = NewArStatus
		WHERE ArticleID = ArID;
		UPDATE Article
        SET EditorID = EID
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
    SET RemainAmount = -1;
	SELECT BRemainAmount
    INTO RemainAmount
    FROM BILL
    WHERE BillID = BID;
    IF RemainAmount = -1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bill Not Found';
	END IF;
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
    SET RAmount = -1;
    START TRANSACTION;
    SELECT BRemainAmount
    INTO RAmount
    FROM Bill
    WHERE BillID = BID;
    -- IF RAmount > 0 THEN
-- 		ROLLBACK;
--         SIGNAL SQLSTATE '45002'
--         SET MESSAGE_TEXT = 'The Bill is not completly paid';
--     END IF;
--     IF RAmount < 0 THEN
-- 		ROLLBACK;
--         SIGNAL SQLSTATE '45002'
--         SET MESSAGE_TEXT = 'The Bill is not valid';
--     END IF;
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
        SIGNAL SQLSTATE '45001'
        SET MESSAGE_TEXT = 'Error occured when deleting the Published Article';
    END;
    
    SELECT BillID INTO BID
    FROM Bill WHERE PublishedArticleID = ArticleIDval;
    
    START TRANSACTION;
    CALL ProcDeleteBill(BID);
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
        SET MESSAGE_TEXT = 'An error occurred during article delete.';
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

DROP PROCEDURE IF EXISTS GetTotalInteractWithTime;
DELIMITER //
CREATE PROCEDURE GetTotalInteractWithTime(
)
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE done2 BOOLEAN DEFAULT FALSE;
	DECLARE A INT;
	DECLARE B TEXT;
	DECLARE C INT;
	DECLARE D INT;
	DECLARE E INT;
	DECLARE C1 INT;
	DECLARE D1 INT;
	DECLARE E1 INT;
	DECLARE F INT;

    -- Declare a cursor
    DECLARE myCursor CURSOR FOR SELECT GenreID, GTitle FROM genre;
    DECLARE myCursor2 CURSOR FOR 
    SELECT PublishedArticleID, ArTotalViews, ArTotalLikes, ArTotalShares FROM PublishedArticle;
	
    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE, done2 = TRUE;

    OPEN myCursor;
	DELETE FROM result WHERE TotalLike >= 0;
	
    my_loop: LOOP
        FETCH myCursor INTO A, B;

        -- Break the loop if no more records
        IF done THEN
            LEAVE my_loop;
        END IF;
		
        INSERT INTO Result(GenreID, GenreList, TotalView, TotalLike, TotalShare) 
        VALUE (A, B, 0, 0, 0);
        
    END LOOP;

    CLOSE myCursor;
    SET done2 = FALSE;
	OPEN myCursor2;
    
	my_loop2: LOOP
        FETCH myCursor2 INTO A, C, D, E;
		SELECT GenreID INTO F FROM Article WHERE ArticleID = A;
		SELECT TotalView INTO C1 FROM Result WHERE GenreID = F;
		SELECT TotalLike INTO D1 FROM Result WHERE GenreID = F;
		SELECT TotalShare INTO E1 FROM Result WHERE GenreID = F;
        -- Break the loop if no more records
        IF done2 THEN
            LEAVE my_loop2;
        END IF;
		UPDATE Result
        Set TotalView = C1 + C, TotalLike = D1 + D, TotalShare = E1 + E
        WHERE GenreID = F;
        
    END LOOP;
    
    CLOSE myCursor2;
    SELECT * FROM Result;
END //

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