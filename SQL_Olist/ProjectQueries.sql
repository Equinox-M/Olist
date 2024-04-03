-- query 1

-- A
WITH customer_year AS
(SELECT customer_unique_id,
MIN(YEAR(order_purchase_timestamp)) AS first_order_year
FROM Customers
JOIN Orders
ON Customers.customer_id = Orders.customer_id
GROUP BY customer_unique_id)

SELECT first_order_year AS year,
COUNT(customer_unique_id) AS new_customers,
ROUND(CASE
WHEN first_order_year = 2016 THEN 0
ELSE (COUNT(customer_unique_id) / (SELECT COUNT(customer_unique_id) FROM customer_year WHERE first_order_year = year - 1)) * 100
END, 2) AS growth_rate
FROM customer_year
GROUP BY first_order_year
ORDER BY first_order_year;


-- B

WITH customer_orders AS (
SELECT customer_id, COUNT(order_id) AS num_orders
FROM Orders
GROUP BY customer_id
)
SELECT YEAR(o.order_purchase_timestamp) AS year,
SUM(co.num_orders) AS num_orders
FROM customer_orders co
JOIN Orders o ON co.customer_id = o.customer_id
GROUP BY year;


-- query 2
SELECT customer_state, COUNT(DISTINCT Customers.customer_id) as 'customer_count', SUM(OrderDetails.price) as 'total_sales' FROM Orders
JOIN Customers ON Orders.customer_id = Customers.customer_id
JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
GROUP BY customer_state
ORDER BY total_sales DESC;


-- query 3

-- A
SELECT ROUND(SUM(CASE 
                WHEN TIMESTAMPDIFF(day, order_purchase_timestamp, order_delivered_customer_date) <= 2 THEN 1
                ELSE 0
              END)/COUNT(order_id)*100,2) AS under_two_days,
       ROUND(SUM(CASE 
                WHEN TIMESTAMPDIFF(day, order_purchase_timestamp, order_delivered_customer_date) BETWEEN 3 AND 5 THEN 1
                ELSE 0
              END)/COUNT(order_id)*100,2) AS in_one_week,
       ROUND(SUM(CASE 
                WHEN TIMESTAMPDIFF(day, order_purchase_timestamp, order_delivered_customer_date) BETWEEN 6 AND 14 THEN 1
                ELSE 0
              END)/COUNT(order_id)*100,2) AS in_two_weeks,
       ROUND(SUM(CASE 
                WHEN TIMESTAMPDIFF(day, order_purchase_timestamp, order_delivered_customer_date) > 14 THEN 1
                ELSE 0
              END)/COUNT(order_id)*100,2) AS more_than_two_weeks
FROM Orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL
AND order_purchase_timestamp IS NOT NULL
AND TIMESTAMPDIFF(day,order_purchase_timestamp,
order_delivered_customer_date) >= 0;
                  
                  
-- B
SELECT c.customer_state, AVG(TIMESTAMPDIFF(day, o.order_purchase_timestamp, o.order_delivered_customer_date)) as avg_delivery_time
FROM Orders as o
JOIN Customers as c
ON o.customer_id = c.customer_id
GROUP BY customer_state
ORDER BY avg_delivery_time ASC;


-- quey 4

SELECT 
    c.customer_id, 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') as purchase_month, 
    SUM(od.price) as total_spend, 
    COUNT(DISTINCT od.product_id) as unique_product_count
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
GROUP BY c.customer_id, purchase_month
ORDER BY purchase_month DESC, total_spend DESC;

-- query 5

SELECT
    s.seller_id,
    COUNT(od.order_item_id) as order_count,
    SUM(od.price) as total_revenue
FROM OrderDetails od
JOIN Sellers s
ON od.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC;


-- query 6

SELECT 
    p.product_category_name,
    MIN(od.price) as cheapest_price,
    MAX(od.price) as most_expensive_price
