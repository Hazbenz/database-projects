-- TODO: NEEDS DEBUGGING
DROP PROCEDURE IF EXISTS generate_offer;

DELIMITER //

CREATE PROCEDURE generate_offer()
BEGIN
    DECLARE ins_id INT;
    DECLARE per_price DOUBLE(18, 4);
    DECLARE strike_pr DOUBLE(18, 4);
    DECLARE trade_size DOUBLE(18, 4);
    DECLARE premium DOUBLE(18, 4);
    DECLARE offer_exp DATE;
    DECLEARE is_buyer BOOL;
    DECLARE trad_id INT;

    SELECT
    INSTRUMENT_ID, 
    TRADE_DATE,
    TRADE_PRICE/TRADE_SIZE,
    ((TRADE_PRICE/TRADE_SIZE)*((SELECT FLOOR((RAND() * (11))-5))/100)) + (TRADE_PRICE/TRADE_SIZE)
        INTO ins_id, offer_exp, per_price, strike_pr
    FROM STOCK_TRADE
    ORDER BY RAND() LIMIT 1;

    is_buyer = FLOOR(RAND() * 2);

    IF is_buyer THEN
        SELECT
        trad_id,
        FLOOR((RAND() * FLOOR(total_balance/per_price))+1)
            INTO trad_id, trade_size
        FROM traders
        ORDER BY RAND() LIMIT 1;
    ELSE
        SELECT
        trad_id,
        FLOOR(RAND() * 1000) + 1
            INTO trad_id, trade_size
        FROM traders
        ORDER BY RAND() LIMIT 1;
    END IF;

    SET premium = (per_pr * trade_size) * (0.05);

    INSERT INTO option_quotes
    (
        instrument_id,
        trader_id,
        is_active,
        trader_type,
        option_type,
        trade_size,
        premium,
        strike_price,
        option_expires,
        offer_expires
    )
    VALUES
    (
        ins_id,
        trad_id,
        true,
        is_buyer,
        premium,
        strike_pr,
        DATE_ADD(offer_exp, INTERVAL 3 day),
        DATE_ADD(offer_exp, INTERVAL 1 day)
    );
END //

DELIMITER //
