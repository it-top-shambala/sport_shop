-- triggers for products and nomenclatures

DELIMITER |
CREATE TRIGGER trigger_refresh_nomenclature_amount
    AFTER INSERT ON table_procurements
    FOR EACH ROW
    BEGIN
    INSERT INTO table_nomenclatures (product_id, amount) VALUES (NEW.product_id, NEW.amount);
END |


DELIMITER |
CREATE TRIGGER trigger_insert_nomenclature_if_it_exists
    BEFORE INSERT ON table_nomenclatures
    FOR EACH ROW
    BEGIN
        SET @exists := EXISTS(SELECT nomenclature_id FROM table_nomenclatures
                                               WHERE product_id = NEW.product_id);
        IF @exists THEN
         BEGIN
             DECLARE new_amount INT;
             SET @existing_nomenclature_id := function_get_nomenclature_id(NEW.product_id);
             SET @old_amount := function_get_nomenclature_amount(@existing_nomenclature_id);
             SELECT @old_amount+NEW.amount INTO new_amount;
             UPDATE table_nomenclatures
             SET amount = new_amount
             WHERE nomenclature_id = @existing_nomenclature_id;
         END;
        ELSE INSERT INTO table_nomenclatures (product_id, amount)
             VALUES (NEW.product_id, NEW.amount);
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_set_nomenclature_is_available
    AFTER UPDATE ON table_nomenclatures
    FOR EACH ROW
    BEGIN
        IF NEW.sell_price>0 THEN
        UPDATE table_nomenclatures
            SET is_available = TRUE
            WHERE nomenclature_id = NEW.nomenclature_id;
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_drop_nomenclature_to_table_last_items
    AFTER UPDATE ON table_nomenclatures
    FOR EACH ROW
    BEGIN
        SET @amount_left := function_get_nomenclature_amount(NEW.nomenclature_id);
        IF @amount_left = 1 THEN
        SET @price := function_get_nomenclature_price(NEW.nomenclature_id);
        SET @new_price := @price*0.9;
        INSERT INTO table_nomenclature_last_items (nomenclature_id, new_sell_price)
            VALUES (NEW.nomenclature_id, @new_price);
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_set_nomenclature_is_sold_out
    AFTER UPDATE ON table_nomenclatures
    FOR EACH ROW
    BEGIN
        SET @amount_left := function_get_nomenclature_amount(NEW.nomenclature_id);
        IF @amount_left = 0 THEN
        UPDATE table_nomenclatures
        SET is_sold_out = TRUE AND is_available = FALSE
        WHERE nomenclature_id = NEW.nomenclature_id;
        END IF;
END|


-- triggers for sales

DELIMITER |
CREATE TRIGGER trigger_calculate_total_price_in_receipt
    AFTER INSERT ON table_receipt_items
    FOR EACH ROW
    BEGIN
       DECLARE new_total_price DOUBLE;
       DECLARE count INT;
       SET @old_total_price := function_get_receipt_total_price(NEW.receipt_id);
       SET @added_item_price := function_get_nomenclature_price(NEW.nomenclature_id);
       SELECT @old_total_price + (@added_item_price*NEW.amount) INTO new_total_price;
       SELECT total_items+1 INTO count FROM table_receipts WHERE receipt_id=NEW.receipt_id;
       UPDATE table_receipts
       SET total_price = new_total_price AND total_items=count
       WHERE receipt_id=NEW.receipt_id;
END|


DELIMITER |
CREATE TRIGGER trigger_calculate_total_price_in_order
    AFTER INSERT ON table_order_items
    FOR EACH ROW
    BEGIN
       DECLARE new_total_price DOUBLE;
       DECLARE count INT;
       SET @old_total_price := function_get_receipt_total_price(NEW.order_id);
       SET @added_item_price := function_get_nomenclature_price(NEW.nomenclature_id);
       SELECT @old_total_price + (@added_item_price*NEW.amount) INTO new_total_price;
       SELECT total_items+1 INTO count FROM table_orders WHERE order_id=NEW.order_id;
       UPDATE table_orders
       SET total_price = new_total_price AND total_items=count
       WHERE order_id=NEW.order_id;
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
                       SET @existed_discount := function_get_client_discount(NEW.client_id);
                            IF @existed_discount<15 THEN
                                UPDATE table_receipts
                                SET discount = 15
                                WHERE receipt_id=NEW.receipt_id;
                            ELSE
                                UPDATE table_receipts
                                SET discount = @existed_discount
                                WHERE receipt_id=NEW.receipt_id;
                            END IF;
                    END;
                ELSE
                    BEGIN
                       SET @existed_discount := function_get_client_discount(NEW.client_id);
                       UPDATE table_receipts
                       SET discount = @existed_discount
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
                       SET @existed_discount := function_get_client_discount(NEW.client_id);
                            IF @existed_discount<15 THEN
                                UPDATE table_orders
                                SET discount = 15
                                WHERE order_id=NEW.order_id;
                            ELSE
                                UPDATE table_orders
                                SET discount = @existed_discount
                                WHERE order_id=NEW.order_id;
                            END IF;
                    END;
                ELSE
                    BEGIN
                       SET @existed_discount := function_get_client_discount(NEW.client_id);
                       UPDATE table_orders
                       SET discount = @existed_discount
                       WHERE order_id=NEW.order_id;
                    END;
                END IF;
            END;
        END IF;
        IF discount>0 THEN
            BEGIN
                DECLARE total_price_minus_discount DOUBLE;
                SELECT total_price*(discount/100) INTO total_price_minus_discount;
                UPDATE table_orders
                SET total_price=total_price_minus_discount
                WHERE order_id=NEW.order_id;
            END;
        END IF;
END|


DELIMITER |
CREATE TRIGGER trigger_set_date_to_receipt_after_payment
    AFTER UPDATE ON table_receipts
    FOR EACH ROW
    BEGIN
        IF NEW.is_paid = TRUE  THEN
            UPDATE table_receipts
            SET date_of_deal=DATE(now())
            WHERE receipt_id=NEW.receipt_id;
            INSERT INTO table_all_sales (receipt_id) VALUES (NEW.receipt_id);
        END IF;
END |


DELIMITER |
CREATE TRIGGER trigger_set_date_to_order_after_payment
    AFTER UPDATE ON table_orders
    FOR EACH ROW
    BEGIN
        IF NEW.is_paid = TRUE  THEN
            UPDATE table_orders
            SET date_of_order=DATE(now())
            WHERE order_id=NEW.order_id;
            INSERT INTO table_all_sales (order_id) VALUES (NEW.order_id);
        END IF;
END |


-- triggers for employee and clients

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
