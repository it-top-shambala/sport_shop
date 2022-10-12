DELIMITER |
CREATE TRIGGER trigger_insert_to_deals_backup
    AFTER INSERT ON table_deals
    FOR EACH ROW
    BEGIN
        INSERT INTO table_deals_backup (product_id, client_id, salesman_id, amount, price, date_of_deal)
            VALUE (NEW.product_id,NEW.client_id,NEW.salesman_id,NEW.amount,NEW.price,NEW.date_of_deal);
END|

DELIMITER |
CREATE TRIGGER trigger_drop_product_to_archive
    AFTER INSERT ON table_deals
    FOR EACH ROW
    BEGIN
        DECLARE amount_left INT;
        SELECT amount INTO amount_left FROM table_products WHERE NEW.product_id=product_id;
        IF amount_left=0 THEN
        INSERT INTO table_products_archive (product_id) VALUE (NEW.product_id);
        END IF;
END|

DELIMITER |
CREATE TRIGGER trigger_drop_product_to_last_item
    AFTER INSERT ON table_deals
    FOR EACH ROW
    BEGIN
        DECLARE amount_left INT;
        SELECT amount INTO amount_left FROM table_products WHERE NEW.product_id=product_id;
        IF amount_left=1 THEN
        INSERT INTO table_products_last_item (product_id) VALUE (NEW.product_id);
        END IF;
END|

DELIMITER |
CREATE TRIGGER trigger_insert_client
    BEFORE INSERT ON table_clients
    FOR EACH ROW
    BEGIN
        SET @exists := EXISTS(SELECT client_id FROM table_clients
                                               WHERE NEW.first_name=first_name AND
                                                     NEW.middle_name=middle_name AND
                                                     NEW.last_name=last_name AND
                                                     NEW.e_mail=e_mail);
        IF !@exists THEN
        INSERT INTO table_clients (first_name, middle_name, last_name, gender, e_mail, phone, discount, is_subscribed)
            VALUE (NEW.first_name, NEW.middle_name, NEW.last_name, NEW.gender, NEW.e_mail, NEW.phone, NEW.discount, NEW.is_subscribed);
        END IF;
END|

DELIMITER |
CREATE TRIGGER trigger_set_discount_if_50000
    BEFORE INSERT ON table_deals
    FOR EACH ROW
    BEGIN
        SET @exists := EXISTS(SELECT deal_id FROM table_deals
                                               WHERE NEW.date_of_deal=date(now())AND
                                                     NEW.client_id=client_id);
        IF @exists THEN
         BEGIN
            DECLARE done INT DEFAULT FALSE;
            DECLARE temp FLOAT DEFAULT 0.0;
            DECLARE sum FLOAT DEFAULT 0.0;
            DECLARE price_cursor CURSOR FOR SELECT price FROM table_deals
                                               WHERE NEW.date_of_deal=date(now())AND
                                                     NEW.client_id=client_id;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
            OPEN price_cursor;
            read_loop: LOOP
            FETCH price_cursor INTO temp;
            IF done THEN
            LEAVE read_loop;
            END IF;
            SELECT sum+temp INTO sum;
            END LOOP;
            CLOSE price_cursor;

            IF sum>50000.0 THEN
                BEGIN
                    DECLARE existed_discount INT DEFAULT 0;
                    SELECT discount INTO existed_discount FROM table_clients WHERE client_id = NEW.client_id;
                    IF existed_discount<15 THEN
                        UPDATE table_clients
                        SET discount=15
                        WHERE client_id=NEW.client_id;
                    END IF;
                END;
            END IF;
         END;
        END IF;
        INSERT INTO table_deals (product_id, client_id, salesman_id, amount, price, date_of_deal)
               VALUES (NEW.product_id, NEW.client_id, NEW.salesman_id, NEW.amount, NEW.price, NEW.date_of_deal);
END|
-- условие для отмены временной скидки после завершения покупки???


DELIMITER |
CREATE TRIGGER trigger_drop_employee_to_archive
    AFTER UPDATE ON table_employee
    FOR EACH ROW
    BEGIN
        IF NEW.is_working=FALSE THEN
        INSERT INTO table_employee_archive (employee_id) VALUE (NEW.employee_id);
        END IF;
END|

DELIMITER |
CREATE TRIGGER trigger_if_product_exists
    BEFORE INSERT ON table_products
    FOR EACH ROW
    BEGIN
        SET @exists := EXISTS(SELECT product_id FROM table_products
                                               WHERE NEW.product_name=product_name AND
                                                     NEW.product_type=product_type AND
                                                     NEW.manufacturer=manufacturer AND
                                                     NEW.cost_price=cost_price);
        IF @exists THEN
         BEGIN
             DECLARE existed_product_id INT;
             DECLARE old_amount INT;
             DECLARE new_amount INT;
             SELECT product_id INTO existed_product_id FROM table_products WHERE
                                                     NEW.product_name=product_name AND
                                                     NEW.product_type=product_type AND
                                                     NEW.manufacturer=manufacturer AND
                                                     NEW.cost_price=cost_price;
             SELECT amount INTO old_amount FROM table_products WHERE product_id=existed_product_id;
             SELECT old_amount+NEW.amount INTO new_amount;
             UPDATE table_products
             SET amount = new_amount
             WHERE product_id=existed_product_id;
         END;
        ELSE INSERT INTO table_products (product_name, product_type, manufacturer, amount, cost_price, sell_price)
             VALUES (NEW.product_name, NEW.product_type, NEW.manufacturer, NEW.amount, NEW.cost_price, NEW.sell_price);
        END IF;
END|
