

CREATE SCHEMA  myshop_db;

CREATE TABLE  producing_countries
(
    producing_country_id    INT  NOT NULL PRIMARY KEY AUTO_INCREMENT,
    producing_country   TEXT NOT  NULL
);

CREATE TABLE  products (
    product_id INT NOT NULL PRIMARY KEY  AUTO_INCREMENT,
    product_name TEXT NOT NULL,
    producing_country_id INT NOT NULL
);

CREATE TABLE  current_products (
    product_id INT NOT NULL,
    product_count INT NULL,
    product_cost_price_today DOUBLE NULL,
    product_sell_price_today DOUBLE NULL
);

CREATE TABLE  sex
(
    sex_id  INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    sex  TEXT NOT NULL
);

CREATE TABLE  employees (
    employee_id INT NOT NULL PRIMARY KEY  AUTO_INCREMENT,
    employee_fio TEXT NOT NULL,
    sex_id int NOT NULL,
    employment_date DATE NOT NULL,
    dismissal_date DATE  NULL
);

CREATE TABLE  posts
(
    post_id  INT NOT  NULL PRIMARY KEY AUTO_INCREMENT,
    post   TEXT NOT NULL,
    salary double  NULL,
    employee_id INT NOT NULL
);

CREATE TABLE  subscribing
(
    subscribing_id    INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    subscribing   BOOL  NOT NULL
);

CREATE TABLE  buyers (
    buyer_id    INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    buyer_fio   TEXT NOT NULL,
    buyer_phone TEXT  NULL,
    buyer_mail  TEXT  NULL,
    subscribing_id  INT NOT NULL
);

CREATE TABLE  discounts
(
    discount_id   INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    discount   DOUBLE  NULL
);

CREATE TABLE  sold_products (
    product_id INT NOT NULL,
    employee_id INT NOT NULL,
    buyer_id INT NOT NULL,
    discount_id INT NOT NULL,
    selling_price DOUBLE NULL,
    count_sold INT NULL,
    selling_date DATE NOT NULL
);

INSERT INTO producing_countries (producing_country)
VALUES ('russia'),
       ('china'),
       ('vietnam'),
       ('india');


INSERT INTO products (product_name, producing_country_id)
VALUES ('boots', 1),
       ('suit', 1),
       ('t-shirt', 4),
       ('trousers', 2),
       ('sneakers', 3);

INSERT INTO current_products (product_id, product_count, product_cost_price_today, product_sell_price_today)
VALUES (1, 10, 2000, 2500),
       (2, 15, 1800, 2250),
       (3, 50, 300, 370),
       (4, 35, 1000, 1600),
       (5, 23, 3000, 4000);

INSERT INTO sex (sex) VALUES ('man'), ('woman');

INSERT INTO employees(employee_fio, sex_id, employment_date, dismissal_date )
VALUES ('Старинин Андрей', 1, '01.01.2012', '00.00.00'),
       ('Калистратов Тимур', 1, '10.07.2021', '00.00.00'),
       ('Кондарев Антон', 1, '14.02.2018','11.05.2022'),
       ('Рубо Галина', 2, '22.10.2015', '00.00.00');

INSERT INTO posts(post, salary, employee_id)
VALUES ('boss', 200000, 1),
       ('seller', 80000, 2),
       ('seller', 60000, 4),
       ('storekeeper', 60000, 3),
       ('accountant', 20000, 4);

INSERT INTO subscribing(subscribing)
VALUES (TRUE), (FALSE);

INSERT INTO buyers(buyer_fio, buyer_phone, buyer_mail, subscribing_id)
VALUES ('Дюмин Назар', 88001001010, 'dz@mail.ru', 1),
       ('Сырцов Евгений', 88002002020, 'se@mail.ru', 1),
       ('Харитоненко Михаил', 88003003030, 'hm@mail.ru', 1),
       ('Анкушин Алексей', 88004004040, 'aa@mail.ru', 2),
       ('Каракич Роман', 88005005050, 'kr@mail.ru', 2);

INSERT INTO discounts(discount)
VALUE (0.05),(0.1),(0.15),(0.2);

INSERT INTO sold_products (product_id, employee_id, buyer_id, discount_id, selling_price, count_sold, selling_date)
VALUE  (1,2,2,1,2300,1,'10.10.2022'),
       (2,2,1,1,2250,1,'10.10.2022'),
       (3,4,1,2,370,2,'05.10.2022'),
       (3,2,3,2,350,2,'03.10.2022'),
       (4,4,4,3,1600,1,'01.10.2022'),
       (5,2,5,4,4000,1,'08.10.2022');



