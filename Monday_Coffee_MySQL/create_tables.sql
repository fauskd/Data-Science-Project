-- create a database
create database Monday_Coffee;
use Monday_Coffee;


-- Import rules
-- please import the datasets according to the tables
-- Create tables
create table city(
city_id int primary key,
city_name varchar(20),
population bigint,
estimated_rent float,
city_rank int
);

create table customers(
customer_id int primary key,
customer_name varchar(20),
city_id int references city(city_id)
);


create table products(
product_id int primary key,
product_name varchar(50),
price float 
);


create table sales(
sale_id int primary key,
sale_date date,
product_id int references products(product_id),
customer_id int references customers(customer_id),
total bigint,
rating int
);