

CREATE SCHEMA  myshop_db;

CREATE TABLE  producing
(
    producing_firm_id    INT  NOT NULL PRIMARY KEY AUTO_INCREMENT,
    producing_firm   TEXT NOT  NULL,
    producing_country  TEXT NOT  NULL
);

CREATE TABLE  products (
    product_id INT NOT NULL PRIMARY KEY  AUTO_INCREMENT,
    product_name TEXT NOT NULL,
    manufacturer INT  NOT NULL,
    FOREIGN KEY (manufacturer)  REFERENCES producing (producing_firm_id)
);

CREATE TABLE  current_products (
    current_product INT NOT NULL PRIMARY KEY,
    product_count INT NULL,
    product_cost_price_today DOUBLE NULL,
    product_sell_price_today DOUBLE NULL,
    FOREIGN KEY (current_product)  REFERENCES products (product_id)
);

CREATE TABLE  sex
(
    sex_id  INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    sex  TEXT NOT NULL
);

CREATE TABLE  employees (
    employee_id INT NOT NULL PRIMARY KEY  AUTO_INCREMENT,
    employee_fio TEXT NOT NULL,
    sex_employee int NOT NULL,
    employment_date DATE NOT NULL,
    dismissal_date DATE  NULL,
    FOREIGN KEY (sex_employee)  REFERENCES sex (sex_id)
);

CREATE TABLE  posts
(
    post_id  INT NOT  NULL PRIMARY KEY AUTO_INCREMENT,
    post   TEXT NOT NULL,
    salary double  NULL,
    employee INT NOT NULL,
    FOREIGN KEY (employee)  REFERENCES employees (employee_id)
);


CREATE TABLE  buyers (
    buyer_id    INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    buyer_fio   TEXT NOT NULL,
    sex_buyer   int NOT NULL,
    buyer_phone TEXT  NULL,
    buyer_mail  TEXT  NULL,
    subscribing BOOL NOT NULL,
    FOREIGN KEY (sex_buyer)  REFERENCES sex (sex_id)
);

CREATE TABLE  discounts
(
    discount_id   INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    discount   DOUBLE  NULL
);

CREATE TABLE  sold_products (
    leaving_time_id INT  NOT NULL PRIMARY KEY  AUTO_INCREMENT,
    leaving_time TIMESTAMP NOT NULL,
    sold_product INT NOT NULL,
    seller INT NOT NULL,
    happy_buyer INT NOT NULL,
    buyer_discount INT NOT NULL,
    selling_price DOUBLE NULL,
    count_sold INT NULL,
    internet BOOL NOT NULL,
    FOREIGN KEY (sold_product) REFERENCES products (product_id),
    FOREIGN KEY (seller) REFERENCES products (product_id),
    FOREIGN KEY (happy_buyer) REFERENCES buyers (buyer_id),
    FOREIGN KEY (buyer_discount) REFERENCES discounts (discount_id)
);

CREATE TABLE  last_item(
last_item_product INT NOT NULL PRIMARY KEY,
FOREIGN KEY (last_item_product) REFERENCES current_products (current_product)
);

INSERT INTO producing (producing_firm, producing_country)
VALUES ('sport','russia'),
       ('adidas','china'),
       ('nike','vietnam'),
       ('puma','india');


INSERT INTO products (product_name, manufacturer)
VALUES ('boots', 1),
       ('suit', 1),
       ('t-shirt', 4),
       ('trousers', 2),
       ('sneakers', 3);

INSERT INTO current_products (current_product, product_count, product_cost_price_today, product_sell_price_today)
VALUES (1, 10, 2000, 2500),
       (2, 15, 1800, 2250),
       (3, 50, 300, 370),
       (4, 35, 1000, 1600),
       (5, 23, 3000, 4000);

INSERT INTO sex (sex) VALUES ('man'), ('woman');

INSERT INTO employees(employee_fio, sex_employee, employment_date, dismissal_date )
VALUES ('Старинин Андрей', 1, '01.01.2012', '00.00.00'),
       ('Калистратов Тимур', 1, '10.07.2021', '00.00.00'),
       ('Кондарев Антон', 1, '14.02.2018','11.05.2022'),
       ('Рубо Галина', 2, '22.10.2015', '00.00.00');

INSERT INTO posts(post, salary, employee)
VALUES ('boss', 200000,1),
       ('seller1', 80000,2),
       ('seller2', 60000,4),
       ('storekeeper', 60000,3),
       ('accountant', 20000,4);


INSERT INTO buyers(buyer_fio, sex_buyer, buyer_phone, buyer_mail, subscribing)
VALUES ('Дюмин Назар',1, 88001001010, 'dz@mail.ru', TRUE),
       ('Сырцов Евгений',1, 88002002020, 'se@mail.ru', TRUE),
       ('Харитоненко Михаил',1, 88003003030, 'hm@mail.ru', TRUE),
       ('Анкушин Алексей',1, 88004004040, 'aa@mail.ru', FALSE),
       ('Каракич Роман',1, 88005005050, 'kr@mail.ru', FALSE);

INSERT INTO discounts(discount)
VALUE (0.05),(0.1),(0.15),(0.2);

INSERT INTO sold_products (leaving_time,sold_product, seller, happy_buyer, buyer_discount, selling_price, count_sold, internet)
VALUE  ('22.10.10.10.12.30',1,2,2,1,2300,1,FALSE),
       ('22.10.10.13.10.15',2,2,1,1,2250,1,FALSE),
       ('20.10.05.12.05.23',3,4,1,2,370,2,TRUE),
       ('22.10.03.16.03.20',3,2,3,2,350,2,TRUE),
       ('22.10.01.17.05.22',4,4,4,3,1600,1,FALSE),
       ('22.10.05.12.05.23',2,4,1,2,2250,1,TRUE),
       ('22.10.03.16.03.20',1,2,3,2,2300,1,TRUE),
       ('22.10.04.11.01.00',5,2,5,4,4000,1,TRUE);



