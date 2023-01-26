#What is the total amount each customer spent at the restaurant?
  select customer_id, concat ('$', sum(price_$)) as total_sales from menu
	inner join sales on (menu.product_id = sales.product_id) group by customer_id;
    
#How many days has each customer visited the restaurant?
select * from sales;

select customer_id,
	count(distinct order_date) as visit from sales
    group by customer_id;
    
#What was the first item from the menu purchased by each customer?
	#use dense rank()
select distinct product_name, customer_id, order_date, 
	dense_rank() over(partition by sales.customer_id order by sales.order_date) AS item_rank from menu
		inner join sales on (menu.product_id = sales.product_id);
        
select distinct product_name, customer_id, order_date from menu  
	inner join sales on (menu.product_id = sales.product_id) order by order_date;