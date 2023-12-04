BEGIN;
-- INSERT INTO IF NOT EXIST newspaper_department(DAddress, Dname) VALUES("252 Ly Thuong Kiet, Quan 10, HCM City", "Leu Bao Bach Khoa");


SET SQL_SAFE_UPDATES = 0;
DELETE FROM employee;
DELETE FROM Author;
DELETE FROM Editor;
DELETE FROM Manager;
SET SQL_SAFE_UPDATES = 1;

INSERT INTO employee(EmployeeID, EEmailAddress, EName, EPhoneNum, EType, EBankAccount, BranchID, EStartDate) 
VALUES(123, "a@gmail.com", "Tran Mau That", "0123456789", "Author", "MBBANK - 1234567", 17, '2023-10-30');
INSERT INTO Author(AuthorID, AUsername) 
VALUES(123, "MT");

INSERT INTO employee(EmployeeID, EEmailAddress, EName, EPhoneNum, EType, EBankAccount, BranchID, EStartDate) 
VALUES(456, "b@gmail.com", "Tran Le Quoc Khanh", "0969696969", "Editor", "SGB - 2222223", 17, '2023-10-30');
INSERT INTO Editor(EditorID, EUsername) 
VALUES("456", "TLQK");

INSERT INTO employee(EmployeeID, EEmailAddress, EName, EPhoneNum, EType, EBankAccount, BranchID, EStartDate) 
VALUES(789, "c@gmail.com", "Phan Tran Minh Dat", "0001110001", "Manager", "AGB - 25251325", 17, '2023-10-30');
INSERT INTO Manager(ManagerID, BranchID) 
VALUE(789, 17);

INSERT INTO employee(EmployeeID, EEmailAddress, EName, EPhoneNum, EType, EBankAccount, BranchID, EStartDate) 
VALUES(111, "d@gmail.com", "Phan Le Nhat Minh", "0000", "Accountant", "VIB - 100307979", 17, '2023-10-30');

COMMIT;
-- SET SQL_SAFE_UPDATES = 0;
-- DELETE FROM employee;
-- DELETE FROM newspaper_department;
-- SET SQL_SAFE_UPDATES = 1;