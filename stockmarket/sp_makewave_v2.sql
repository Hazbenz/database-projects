DROP PROCEDURE IF EXISTS makewave_v2;

DELIMITER //

CREATE PROCEDURE makewave_v2()
BEGIN
    DECLARE v_instrument_id INT;
    DECLARE v_trade_time DATETIME;
    DECLARE v_next_time DATETIME;
    DECLARE v_time_diff INT;
    DECLARE v_trade_price DOUBLE(18, 4);

    SELECT INSTRUMENT_ID
    INTO v_instrument_id
    FROM stocks
    ORDER BY RAND()
    LIMIT 1;

    SELECT
        TRADE_TIME,
        TRADE_PRICE
    INTO
        v_trade_time,
        v_trade_price
    FROM
        STOCK_TRADE
    WHERE 
        INSTRUMENT_ID = v_instrument_id
    ORDER BY
        RAND() LIMIT 1;

    SET v_time_diff = TIMESTAMPDIFF(
                            MINUTE,
                            v_trade_time,
                            DATE_ADD(DATE(v_trade_time), INTERVAL 16 HOUR)
                        );

    IF v_time_diff > 30 THEN
        SET v_next_time = DATE_ADD(
                            v_trade_time,
                            INTERVAL (FLOOR(RAND() * v_time_diff) + 1) MINUTE
                        );
    ELSE
        SET v_next_time = DATE_ADD(
                            DATE_ADD(v_trade_time, INTERVAL 1 DAY),
                            INTERVAL (FLOOR(RAND() * 30) + 1) MINUTE
                        );
    END IF;

    INSERT INTO STOCK_TRADE
    (
        INSTRUMENT_ID,
        TRADE_DATE,
        TRADE_TIME,
        TRADE_PRICE,
        TRADE_SIZE
    )
    VALUES
    (
        v_instrument_id,
        DATE(v_next_time),
        v_next_time,
        ((v_trade_price * (FLOOR((RAND() * 7)-3))/100) + v_trade_price),
        FLOOR((RAND() * 1000) + 1)
    );

END //
DELIMITER ;
