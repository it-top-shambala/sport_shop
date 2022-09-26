  #проверяет наличие товара на складе и изменяет количество
CREATE TRIGGER check_things
    BEFORE INSERT ON things
    FOR EACH ROW
    SET @index_check = CALL Check_things();
    IF(@index_check) THEN CALL Change_amount_thing(@index_check);
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

  #проверка, зарегистрирован ли покупатель
CREATE TRIGGER set_clients
    BEFORE INSERT ON clients
    FOR EACH ROW
    IF(NEW.id_human = id_human AND NEW.email = email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The client is already registered';
    ELSE
        INSERT INTO clients (id_human, email, phone, discount, newsletter_sub, is_deleted)
            VALUE (NEW.id_human, NEW.email, NEW.phone,
                   NEW.discount, NEW.newsletter_sub, NEW.is_deleted);
    END IF;

  #запрет на удаление существующих клиентов
CREATE TRIGGER ban_deletion_client
    BEFORE DELETE ON clients
    FOR EACH ROW
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Удаление запрещено';

  #запрет на удаление сотрудников, принятых на работу до 2015г.
CREATE TRIGGER ban_deletion_employee
    BEFORE DELETE ON employees
    FOR EACH ROW
      IF ((SELECT date_employment FROM employees WHERE id_employee = NEW.id_employee) < '01.01.2015')
      THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Удаление запрещено';
      END IF;

  #запрет на добавление фирмы "Спорт, солнце и штанга"
CREATE TRIGGER ban_insert_manufacture
    BEFORE INSERT ON manufacturer
    FOR EACH ROW
    IF (NEW.name_manufacturer = 'Спорт, солнце и штанга') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Добавление производителя запрещено';
    END IF;

  #При продаже товара заносит информацию о продаже в таблицу «История продаж»
CREATE TRIGGER check_amount_employees
    BEFORE INSERT ON employees
    FOR EACH ROW
    IF ((SELECT COUNT(1) FROM employees WHERE id_employee = 1) >= 6) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Добавление продавца запрещено';
    END IF;

