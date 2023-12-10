SET SQL_SAFE_UPDATES = 0;
use newspaper_database;
 -- DUMP DATA FOR NEWSPAPER DEPARTMENT
SELECT * FROM Employee;
SELECT * FROM User;
DELETE FROM employee WHERE EmployeeID < 100;
DELETE FROM Author WHERE AuthorID < 100;
DELETE FROM Editor WHERE EditorID < 100;
DELETE FROM Accountant WHERE AccountantID < 100;
DELETE FROM Manager WHERE ManagerID < 100;
DELETE FROM User WHERE Username <> '';
DELETE FROM BankAccount WHERE EmployeeID > 0;
 
 INSERT INTO Newspaper_department (DAddress, DName) VALUES
    ('Số 1, Phố Chùa Bộc, Đống Đa, Hà Nội', 'Hà Nội'),
    ('Số 15, Đinh Tiên Hoàng, Thừa Thiên Huế', 'Huế'),
    ('Số 10, Lê Lợi, Quận 1, TP.Hồ Chí Minh', 'Hồ Chí Minh');
 -- DUMP DATA FOR EMPLOYEE DATA
INSERT INTO Employee(EEmailAddress, EName, EPhoneNum, EType, EBankAccount, BranchID, EStartDate) VALUES
    ('tranvanchien@gmail.com', 'Trần Văn Chiến', '1234567890', 'Author', '1234567890', 1, '2023-01-01'),
    ('nguyenthimyhoa4502@gmail.com', 'Nguyễn Thị Mỹ Hoa', '0884295274', 'Editor', '0987654321', 2, '2023-02-01'),
    ('daitrinh@gmail.com', 'Nguyễn Lê Đại Trình', '0221468910', 'Author', '1111222233334444', 3, '2023-03-01'),
    ('haovan1918@gmail.com', 'Nguyễn Văn Hảo', '0123456819', 'Accountant', '5555444433332222', 1, '2023-04-01'),
    ('buithuy@gmail.com', 'Bùi Thị Thuỳ', '0839223317', 'Author', '5555222233334444', 2, '2023-05-01'),
    ('trungminh1969@gmail.com', 'Lê Minh Trung', '0215687901', 'Editor', '5555111133334444', 3, '2023-06-01'),
    ('tranthuy2212@gmail.com', 'Châu Thị Thuỷ', '0989123456', 'Accountant', '5555222211114444', 1, '2023-07-01'),
    ('havanman@gmail.com', 'Hà Văn Mẫn', '0372126128', 'Manager', '5555222233331111', 2, '2023-08-01'),
    ('vanduong@email.com', 'Bùi Văn Dương', '0231456898', 'Author', '55552222333344441', 3, '2023-09-01'),
    ('manhhung2302@email.com', 'Trần Mạnh Hùng', '0230156879', 'Author', '55552222333344442', 1, '2023-10-01');    
INSERT INTO `User` (Username, UCreatedDate, ULastLogin, UName, UBirthDate, UType, UHasedPassword) VALUES
    ('chienvan', '2023-01-01', CURRENT_TIMESTAMP, 'Trần Văn Chiến', '1990-05-15', 'Author', 'hashed_password_1'),
    ('hoamy', '2023-02-01', CURRENT_TIMESTAMP, 'Nguyễn Thị Mỹ Hoa', '1985-08-22', 'Editor', 'hashed_password_2'),
    ('daitrinh1210', '2023-03-01', CURRENT_TIMESTAMP, 'Nguyễn Lê Đại Trình', '2000-12-10', 'Author', 'hashed_password_3'),
    ('buithuy', '2023-04-01', CURRENT_TIMESTAMP, 'Bùi Thị Thuỳ', '1998-03-27', 'Author', 'hashed_password_4'),
    ('hieutrung', '2023-04-01', CURRENT_TIMESTAMP, 'Trần Trung Hiếu', '1999-03-26', 'Reader', 'hashed_password_5'),
    ('tienquoc', '2023-04-01', CURRENT_TIMESTAMP, 'Hồ Quốc Tiến', '1978-09-27', 'Reader', 'hashed_password_6'),
    ('chauminh', '2023-04-01', CURRENT_TIMESTAMP, 'Dương Minh Châu', '1989-03-21', 'Reader', 'hashed_password_7'),
    ('minhtrung', '2023-05-01', CURRENT_TIMESTAMP, 'Lê Minh Trung', '1975-11-08', 'Editor', 'hashed_password_8'),
    ('vanduong', '2023-05-05', CURRENT_TIMESTAMP, 'Bùi Văn Dương', '1968-12-09', 'Author', 'hashed_password_9'),
    ('manhhung', '2023-05-09', CURRENT_TIMESTAMP, 'Trần Mạnh Hùng', '1986-10-04', 'Author', 'hashed_password_10');
