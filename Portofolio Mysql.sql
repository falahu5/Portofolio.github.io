
create database portofolio_mysql;

use portofolio_mysql;

create table product
( 
	product_id varchar(10),
    name_product varchar(10),
    price int unsigned
) engine = innodb;

insert into product (product_id, name_product, price)
	values
			('G32N', 'gaun', 400000),
            ('J22S', 'jas', 350000),
            ('K78A', 'kemeja', 250000),
            ('M90L', 'mantel', 170000),
            ('R28K', 'rok', 85000);
select * from product;

create table customer
( 
	customer_id varchar(10),
    name_customer varchar(20),
    address varchar(15)
) engine = innodb;

insert into customer (customer_id, name_customer, address)
	values
			('IND76X', 'Indra Agustina', 'Jawa'),
            ('KUS50X', 'Kusuma Dina', 'Kalimantan'),
            ('AND23X', 'Andi Ade', 'Sulawesi'),
            ('IKA40X', 'Ika Indah', 'Jawa'),
            ('RAT11X', 'Ratna Fitria', 'Sumatra'),
            ('AHM07X', 'Ahmad Surya', 'Bali');
            
select * from customer;

select*from sales;

#What is the total price each customer?

with total_price as (
	select name_customer, units*price as total  from sales
		join customer using(customer_id)
		join product using(product_id))
select name_customer, concat('Rp',sum(total)) as total_amount 
from customer
	join total_price using(name_customer) 
    group by name_customer 
    order by total_amount desc;

#What is the most purchased item

select name_product, sum(units) as total_unit from sales
	join product using (product_id)
		group by name_product order by total_unit desc;
        
#Which item was the most popular for each customer?

with popular_item as 
(
	select name_customer, name_product, sum(units) as total_unit,
		rank() over(partition by name_customer
		order by sum(units) desc) as rank_num
		from sales
			join customer using (customer_id)
			join product using (product_id)
				group by name_customer, name_product 
				order by name_customer asc, total_unit desc
        )
select name_customer, name_product, total_unit
	from popular_item
		where rank_num <= 2;
        

#What is the total amount each month?
with total_price as 
(
	select month(order_date) as month_order, units*price as total  
		from sales
        join product using (product_id)
)
select month_order, concat('Rp',sum(total)) as total_amount from total_price
    group by month_order order by month_order asc, total_amount desc;
    

#Which item was the most popular for each month?

with popular_item as 
(
	select order_date, name_product, sum(units) as total_unit,
		rank() over(partition by month(order_date)
		order by sum(units) desc) as rank_num
		from sales
			join product using (product_id)
				group by order_date, name_product 
				order by order_date asc, total_unit desc
        )
        
select order_date, name_product, total_unit
	from popular_item
		where rank_num = 1;

#What is the average monthly income
with total_price as 
(
	select month(order_date) as month_order, 
    units*price as total  
		from sales
        join product using (product_id)
)
select month_order,  
concat('Rp',round(avg(total),0)) 
as avg_income 
from total_price
    group by month_order 
    order by month_order 
    asc, avg_income desc;
