  select * from regions;
  select*from customer_nodes;
  
  #How many unique nodes are there on the Data Bank system?
  select count(node_id) from customer_nodes;
  
  #What is the number of nodes per region?
  select region_id, region_name, count(node_id) as node_count from customer_nodes
		inner join regions using (region_id) group by region_id;
  
  
  #How many customers are allocated to each region?
  select region_id, region_name, count( distinct customer_id) as customer_count from customer_nodes
		inner join regions using (region_id) group by region_id;
  
  
  #How many days on average are customers reallocated to a different node?
  select * from customer_nodes
  order by customer_id asc;
  
  select customer_id, node_id, start_date, end_date
  , datediff(start_date, end_date) as difference
  from customer_nodes;
  
  select customer_id, node_id, avg(datediff(end_date, start_date)) as 'avg_difference'
  from customer_nodes group by customer_id, region_id, node_id;
  
#What is the total amount for each transaction type?
select*from customer_transactions;
select  txn_type, sum(txn_amount) as 'amount'
from customer_transactions group by txn_type;


#What is the total historical deposit counts customer?
select  customer_id, txn_date, sum(txn_amount) as 'amount'
from customer_transactions group by customer_id, txn_date;

#one to many relationship (join)
desc regions;
alter table regions
	add primary key (region_id);
    
    
alter table customer_nodes
	add constraint fk_customernodes_regions
		foreign key (region_id) references regions (region_id);
        

select * from regions
join customer_nodes on (customer_nodes.region_id = regions.region_id);

