CREATE TRIGGER sales_log_history_insert AFTER INSERT ON
goods_sales FOR EACH ROW
    INSERT INTO History(log_type_id, goods_manufacturer, buyer_firstname, saler_firstname, sales_price, good_name, sales_date)
        VALUES (
                (SELECT trigger_type.Id FROM trigger_type WHERE trigger_type.type_name = 'insert'),
                (SELECT goods_manufacturer_name FROM goods_manufacturer WHERE Id = (SELECT saled_goods_id FROM goods_sales WHERE saled_goods_id = NEW.saled_goods_id)),
                (SELECT first_name FROM Person WHERE Person.Id = (SELECT goods_buyer_id FROM goods_sales WHERE goods_buyer_id = NEW.goods_buyer_id)),
                (SELECT first_name FROM Person WHERE Person.Id = (SELECT goods_seller_id FROM goods_sales WHERE goods_seller_id = NEW.goods_seller_id)),
                New.sales_price,
                (SELECT goods_name FROM goods WHERE goods.Id = NEW.saled_goods_id),
                NEW.sales_date
        );


DROP TRIGGER sales_log_history_insert;

DELIMITER |
CREATE TRIGGER check_is_there_goods AFTER INSERT ON
goods_sales FOR EACH ROW
    BEGIN
        DECLARE amount_ INT(11);
        DECLARE goods_id_ INT(11);
        SELECT goods_amount INTO amount_ FROM goods WHERE Id =
                                           (SELECT saled_goods_id FROM goods_sales WHERE saled_goods_id = NEW.saled_goods_id);
        SELECT Id INTO goods_id_ FROM goods WHERE Id =
                                            (SELECT saled_goods_id FROM goods_sales WHERE saled_goods_id = NEW.saled_goods_id);
        IF amount_ <= 0 THEN
            INSERT INTO Archive(archive_goods_name, archive_goods_type_id, archive_goods_manufacturer_id, archive_goods_amount, archive_goods_cost_price, archive_goods_sales_price)
                VALUES(
                    (SELECT goods_name FROM goods WHERE Id = goods_id_),
                    (SELECT goods_type_id FROM goods WHERE Id = goods_id_),
                    (SELECT goods_manufacturer_id FROM goods WHERE Id = goods_id_),
                    (SELECT goods_amount FROM goods WHERE Id = goods_id_),
                    (SELECT goods_cost_price FROM goods WHERE Id = goods_id_),
                    (SELECT goods_sales_price FROM goods WHERE Id = goods_id_)
                );
        END IF;
    END |



DELIMITER |
CREATE TRIGGER check_user_exist AFTER INSERT ON
Client FOR EACH ROW
    BEGIN
        DECLARE is_exist INT(11);
        DECLARE last_name_ VARCHAR(100);
        DECLARE first_name_ VARCHAR(100);
        DECLARE email_ VARCHAR(100);
        SELECT first_name INTO first_name_ FROM sport_shop.person Where Id = (SELECT person_id FROM sport_shop.client WHERE person_id = NEW.person_id);
        SELECT last_name INTO last_name_ FROM sport_shop.person Where Id = (SELECT person_id FROM sport_shop.client WHERE person_id = NEW.person_id);
        SELECT EXISTS((SELECT * FROM sport_shop.person WHERE
                                                           person.first_name = first_name_ AND
                                                           person.last_name = last_name_
                                                       )) INTO is_exist;
        #check whetever user exist if user exist then EXISTS return 1 otherwise return 0
        SELECT EXISTS((SELECT * FROM client WHERE Id = NEW.Id = email = NEW.email)) INTO email_;
        IF is_exist = 1 OR email_ = 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'USER ALREADY EXIST';
        END IF;
    END |


    DROP TRIGGER check_user_exist;




