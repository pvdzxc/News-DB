USE newspaper_database; 
DROP TRIGGER IF EXISTS before_insert_employee;
DROP TRIGGER IF EXISTS before_insert_Edit_log;
DROP TRIGGER IF EXISTS before_insert_Review_log;
DROP TRIGGER IF EXISTS InsertBill_AfterInsertPublishedArticle;
DROP TRIGGER IF EXISTS InsertPublishedArticle_AfterUpdateArticle;
DROP TRIGGER IF EXISTS UpdateETotalReviewedArticles_AfterUpdateArticle;
DROP TRIGGER IF EXISTS after_insert_Edit_log;
DROP TRIGGER IF EXISTS UpdateArStatus_AfterInsertEditLog;
DROP TRIGGER IF EXISTS UpdateAcTotalApprovedBills_AfterInsertBill;
DROP TRIGGER IF EXISTS UpdateBStatus_AfterUpdateRemainAmount;
DROP TRIGGER IF EXISTS UpdateCTotalReplies_AfterInsertComment;
DROP TRIGGER IF EXISTS UpdateCTotalLikes_AfterInsertCommentLike;
DROP TRIGGER IF EXISTS UpdateArStatus_AfterInsertEditLog;
DROP TRIGGER IF EXISTS UpdateArTotalLikes_AfterInsertInteract;
DROP TRIGGER IF EXISTS UpdateArTotalShares_AfterInsertInteract;
DROP TRIGGER IF EXISTS UpdateArTotalViews_AfterInsertInteract;
DROP TRIGGER IF EXISTS UpdateRTotalViewedArticles_AfterInsertInteract;

DROP TRIGGER IF EXISTS UpdateATotalPublishedArticles_AfterInsertPublishedArticle;
DROP TRIGGER IF EXISTS UpdateARank_AfterInsertPublishedArticle;
DROP TRIGGER IF EXISTS UpdateATotalViews_AfterUpdatePublishedArticle;
DROP TRIGGER IF EXISTS UpdateATotalLikes_AfterUpdatePublishedArticle;
DROP TRIGGER IF EXISTS UpdateATotalShares_AfterUpdatePublishedArticle;
DROP TRIGGER IF EXISTS UpdateArStatus_AfterInsertReviewLog;

DROP TRIGGER IF EXISTS after_insert_bill;
DELIMITER //
CREATE TRIGGER before_insert_employee
BEFORE INSERT ON employee 
FOR EACH ROW 
BEGIN     
	IF CHAR_LENGTH(NEW.EPhoneNum) < 10 OR CHAR_LENGTH(NEW.EPhoneNum) > 11 THEN 	
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Phone number must be at least 10 and at most 11 characters';
	END IF; 
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER before_insert_Edit_log
BEFORE INSERT ON Edit_log 
FOR EACH ROW 
BEGIN     
	DECLARE ArStat VARCHAR(255);

    SELECT ArStatus
    INTO ArStat
    FROM Article
    WHERE ArticleID = NEW.ArticleID;
	IF ArStat != 'Edit' THEN 	
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The Article is not in the Edit Phase!';
	END IF; 
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER before_insert_Review_log
BEFORE INSERT ON Review_log 
FOR EACH ROW 
BEGIN     
	DECLARE ArStat VARCHAR(255);

    SELECT ArStatus
    INTO ArStat
    FROM Article
    WHERE ArticleID = NEW.ArticleID;
	IF ArStat <> 'Upload' AND ArStat <> 'Wait' THEN 	
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'The Article is not in the Review Phase!';
	END IF; 
END;

//
DELIMITER ;

DELIMITER //

-- CREATE TRIGGER UpdateArStatus_AfterInsertReviewLog 
-- AFTER INSERT ON Review_log
-- FOR EACH ROW
-- BEGIN
--     UPDATE Article
--     SET ArStatus = 'Edit'
--     WHERE ArticleID = NEW.ArticleID;
-- END;

