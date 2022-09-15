  #проверяет наличие товара на складе и изменяет количество
CREATE TRIGGER check_things
    BEFORE INSERT ON things
    FOR EACH ROW
    SET @index_check = Check_things();
    IF(@index_check) THEN Change_amount_thing(@index_check);
    ELSE
         INSERT INTO things( name_thing, id_type_thing, cost_price, selling_price,
                            amount_thing, id_manufacturer)
         VALUE (NEW.name_thing, NEW.id_type_thing, NEW.cost_price, NEW.selling_price,
                            NEW.amount_thing, NEW.id_manufacturer);
    END IF;

  #добавляет запись об уволенном сотруднике в Архив сотрудников
CREATE TRIGGER employee_delete
    AFTER UPDATE ON things
    FOR EACH ROW
    IF (is_deleted = true) THEN
        INSERT INTO archive_employees(id_employee)
            VALUE (id_employee);
    END IF;