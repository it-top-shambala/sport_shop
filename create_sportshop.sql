CREATE TABLE goods_type(
    Id INT PRIMARY KEY AUTO_INCREMENT,
    goods_type_name VARCHAR(100) NOT NULL,
    is_delete BOOL DEFAULT FALSE
);
CREATE TABLE goods_manufacturer(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    goods_manufacturer_name VARCHAR(100) NOT NULL,
    goods_manufacturer_location VARCHAR(100) NOT NULL,
    is_delete BOOL DEFAULT FALSE
);

CREATE TABLE goods(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    goods_name VARCHAR(100) NOT NULL,
    goods_type_id INT NOT NULL,
    goods_manufacturer_id INT NOT NULL,
    goods_amount INT NOT NULL,
    goods_cost_price INT NOT NULL,
    goods_sales_price INT NOT NULL,
    is_delete BOOL DEFAULT FALSE,
    CONSTRAINT FOREIGN KEY (goods_type_id) REFERENCES goods_type(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (goods_manufacturer_id) REFERENCES goods_manufacturer(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION

);

CREATE TABLE Gender(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    gender_name VARCHAR(40) NOT NULL,
    is_delete BOOL DEFAULT FALSE
);

CREATE TABLE Person(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    patronymic VARCHAR(100) NULL,
    age INT NOT NULL,
    gender_id INT NOT NULL,
    is_delete BOOL DEFAULT FALSE,
    CONSTRAINT FOREIGN KEY (gender_id) REFERENCES Gender(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

CREATE TABLE performerd_sales(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    performed_sales_name VARCHAR(100) NOT NULL,
    performed_sales_date DATETIME NOT NULL,
    is_delete BOOL DEFAULT FALSE
);

CREATE TABLE goods_seller(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    is_delete BOOL DEFAULT FALSE,
    performed_sales_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (person_id) REFERENCES Person(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (performed_sales_id) REFERENCES performerd_sales(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

CREATE TABLE performerd_buys(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    performed_buys VARCHAR(100) NOT NULL,
    performed_buys_date DATETIME NOT NULL,
    is_delete BOOL DEFAULT FALSE
);

CREATE TABLE goods_buyer(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    performed_buys_id INT NOT NULL,
    is_delete BOOL DEFAULT FALSE,
    CONSTRAINT FOREIGN KEY (person_id) REFERENCES Person(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (performed_buys_id) REFERENCES performerd_buys(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

CREATE TABLE goods_sales(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    sales_price INT NOT NULL,
    sales_amount INT NOT NULL,
    sales_date DATETIME NOT NULL,
    saled_goods_id INT NOT NULL,
    goods_seller_id INT NOT NULL,
    goods_buyer_id INT NOT NULL,
    is_delete BOOL DEFAULT FALSE,
    CONSTRAINT FOREIGN KEY (saled_goods_id) REFERENCES goods(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (goods_seller_id) REFERENCES goods_seller(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (goods_buyer_id) REFERENCES goods_buyer(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

CREATE TABLE table_jobs_employees(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    job_title VARCHAR(100) NOT NULL,
    is_delete BOOL DEFAULT FALSE
);

CREATE TABLE employee(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    employee_job_id INT NOT NULL,
    employment_date DATETIME NOT NULL,
    salary INT NOT NULL,
    is_delete BOOL DEFAULT FALSE,
    CONSTRAINT FOREIGN KEY (person_id) REFERENCES Person(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (employee_job_id) REFERENCES table_jobs_employees(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);
CREATE TABLE client_history(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    performed_name VARCHAR(100) NOT NULL,
    is_delete BOOL DEFAULT FALSE
);
CREATE TABLE Client(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    email VARCHAR(100) NOT NULL,
    client_contact VARCHAR(100) NOT NULL,
    discount INT NULL,
    is_subscribe BOOL DEFAULT FALSE,
    is_delete BOOL DEFAULT FALSE,
    client_history_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (person_id) REFERENCES Person(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT FOREIGN KEY (client_history_id) REFERENCES client_history(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

CREATE TABLE trigger_type(
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type_name TEXT NOT NULL
);

CREATE TABLE History(
    Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    log_type_id INT NOT NULL,
    goods_manufacturer VARCHAR(100) NOT NULL,
    buyer_firstname VARCHAR(100) NOT NULL,
    saler_firstname VARCHAR(100) NOT NULL,
    sales_price VARCHAR(100) NOT NULL,
    good_name VARCHAR(100) NOT NULL,
    sales_date DATETIME,
    is_delete BOOL DEFAULT FALSE,
    CONSTRAINT FOREIGN KEY (log_type_id) REFERENCES trigger_type(Id)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);
