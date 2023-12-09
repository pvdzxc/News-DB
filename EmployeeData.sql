BEGIN;
-- INSERT INTO newspaper_department(BranchID, DAddress, Dname) VALUES(2003, "252 Ly Thuong Kiet, Quan 10, HCM City", "Leu Bao Bach Khoa");
SELECT * FROM newspaper_department;
SELECT * FROM employee;
SELECT * FROM Accountant;

SET SQL_SAFE_UPDATES = 0;
-- DELETE FROM employee;
-- DELETE FROM Author;
-- DELETE FROM Editor;
-- DELETE FROM Accountant;
-- DELETE FROM Manager;
SET SQL_SAFE_UPDATES = 1;

INSERT INTO employee(EmployeeID, EEmailAddress, EName, EPhoneNum, EType, EBankAccount, BranchID, EStartDate) 
VALUES(123, "a@gmail.com", "Tran Mau That", "0113456789", "Author", "MBBANK - 1234567", 3, '2023-10-30');
INSERT INTO `user` (Username, UCreatedDate, ULastLogin, UName, UBirthDate, Utype, UHasedPassword)
VALUES
('mauthat2k3', '2023-10-30', '2023-11-30', 'Tran Mau That', '2003-1-1', 'Author', 'hashed_password');

INSERT INTO Author(AuthorID, AUsername) 
VALUES(123, "mauthat2k3");

INSERT INTO employee(EmployeeID, EEmailAddress, EName, EPhoneNum, EType, EBankAccount, BranchID, EStartDate) 
VALUES(456, "b@gmail.com", "Tran Le Quoc Khanh", "0969696969", "Editor", "SGB - 2222223", 3, '2023-10-30');
INSERT INTO `user` (Username, UCreatedDate, ULastLogin, UName, UBirthDate, Utype, UHasedPassword)
VALUES
('quockhanh2k3', '2023-10-30', '2023-11-30', 'Tran Le Quoc Khanh', '2003-2-2', 'Editor', 'hashed_password');

INSERT INTO Editor(EditorID, EUsername) 
VALUES("456", "quockhanh2k3");

INSERT INTO employee(EmployeeID, EEmailAddress, EName, EPhoneNum, EType, EBankAccount, BranchID, EStartDate) 
VALUES(789, "c@gmail.com", "Phan Tran Minh Dat", "0001110001", "Manager", "AGB - 25251325", 3, '2023-10-30');
INSERT INTO Manager(ManagerID, BranchID) 
VALUE(789, 3);

INSERT INTO employee(EmployeeID, EEmailAddress, EName, EPhoneNum, EType, EBankAccount, BranchID, EStartDate) 
VALUES(111, "d@gmail.com", "Phan Le Nhat Minh", "6969690000", "Accountant", "VIB - 100307979", 3, '2023-10-30');
INSERT INTO Accountant(AccountantID) 
VALUE(111);

COMMIT;
-- SET SQL_SAFE_UPDATES = 0;
-- DELETE FROM employee;
-- DELETE FROM newspaper_department;
-- SET SQL_SAFE_UPDATES = 1;