INSERT INTO `user` VALUES ('author','2023-12-10','2023-12-10 04:38:49','Author','2004-01-28','Author','$2b$10$2A340o4s3JQjCHZ0oNLDyeEzmpEv.7pZ.pVZ6ORimNysKy67pjCJ2'),
	('editor','2023-12-10','2023-12-10 04:42:17','Editor','2003-01-01','Editor','$2b$10$VyseIhXGkII.5qMrV5eKrujvc7RpuRKCJEuTqhqrDuXR9EGeJO1Ea'),
	('khanh','2023-12-10','2023-12-10 03:48:15','TLQKhanh','2023-12-07','Reader','$2b$10$njkixXmRWfQXippvbuL3eu7JjwgmK7OgoX2m.U94k4bYwFQUykHxu'),
	('kiwi','2023-12-10','2023-12-10 03:45:08','TLQKhanh','2023-12-01','Reader','$2b$10$TC7Mb.2UBDiE68s7qhDs1.j/THmngZv8AHrlqmZzLcZLKp7tWSm.u'),
	('tlqkhanh','2023-12-10','2023-12-10 03:46:38','TLQKhanh','2023-12-01','Reader','$2b$10$RBSaRQ3pdDcGQokW/TKqQuVRuNUpwmAYnChEsl36WpgGMDzSoeunq');

INSERT INTO BankAccount (EmployeeID, BankAccount) VALUES
    (1, '123456789'),
    (2, '987654321'),
    (3, '11112222333'),
    (4, '5555444432'),
    (5, '55552222333'),
    (6, '55551111333'),
    (2, '33333311111'),
    (9, '111111111112'),
    (4, '3333333322255'),
    (7, '55552114444'),
    (8, '555522221111'),
    (9, '5555222233344'),
    (10, '555522223344');
INSERT INTO Accountant (AccountantID, AcTotalApprovedBills) VALUES
    (4, 0),
    (7,0);
INSERT INTO Manager (ManagerID, BranchID) VALUES
	(8,2);
INSERT INTO Editor (EditorID, EUserName, ETotalReviewedArticles) VALUES
	(2, 'hoamy', 0),
    (6, 'minhtrung',0);
INSERT INTO Author (AuthorID, AUsername) VALUES 
	(1,'chienvan'),
    (3, 'daitrinh1210'),
    (5, 'buithuy'),
    (9, 'vanduong'),
    (10, 'manhhung');
INSERT INTO Reader (RUserName) VALUES
	('chauminh'),
    ('hieutrung'),
    ('tienquoc');
INSERT INTO Topic (TpTitle) VALUES
    ('Khoa học'),
    ('Công nghệ'),
    ('Nghệ thuật'),
    ('Chính trị'),
    ('Thể thao'),
    ('Âm nhạc'),
    ('Du lịch'),
    ('Xã hội'),
    ('Giáo dục'),
    ('Cuộc sống');
INSERT INTO Genre (GTitle, GPaymentMultiplier) VALUES
	('Tin', 10),
    ('Trả lời bạn đọc', 10),
    ('Tranh', 10),
    ('Ảnh', 10),
    ('Chính luận', 30),
    ('Phóng sự', 30),
    ('Ký', 30),
    ('Bài phỏng vấn', 30),
    ('Sáng tác văn học',30),
    ('Nghiên cứu', 30),
    ('Trực tuyến', 50),
    ('Media', 50);
INSERT INTO Tag (TgTitle) VALUES
    ('Nổi bật'),
    ('Hot'),
    ('Giáng sinh'),
    ('Tết Nguyên Đán'),
    ('Việt Nam'),
    ('Tương lai'), 
    ('Khai giảng'),
    ('Công sở'),
    ('Nhà nước');