CREATE TRIGGER UpdateArStatus_AfterInsertEditLog
AFTER INSERT ON Edit_log
FOR EACH ROW
BEGIN
    UPDATE Article
    SET ArStatus = 'Wait'
    WHERE ArticleID = NEW.ArticleID;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateBStatus_AfterUpdateRemainAmount
BEFORE UPDATE ON Bill
FOR EACH ROW
BEGIN
    IF NEW.BRemainAmount = 0 THEN
        SET NEW.BStatus = 'Full';
    ELSEIF NEW.BRemainAmount < NEW.BTotalAmount AND NEW.BRemainAmount > 0 THEN
        SET NEW.BStatus = 'Partial';
    ELSE
        SET NEW.BStatus = 'Initial';
    END IF;
    SET NEW.BPayDate = current_date();
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateArTotalLikes_AfterInsertInteract
AFTER INSERT ON Interact
FOR EACH ROW
BEGIN
    DECLARE article_likes INT;

    -- Calculate the number of likes for the corresponding article
    SELECT COUNT(*) INTO article_likes
    FROM Interact
    WHERE PublishedArticleID = NEW.PublishedArticleID AND ILikeFlag = 1;

    -- Update the ArTotalLikes in PublishedArticle
    UPDATE PublishedArticle
    SET ArTotalLikes = article_likes
    WHERE PublishedArticleID = NEW.PublishedArticleID;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateArTotalShares_AfterInsertInteract
AFTER INSERT ON Interact
FOR EACH ROW
BEGIN
    DECLARE article_shares INT;

    -- Calculate the number of likes for the corresponding article
    SELECT COUNT(*) INTO article_shares
    FROM Interact
    WHERE PublishedArticleID = NEW.PublishedArticleID AND IShareFlag = 1;

    -- Update the ArTotalLikes in PublishedArticle
    UPDATE PublishedArticle
    SET ArTotalShares = article_shares
    WHERE PublishedArticleID = NEW.PublishedArticleID;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateArTotalViews_AfterInsertInteract
AFTER INSERT ON Interact
FOR EACH ROW
BEGIN
    DECLARE article_views INT;

    -- Calculate the total views for the corresponding article
    SELECT SUM(IView) INTO article_views
    FROM Interact
    WHERE PublishedArticleID = NEW.PublishedArticleID;

    -- Update the ArTotalViews in PublishedArticle
    UPDATE PublishedArticle
    SET ArTotalViews = article_views
    WHERE PublishedArticleID = NEW.PublishedArticleID;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER InsertPublishedArticle_AfterUpdateArticle
AFTER UPDATE ON Article
FOR EACH ROW
BEGIN
    -- Check if ArStatus has been changed to 'Accept'
    IF NEW.ArStatus = 'Accept' AND OLD.ArStatus != 'Accept' THEN
        -- Insert a new row into PublishedArticle
        INSERT INTO PublishedArticle (PublishedArticleID, ArPublishDate, ArTotalViews, ArTotalLikes, ArTotalShares)
        VALUES (NEW.ArticleID, CURRENT_TIMESTAMP, 0, 0, 0);
    END IF;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateRTotalViewedArticles_AfterInsertInteract
AFTER INSERT ON Interact
FOR EACH ROW
BEGIN
    DECLARE reader_views INT;

    -- Calculate the number of viewed articles for the corresponding reader
    SELECT COUNT(DISTINCT PublishedArticleID) INTO reader_views
    FROM Interact
    WHERE RUserName = NEW.RUserName AND IView > 0;

    -- Update the RTotalViewedArticles in Reader
    UPDATE Reader
    SET RTotalViewedArticles = reader_views
    WHERE RUserName = NEW.RUserName;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateATotalPublishedArticles_AfterInsertPublishedArticle
