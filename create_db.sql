CREATE SCHEMA sport_shop_db;

DROP TABLE table_employee_archive;
DROP TABLE table_procurements;
DROP TABLE table_last_items;
DROP TABLE table_receipt_items;
DROP TABLE table_order_items;
DROP TABLE table_all_sales;
DROP TABLE table_orders;
DROP TABLE table_receipts;
DROP TABLE table_products;
DROP TABLE table_product_types;
DROP TABLE table_companies;
DROP TABLE table_clients;
DROP TABLE table_employee;
DROP TABLE table_positions;
DROP TABLE table_persons;
DROP TABLE table_genders;


-- tables for employee and clients
CREATE TABLE table_genders(
    gender_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    gender CHAR(7) NOT NULL
);

CREATE TABLE table_persons(
    person_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender_id INT NOT NULL,
    FOREIGN KEY (gender_id) REFERENCES table_genders (gender_id)
);

CREATE TABLE table_positions(
    position_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    position VARCHAR(255) NOT NULL,
    salary DOUBLE NOT NULL
);

CREATE TABLE table_employee(
    employee_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    position_id INT NOT NULL,
    bonus DOUBLE,
    date_of_employment DATE NOT NULL,
    is_working BOOL DEFAULT TRUE,
    FOREIGN KEY (person_id) REFERENCES table_persons (person_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (position_id) REFERENCES table_positions (position_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE table_employee_archive(
    employee_archive_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    date_of_firing DATE NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES table_employee(employee_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE table_clients(
    client_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    e_mail VARCHAR(100) NOT NULL,
    phone VARCHAR(12) NOT NULL,
    discount INT,
    is_subscribed BOOL DEFAULT FALSE,
    FOREIGN KEY (person_id) REFERENCES table_persons (person_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- tables for products
CREATE TABLE table_companies(
    company_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    company_name TEXT NOT NULL,
    contact_info TEXT NOT NULL,
    is_cooperating BOOL DEFAULT TRUE
);

CREATE TABLE table_product_types(
    product_type_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    product_type VARCHAR(255) NOT NULL
);

CREATE TABLE table_products(
    product_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    product_name TEXT NOT NULL,
    product_type_id INT NOT NULL,
    company_id INT NOT NULL,
    amount INT NOT NULL,
    defective_amount INT DEFAULT 0,
    sell_price DOUBLE NOT NULL,
    is_sold_out BOOL DEFAULT FALSE,
    FOREIGN KEY (product_type_id) REFERENCES table_product_types (product_type_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (company_id) REFERENCES table_companies (company_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE table_procurements(
    procurement_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    date_of_procurement DATE NOT NULL,
    company_id INT NOT NULL,
    product_id INT NOT NULL,
    amount INT NOT NULL,
    cost_price DOUBLE NOT NULL,
    FOREIGN KEY (company_id) REFERENCES table_companies (company_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (product_id) REFERENCES table_products (product_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE table_last_items(
    last_item_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    new_price DOUBLE,
    FOREIGN KEY (product_id) REFERENCES table_products (product_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);


-- tables for sales
CREATE TABLE table_receipts(
    receipt_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    date_of_deal DATETIME,
    salesman_id INT NOT NULL,
    client_id INT,
    total_items INT,
    total_price DOUBLE,
    discount INT,
    client_card_is_scanned BOOL DEFAULT FALSE,
    is_paid BOOL DEFAULT FALSE,
    is_refunded BOOL DEFAULT FALSE,
    FOREIGN KEY (salesman_id) REFERENCES table_employee (employee_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (client_id) REFERENCES table_clients (client_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE table_receipt_items(
    receipt_item_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    receipt_id INT NOT NULL,
    product_id INT NOT NULL,
    amount INT NOT NULL,
    FOREIGN KEY (receipt_id) REFERENCES table_receipts (receipt_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (product_id) REFERENCES table_products (product_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE table_orders(
    order_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    date_of_order DATETIME,
    total_items INT,
    total_price DOUBLE,
    discount INT,
    is_confirmed BOOL DEFAULT FALSE,
    is_paid BOOL DEFAULT FALSE,
    is_refunded BOOL DEFAULT FALSE,
    FOREIGN KEY (client_id) REFERENCES table_clients (client_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE table_order_items(
    order_item_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    amount INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES table_orders (order_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (product_id) REFERENCES table_products (product_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE table_all_sales(
    sale_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    receipt_id INT,
    order_id INT,
    FOREIGN KEY (receipt_id) REFERENCES table_receipts (receipt_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (order_id) REFERENCES table_orders (order_id)
    ON DELETE NO ACTION ON UPDATE NO ACTION
);