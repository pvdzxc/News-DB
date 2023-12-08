use newspaper_database;
 -- DUMP DATA FOR NEWSPAPER DEPARTMENT
 INSERT INTO Newspaper_department (DAddress, DName) VALUES
    ('Số 1, Phố Chùa Bộc, Đống Đa, Hà Nội', 'Hà Nội'),
    ('Số 15, Đinh Tiên Hoàng, Thừa Thiên Huế', 'Huế'),
    ('Số 10, Lê Lợi, Quận 1, TP.Hồ Chí Minh', 'Hồ Chí Minh');
    
 -- DUMP DATA FOR EMPLOYEE DATA
 INSERT INTO Employee (EEmailAddress, EName, EPhoneNum, EType, EBankAccount, BranchID, EStartDate) VALUES
    ('tranvanchien@gmail.com', 'Trần Văn Chiến', '123456789', 'Author', '1234567890', 1, '2023-01-01'),
    ('nguyenthimyhoa4502@gmail.com', 'Nguyễn Thị Mỹ Hoa', '987654321', 'Editor', '0987654321', 2, '2023-02-01'),
    ('daitrinh@gmail.com', 'Nguyễn Lê Đại Trình', NULL, 'Author', '1111222233334444', 3, '2023-03-01'),
    ('haovan1918@gmail.com', 'Nguyễn Văn Hảo', '555555555', 'Accountant', '5555444433332222', 1, '2023-04-01'),
    ('buithuy@gmail.com', 'Bùi Thị Thuỳ', '111111111', 'Author', '5555222233334444', 2, '2023-05-01'),
    ('trungminh1969@gmail.com', 'Lê Minh Trung', '222222222', 'Editor', '5555111133334444', 3, '2023-06-01'),
    ('tranthuy2212@gmail.com', 'Châu Thị Thuỷ', '333333333', 'Accountant', '5555222211114444', 1, '2023-07-01'),
    ('havanman@gmail.com', 'Hà Văn Mẫn', '444444444', 'Manager', '5555222233331111', 2, '2023-08-01'),
    ('vanduong@email.com', 'Bùi Văn Dương', '7777777777', 'Author', '55552222333344441', 3, '2023-09-01'),
    ('manhhung2302@email.com', 'Trần Mạnh Hùng', '666666666', 'Author', '55552222333344442', 1, '2023-10-01');
    
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
select * from employee;
select * from `user`;
select * from author;