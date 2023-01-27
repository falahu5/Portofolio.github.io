show databases;
use latihan_quary;

CREATE TABLE sales (
  customer_id VARCHAR(5),
  order_date DATE,
  product_id INTEGER
) engine = innodb;

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 desc sales;
 select * from sales;

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(20),
  price float,
  primary key (product_id)
)engine = innodb;

alter table menu
	rename column price_K to price_$;

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
  desc menu;
  select * from menu;
  

CREATE TABLE members (
  customer_id VARCHAR(5),
  join_date DATE,
  primary key (customer_id)
) engine = innodb;

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  select * from members;
  


  
    