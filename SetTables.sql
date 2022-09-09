CREATE TABLE human(#таблица людей
    id_human INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,#имя
    last_name VARCHAR(255) NOT NULL,#фамилия
    patronymic VARCHAR(255),#отчество
    gender VARCHAR(8) NOT NULL,#пол
    is_deleted BOOL #удален ли
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
  FOREIGN KEY (id_human) REFERENCES human(id_human)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
);

CREATE TABLE manufacturer(#произзвлдитель
  id_manufacturer INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name_manufacturer TEXT NOT NULL
);

CREATE TABLE things(#товары
  id_thing INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name_thing VARCHAR(100) NOT NULL,
  type_thing VARCHAR(100) NOT NULL,
  amount_thing INT NOT NULL,
  id_manufacturer INTEGER NOT NULL,
  FOREIGN KEY (id_manufacturer) REFERENCES manufacturer(id_manufacturer)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
);

CREATE TABLE cost_price(#себестоимость
  id_cost_price INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  id_thing INT NOT NULL,
  cost_price_thing DOUBLE NOT NULL,
  FOREIGN KEY (id_thing) REFERENCES things(id_thing)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
);

CREATE TABLE selling_price(#цена продажи
  id_selling_price INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  id_cost_price INTEGER NOT NULL,
  selling_price_thing DOUBLE NOT NULL,
  FOREIGN KEY (id_cost_price) REFERENCES cost_price(id_cost_price)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
);

CREATE TABLE amount_thing(#количество товара
    id_amount INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_thing INT NOT NULL,
    amount INT NOT NULL,
    FOREIGN KEY (id_thing) REFERENCES things(id_thing)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
);

CREATE TABLE history_sales(#история продаж
  id_sale INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  id_thing INT NOT NULL,
  data_sale DATE NOT NULL,#дата продажи
  amount_sale INT NOT NULL,#количество куплено
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
    id_amount INT NOT NULL,
    FOREIGN KEY (id_thing) REFERENCES things(id_thing)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION,
    FOREIGN KEY (id_amount) REFERENCES amount_thing(id_amount)
                      ON UPDATE NO ACTION
                      ON DELETE NO ACTION
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