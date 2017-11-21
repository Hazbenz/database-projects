DELIMITER //

CREATE PROCEDURE `Call_Option`(IN `Trader_ID` INT)
BEGIN
    DECLARE SellerName varchar(15);
    DECLARE YourStock varchar(15);
    DECLARE GainMoney INT(15);
    DECLARE AmountOfStock INT(15);
    
    SET SellerName=(SELECT `Name` FROM Put_Option WHERE `Trader_ID` = Trader_ID);
    SET YourStock=(SELECT `Stock` FROM Put_Option WHERE `Trader_ID` = Trader_ID);
    SET AmountOfStock=(SELECT `trade_size` From option_transactions WHERE `seller_id` = Trader_ID);
    SET GainMoney =(SELECT `seller_gain` FROM option_transactions WHERE `seller_id` = Trader_ID);
    SELECT SellerName;
    SELECT YourStock;
    SELECT AmountOfStock;
    SELECT GainMoney;
   
END //
DELIMITER ;