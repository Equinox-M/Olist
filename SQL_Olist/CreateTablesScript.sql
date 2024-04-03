create database myproject;
use myproject;

create table Sellers (
	seller_id varchar(50) PRIMARY KEY,
	seller_city varchar(50),
	seller_state varchar(50)
);

set global local_infile=true;
LOAD DATA LOCAL INFILE
'/Users/messaoudsmail/Downloads/projectSQLdataset/Sellers2.csv'
INTO TABLE myproject.Sellers
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 lines
(seller_id, seller_city, seller_state);


create table Products (
	product_id varchar(50) PRIMARY KEY,
	product_category_name varchar(255),
	product_name_length INT,
	product_description_length int,
	product_photos_qty int,
	product_weight_g int,
	product_length_cm int,
	product_height_cm int,
	product_width_cm int
);

set global local_infile=true;
LOAD DATA LOCAL INFILE
'/Users/messaoudsmail/Downloads/projectSQLdataset/Products.csv'
INTO TABLE myproject.Products
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 lines
(product_id, product_category_name, product_name_length,product_description_length, product_photos_qty, product_weight_g,product_length_cm, product_height_cm, product_width_cm);


create table Customers (
	customer_id varchar(50) PRIMARY KEY,
    custtomer_unique_id  VARCHAR(50),
	customer_city varchar(255),
	customer_state varchar(10)
);

set global local_infile=true;
LOAD DATA LOCAL INFILE
'/Users/messaoudsmail/Downloads/projectSQLdataset/Customers.csv'
INTO TABLE myproject.Customers
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 lines
(customer_id, custtomer_unique_id, customer_city, customer_state);

create table Orders (
	order_id varchar(50) primary key,
	customer_id varchar(50),
	order_status varchar(100),
    order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date timestamp,
	FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

set global local_infile=true;
LOAD DATA LOCAL INFILE
'/Users/messaoudsmail/Downloads/projectSQLdataset/Orders.csv'
INTO TABLE myproject.Orders
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 lines
(order_id, customer_id, order_status,order_purchase_timestamp,order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date);

create table OrderDetails (
	order_item_id INT,
	shipping_limit_date timestamp,
	price FLOAT,
	freight_value FLOAT,
	order_id varchar(50),
	product_id varchar(50),
	seller_id varchar(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (seller_id) REFERENCES Sellers(seller_id)
);

set global local_infile=true;
LOAD DATA LOCAL INFILE
'/Users/messaoudsmail/Downloads/projectSQLdataset/OrderDetails.csv'
INTO TABLE myproject.OrderDetails
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 lines
(order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value);


CREATE TABLE Payments (
	order_id VARCHAR(50),
    payment_squential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    paymnet_value FLOAT,
	FOREIGN KEY (order_id) REFERENCES Orders (order_id)
);

set global local_infile=true;
LOAD DATA LOCAL INFILE
'/Users/messaoudsmail/Downloads/projectSQLdataset/Payments.csv'
INTO TABLE myproject.Payments
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 lines
(order_id, payment_squential, payment_type, payment_installments, paymnet_value);

CREATE TABLE Reviews (
	review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_creation_date timestamp,
    review_answer_timestamp timestamp,
    PRIMARY KEY (review_id,order_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

set global local_infile=true;
LOAD DATA LOCAL INFILE
'/Users/messaoudsmail/Downloads/projectSQLdataset/Reviews.csv'
INTO TABLE myproject.Reviews
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 lines
(review_id, order_id,review_score, review_creation_date, review_answer_timestamp);
