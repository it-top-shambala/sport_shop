DELIMITER |
CREATE TRIGGER trigger_insert_receipt_into_table_all_sales
    AFTER UPDATE ON table_receipts
    FOR EACH ROW
    BEGIN
        IF NEW.is_paid=TRUE THEN
           INSERT INTO table_all_sales (receipt_id) VALUES (NEW.receipt_id);
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_insert_order_into_table_all_sales
    AFTER UPDATE ON table_orders
    FOR EACH ROW
    BEGIN
        IF NEW.is_paid=TRUE THEN
           INSERT INTO table_all_sales (order_id) VALUES (NEW.order_id);
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_calculate_total_price_in_receipt
    AFTER INSERT ON table_receipt_items
    FOR EACH ROW
    BEGIN
       DECLARE old_total_price INT;
       DECLARE added_item_price INT;
       DECLARE new_total_price INT;
       SELECT total_price INTO old_total_price FROM table_receipts WHERE receipt_id=NEW.receipt_id;
       SELECT sell_price INTO added_item_price FROM table_products WHERE product_id=NEW.product_id;
       SELECT old_total_price + added_item_price INTO new_total_price;
       UPDATE table_receipts
       SET total_price = new_total_price
       WHERE receipt_id=NEW.receipt_id;
END|


DELIMITER |
CREATE TRIGGER trigger_calculate_total_price_in_order
    AFTER INSERT ON table_order_items
    FOR EACH ROW
    BEGIN
       DECLARE old_total_price INT;
       DECLARE added_item_price INT;
       DECLARE new_total_price INT;
       SELECT total_price INTO old_total_price FROM table_receipts WHERE receipt_id=NEW.order_id;
       SELECT sell_price INTO added_item_price FROM table_products WHERE product_id=NEW.product_id;
       SELECT old_total_price + added_item_price INTO new_total_price;
       UPDATE table_receipts
       SET total_price = new_total_price
       WHERE receipt_id=NEW.order_id;
END|


DELIMITER |
CREATE TRIGGER trigger_set_discount_to_receipt_if_total_price_exceeds_50000
    AFTER UPDATE ON table_receipts
    FOR EACH ROW
    BEGIN
        IF NEW.client_card_is_scanned THEN
            BEGIN
                IF NEW.total_price>50000.0 THEN
                    BEGIN
                       DECLARE existed_discount INT;
                       SELECT discount INTO existed_discount FROM table_clients WHERE client_id=NEW.client_id;
                            IF existed_discount<15 THEN
                                UPDATE table_receipts
                                SET discount = 15
                                WHERE receipt_id=NEW.receipt_id;
                            ELSE
                                UPDATE table_receipts
                                SET discount = existed_discount
                                WHERE receipt_id=NEW.receipt_id;
                            END IF;
                    END;
                ELSE
                    BEGIN
                       DECLARE existed_discount INT;
                       SELECT discount INTO existed_discount FROM table_clients WHERE client_id=NEW.client_id;
                       UPDATE table_receipts
                       SET discount = existed_discount
                       WHERE receipt_id=NEW.receipt_id;
                    END;
                END IF;
            END;
        END IF;
        IF discount>0 THEN
            BEGIN
                DECLARE total_price_minus_discount DOUBLE;
                SELECT total_price*(discount/100) INTO total_price_minus_discount;
                UPDATE table_receipts
                SET total_price=total_price_minus_discount
                WHERE receipt_id=NEW.receipt_id;
            END;
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_set_discount_to_order_if_total_price_exceeds_50000
    AFTER UPDATE ON table_orders
    FOR EACH ROW
    BEGIN
        IF NEW.is_confirmed THEN
            BEGIN
                IF NEW.total_price>50000.0 THEN
                    BEGIN
                       DECLARE existed_discount INT;
                       SELECT discount INTO existed_discount FROM table_clients WHERE client_id=NEW.client_id;
                            IF existed_discount<15 THEN
                                UPDATE table_receipts
                                SET discount = 15
                                WHERE receipt_id=NEW.order_id;
                            ELSE
                                UPDATE table_receipts
                                SET discount = existed_discount
                                WHERE receipt_id=NEW.order_id;
                            END IF;
                    END;
                ELSE
                    BEGIN
                       DECLARE existed_discount INT;
                       SELECT discount INTO existed_discount FROM table_clients WHERE client_id=NEW.client_id;
                       UPDATE table_receipts
                       SET discount = existed_discount
                       WHERE receipt_id=NEW.order_id;
                    END;
                END IF;
            END;
        END IF;
        IF discount>0 THEN
            BEGIN
                DECLARE total_price_minus_discount DOUBLE;
                SELECT total_price*(discount/100) INTO total_price_minus_discount;
                UPDATE table_receipts
                SET total_price=total_price_minus_discount
                WHERE receipt_id=NEW.order_id;
            END;
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_drop_product_to_table_last_items
    AFTER UPDATE ON table_products
    FOR EACH ROW
    BEGIN
        DECLARE amount_left INT;
        SELECT amount INTO amount_left FROM table_products WHERE NEW.product_id=product_id;
        IF amount_left = 1 THEN
        INSERT INTO table_last_items (product_id) VALUE (NEW.product_id);
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_drop_product_to_table_sold_out_products_archive
    AFTER UPDATE ON table_products
    FOR EACH ROW
    BEGIN
        DECLARE amount_left INT;
        SELECT amount INTO amount_left FROM table_products WHERE NEW.product_id=product_id;
        IF amount_left = 0 THEN
        INSERT INTO table_sold_out_products_archive (product_id) VALUE (NEW.product_id);
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_insert_client
    BEFORE INSERT ON table_clients
    FOR EACH ROW
    BEGIN
        SET @exists := EXISTS(SELECT client_id FROM table_clients WHERE NEW.e_mail=e_mail OR
                                                                        NEW.phone=phone);
        IF !@exists THEN
        INSERT INTO table_clients (person_id, e_mail, phone, discount, is_subscribed)
            VALUE (NEW.person_id, NEW.e_mail, NEW.phone, NEW.discount, NEW.is_subscribed);
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_drop_employee_to_archive
    AFTER UPDATE ON table_employee
    FOR EACH ROW
    BEGIN
        IF NEW.is_working = FALSE  THEN
        INSERT INTO table_employee_archive (employee_id, date_of_firing) VALUE (NEW.employee_id, DATE(now()));
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_insert_product_if_exists
    BEFORE INSERT ON table_products
    FOR EACH ROW
    BEGIN
        SET @exists := EXISTS(SELECT product_id FROM table_products
                                               WHERE NEW.product_name=product_name AND
                                                     NEW.product_name=product_name AND
                                                     NEW.product_type_id=product_type_id AND
                                                     NEW.company_id=company_id);
        IF @exists THEN
         BEGIN
             DECLARE existed_product_id INT;
             DECLARE old_amount INT;
             DECLARE new_amount INT;
             SELECT product_id INTO existed_product_id FROM table_products WHERE
                                                     NEW.product_name=product_name AND
                                                     NEW.product_type_id=product_type_id AND
                                                     NEW.company_id=company_id;
             SELECT amount INTO old_amount FROM table_products WHERE product_id=existed_product_id;
             SELECT old_amount+NEW.amount INTO new_amount;
             UPDATE table_products
             SET amount = new_amount
             WHERE product_id = existed_product_id;
         END;
        ELSE INSERT INTO table_products (product_name, product_type_id, company_id, amount, sell_price)
             VALUES (NEW.product_name, NEW.product_type_id, NEW.company_id, NEW.amount, NEW.sell_price);
        END IF;
END|