AFTER INSERT ON PublishedArticle
FOR EACH ROW
BEGIN
    DECLARE author_published_articles INT;
	DECLARE author_articles INT;
    
    SELECT AuthorID INTO author_articles
    FROM Article
    WHERE ArticleID = NEW.PublishedArticleID;
    
    -- Calculate the number of published articles for the corresponding author
    SELECT COUNT(*) INTO author_published_articles
    FROM PublishedArticle
    JOIN Article ON PublishedArticle.PublishedArticleID = Article.ArticleID
    WHERE Article.AuthorID = author_articles;

    -- Update the ATotalPublishedArticles in Author
    UPDATE Author
    SET ATotalPublishedArticles = author_published_articles
    WHERE AuthorID = author_articles;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateATotalViews_AfterUpdatePublishedArticle
AFTER UPDATE ON PublishedArticle
FOR EACH ROW
BEGIN
    DECLARE author_total_views INT;
    DECLARE author_articles INT;
    
    SELECT AuthorID INTO author_articles
    FROM Article
    WHERE ArticleID = NEW.PublishedArticleID;

    -- Calculate the total views for the corresponding author
    SELECT SUM(ArTotalViews) INTO author_total_views
    FROM PublishedArticle
    JOIN Article ON PublishedArticle.PublishedArticleID = Article.ArticleID
    WHERE Article.AuthorID = author_articles;

    -- Update the ATotalViews in Author
    UPDATE Author
    SET ATotalViews = author_total_views
    WHERE AuthorID = author_articles;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateATotalLikes_AfterUpdatePublishedArticle
AFTER UPDATE ON PublishedArticle
FOR EACH ROW
BEGIN
    DECLARE author_total_likes INT;
    DECLARE author_articles INT;
    
    SELECT AuthorID INTO author_articles
    FROM Article
    WHERE ArticleID = NEW.PublishedArticleID;

    -- Calculate the total views for the corresponding author
    SELECT SUM(ArTotalLikes) INTO author_total_likes
    FROM PublishedArticle
    JOIN Article ON PublishedArticle.PublishedArticleID = Article.ArticleID
    WHERE Article.AuthorID = author_articles;

    -- Update the ATotalViews in Author
    UPDATE Author
    SET ATotalLikes = author_total_likes
    WHERE AuthorID = author_articles;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateATotalShares_AfterUpdatePublishedArticle
AFTER UPDATE ON PublishedArticle
FOR EACH ROW
BEGIN
    DECLARE author_total_shares INT;
    DECLARE author_articles INT;
    
    SELECT AuthorID INTO author_articles
    FROM Article
    WHERE ArticleID = NEW.PublishedArticleID;

    -- Calculate the total views for the corresponding author
    SELECT SUM(ArTotalShares) INTO author_total_shares
    FROM PublishedArticle
    JOIN Article ON PublishedArticle.PublishedArticleID = Article.ArticleID
    WHERE Article.AuthorID = author_articles;

    -- Update the ATotalViews in Author
    UPDATE Author
    SET ATotalShares = author_total_shares
    WHERE AuthorID = author_articles;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateARank_AfterInsertPublishedArticle
AFTER INSERT ON PublishedArticle
FOR EACH ROW
BEGIN
    DECLARE author_point INT;
    DECLARE author_rank VARCHAR(16);
    DECLARE author_articles INT;
    
    SELECT AuthorID INTO author_articles
    FROM Article
    WHERE ArticleID = NEW.PublishedArticleID;

    -- Calculate the ARank for the corresponding author
    SELECT 100 * ATotalFollowers + 10 * ATotalShares + 3 * ATotalLikes + ATotalViews
    INTO author_point
    FROM Author
    WHERE AuthorID = author_articles;
	
    IF author_point < 1000 THEN
		SET author_rank = 'Iron';
	ELSEIF author_point >= 1000 AND author_point < 10000 THEN
		SET author_rank = 'Bronze';
	ELSEIF author_point >= 10000 AND author_point < 50000 THEN
		SET author_rank = 'Silver';
	ELSEIF author_point >= 50000 AND author_point < 200000 THEN
		SET author_rank = 'Gold';
	ELSE 
		SET author_rank = 'Platinum';
	END IF;
    -- Update the ARank in Author
    UPDATE Author
    SET ARank = author_rank
    WHERE AuthorID = author_articles;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateETotalReviewedArticles_AfterUpdateArticle
