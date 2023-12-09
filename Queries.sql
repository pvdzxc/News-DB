SELECT * FROM author;
SELECT * FROM user;
SELECT * FROM comment;
SELECT * FROM article;
SELECT * FROM publishedarticle;
SELECT * FROM edit_log;
SELECT * FROM review_log;
SELECT * FROM Bill;
SELECT * FROM Accountant;
SELECT * FROM review_log;
SELECT * FROM Genre;
SELECT * FROM attach;

-- DELETE FROM Bill
-- WHERE BillID < 100;
-- DELETE FROM PublishedArticle
-- WHERE PublishedArticleID < 100;
-- DELETE FROM edit_log
-- WHERE ArticleID < 100;
-- DELETE FROM review_log
-- WHERE ArticleID < 100;
-- DELETE FROM article
-- WHERE ArticleID < 100;
CALL ProcInsertArticleDebug(99,'bai bao 3', 'so it is', 'Tranh', 10);
CALL ProcInsertReviewLog(69,'Bài Viết quá ngắn gọn', 'Edit');
CALL ProcInsertEditLog(69,'Bạn bè đánh nhau, sứt đầu chảy máo');
CALL ProcInsertReviewLog(69,'Sai trính tả rôif', 'Edit');
CALL ProcInsertEditLog(69,'123 Bạn bè đánh nhao, sứt đầu chảy máo');
CALL ProcInsertReviewLog(69,'Thoi m nghi luon di', 'Reject');
CALL ProcInsertReviewLog(96,'Bai viet hay, 10 diem', 'Accept');
CALL ProcInsertReviewLog(99,'Nên sửa vài chỗ có vẻ là thiếu', 'Edit', 'hoamy');
CALL ProcInsertEditLog(99,'ahihi');
CALL ProcInsertReviewLog(99,'Thôi cũng được', 'Accept', 'hoamy');
CALL ProcDeleteArticle(99);
CALL ProcInsertComment(99, 'Ôi hay quá', 'chauminh');
CALL ProcInsertCommentReply(99, 'Ôi hay quá', 'chauminh', 10);
-- CALL ProcDeleteComment(6);
DELETE FROM Edit_log WHERE ArticleID = 99;
CALL ProcDeleteArticle(99);
    DELETE FROM PublishedArticle WHERE PublishedArticleID = 99;
DELETE FROM PublishedArticle WHERE ArticleID = ArticleIDval;
    CALL ProcDeletePublishedArticle(99);

    CALL ProcDeleteBill(1);
ROLLBACK;
CALL ProcUpdateBill(1, 5000);
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint
-- fails (`newspaper_database`.`bill`, CONSTRAINT `fk_accountant_bill` 
-- FOREIGN KEY (`BAccountantID`) REFERENCES `accountant` (`AccountantID`))
CALL GetTotalInteractWithTime();
COMMIT;