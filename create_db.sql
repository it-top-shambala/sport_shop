CREATE SCHEMA sport_shop_db;

DROP TABLE table_manufacturers;
DROP TABLE table_product_types;
DROP TABLE table_products;
DROP TABLE table_genders;
DROP TABLE table_positions;
DROP TABLE table_employee;
DROP TABLE table_clients;
DROP TABLE table_orders;
DROP TABLE table_deals;
DROP TABLE table_deals_backup;
DROP TABLE table_products_archive;
DROP TABLE table_products_last_item;


CREATE TABLE table_manufacturers(
    manufacturer_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    manufacturer TEXT NOT NULL
);

CREATE TABLE table_product_types(
    product_type_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    product_type VARCHAR(255) NOT NULL
);

CREATE TABLE table_products(
    product_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    product_name TEXT NOT NULL,
    product_type INT NOT NULL,
    FOREIGN KEY (product_type) REFERENCES table_product_types (product_type_id),
    manufacturer INT NOT NULL,
    FOREIGN KEY (manufacturer) REFERENCES table_manufacturers (manufacturer_id),
    amount INT NOT NULL,
    cost_price FLOAT NOT NULL,
    sell_price FLOAT NOT NULL
);

CREATE TABLE table_genders(
    gender_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    gender CHAR(7) NOT NULL
);

CREATE TABLE table_positions(
    position_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    position VARCHAR(255) NOT NULL
);

CREATE TABLE table_employee(
    employee_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender INT NOT NULL,
    FOREIGN KEY (gender) REFERENCES table_genders (gender_id),
    position INT NOT NULL,
    FOREIGN KEY (position) REFERENCES table_positions (position_id),
    date_of_employment DATE NOT NULL,
    salary FLOAT NOT NULL,
    is_working BOOL DEFAULT TRUE
);

CREATE TABLE table_clients(
    client_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender INT NOT NULL,
    FOREIGN KEY (gender) REFERENCES table_genders (gender_id),
    e_mail VARCHAR(255) NOT NULL,
    phone VARCHAR(12) NOT NULL,
    discount INT,
    is_subscribed BOOL DEFAULT FALSE
);

CREATE TABLE table_orders(
    order_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES table_clients (client_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES table_products(product_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    amount INT NOT NULL,
    price FLOAT NOT NULL,
    date_of_purchase DATE NOT NULL
);

CREATE TABLE table_deals(
    deal_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES table_products(product_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES table_clients (client_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    salesman_id INT NOT NULL,
    FOREIGN KEY (salesman_id) REFERENCES table_employee (employee_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    amount INT NOT NULL,
    price FLOAT NOT NULL,
    date_of_deal DATE NOT NULL
);

CREATE TABLE table_deals_backup(
    deal_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES table_products(product_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES table_clients (client_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    salesman_id INT NOT NULL,
    FOREIGN KEY (salesman_id) REFERENCES table_employee (employee_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    amount INT NOT NULL,
    price FLOAT NOT NULL,
    date_of_deal DATE NOT NULL
);

CREATE TABLE table_products_archive(
    product_archive_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES table_products(product_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE TABLE table_products_last_item(
    product_last_item_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES table_products(product_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

CREATE TABLE table_employee_archive(
    employee_archive_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES table_employee(employee_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);