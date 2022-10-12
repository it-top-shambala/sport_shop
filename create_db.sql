create table manufacture (
  id int not null primary key auto_increment,
  name_manufacture text not null
);

create table type_product (
  id int not null primary key auto_increment,
  type text not null
);

create table product (
    id int not null primary key auto_increment,
    name_product text not null,
    id_type_product int not null ,
    availability int not null,
    start_price float not null,
    id_manufacturer int not null,
    foreign key (id_type_product) references type_product(id),
    foreign key (id_manufacturer) references manufacture(id)
);

create table sellers (
    id int not null primary key auto_increment,
    last_name text not null,
    first_name text not null,
    post text not null,
    gender text not null,
    date_employment datetime not null ,
    salary float not null
);

create table buyers (
    id int not null primary key auto_increment,
    last_name text not null,
    first_name text not null,
    email text not null,
    gender text not null,
    discount int not null,
    is_subscribe bool not null
);

create table sale (
    id int not null primary key auto_increment,
    id_product int not null,
    price_sale float not null,
    amount int not null,
    date_sale datetime not null,
    id_seller int not null,
    id_buyer int not null,
    foreign key (id_buyer) references buyers(id),
    foreign key (id_seller) references sellers(id)
);

create table history (
    id int not null primary key auto_increment,
    date_time datetime not null default now(),
     id_product int not null,
    price_sale float not null,
    amount int not null,
    id_seller int not null,
    id_buyer int not null,
    foreign key (id_buyer) references buyers(id),
    foreign key (id_seller) references sellers(id)
);

create table arhive (
    id int not null primary key auto_increment,
    name_product text not null,
    type_product int not null ,
    start_price float not null,
    manufacturer int not null
);

create table last_unit (
    id int not null primary key auto_increment,
    id_product int not null,
    time_action datetime not null default now(),
    availability int not null
)

create table arhive_sellers (
    id int not null primary key auto_increment,
    last_name text not null,
    first_name text not null,
    post text not null,
    gender text not null,
    date_employment datetime not null,
    date_dismiss datetime not null default now()
);
