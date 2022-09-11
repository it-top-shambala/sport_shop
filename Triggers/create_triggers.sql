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
CREATE TRIGGER check_user_exist_person BEFORE INSERT ON
Person FOR EACH ROW
    BEGIN
        DECLARE is_exist INT(11);
        SELECT EXISTS((SELECT first_name,last_name FROM sport_shop.person WHERE first_name = NEW.first_name OR last_name = NEW.last_name)) INTO is_exist;
        #check whetever user exist if user exist then EXISTS return 1 otherwise return 0
        IF is_exist = 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'USER FIRST_NAME AND LAST_NAME ALREADY EXIST';
        END IF;
    END |
    DROP TRIGGER check_user_exist_person;

DELIMITER |
<<<<<<< HEAD
CREATE TRIGGER check_user_exist_client BEFORE INSERT ON
Client FOR EACH ROW
    BEGIN
        DECLARE is_exist INT(11);
        SELECT EXISTS(SELECT person_id, email FROM sport_shop.Client WHERE person_id = NEW.person_id OR email = NEW.email) INTO is_exist;
        #check whetever user exist if user exist then EXISTS return 1 otherwise return 0
        IF is_exist = 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PERSON OR EMAIL ALREADY EXIST';
        END IF;
    END |

    DROP TRIGGER check_user_exist_client;

#TODO FIX CLIENT INSERT
DELIMITER |
CREATE TRIGGER save_deleted_users AFTER UPDATE ON
Client FOR EACH ROW
    BEGIN
        IF NEW.is_delete =  TRUE THEN
            INSERT INTO deleted_users(client_id) VALUES(NEW.Id);
        END IF;
    END |

DROP TRIGGER save_deleted_users;

DELIMITER |
CREATE TRIGGER check_employee_date BEFORE UPDATE ON
employee FOR EACH ROW
    BEGIN
        SET @isGreater = NEW.employment_date <= STR_TO_DATE('2015-01-01','%Y-%m-%d');
        IF  @isGreater = TRUE AND NEW.is_delete = TRUE THEN
            SIGNAL SQLSTATE '12343' SET MESSAGE_TEXT = 'You cant delete this employee';
        END IF;
    END |

DROP TRIGGER check_employee_date;


#TODO FIX SOME PROBLEMS
DELIMITER |
CREATE TRIGGER check_client_buys_sum AFTER INSERT ON
goods_sales FOR EACH ROW
    BEGIN
        DECLARE sum INT;
        DECLARE sales_id INT;
        DECLARE old_discount INT;
        SELECT Id INTO sales_id FROM performerd_buys WHERE Id = (SELECT goods_buyer_id FROM goods_sales WHERE goods_buyer_id = NEW.goods_buyer_id);
        SELECT SUM(performed_buys_price) INTO sum FROM performerd_buys WHERE Id = sales_id;
        SELECT discounts INTO old_discount FROM goods_sales WHERE Id = NEW.Id;
        IF sum >= 50000 THEN
            UPDATE goods_sales SET discounts = (old_discount + 15) WHERE Id = NEW.Id;
        END IF;
    END |
DROP TRIGGER check_client_buys_sum;








=======
CREATE TRIGGER check_user_exist_person AFTER INSERT ON
Person FOR EACH ROW
    BEGIN
        DECLARE is_exist INT(11);
        SELECT EXISTS(SELECT first_name,last_name FROM sport_shop.person WHERE first_name = NEW.first_name AND last_name = NEW.last_name)) INTO is_exist;
        #check whetever user exist if user exist then EXISTS return 1 otherwise return 0
        IF is_exist = 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'USER FIRST_NAME AND LAST_NAME ALREADY EXIST';
        END IF;
    END |

    DROP TRIGGER check_user_exist_person;

DELIMITER |
CREATE TRIGGER check_user_exist_client AFTER INSERT ON
Client FOR EACH ROW
    BEGIN
        DECLARE is_exist INT(11);
        SELECT EXISTS(SELECT person_id, email FROM sport_shop.Client WHERE person_id = NEW.person_id OR email = NEW.email)) INTO is_exist;
        #check whetever user exist if user exist then EXISTS return 1 otherwise return 0
        IF is_exist = 1 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PERSON OR EMAIL ALREADY EXIST';
        END IF;
    END |
>>>>>>> ff2b1044760a4cecd29ed0ceeccbe76a70f69ff2

    DROP TRIGGER check_user_exist_client;
