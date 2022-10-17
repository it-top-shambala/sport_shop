-- добавление количества товара к существующему
DELIMITER  |
CREATE TRIGGER add_product BEFORE  INSERT ON  current_products
FOR EACH ROW
    BEGIN
        IF EXISTS(SELECT product_id FROM current_products WHERE product_id = NEW.product_id)
            THEN UPDATE current_products SET product_count = product_count + NEW.product_count
            WHERE product_id = NEW.product_id;
            END IF;
        END|
-- обновление количества товара после продажи
DELIMITER  |
CREATE TRIGGER list_sells AFTER INSERT ON sold_products
FOR EACH ROW
    BEGIN
        UPDATE current_products SET product_count = product_count-NEW.count_sold
                                WHERE current_products.product_id = NEW.product_id;
        END|

-- запрет на добавление существующего покупателя
DELIMITER  |
CREATE TRIGGER aborting_buyer BEFORE  INSERT ON  buyers
    FOR EACH ROW
    BEGIN
          SET @found := FALSE;
    SELECT TRUE INTO @found from buyers WHERE  buyer_fio = NEW.buyer_fio AND buyer_mail = NEW.buyer_mail;
    IF @found THEN
        SIGNAL  SQLSTATE '45000' SET MESSAGE_TEXT  = 'duplicate insert';
        INSERT IGNORE INTO buyers(BUYER_FIO, SEX_ID, BUYER_PHONE, BUYER_MAIL, SUBSCRIBING)
        VALUES (NEW.buyer_fio, NEW.sex_id, NEW.buyer_phone, NEW.buyer_mail, NEW.subscribing);
    end IF;
        END|

 -- запрет на удаление данных о покупателе
DELIMITER |
CREATE TRIGGER forbid_delete_buyers BEFORE DELETE ON buyers
    FOR EACH ROW
    BEGIN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DELETE buyer canceled';
        END |

-- запрет на удаление данных о сотрудниках, уволенных до 2015 г.
DELIMITER |
CREATE TRIGGER forbid_delete_employees BEFORE DELETE ON employees
    FOR EACH ROW
    BEGIN
   IF OLD.employment_date < '2015.01.01' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DELETE employee canceled';
    END IF;
END |

-- запрет на ввод товара фирмы 'Спорт, солнце и штанга (SSB)'
DELIMITER |
CREATE TRIGGER forbid_add_product_SSB BEFORE INSERT ON producing_countries
    FOR EACH ROW
    BEGIN
   IF NEW.producing_firm = 'SSB' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FOBID SSB';
    END IF;
END |

-- установкиа скидки 15% покупателю  при покупке на сумму более 5000 рублей за весь период
DELIMITER |
CREATE TRIGGER set_discont_for_5000 BEFORE INSERT ON sold_products
    FOR EACH ROW
    BEGIN
        DECLARE selling_sum DOUBLE DEFAULT 0;
        SELECT NEW.buyer_id, SUM(selling_price) AS selling_sum FROM buyers GROUP BY NEW.buyer_id;
        IF selling_sum > 5000 THEN SET NEW.discount_id = 3 ;
    END IF;
END |

-- внесение последней единицы товара в таблицу 'Последняя единица'
DELIMITER |
CREATE TRIGGER set_last_item AFTER UPDATE ON current_products
    FOR EACH ROW
    BEGIN
        IF NEW.product_count = 1 THEN INSERT INTO last_item(product_id) VALUE (NEW.product_id) ;
            END IF;
        IF NEW.product_count = 0 THEN DELETE  FROM last_item WHERE last_item.product_id = NEW.product_id;
            END IF;
END |





