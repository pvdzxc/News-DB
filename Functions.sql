use newspaper_database;
DROP FUNCTION IF EXISTS FindAQuiteFreeAccountant;
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
-- DROP FUNCTION IF EXISTS GetEditorByUsername;
-- CREATE FUNCTION GetEditorByUsername(Username INT)
-- RETURNS INT
-- DETERMINISTIC
-- READS SQL DATA
-- BEGIN
--     DECLARE done BOOLEAN DEFAULT FALSE;
--     DECLARE AID INT;
--     DECLARE ATAB INT;
--     DECLARE lowest_value INT;
--     DECLARE ID_lowest_value INT;

--     -- Declare a cursor
--     DECLARE myCursor CURSOR FOR SELECT AccountantID, AcTotalApprovedBills FROM Accountant;

--     -- Declare continue handler
--     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

--     OPEN myCursor;

--     -- Initialize variables
--     SET lowest_value = NULL;

--     my_loop: LOOP
--         -- Fetch from the cursor
--         FETCH myCursor INTO AID, ATAB;

--         -- Break the loop if no more records
--         IF done THEN
--             LEAVE my_loop;
--         END IF;
-- 		
--         -- Check if the current row has the lowest value
--         IF lowest_value IS NULL OR ATAB < lowest_value THEN
--             SET lowest_value = ATAB;
--             SET ID_lowest_value = AID;
--         END IF;
--     END LOOP;

--     CLOSE myCursor;

--     -- Return the lowest value found
--     RETURN ID_lowest_value;
-- END //

-- DELIMITER ;
