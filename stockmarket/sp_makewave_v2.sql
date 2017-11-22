DROP PROCEDURE IF EXISTS makewave_v2;

DELIMITER //

CREATE PROCEDURE makewave_v2()
BEGIN
    DECLARE v_instrument_id INT;
    DECLARE v_trade_time DATETIME;
    DECLARE v_next_time DATETIME;
    DECLARE v_time_diff INT;
    DECLARE v_trade_price DECIMAL(18, 4);

    DECLARE v_distinct_instrument_id BOOLEAN;

    SELECT count(distinct INSTRUMENT_ID)
    INTO v_distinct_instrument_id
    FROM STOCK_TRADE;

    IF v_distinct_instrument_id THEN

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
            TRADE_TIME DESC
        LIMIT 1;

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
                                DATE_ADD(
                                    DATE_ADD(DATE(v_trade_time), INTERVAL 1 DAY),
                                    INTERVAL 9 HOUR
                                ),
                                INTERVAL (FLOOR(RAND() * 30) + 1) MINUTE
                            );
        END IF;

        SELECT v_instrument_id, v_next_time;

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
            ((v_trade_price * (((RAND() * 7)-3)/100)) + v_trade_price),
            FLOOR((RAND() * 1000) + 1)
        );
    ELSE
        INSERT INTO STOCK_TRADE
        (
            INSTRUMENT_ID,
            TRADE_DATE,
            TRADE_TIME,
            TRADE_PRICE,
            TRADE_SIZE
        )
        SELECT
            INSTRUMENT_ID,
            DATE_SUB(DATE(NOW()), INTERVAL 7 YEAR),
            DATE_ADD(DATE_SUB(DATE(NOW()), INTERVAL 7 YEAR), INTERVAL FLOOR((RAND() * 7)+9) HOUR),
            FLOOR(RAND() * 100) + 1,
            FLOOR(RAND() * 1000) + 1
        FROM
            stocks;
    END IF;

END //

DELIMITER ;