AFTER UPDATE ON Article
FOR EACH ROW
BEGIN
	DECLARE reviewed_article INT DEFAULT 0;
    
    SELECT COUNT(*) INTO reviewed_article
    FROM Article
    WHERE EditorID = NEW.EditorID;
    
    UPDATE Editor
    SET ETotalReviewedArticles = reviewed_article
    WHERE EditorID = NEW.EditorID;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateAcTotalApprovedBills_AfterInsertBill
AFTER INSERT ON Bill
FOR EACH ROW
BEGIN
    DECLARE accountant_approved_bills INT;

    -- Calculate the AcTotalApprovedBills for the corresponding accountant
    SELECT COUNT(*) INTO accountant_approved_bills
    FROM Bill
    WHERE BAccountantID = NEW.BAccountantID;

    -- Update the AcTotalApprovedBills in Accountant
    UPDATE Accountant
    SET AcTotalApprovedBills = accountant_approved_bills
    WHERE AccountantID = NEW.BAccountantID;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateCTotalLikes_AfterInsertCommentLike
AFTER INSERT ON Comment_like
FOR EACH ROW
BEGIN
    DECLARE comment_likes INT;

    -- Calculate the CTotalLikes for the corresponding comment
    SELECT COUNT(*) INTO comment_likes
    FROM Comment_like
    WHERE CommentID = NEW.CommentID;

    -- Update the CTotalLikes in Comment
    UPDATE `Comment`
    SET CTotalLikes = comment_likes
    WHERE CommentID = NEW.CommentID;
END;

//
DELIMITER ;

DELIMITER //

CREATE TRIGGER UpdateCTotalReplies_AfterInsertComment
AFTER INSERT ON Comment
FOR EACH ROW
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
END;
DROP TRIGGER UpdateCTotalReplies_AfterInsertComment;
//
DELIMITER ;

DELIMITER //

CREATE TRIGGER InsertBill_AfterInsertPublishedArticle
AFTER INSERT ON PublishedArticle
FOR EACH ROW
BEGIN
    -- Insert a new bill for the published article
    DECLARE accountant_bill INT DEFAULT 1; 
    DECLARE unit_value INT;
    DECLARE coefficient_value INT;
    DECLARE AuthorIDval TEXT;
    DECLARE AuthorRank TEXT;
    DECLARE ResponseAccountantID INT;
	SELECT AuthorID
    INTO AuthorIDval
    FROM Article
    Where Article.ArticleID = NEW.PublishedArticleID;
	SELECT ARank
    INTO AuthorRank
    FROM Author
    Where Author.AuthorID = AuthorIDval;

    -- Calculate Unit based on ARank
    CASE AuthorRank
        WHEN 'Iron' THEN SET unit_value = 40000;
        WHEN 'Bronze' THEN SET unit_value = 75000;
        WHEN 'Silver' THEN SET unit_value = 112500;
        WHEN 'Gold' THEN SET unit_value = 150000;
        WHEN 'Platinum' THEN SET unit_value = 187500;
        ELSE SET unit_value = -1; -- Handle any other case (default to -1)
    END CASE;

    -- Retrieve GPaymentMultiplier from corresponding Genre
    SELECT GPaymentMultiplier INTO coefficient_value
    FROM Genre
    JOIN Article ON Article.GenreID = Genre.GenreID AND Article.ArticleID = NEW.PublishedArticleID;
    SELECT FindAQuiteFreeAccountant() INTO ResponseAccountantID;
    INSERT INTO Bill (BPayDate, BTotalAmount, BRemainAmount, BAccountantID, PublishedArticleID)
    VALUES (NULL, unit_value * coefficient_value, unit_value * coefficient_value, ResponseAccountantID, NEW.PublishedArticleID);
    
    
END;

//
DELIMITER ;