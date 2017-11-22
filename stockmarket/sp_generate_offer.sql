-- Generates option quotes (buy/sell offers)

DROP PROCEDURE IF EXISTS generate_offer;

DELIMITER //

CREATE PROCEDURE generate_offer()
BEGIN
    DECLARE v_instrument_id INT;
    DECLARE v_per_price DOUBLE(18, 4);
    DECLARE v_strike_price DOUBLE(18, 4);
    DECLARE v_trade_size DOUBLE(18, 4);
    DECLARE v_premium DOUBLE(18, 4);
    DECLARE v_is_buyer BOOL;
    DECLARE v_offer_expires DATE;
    DECLARE v_trader_id INT;

    -- Strike price is to be set between -5 to 5 percent in change from
    -- current per stock price

    SELECT INSTRUMENT_ID
    INTO v_instrument_id
    FROM STOCK_TRADE
    ORDER BY RAND()
    LIMIT 1;

    SELECT
        TRADE_DATE,
        TRADE_PRICE,
        (TRADE_PRICE*((FLOOR((RAND() * (11))-5))/100)) + TRADE_PRICE
    INTO
        v_offer_expires,
        v_per_price,
        v_strike_price
    FROM
        STOCK_TRADE
    WHERE
        INSTRUMENT_ID=v_instrument_id
    ORDER BY
        TRADE_TIME DESC
    LIMIT 1;

    SET v_is_buyer = FLOOR(RAND() * 2);

    -- If trader is looking to buy options
    --   + Generate the number of shares of option trader will buy within
    --   + what a trader can currently afford given their total balance
    -- Else if looking to sell
    --   + Allow seller to offer any amount of share from a limit (1000)

    IF v_is_buyer THEN
        SELECT
        trader_id,
        FLOOR((RAND() * FLOOR(total_balance/v_per_price))+1)
            INTO v_trader_id, v_trade_size
        FROM traders
        ORDER BY RAND() LIMIT 1;
    ELSE
        SELECT
        trader_id,
        FLOOR(RAND() * 1000) + 1
            INTO v_trader_id, v_trade_size
        FROM traders
        ORDER BY RAND() LIMIT 1;
    END IF;

    -- Set premium price 5% of the total
    SET v_premium = (v_per_price * v_trade_size) * (0.05);

    SELECT v_instrument_id, v_is_buyer, v_trader_id, v_trade_size, v_premium, v_strike_price;

    INSERT INTO option_quotes
    (
        instrument_id,
        trader_id,
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
        v_instrument_id,
        v_trader_id,
        v_is_buyer,
        FLOOR(RAND() * 2),
        v_trade_size,
        v_premium,
        v_strike_price,
        DATE_ADD(DATE_ADD(v_offer_expires, INTERVAL 960 MINUTE), INTERVAL 3 day),
        DATE_ADD(DATE_ADD(v_offer_expires, INTERVAL 960 MINUTE), INTERVAL 1 day)
    );

END //

DELIMITER ;
