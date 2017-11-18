CREATE PROCEDURE `Call_Option`(IN `Trader_ID` INT)
BEGIN
    SELECT * FROM Call_Option WHERE `Trader_ID` = Trader_ID;
    SELECT * FROM option_transactions WHERE `seller_id` = Trader_ID;

END