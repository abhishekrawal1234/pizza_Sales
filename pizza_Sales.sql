
Q1:Retrieve the total number of orders placed?
select count(order_id) as total_orders from orders


Q2:Calculate the total revenue generated from pizza sales.
select sum(a.price*b.quantity) as total_revenue from pizza as a
join order_details as b
on a.pizza_id=b.pizza_id

Q3:Identify the highest-priced pizza?
select pizza_id,price from pizza
order by price desc
limit 1

Q4:Identify the most common pizza size ordered?
select count(a.size) as most_common_size,a.size from pizza as a
join order_details as b
on a.pizza_id=b.pizza_id
group by a.size 
order by most_common_size desc
limit 1


Q5:List the top 5 most ordered pizza types along with their quantities?
select a.name,sum(c.quantity) as quantity from pizza_types as a
join pizza as b
on a.pizza_type_id=b.pizza_type_id
join order_details as c
on b.pizza_id=c.pizza_id
group by a.name
order by quantity desc
limit 5

Q6:Join the necessary tables to find the total quantity of each pizza category ordered?
select a.category,sum(c.quantity) from pizza_types as a
join pizza as b
on a.pizza_type_id=b.pizza_type_id
join order_details as c
on b.pizza_id=c.pizza_id
group by a.category
order by sum desc

Q7:Determine the distribution of quantites sold by hour of the day?
select extract(hour from orders.time) as hr,sum(b.quantity) from orders 
join order_details as b
on orders.order_id=b.order_id
group by hr 
order by sum desc
Q8:Determine the distribution of orders by hour of the day.?
select extract(hour from orders.time) as hr,count(order_id) from orders
group by hr 
order by hr desc
Q9:Join relevant tables to find the category-wise distribution of pizzas?

select category,count(name) as ct from pizza_types 
group by category
Q10:Group the orders by date and calculate the average number of pizzas ordered per day?

select round(avg(quantity),0) as average
from 	(select a.date,sum(b.quantity) as quantity from orders as a
join order_details as b
on a.order_id=b.order_id
group by a.date) as data

Q11:Determine the top 3 most ordered pizza types based on revenue?

select sum(b.price*a.quantity) as revenue,c.name from order_details as a
join pizza as b
on a.pizza_id=b.pizza_id
join pizza_types as c
on b.pizza_type_id =c.pizza_type_id
group by c.name
order by revenue desc
limit 3

Q12:Calculate the percentage contribution of each pizza type to total revenue.

select (sum(b.price*a.quantity)/(select sum(c.price*d.quantity)  from pizza as c
											join order_details as d
											on c.pizza_id=d.pizza_id))*100 as contributions,
c.category from order_details as a
join pizza as b
on a.pizza_id=b.pizza_id
join pizza_types as c
on b.pizza_type_id =c.pizza_type_id
group by c.category
ORDER BY contributions desc


Q13:Analyze the cumulative revenue generated over time?
select date,sum(sales) over(order by date) as cum_sum
from (select c.date,sum(a.price*b.quantity) as sales from pizza as a
join order_details as b
on a.pizza_id=b.pizza_id
join orders as c
on b.order_id=c.order_id
group by c.date
order by c.date) as net_sales

Q14:Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select sales,name,category from
(select sales,name,category,rank() over(partition by category order by sales desc) as rnk
from (select sum(a.price*b.quantity) as sales,c.name,c.category from pizza as a
join order_details as b
on a.pizza_id=b.pizza_id
join pizza_types as c
on a.pizza_type_id=c.pizza_type_id
group by c.name,c.category
order by c.category desc,sales desc) as sales) as best_sellers
where rnk<=3


