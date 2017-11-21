DROP TABLE IF EXISTS option_quotes;

CREATE TABLE option_quotes
(

    quote_id       INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    instrument_id  INT NOT NULL REFERENCES
                   stockmarket.INSTRUMENT(INSTRUMENT_ID),
    trader_id      INT NOT NULL REFERENCES
                   traders(trader_id),
    is_active      BOOLEAN NOT NULL DEFAULT TRUE,
    trader_type    BOOLEAN NOT NULL,
    option_type    BOOLEAN NOT NULL,
    trade_size     INT NOT NULL,
    premium        DOUBLE(18, 4) NOT NULL,
    strike_price   DOUBLE(18, 4) NOT NULL,
    option_expires DATETIME NOT NULL,
    offer_expires  DATETIME NOT NULL
);
