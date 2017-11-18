-- Call this first in any trigger or stored procedure

DROP PROCEDURE IF EXISTS makewave_v2;

DELIMITER //

CREATE PROCEDURE makewave_v2()
BEGIN

    UPDATE STOCK_TRADE SET
        TRADE_DATE  = DATE_ADD(TRADE_DATE, INTERVAL 1 DAY),
        TRADE_TIME  = DATE_ADD(TRADE_DATE, INTERVAL (floor(rand() * 24) + 0) HOUR),
        TRADE_PRICE = (rand() * 1000) + 1,
        TRADE_SIZE  = floor(rand() * 1000) + 1;
    -- TODO: update only if current time is > 9 and < 16
    -- Lower priority TODO: ensure TRADE_DATE and TRADE_TIME are always > 9
    -- and < 16
END //
DELIMITER ;
