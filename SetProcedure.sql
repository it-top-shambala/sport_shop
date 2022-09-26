 #поиск и проверка наличия товара в таблицах
DELIMITER |
CREATE PROCEDURE Check_things(OUT index_ INT)
BEGIN
    SET index_ = SELECT id_thing FROM things
    WHERE name_thing = NEW.name_thing AND id_type_thing = NEW.id_type_thing
       AND cost_price = NEW.cost_price AND selling_price = NEW.selling_price
       AND id_manufacturer = NEW.id_manufacturer;
END|

 #изменение количества товара по id
DELIMITER |
CREATE PROCEDURE Change_amount_thing(IN index_ INT)
BEGIN
   UPDATE things SET amount_thing = NEW.amount_thing WHERE id_thing = index_;
END|

 /*При продаже товара заносит информацию о продаже в таблицу «История продаж»,
 изменяет количество товаров в таблице товаров
 и заносить в таблицу "Последняя единица", если товар остался в единичном экземпляре
  */
DELIMITER |
CREATE PROCEDURE Register_new_sale()
BEGIN
INSERT INTO history_sales(id_thing, amount_sale, final_price, id_client, id_employee)
    VALUES (NEW.id_thing, NEW.amount_sale, NEW.final_price, NEW.id_client, NEW.id_employee);
    UPDATE things SET amount_thing = amount_thing - NEW.amount_sale WHERE id_thing = NEW.id_thing;
    SET @amount_ = SELECT amount_thing FROM things WHERE id_thing = NEW.id_thing;
    IF (@amount_ = 1) THEN
        INSERT INTO last_thing(id_thing) VALUE (NEW.id_thing);
        #SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Товар добавлен в таблицу "Последняя единица"';
    ELSE IF (@amount_ < 1) THEN
        INSERT INTO archive_things(id_thing) VALUE (NEW.id_thing);
        #SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Товар добавлен в таблицу "Архив товаров"';
    END IF;
END|


DELIMITER |
CREATE PROCEDURE check_things_() #поиск и проверка наличия товара в таблицах
BEGIN

END|

DELIMITER |
CREATE PROCEDURE check_things_() #поиск и проверка наличия товара в таблицах
BEGIN

END|