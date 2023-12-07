
DROP PROCEDURE IF EXISTS ProcInsertArticle;
DROP PROCEDURE IF EXISTS ProcDeleteArticle;

DROP PROCEDURE IF EXISTS ProcInsertEditLog;
DROP PROCEDURE IF EXISTS ProcDeleteEditLog;

DROP PROCEDURE IF EXISTS ProcInsertReviewLog;
DROP PROCEDURE IF EXISTS ProcDeleteReviewLog;
DROP PROCEDURE IF EXISTS ProcDeletePublishedArticle;

DROP FUNCTION IF EXISTS FindAQuiteFreeAccountant;
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

CREATE PROCEDURE ProcDeletePublishedArticle(
    IN ArticleIDval INT
)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Handle errors (rollback transaction, log, etc.)
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error occured when deleting the Published Article';
    END;
    
    START TRANSACTION;
    
    DELETE FROM PublishedArticle WHERE ArticleID = ArticleIDval;
    
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
    
    DELETE FROM Edit_log WHERE ArticleID = ArticleIDval;
    DELETE FROM Review_log WHERE ArticleID = ArticleIDval;
    CALL ProcDeletePublishedArticle(ArticleIDval);
    DELETE FROM Article WHERE ArticleID = ArticleIDval;
    
    COMMIT;
END;
//
DELIMITER ;

DELIMITER //

CREATE FUNCTION FindAQuiteFreeAccountant()
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE AID INT;
    DECLARE ATAB INT;
    DECLARE lowest_value INT;
    DECLARE ID_lowest_value INT;

    -- Declare a cursor
    DECLARE myCursor CURSOR FOR SELECT AccountantID, AcTotalApprovedBills FROM Accountant;

    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN myCursor;

    -- Initialize variables
    SET lowest_value = NULL;

    my_loop: LOOP
        -- Fetch from the cursor
        FETCH myCursor INTO AID, ATAB;

        -- Break the loop if no more records
        IF done THEN
            LEAVE my_loop;
        END IF;
		
        -- Check if the current row has the lowest value
        IF lowest_value IS NULL OR ATAB < lowest_value THEN
            SET lowest_value = ATAB;
            SET ID_lowest_value = AID;
        END IF;
    END LOOP;

    CLOSE myCursor;

    -- Return the lowest value found
    RETURN ID_lowest_value;
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
-- DELIMITER ;