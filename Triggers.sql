USE newspaper_department; 
DROP TRIGGER IF EXISTS before_insert_customer;
DELIMITER //
CREATE TRIGGER before_insert_customer 
BEFORE INSERT ON employee 
FOR EACH ROW 
BEGIN     
	IF CHAR_LENGTH(NEW.EPhoneNum) < 10 OR CHAR_LENGTH(NEW.EPhoneNum) > 11 THEN 	
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Phone number must be at least 10 and at most 11 characters';
	END IF; 
END;

