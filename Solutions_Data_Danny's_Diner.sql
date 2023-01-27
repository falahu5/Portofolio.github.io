use latihan_quary;

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
	dense_rank() over(partition by sales.customer_id order by sales.order_date) as item_rank from menu #define rank
		inner join sales on (menu.product_id = sales.product_id);
        
select distinct product_name, customer_id, order_date from menu  
	inner join sales on (menu.product_id = sales.product_id) order by order_date;
    
#What is the most purchased item on the menu and how many times was it purchased by all customers?
select * from sales;
select * from menu;

select product_name, count(product_id) as most_purchased from sales
	join menu using (product_id) group by product_name order by most_purchased desc;
 
# Which item was the most popular for each customer?
  
with order_info as
  (select product_name, customer_id, count(product_id) as order_count from menu
   join sales using (product_id)
   group by customer_id, product_name)
select customer_id, product_name, order_count from order_info 
	order by order_count desc;

# Which item was purchased first by the customer after they became a member?    
select * from sales;
select * from members;

with member_info as
	(select customer_id, product_id, product_name, order_date, join_date,
    dense_rank() over(partition by customer_id order by order_date) as first_item from sales as f_o
		join menu using (product_id)
		join members using (customer_id)
        where order_date >= join_date)
	select customer_id, product_name, order_date, join_date from member_info where first_item =1;

# Which item was purchased just before the customer became a member?
select * from sales;
with became_member as
	(select customer_id, product_id, product_name, order_date, join_date,
    dense_rank() over(partition by customer_id order by order_date desc) as first_item from sales as purch_became
		join menu using (product_id)
		join members using (customer_id)
        where order_date < join_date)
	select customer_id, product_name, order_date, join_date from became_member;

#  What is the total items and amount spent for each member before they became a member?
select customer_id, count(product_id), sum(price_$) from sales
		join menu using (product_id)
		join members using (customer_id) 
        where order_date < join_date group by customer_id;
        
# If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select * from sales;
select * from menu;

select customer_id, 
	sum(case 
		when product_name = 'sushi' then price_$*20
		else price_$*10 end) as total_points
	from menu
		join sales using (product_id) group by customer_id;
        
/*In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
not just sushi - how many points do customer A and B have at the end of January?*/

select * from sales
	join members using (customer_id);

with program_last_day_cte as
	(select join_date,
          adddate(join_date, interval 7 day) as program_last_date,
          customer_id
	FROM members) #define day intervals
 select customer_id,
       sum(case
               when order_date between join_date and program_last_date then price_$*10*2
               when order_date not between join_date and program_last_date
                    and product_name = 'sushi' then price_$*10*2
               when order_date not between join_date and program_last_date
                    and product_name != 'sushi' then price_$*10
           end) as customer_points from sales #define points
	join menu using (product_id)
	join program_last_day_cte using (customer_id)
		where order_date <='2021-01-31'
		and order_date >=join_date
		group by customer_id;