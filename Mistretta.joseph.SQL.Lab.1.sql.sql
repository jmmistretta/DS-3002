#1. Write a query to get Product name and quantity/unit.  
Select northwind.products.product_name, northwind.products.quantity_per_unit FROM northwind.products;
#2. Write a query to get current Product list (Product ID and name).  
Select northwind.products.id, northwind.products.product_name FROM northwind.products WHERE discontinued=0;
#3. Write a query to get discontinued Product list (Product ID and name). 
Select northwind.products.id, northwind.products.product_name FROM northwind.products WHERE discontinued=1;
#4. Write a query to get most expense and least expensive Product list (name and unit price).
# -ORDERED FROM LEAST TO MOST EXPENSIVE:
SELECT northwind.products.product_name, northwind.products.list_price FROM northwind.products ORDER BY list_price;
# -ORDERED FROM MOST TO LEAST EXPENSIVE:
SELECT northwind.products.product_name, northwind.products.list_price FROM northwind.products ORDER BY list_price desc;
#5. Write a query to get Product list (id, name, unit price) where current products cost less than $20.  
SELECT northwind.products.id, northwind.products.product_name, northwind.products.list_price FROM northwind.products WHERE list_price<20;
#6. Write a query to get Product list (id, name, unit price) where products cost between $15 and $25.  
SELECT northwind.products.id, northwind.products.product_name, northwind.products.list_price FROM northwind.products WHERE list_price between 15 and 25;
#7. Write a query to get Product list (name, unit price) of above average price.  
SELECT northwind.products.product_name, northwind.products.list_price FROM northwind.products WHERE list_price> (SELECT avg(list_price) FROM northwind.products);
#8. Write a query to get Product list (name, unit price) of ten most expensive products.  
SELECT northwind.products.product_name, northwind.products.list_price FROM northwind.products ORDER BY list_price desc limit 10;
#9. Write a query to count current and discontinued products. 
# CURRENT:
SELECT COUNT(*) FROM northwind.products WHERE discontinued=0;
# DISCONTINUED:
SELECT COUNT(*) FROM northwind.products WHERE discontinued=1;
#10. Write a query to get Product list (name, units on order, units in stock) of stock is less than the quantity on order.  
SELECT northwind.products.product_name, northwind.order_details.quantity, northwind.inventory_transactions.quantity FROM northwind.products JOIN northwind.order_details JOIN northwind.inventory_transactions ON northwind.products.id=northwind.order_details.product_id AND northwind.order_details.product_id=inventory_transactions.product_id WHERE inventory_transactions.quantity << northwind.order_details.quantity;