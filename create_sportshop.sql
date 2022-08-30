CREATE TABLE goods(
    goods_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    goods_name VARCHAR(100) NOT NULL,
    goods_type VARCHAR(100) NOT NULL,
    goods_amount INT NOT NULL,
    goods_manufacturer VARCHAR(100) NOT NULL,
    goods_price INT NOT NULL
);
/*GOOD TABLE INSERT*/
CREATE TABLE goods_sales_performed(
    goods_sales_performed_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    performed_name VARCHAR(100) NOT NULL,
    performed_date DATE,
    is_delete BOOL DEFAULT FALSE
);
CREATE TABLE goods_buyer_performed(
    goods_buyer_performed_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    performed_name VARCHAR(100) NOT NULL,
    performed_date DATE,
    is_delete BOOL DEFAULT FALSE
);
CREATE TABLE goods_sales(
    goods_sales_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    goods_sales_firstName VARCHAR(100) NOT NULL,
    goods_sales_lastName VARCHAR(100) NOT NULL,
    goods_sales_performed_id INT NOT NULL,
    is_delete BOOL DEFAULT FALSE,
    CONSTRAINT FOREIGN KEY (goods_sales_performed_id) REFERENCES goods_sales_performed(goods_sales_performed_id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);
CREATE TABLE goods_buyer(
    goods_buyer_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    goods_buyer_firstName VARCHAR(100) NOT NULL,
    goods_buyer_lastName VARCHAR(100) NOT NULL,
    goods_buyer_performed_id INT NOT NULL,
    is_delete BOOL DEFAULT FALSE,
    CONSTRAINT FOREIGN KEY (goods_buyer_performed_id) REFERENCES goods_buyer_performed(goods_buyer_performed_id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);
CREATE TABLE sales(
    sales_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    sales_name VARCHAR(125) NOT NULL,
    sales_price INT NOT NULL,
    sales_amount INT NOT NULL,
    sales_date DATE,
    goods_sales_id INT NOT NULL,
    goods_buyer_id INT NOT NULL,
    is_delete BOOL DEFAULT FALSE,
    CONSTRAINT FOREIGN KEY (goods_sales_id) REFERENCES goods_sales(goods_sales_id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (goods_buyer_id) REFERENCES goods_buyer(goods_buyer_id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);
/*GOOD TABLE INSERT*/
/*EMPLOYESS CREATE TABLE*/
CREATE TABLE employees(
    employees_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    employees_FirstName VARCHAR(100) NOT NULL,
    employees_LastName VARCHAR(100) NOT NULL,
    employees_patronymic VARCHAR(100),
    employees_position VARCHAR(100) NOT NULL,
    employees_date_of_receipt DATE,
    employees_gender VARCHAR(30) NOT NULL,
    employees_salary INT NOT NULL,
    is_delete BOOL DEFAULT FALSE
);
/*EMPLOYESS CREATE TABLE*/

CREATE TABLE client_phones(
    client_phones_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    phone_number VARCHAR(100) NOT NULL,
    is_delete BOOL DEFAULT FALSE
);
CREATE TABLE history_orders(
    history_orders_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    history_order VARCHAR(100) NOT NULL,
    order_date DATE,
    is_delete BOOL DEFAULT FALSE
);
CREATE TABLE client(
    client_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    client_FirstName VARCHAR(100) NOT NULL,
    client_LastName VARCHAR(100) NOT NULL,
    client_patronymic VARCHAR(100),
    client_email VARCHAR(100) NOT NULL,
    client_phones_id INT NOT NULL,
    client_history_orders_id INT NOT NULL,
    client_discounts INT NOT NULL,
    is_subscribe BOOL DEFAULT FALSE,
    is_delete BOOL DEFAULT FALSE,
    CONSTRAINT FOREIGN KEY (client_phones_id) REFERENCES client_phones(client_phones_id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (client_history_orders_id) REFERENCES history_orders(history_orders_id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);