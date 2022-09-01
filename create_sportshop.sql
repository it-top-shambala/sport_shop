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

CREATE TABLE Company(
    company_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(125) NOT NULL,
    company_location VARCHAR(125) NOT NULL,
    is_delete_company BOOL DEFAULT FALSE
);

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
    employees_company_id INT NOT NULL,
    is_delete BOOL DEFAULT FALSE,
    FOREIGN KEY(employees_company_id) REFERENCES Company(company_id)
            ON UPDATE NO ACTION
            ON DELETE NO ACTION
);
/*EMPLOYESS CREATE TABLE*/

CREATE TABLE client_phones(
    phones_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    phone_number VARCHAR(100) NOT NULL,
    is_delete_client_phones BOOL DEFAULT FALSE
);
CREATE TABLE history_orders(
    history_orders_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    history_order VARCHAR(100) NOT NULL,
    order_date DATE,
    is_delete_history_orders BOOL DEFAULT FALSE
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
    is_delete_client BOOL DEFAULT FALSE,
    CONSTRAINT FOREIGN KEY (client_phones_id) REFERENCES client_phones(phones_id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (client_history_orders_id) REFERENCES history_orders(history_orders_id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

CREATE VIEW vw_client
AS SELECT *
FROM client
INNER JOIN history_orders h_orders on client.client_id = h_orders.history_orders_id
INNER JOIN client_phones client_p on client.client_phones_id = client_p.phones_id
WHERE client.is_delete_client = FALSE AND h_orders.is_delete_history_orders = FALSE AND client_p.is_delete_client_phones = false;

SELECT phones_id AS id,phone_number AS number
FROM client_phones ORDER BY phone_number;


SELECT * FROM vw_client;
/*INSERTION FAKE DATA TO client*/
INSERT INTO client_phones(phone_number)VALUE('54645');
INSERT INTO history_orders(history_order,order_date) VALUE ('5464545',NOW());
INSERT INTO client(client_FirstName, client_LastName, client_patronymic, client_email,client_discounts,client_phones_id,client_history_orders_id)
VALUES('TEST3','TESTGUY3','SOMETESTGUY3','SOMETESTGUY@GMAIL.COM3',5445,1,1);

DELETE FROM client_phones WHERE phones_id = 1;