select *
from pizza_sales

--KPI's( Key Performance Indicators)

--Total Revenue Calculation.

SELECT SUM(total_price) AS TotalPrice
FROM pizza_sales;



--Total Number of Orders.

SELECT COUNT(DISTINCT order_id) AS TotalOrders
FROM pizza_sales



--Average Order Value.

SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value
FROm pizza_sales;



-- Calculates the average number of pizzas per order.
-- Ensures floating-point division by multiplying by 1.0.
-- Uses CAST to format the result with exactly 2 decimal places. 

SELECT 
    CAST(SUM(quantity) * 1.0 / COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS Avg_Pizza_Per_Order
FROM pizza_sales;



-- Retrieving the pizza category with the highest total revenue.

SELECT  TOP 1 pizza_category, SUM(total_price) AS Most_Revenue_Pizza
FROM pizza_sales
GROUP BY pizza_category
ORDER BY SUM(total_price) DESC;



--DAILY AND TIMELY ORDER AND REVENUE TRENDS

--Calculating the total revenue each month by formatting the date

SELECT 
    FORMAT(order_date, 'MM-yyyy') AS Month, 
    SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY FORMAT(order_date, 'MM-yyyy')
ORDER BY Month;



-- Retrieving total revenue and total orders per month.

SELECT 
    DATENAME(MONTH, order_date) AS Month, 
    SUM(total_price) AS Total_Revenue,
	COUNT(DISTINCT order_id) AS TotalOrders
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date), MONTH(order_date)
ORDER BY MONTH(order_date);



-- Retrieving total revenue and total orders per day.

SELECT 
    DATENAME(DW, order_date) AS OrderDay, 
    SUM(total_price) AS Total_Revenue,
	COUNT(DISTINCT order_id) AS TotalOrders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date);



--  Orders results in descending order to show the top 5 highest revenue days.

SELECT 
    TOP 5 order_date, 
    SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY order_date
ORDER BY Total_Revenue DESC;



-- Retrieving the busiest hour of the day by counting the number of orders.

SELECT 
    DATEPART(HOUR, order_time) AS OrderHour, 
    COUNT(order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY Total_Orders DESC;



-- Categorizes orders based on time of day using a CASE statement.  
-- Repeats the CASE statement in GROUP BY to ensure compatibility in SQL Server.

SELECT 
    CASE 
        WHEN order_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN order_time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN order_time BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(order_id) AS total_orders
FROM pizza_sales
GROUP BY 
    CASE 
        WHEN order_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN order_time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
        WHEN order_time BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
        ELSE 'Night'
    END
ORDER BY total_orders DESC;



-- Querying the highest sales day for each pizza category.

SELECT 
    pizza_category, 
    order_date, 
    SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_category, order_date
HAVING SUM(quantity) = (
    SELECT MAX(Total_Quantity)
    FROM (SELECT pizza_category, order_date, SUM(quantity) AS Total_Quantity 
          FROM pizza_sales 
          GROUP BY pizza_category, order_date) AS CategorySales
    WHERE CategorySales.pizza_category = pizza_sales.pizza_category
)

ORDER BY Total_Quantity_Sold DESC;



--Retrieving the 5 top-selling pizzas based on total quantity sold.

SELECT 
    TOP 5 pizza_name, 
    SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC;



---Retrieving the 5 lowest-selling pizzas based on total quantity sold.

SELECT 
    TOP 5 pizza_name, 
    SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity;



--Retrieving the favorite pizza by revenue.

SELECT 
    pizza_size, 
    SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Total_Revenue DESC;



-- Querying the highest sales day for each pizza category.

SELECT 
    pizza_category, 
    order_date, 
    SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_category, order_date
HAVING SUM(quantity) = (
    SELECT MAX(Total_Quantity)
    FROM (SELECT pizza_category, order_date, SUM(quantity) AS Total_Quantity 
          FROM pizza_sales 
          GROUP BY pizza_category, order_date) AS CategorySales
    WHERE CategorySales.pizza_category = pizza_sales.pizza_category
)
ORDER BY Total_Quantity_Sold desc;