FROM Products as p
JOIN OrderDetails as od
ON p.product_id = od.product_id
GROUP BY product_category_name;

-- query 7

SELECT
p.product_category_name,
COUNT(od.product_id) as product_count,
SUM(od.price) as total_revenue
FROM OrderDetails as od
JOIN Products as p
ON od.product_id = p.product_id
GROUP BY product_category_name
ORDER BY total_revenue DESC;

-- query 8

SELECT order_status, COUNT(order_id) AS num_orders,
       ROUND(COUNT(order_id)/(SELECT COUNT(order_id) FROM Orders)*100,2) AS percentage
FROM Orders
GROUP BY order_status
ORDER BY order_status;

-- query 9
-- A
SELECT MONTH(order_purchase_timestamp) as month, YEAR(order_purchase_timestamp) as year, SUM(price*order_item_id) as total_sales
FROM OrderDetails
JOIN Orders ON OrderDetails.order_id = Orders.order_id
GROUP BY MONTH(order_purchase_timestamp), YEAR(order_purchase_timestamp)
ORDER BY year, month;
-- B

SELECT
  CASE
    WHEN HOUR(o.order_purchase_timestamp) BETWEEN 0 AND 5 THEN 'Dawn'
    WHEN HOUR(o.order_purchase_timestamp) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN HOUR(o.order_purchase_timestamp) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Night'
  END AS time_of_day,
  COUNT(*) as num_orders
FROM Orders o
GROUP BY time_of_day
ORDER BY num_orders DESC;

-- query 10

SELECT product_category_name, p.product_id, COUNT(*) as Number_of_purchases 
FROM OrderDetails as i
INNER JOIN Products as p
ON p.product_id = i.product_id
INNER JOIN Reviews as r
ON r.order_id = i.order_id
WHERE r.review_score = 5
GROUP BY p.product_id;

-- query 11


select customer_state , round(avg(price),2 )mean_price, round(avg(freight_value),2) mean_freight, 
round(sum(price),2) sum_price, round(sum(freight_value),2) sum_freight 
from Orders as o 
left join Customers as c on o.customer_id = c.customer_id
left join OrderDetails as od on o.order_id = od.order_id
group by customer_state ;

-- query 12

SELECT order_status,
       SUM(IF(review_score = 1,1,0)) AS score_1,
       SUM(IF(review_score = 2,1,0)) AS score_2,
       SUM(IF(review_score = 3,1,0)) AS score_3,
       SUM(IF(review_score = 4,1,0)) AS score_4,
       SUM(IF(review_score = 5,1,0)) AS score_5
FROM (SELECT order_status, review_score
      FROM Orders o JOIN Reviews re
      ON o.order_id = re.order_id) a
GROUP BY order_status
ORDER BY order_status;

-- query 13

SELECT payment_type,
       COUNT(order_id) AS num_payments
FROM Payments
GROUP BY payment_type
ORDER BY num_payments DESC;

-- query 14

SELECT payment_methods,
       SUM(IF(YEAR(order_purchase_timestamp) = 2016,1,0))
       AS year_2016,
       SUM(IF(YEAR(order_purchase_timestamp) = 2017,1,0))
       AS year_2017,
       SUM(IF(YEAR(order_purchase_timestamp) = 2018,1,0))
       AS year_2018,
       ROUND((SUM(IF(YEAR(order_purchase_timestamp) = 2018,1,0)) -
              SUM(IF(YEAR(order_purchase_timestamp) = 2017,1,0)))/
              SUM(IF(YEAR(order_purchase_timestamp) = 2017,1,0))*100,2)
       AS percentage_change_17_18
FROM (SELECT order_id,
             GROUP_CONCAT(DISTINCT payment_type ORDER BY payment_type)
             AS payment_methods
      FROM Payments
      GROUP BY order_id) a
JOIN Orders o
ON a.order_id = o.order_id
GROUP BY payment_methods;


