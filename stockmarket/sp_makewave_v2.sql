-- Call this first in any trigger or stored procedure

-- Every time this is run:
-- + TRADE_DATE updates to next day
-- + TRADE_TIME updates to next day some time between 9am to 4pm
-- + TRADE_PRICE updates to a random double from 1 to 1000
-- + TRADE_SIZE updates to random integer from 1 to 1000

DROP PROCEDURE IF EXISTS makewave_v2;

DELIMITER //

CREATE PROCEDURE makewave_v2()
BEGIN
    UPDATE STOCK_TRADE SET
        TRADE_DATE  = DATE_ADD(TRADE_DATE, INTERVAL 1 DAY),
        TRADE_TIME  = DATE_ADD(
                        DATE_ADD(
                            DATE_ADD(
                                TRADE_DATE,
                                INTERVAL (FLOOR((RAND() * 7) + 9)) HOUR),
                            INTERVAL (FLOOR(RAND() * 61)) MINUTE),
                        INTERVAL (FLOOR(RAND() * 61)) SECOND),
        TRADE_PRICE = (rand() * 10000) + 1,
        TRADE_SIZE  = floor(rand() * 1000) + 1;
END //
DELIMITER ;
