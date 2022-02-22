DROP DATABASE `northwind_dw`;
CREATE DATABASE `northwind_dw` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE northwind_dw;

#DROP TABLE `dim_customers`;
CREATE TABLE `dim_customers` (
  `customer_key` int NOT NULL AUTO_INCREMENT,
  `company` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `job_title` varchar(50) DEFAULT NULL,
  `business_phone` varchar(25) DEFAULT NULL,
  `fax_number` varchar(25) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`customer_key`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb3;

#DROP TABLE `dim_employees`;
CREATE TABLE `dim_employees` (
  `employee_key` int NOT NULL AUTO_INCREMENT,
  `company` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `email_address` varchar(50) DEFAULT NULL,
  `job_title` varchar(50) DEFAULT NULL,
  `business_phone` varchar(25) DEFAULT NULL,
  `home_phone` varchar(25) DEFAULT NULL,
  `fax_number` varchar(25) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  `web_page` longtext,
  `notes` longtext,
  PRIMARY KEY (`employee_key`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `first_name` (`first_name`),
  KEY `last_name` (`last_name`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;

#DROP TABLE `dim_products`;
CREATE TABLE `dim_products` (
  `supplier_ids` longtext,
  `product_key` int NOT NULL AUTO_INCREMENT,
  `product_code` varchar(25) DEFAULT NULL,
  `product_name` varchar(50) DEFAULT NULL,
  `standard_cost` decimal(19,4) DEFAULT '0.0000',
  `list_price` decimal(19,4) NOT NULL DEFAULT '0.0000',
  `reorder_level` int DEFAULT NULL,
  `target_level` int DEFAULT NULL,
  `quantity_per_unit` varchar(50) DEFAULT NULL,
  `discontinued` tinyint(1) NOT NULL DEFAULT '0',
  `minimum_reorder_quantity` int DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product_key`),
  KEY `product_code` (`product_code`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb3;

#DROP TABLE `dim_shippers`;
CREATE TABLE `dim_shippers` (
  `shipper_key` int NOT NULL AUTO_INCREMENT,
  `company` varchar(50) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`shipper_key`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `fact_orders` (
`order_id` int,
`employee_id` int,
`customer_id` int,
`product_id` int,
`shipper_id` int,
`ship_name` varchar(50) DEFAULT NULL,
`ship_address` varchar(50) DEFAULT NULL,
`ship_city` varchar(50) DEFAULT NULL,
`ship_state_province` varchar(2) DEFAULT NULL,
`ship_zip_postal_code` varchar(50) DEFAULT NULL,
`ship_country_region` varchar(50) DEFAULT NULL,
`quantity` int,
`order_date` date,
`shipped_date` date,
`unit_price` int,
`discount` int,
`shipping_fee` int,
`taxes` int,
`payment_type` varchar(50) DEFAULT NULL,
`paid_date` date,
`tax_rate` int,
`order_status` varchar(50) DEFAULT NULL,
`order_details_status`varchar(50) DEFAULT NULL

);

INSERT INTO `northwind_dw`.`fact_orders`
(`order_id`,
`employee_id`,
`customer_id`,
`product_id`,
`shipper_id`,
`ship_name`,
`ship_address`,
`ship_city`,
`ship_state_province`,
`ship_zip_postal_code`,
`ship_country_region`,
`quantity`,
`order_date`,
`shipped_date`,
`unit_price`,
`discount`,
`shipping_fee`,
`taxes`,
`payment_type`,
`paid_date`,
`tax_rate`,
`order_status`,
`order_details_status`)
SELECT o.id,
    o.employee_id,
    o.customer_id,
    od.product_id,
    o.shipper_id,
    o.ship_name,
    o.ship_address,
    o.ship_city,
    o.ship_state_province,
    o.ship_zip_postal_code,
    o.ship_country_region,
    od.quantity,
    o.order_date,
    o.shipped_date,
    od.unit_price,
    od.discount,
    o.shipping_fee,
    o.taxes,
    o.payment_type,
    o.paid_date,
    o.tax_rate,
    os.status_name AS order_status,
    ods.status_name AS order_details_status
FROM northwind.orders AS o
INNER JOIN northwind.orders_status AS os
ON o.status_id = os.id
RIGHT OUTER JOIN northwind.order_details AS od
ON o.id = od.order_id
INNER JOIN northwind.order_details_status AS ods
ON od.status_id = ods.id;

INSERT INTO `northwind_dw`.`dim_customers`
(`customer_key`,
`company`,
`last_name`,
`first_name`,
`job_title`,
`business_phone`,
`fax_number`,
`address`,
`city`,
`state_province`,
`zip_postal_code`,
`country_region`)
SELECT `id`,
`company`,
`last_name`,
`first_name`,
`job_title`,
`business_phone`,
`fax_number`,
`address`,
`city`,
`state_province`,
`zip_postal_code`,
`country_region`
FROM northwind.customers;
SELECT * FROM northwind_dw.dim_customers;

INSERT INTO `northwind_dw`.`dim_employees`
(`employee_key`,
`company`,
`last_name`,
`first_name`,
`email_address`,
`job_title`,
`business_phone`,
`fax_number`,
`address`,
`city`,
`state_province`,
`zip_postal_code`,
`country_region`)
SELECT `employees`.`id`,
`employees`.`company`,
`employees`.`last_name`,
`employees`.`first_name`,
`employees`.`job_title`,
`employees`.`business_phone`,
`employees`.`fax_number`,
`employees`.`address`,
`employees`.`city`,
`employees`.`state_province`,
`employees`.`zip_postal_code`,
`employees`.`country_region`
FROM `northwind`.`employees`;
SELECT * FROM northwind_dw.dim_employees;

INSERT INTO `northwind_dw`.`dim_products`
(`supplier_ids`,
  `product_key`,
  `product_code`,
  `product_name`,
  `standard_cost`,
  `list_price`,
  `reorder_level`,
  `target_level`,
  `quantity_per_unit`,
  `discontinued`,
  `minimum_reorder_quantity`,
  `category`)
  SELECT `products`.`supplier_ids`,
  `products`.`product_key`,
  `products`.`product_code`,
  `products`.`product_name`,
  `products`.`standard_cost`,
  `products`.`list_price`,
  `products`.`reorder_level`,
  `products`.`target_level`,
  `products`.`quantity_per_unit`,
  `products`.`discontinued`,
  `products`.`minimum_reorder_quantity`,
  `products`.`category`
  FROM `northwind`.`products`;
  SELECT * FROM northwind_dw.dim_products;
  
Select * from northwind_dw.dim_customers;

Select northwind_dw.dim_customers.last_name, northwind_dw.fact_orders.quantity, northwind_dw.fact_orders.unit_price FROM northwind_dw.dim_customers JOIN northwind_dw.fact_orders ON northwind_dw.dim_customers.customer_key = northwind_dw.fact_orders.customer_id;