INSERT INTO Article (ArTitle, ArContent, ArStatus, GenreID, TopicID, AuthorID, EditorID)
VALUES
    ('Hội nghị ASEAN LẦN THỨ 17', 'Hội nghị thượng đỉnh ASEAN diễn ra tại Hồng Kông vừa qua với sự tham dự 11 quốc gia thành viên
    đại diện LHQ, cũng như sự theo dõi toàn bộ thế giới', 'Accept', 1, 4, 1, 2),
    ('Bản tin dự báo thời tiết cơn bão số 10 sắp đổ bộ vào miền Trung', 'Ngày hôm qua cơn bão di chuyển với hướng tây bắc đông nam
    với sức gió vùng gần tâm bão giật cấp 5 cấp 6 biển động mạnh', 'Upload', 1, 10, 5, null),
    ('SEAGAMES 21 ASEAN là một thành công lớn ngoài mong đợi', 'Phỏng vấn ông Trang Đình Nhuệ, trưởng ban tổ chức SEAGAMES lần 21
    ông cho hay rằng, thế vận hội Đông Nam Á là một sự thành công ngoài sức tưởng tượng, tuy còn nhiều bất cập,...', 'Edit', 8, 5, 10, 6),
    ('Cơn bão số 9 đã làm cho nông nghiệp tỉnh Quảng Nam gặp nhiều khó khăn', 'Tỉnh Quảng Nam là tỉnh còn nhiều khó khăn do hiện nay
    mỗi năm đều hứng chịu nhiều cơn bão, trong đó nền nông nghiệp là chịu thiệt hại nặng nề nhất hơn cả', 'Accept', 6, 1, 9, 2),
    ('Cuộc thi olympic Sinh viên ASEAN lần thứ 13 tiếp tục được tổ chức với thành tích giải cao cho Việt Nam', 
    'Ngày 21/11 vừa qua, đoàn Việt Nam tham dự đã dành xuất sắc giải nhất toàn đoàn với 3 huy chương vàng, 2 bạc và 1 đồng', 'Accept', 1, 9, 3, 2),
	('Sơn Tùng MTP vừa biểu diễn tại KTX Khu A ĐHQG, thu hút nhiều sinh viên', 'Buổi biểu diễn do TP.Bank tài trợ đã đem một 
    sân khấu quy mô, thu hút hơn 5000 sinh viên về tham dự, đầu tư hoành tráng', 'Wait', 11, 6, 1, 6),
    ('Khảo sát sinh viên và vấn đề trầm cảm trong tâm lí', '80% sinh viên gặp trở ngại trong tâm lí, chủ yếu là các sinh viên 
    học tập căng thẳng, thiếu người chia sẻ', 'Edit', 10, 9, 3, 2),
	('Thành công trong lĩnh vực nghiên cứu nông nghiệp', 'PGS.TS Hà Huy Triết đã thành công trong lĩnh vực nghiên cứu và phát triển
    giống lúa ST-26 gạo thơm ngon hạt béo bùi', 'Accept', 10, 2, 9, 6),
    ('Cô giáo bị học sinh doạ nạt - Lỗi thuộc về ai', 'Gần đây cư dân mạng bức bối trước hình ảnh các em học sinh dồn cô giáo của 
    mình vào chân tường và uy hiếp doạ nạt', 'Reject', 1, 4, 5, 6),
    ('Những triết lí sống cao đẹp mà mỗi học sinh nên nhớ', 'Dưới đây là tổng hợp những triết lí sống mà bạn nên dạy cho con ngay 
    từ khi còn nhỏ, ', 'Wait', 1, 4, 5, 2),
    ('Liệu tương lai của nền kinh tế Việt Nam - ASEAN sẽ ra sao dưới suy thoái kinh tế', 'Suy thoái kinh tế do chiến tranh Nga- 
    Ucraine đã ảnh hưởng rất nhiều đến Việt Nam', 'Accept', 5, 8, 10, 6);
INSERT INTO PublishedArticle (PublishedArticleID) VALUES
(1),(4),(5),(8),(11);



INSERT INTO Interact (PublishedArticleID, RUserName, ILikeFlag, IShareFlag, IView) VALUES 
(1, 'chauminh', 1, 0, 5),
(1, 'hieutrung', 0, 0, 2),
(11, 'chauminh', 1,1,10),
(1, 'tienquoc', 0,1, 9),
(4, 'chauminh', 1,0, 3),
(5, 'tienquoc', 1, 0, 4),
(4, 'hieutrung', 0,1, 5),
(4, 'tienquoc', 1, 1, 7),
(8, 'chauminh', 0,1, 8),
(5, 'chauminh',0,1,9),
(11, 'tienquoc',1,0,2),
(5, 'hieutrung',1,1,3),
(8, 'hieutrung',0,0,4),
(11, 'hieutrung',1,1,6),
(8, 'tienquoc',0,1,5);

UPDATE Bill
SET BStatus = 'Full', BRemainAmount = 0
WHERE BillID = 1;
UPDATE Bill
SET BStatus = 'Full', BRemainAmount = 0
WHERE BillID = 2;
UPDATE Bill
SET BStatus = 'Partial', BRemainAmount = 100000
WHERE BillID = 3;
 
INSERT INTO specialize (EditorID, TopicID) VALUES
(2,4),(2,1),(2,9),(6,5),(6,6),(6,2),(6,4),(6,8);

INSERT INTO Follow (AUsername, RUsername) VALUES 
('chienvan', 'chauminh'), ('chienvan', 'hieutrung'), ('daitrinh1210', 'tienquoc'), ('vanduong', 'chauminh'), ('manhhung', 'tienquoc'), ('manhhung', 'hieutrung');

INSERT INTO `Comment` (CContent, PublishedArticleID, RUserName,ParentCommentID) VALUES
('Tuyệt vời, bài báo thật hay', 1, 'chauminh',null),
('Bài báo nên kiểm tra lại lỗi chính tả', 4, 'hieutrung', null),
('Bài báo này rất hữu ích', 5, 'tienquoc', null),
('Bởi vậy mới nói nhờ bài báo mà tôi mới biết được nhiều như vậy', 11,'tienquoc', null),
('Buổi sáng đọc báo làm li cà phê là tuyệt vời', 4,'hieutrung', null),
('Yeah hu, tui là người đọc báo đầu tiên', 8, 'chauminh',null);
INSERT INTO `Comment` (CContent, PublishedArticleID, RUserName,ParentCommentID) VALUES
('Nói gì v, rảnh hay sao mà cứ spam comment thể', 8, 'tienquoc', 6),
('Mệt mỏi mấy cha này ghê, sao thích dô comment đốp chát nhau thế', 8, 'hieutrung', 8),
('Ngày mới vui vẻ an lànhf nha mọi người', 1, 'hieutrung', null );
INSERT INTO Comment_like ( CommentID, RUserName) VALUES 
 (1, 'hieutrung'), (6, 'tienquoc'), (8, 'chauminh');
INSERT INTO Comment_edit (CommentID, CEditContent) VALUES 
 (7, 'Không nên spam bài viết như vậy') , (9, 'Ngày mới vui vẻ an lành nha mọi người');

INSERT INTO Label (ArticleID, TagID) VALUES 
(1, 5), (1, 8), (1,9), (2, 1), (2,8), (3, 2), (3,5), (4,5),(4,4), (5,9), (5,6), (5,1), 
(6, 1), (6,2), (6,5), (7,1) ,(7,3), (7,8), (8, 1), (8,9), (8,3), (9,5), (9,7), (9,2), (10,  2),
(10,6),  (11,6), (11, 5), (11, 1);

INSERT INTO Review_Log (ArticleID, ReviewPhase, ReviewContent) VALUES 
(2, 1, 'Chỉnh lại lỗi chính tả đi, với kiểm tra lại thông tin thời tiết đúng chưa'),
(6, 1, 'Kiểm tra lại thông tin nhà tài trợ cho buổi diễn Sơn Tùng đầy đủ nhất đi'),
(10,1, 'Nội dung bài viết quá chung chung');

INSERT INTO Edit_log (ArticleID, EditPhase, EditContent) VALUES
(3, 1, 'Chỉnh lại tên người được phỏng vấn, lọc lại nội dung'),
(7, 1, 'Chỉnh lại số liệu cập nhật cụ thể hơn, đã thêm phỏng vấn nhỏ'); 

INSERT INTO Media (Mlink) VALUES 
('https://tse1.mm.bing.net/th?id=OIP.mzmPJeuwJGTc6FKwRmCA8wHaEo&pid=Api&P=0&h=220'),
('https://tse1.mm.bing.net/th?id=OIP.3mqSrPTyTbZo_wV3Qto6CgHaEK&pid=Api&P=0&h=220'),
('https://tse1.mm.bing.net/th?id=OIP.Ghoq50cMembJBlZVUWUviAHaEK&pid=Api&P=0&h=220');

INSERT INTO Attach (ArticleID, MediaID) VALUES 
(1,2), (2,1), (4,1), (6,3), (8,2), (9,3), (11, 1);
-- Xem dữ liệu đã thêm
SELECT * FROM Article;
SELECT * from tag;
select * from employee;
select * from `user`;
select * from genre;
select * from topic;
select * from reader;
select * from author;
select * from editor;

select * from publishedarticle;
select * from comment;
select * from interact;  
select * from article;
select * from Bill;
