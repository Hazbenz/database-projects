DELIMITER //

CREATE PROCEDURE `Call_Option`(IN `Trader_ID` INT)
BEGIN
BEGIN

    DECLARE YourStock varchar(15);
    
    
    SET YourStock=(SELECT `Stock` FROM Call_Option WHERE `Trader_ID` = Trader_ID);
    SELECT * FROM option_transactions WHERE `seller_id` = Trader_ID;
    SELECT YourStock;
    

END
   
END //
DELIMITER ;
