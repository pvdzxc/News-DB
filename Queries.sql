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

DELETE FROM article
WHERE ArticleID < 69;
DELETE FROM edit_log
WHERE ArticleID < 100;
DELETE FROM review_log
WHERE ArticleID < 100;
DELETE FROM Bill
WHERE BillID < 100;
DELETE FROM PublishedArticle
WHERE PublishedArticleID < 100;

CALL ProcInsertArticleDebug(69,'Bao luc hoc duong', 'Ban be danh nhau, sut dau chay mau', 'Education', 123);
CALL ProcInsertArticleDebug(96,'Viet Nam Phong ten lua vao mat troi', 'Sieu tau vu tru Lac Long Quan sau 3 thang di vao quy dao bay tien gan mat troi, hien dang vao qua trinh tien hanh lien ket quy dao xoay quanh mat troi', 'Science', 123);
CALL ProcInsertArticleDebug(99,'bai bao 3', 'so it is', 'World', 123);
CALL ProcInsertReviewLog(69,'Bài Viết quá ngắn gọn', 'Edit');
CALL ProcInsertEditLog(69,'Bạn bè đánh nhau, sứt đầu chảy máo');
CALL ProcInsertReviewLog(69,'Sai trính tả rôif', 'Edit');
CALL ProcInsertEditLog(69,'123 Bạn bè đánh nhao, sứt đầu chảy máo');
CALL ProcInsertReviewLog(69,'Thoi m nghi luon di', 'Reject');
CALL ProcInsertReviewLog(96,'Bai viet hay, 10 diem', 'Accept');
CALL ProcInsertReviewLog(99,'Nên sửa vài chỗ có vẻ là thiếu', 'Edit');
CALL ProcInsertEditLog(99,'ahihi');
CALL ProcInsertReviewLog(99,'Thôi cũng được', 'Accept');
CALL ProcInsertComment(99, 'Ôi hay quá', 'chienvan');
-- CALL ProcDeleteComment(6);
DELETE FROM Edit_log WHERE ArticleID = 99;
CALL ProcDeleteArticle(99);
DELETE FROM PublishedArticle WHERE ArticleID = ArticleIDval;
    CALL ProcDeletePublishedArticle(99);

    CALL ProcDeleteBill(1);

CALL ProcUpdateBill(1, 5000);
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint
-- fails (`newspaper_database`.`bill`, CONSTRAINT `fk_accountant_bill` 
-- FOREIGN KEY (`BAccountantID`) REFERENCES `accountant` (`AccountantID`))

COMMIT;