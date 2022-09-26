CREATE TABLE human(#таблица людей
    id_human INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,#имя
    last_name VARCHAR(255) NOT NULL,#фамилия
    patronymic VARCHAR(255),#отчество
    gender VARCHAR(8) NOT NULL#пол
);

CREATE TABLE job_title(#таблица должностей
    id_title INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title_name VARCHAR(100) NOT NULL,#наименование должности
    salary DOUBLE NOT NULL #заработная плата
);

CREATE TABLE employees(#сотрудники
  id_employee INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  id_human INT NOT NULL,
  id_title INT NOT NULL,
  date_employment DATE NOT NULL, #дата трудоустройства
  is_deleted BOOL NOT NULL DEFAULT FALSE, #удален ли
  FOREIGN KEY (id_human) REFERENCES human(id_human)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION,
  FOREIGN KEY (id_title) REFERENCES job_title(id_title)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
);

CREATE TABLE clients(#клиенты
  id_client INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  id_human INT NOT NULL,
  email TEXT,
  phone VARCHAR(15) NOT NULL,
  discount INT,
  newsletter_sub BOOL,#подписка на рассылку
  is_deleted BOOL NOT NULL DEFAULT FALSE, #удален ли
  FOREIGN KEY (id_human) REFERENCES human(id_human)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
);

CREATE TABLE manufacturer(#произзвлдитель
  id_manufacturer INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name_manufacturer TEXT NOT NULL
);

CREATE TABLE type_thing(#тип товара
    id_type_thing INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(100) NOT NULL
);

CREATE TABLE things(#товары
  id_thing INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name_thing VARCHAR(100) NOT NULL,
  id_type_thing INT NOT NULL,
  cost_price DOUBLE NOT NULL,
  selling_price DOUBLE NOT NULL,
  amount_thing INT NOT NULL,
  id_manufacturer INTEGER NOT NULL,
  is_deleted BOOL NOT NULL DEFAULT FALSE, #удален ли
  FOREIGN KEY (id_manufacturer) REFERENCES manufacturer(id_manufacturer)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION,
  FOREIGN KEY (id_type_thing) REFERENCES type_thing(id_type_thing)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
);

CREATE TABLE history_sales(#история продаж
  id_sale INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  id_thing INT NOT NULL,
  data_sale DATETIME NOT NULL DEFAULT NOW(), #дата и время продажи продажи
  amount_sale INT NOT NULL,#количество куплено
  final_price DOUBLE NOT NULL,
  id_client INT,
  id_employee INT NOT NULL,
  FOREIGN KEY (id_thing) REFERENCES things(id_thing)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION,
  FOREIGN KEY (id_client) REFERENCES clients(id_client)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION,
  FOREIGN KEY (id_employee) REFERENCES employees(id_employee)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
);

CREATE TABLE last_thing(#последняя единица
    id_last_thing INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_thing INT NOT NULL,
   # amount_thing INT NOT NULL,
    FOREIGN KEY (id_thing) REFERENCES things(id_thing)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
   /* FOREIGN KEY (amount_thing) REFERENCES things(amount_thing)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION*/
);

CREATE TABLE archive_employees(#архив сотрудников
    id_deleted_employee INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_employee INT NOT NULL,
    FOREIGN KEY (id_employee) REFERENCES employees(id_employee)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
);

CREATE TABLE archive_things(#архив проданых товаров
    id_deleted_thing INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_thing INT NOT NULL,
    FOREIGN KEY (id_thing) REFERENCES things(id_thing)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
);

INSERT INTO job_title(title_name, salary)
VALUES ('Продавец', 10000),
       ('Менеджер', 20000),
       ('Управляющий', 30000);

INSERT INTO human(gender, first_name, last_name, patronymic)
VALUES ('мужской', 'John', 'Johnson', NULL),
       ('женский', 'Iren','Adler', NULL),
       ('мужской', 'Абрахам','Жванецки', NULL),
       ('мужской','Виктор', 'Викторов','Викторович'),
       ('женский', 'Анна','Петрова','Ивановна'),
       ('мужской', 'Иван','Иванов','Иванович'),
       ('женский', 'Мария','Игнатьева','Павловна'),
       ('женский', 'Ольга','Мухамор','Александровна'),
       ('женский', 'Vengera','Puaro','Alloiza'),
       ('мужской', 'Петр','Горбунков','Петрович'),
       ('женский', 'Матильда','Вишневская','Жоановна');

INSERT INTO clients(id_human, email, phone, discount, newsletter_sub)
VALUES (1,'flip-flap@mail.ru','45-25-42', 0, 0),
       (6, NULL,'35-74-17', 15, 0),
       (7,'amnezia@dostala.org','857-27-27', 0, 1),
       (10,'inogorodnay@ya.com','89123432497', 5, 0),
       (11,'matilda@rulit.net','89505603475', 0, 1);