SELECT * FROM author;
SELECT * FROM article;
SELECT * FROM publishedarticle;
SELECT * FROM edit_log;
SELECT * FROM review_log;
SELECT * FROM Bill;
SELECT * FROM Accountant;
SELECT * FROM review_log;
SELECT * FROM review_log;

DELETE FROM article
WHERE ArticleID = 5;
DELETE FROM edit_log
WHERE ArticleID < 100;
DELETE FROM review_log
WHERE ArticleID = 5;
DELETE FROM Bill
WHERE BillID < 100;
DELETE FROM PublishedArticle
WHERE PublishedArticleID < 100;

CALL ProcInsertArticle('Bao luc hoc duong', 'Ban be danh nhau, sut dau chay mau', 'Education', 123);
CALL ProcInsertArticle('Viet Nam Phong ten lua vao mat troi', 'Sieu tau vu tru Lac Long Quan sau 3 thang di vao quy dao bay tien gan mat troi, hien dang vao qua trinh tien hanh lien ket quy dao xoay quanh mat troi', 'Science', 123);
CALL ProcInsertArticle('bai bao 3', 'so it is', 'World', 123);
CALL ProcInsertEditLog(3,'Bạn bè đánh nhau, sứt đầu chảy máo');
CALL ProcInsertEditLog(3,'123 Bạn bè đánh nhao, sứt đầu chảy máo');
CALL ProcInsertReviewLog(3,'Bài Viết quá ngắn gọn', 'Edit');
CALL ProcInsertReviewLog(3,'Sai trính tả rôif', 'Edit');
CALL ProcInsertReviewLog(3,'Thoi m nghi luon di', 'Reject');
CALL ProcInsertReviewLog('2','Bai viet hay, 10 diem', 'Accept');
CALL ProcInsertReviewLog('5','Bai viet hay, 10 diem', 'Edit');
CALL ProcInsertReviewLog('6','Bai viet hay, 10 diem', 'Accept');

CALL ProcUpdateBill(5, 5000);
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint
-- fails (`newspaper_database`.`bill`, CONSTRAINT `fk_accountant_bill` 
-- FOREIGN KEY (`BAccountantID`) REFERENCES `accountant` (`AccountantID`))
SELECT FindAQuiteFreeAccountant() ;
ROLLBACK;
COMMIT;