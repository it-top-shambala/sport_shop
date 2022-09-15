CREATE TRIGGER check_things #проверяет наличие товара на складе и изменяет количество
    BEFORE INSERT ON things
    FOR EACH ROW
    SET @index_check = Check_things();
    IF(@index_check) THEN Change_amount_thing(@index_check);
    ELSE
         INSERT INTO things( name_thing, id_type_thing, cost_price, selling_price,
                            amount_thing, id_manufacturer, is_deleted)
         VALUE (NEW.name_thing, NEW.id_type_thing, NEW.cost_price, NEW.selling_price,
                            NEW.amount_thing, NEW.id_manufacturer, NEW.is_deleted);

