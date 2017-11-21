DELIMITER //

CREATE PROCEDURE `Call_Option`(IN `Trader_ID` INT)
BEGIN
    DECLARE BuyerName varchar(15);
    DECLARE YourStock varchar(15);
    DECLARE AmountOfStock INT(15);
    DECLARE GainMoney INT(15);
    
    SET BuyerName=(SELECT `Name` FROM Call_Option WHERE `Trader_ID` = Trader_ID);
    SET YourStock=(SELECT `Stock` FROM Call_Option WHERE `Trader_ID` = Trader_ID);
    SET AmountOfStock=(SELECT `trade_size` From option_transactions WHERE `buyer_id` = Trader_ID);
    SET GainMoney =(SELECT `buyer_gain` FROM option_transactions WHERE `buyer_id` = Trader_ID);
    
    SELECT BuyerName;
    SELECT YourStock;
    SELECT AmountOfStock;
    SELECT GainMoney;
   
END //
DELIMITER ;
