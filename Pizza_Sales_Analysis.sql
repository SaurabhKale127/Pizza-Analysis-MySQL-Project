-- Database used is pizzahut
use pizzahut;

-- Easy
--Q.1 Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS Total_Orders from orders;

--Q.2 Calculate the total revenue generated from pizza sales.
SELECT round(SUM((p.price*o.quantity)),2) AS Total_Revenue from pizzas p INNER JOIN orders_details o 
ON p.pizza_id=o.pizza_id;

--Q.3 Identify the highest-priced pizza.
SELECT pt.name, p.price from pizza_types pt INNER JOIN pizzas p ON 
pt.pizza_type_id=p.pizza_type_id order by price desc limit 1;

--Q.4 Identify the most common pizza size ordered.
-- select distinct(size) ,count(size) from pizzas group by size limit 1;
SELECT p.size, count(od.quantity) from pizzas p INNER JOIN orders_details od ON p.pizza_id = od.pizza_id group by p.size limit 1;

--Q.5 List the top 5 most ordered pizza types along with their quantities.
SELECT name, count(quantity) from pizza_types pt 
INNER JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
INNER JOIN orders_details od ON od.pizza_id = p.pizza_id 
group by name order by count(quantity) DESC limit 5;

-- Medium
--Q.1 Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT category, count(quantity) from pizza_types pt 
INNER JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
INNER JOIN orders_details od ON od.pizza_id = p.pizza_id 
group by category order by count(quantity) DESC;

--Q.2 Determine the distribution of orders by hour of the day.
SELECT hour(order_time), count(order_id) AS orders FROM orders group by hour(order_time);

--Q.3 Join relevant tables to find the category-wise distribution of pizzas.
SELECT category,COUNT(category) from pizza_types group by category;

--Q.4 Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT AVG(quantity) from
(SELECT distinct(order_date),SUM(quantity) as quantity from orders o 
INNER JOIN orders_details od ON o.order_id=od.order_id group by order_date) 
AS Order_quantity;

--Q.5 Determine the top 3 most ordered pizza types based on revenue.
SELECT name,SUM(price*quantity) AS revenue from pizza_types pt 
INNER JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
INNER JOIN orders_details od ON od.pizza_id = p.pizza_id 
group by name order by revenue DESC limit 3;

-- Hard
--Q.1 Calculate the percentage contribution of each pizza type to total revenue.

SELECT category, round((revenue/(SELECT round(SUM((p.price*o.quantity)),2) AS Total_Revenue from pizzas p INNER JOIN orders_details o 
ON p.pizza_id=o.pizza_id)*100),2) as revenue_percentage from
(SELECT category, round(SUM((price*quantity)),2) as revenue 
from pizza_types pt 
INNER JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
INNER JOIN orders_details od ON od.pizza_id = p.pizza_id
group by category) as revenue_table group by category;

--Q.2 Analyze the cumulative revenue generated over time.
SELECT order_date, sum(cumu_rev) over(order by order_date) from
(SELECT order_date, round(SUM(price*quantity),2) as cumu_rev from pizzas p INNER JOIN orders_details od ON p.pizza_id=od.pizza_id
INNER JOIN orders o ON od.order_id=o.order_id group by order_date) as sales;

--Q.3 Determine the Revenue's of Pizzas per Category.
SELECT category, name, round(SUM(price*quantity),2) AS Revenue from pizza_types pt 
INNER JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
INNER JOIN orders_details od ON od.pizza_id = p.pizza_id 
group by name, category order by category;
