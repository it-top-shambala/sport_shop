DELIMITER |
CREATE PROCEDURE Check_things(OUT @index_ INT) #поиск и проверка наличия товара в таблицах
BEGIN
    SET index_ = SELECT id_thing FROM things
    WHERE name_thing = NEW.name_thing AND id_type_thing = NEW.id_type_thing
       AND cost_price = NEW.cost_price AND selling_price = NEW.selling_price
       AND id_manufacturer = NEW.id_manufacturer;
END|

DELIMITER |
CREATE PROCEDURE Change_amount_thing(IN index_ INT) #изменение количества товара по id
BEGIN
   UPDATE things SET amount_thing = NEW.amount_thing WHERE id_thing = index_;
END|

DELIMITER |
CREATE PROCEDURE check_things_() #поиск и проверка наличия товара в таблицах
BEGIN

END|

DELIMITER |
CREATE PROCEDURE check_things_() #поиск и проверка наличия товара в таблицах
BEGIN

END|

DELIMITER |
CREATE PROCEDURE check_things_() #поиск и проверка наличия товара в таблицах
BEGIN

END|