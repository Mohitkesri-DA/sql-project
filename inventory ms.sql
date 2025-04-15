create database inventorym;
use inventorym;
-- Create the Products table
CREATE TABLE Products (
    product_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100)
);
-- Insert sample products into Products table
INSERT INTO Products (product_name, price, category) VALUES
('Laptop', 1200.00, 'Electronics'),
('Desk Chair', 150.00, 'Furniture'),
('Notebook', 2.50, 'Stationery');

-- Create the Suppliers table
CREATE TABLE Suppliers (
    supplier_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    phone_number VARCHAR(15)
);

-- Insert sample suppliers into Suppliers table
INSERT INTO Suppliers (supplier_name, contact_email, phone_number) VALUES
('Tech Supplies Co.', 'contact@techsupplies.com', '1234567890'),
('Office Furniture Inc.', 'support@officefurniture.com', '0987654321');

-- Create the Inventory table
CREATE TABLE Inventory (
    inventory_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    quantity INT DEFAULT 0,
    supplier_id INT,
    last_updated DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Insert initial inventory levels for products
INSERT INTO Inventory (product_id, quantity, supplier_id) VALUES
(1, 10, 1), 
(2, 20, 2), 
(3, 100, 2);

alter table inventorydb
drop column Inventory;

-- Create the Transactions table
CREATE TABLE Transactions (
    transaction_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    transaction_type ENUM('sale', 'purchase') NOT NULL,
    transaction_date DATE DEFAULT (CURRENT_DATE),
    quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert sample transactions
INSERT INTO Transactions (product_id, transaction_type, quantity) VALUES
(1, 'purchase', 10),
(2, 'purchase', 20),
(3, 'purchase', 100);

INSERT INTO Transactions (product_id, transaction_type, quantity) VALUES
(1, 'sale', 5);

select * from products;
select * from suppliers;
select * from inventory;
select * from transactions;
select * from inventory;
alter table inventory drop column inventory_id;
select distinct * from inventory;

-- Select the product name and quantity from the Products and Inventory tables
SELECT  .product_name, i.quantity
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id ;

-- Update Stock After a Sale
-- Decrease the quantity of the product with product_id 2 (desks) by 3 units after a sale
UPDATE Inventory
SET quantity = quantity - 3
WHERE product_id = 2;

-- Update Stock After a Purchase
-- Increase the quantity of the product with product_id 1 (laptops) by 10 units after a purchase
UPDATE Inventory
SET quantity = quantity + 10
WHERE product_id = 1;

select * from inventory;

-- To view the purchase and sale history for a specific product, use the following query.
-- This query retrieves the transaction history for a specific product with product_id 1 (Laptop).
SELECT t.transaction_type, t.quantity, t.transaction_date
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id 
WHERE p.product_id = 1;

select p.product_name, i.quantity
from inventory i
join products p on i.product_id=p.product_id
where i.quantity <5;

-- To generate a report showing the total number of products sold in a given month:
-- Generate a sales report for the current month
SELECT p.product_name, SUM(t.quantity) AS total_sold
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_type = 'sale' 
AND t.transaction_date BETWEEN '2024-10-01' AND '2024-10-31'
GROUP BY p.product_name;                                                                                                                                                                                                                                           

insert into Products (product_name, category, price)
values
('monitor', 'electronics', 150.00);
insert into inventory (product_id, quantity)
values
((select product_id from products where product_name = 'monitor'), 20);
select * from inventory;
Select * from Products;



delete from inventory
where product_id = 3;
delete from products 
where product_id = 3;
-- Select the product name and price from the Products table
SELECT product_name, price
FROM Products
WHERE category = 'Electronics';

-- Select the product name, quantity, price, and calculate total value for each product
SELECT p.product_name, i.quantity, p.price, 
       (i.quantity * p.price) AS total_value
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id;

-- Left join Products with Transactions to include all products, even those with no matching transactions
SELECT p.product_name
FROM Products p
LEFT JOIN Transactions t ON p.product_id = t.product_id 

AND t.transaction_type = 'sale'
WHERE t.transaction_date IS NULL OR t.transaction_date < '2024-09-01';


-- Calculate the total revenue by multiplying the quantity sold by the product price
SELECT SUM(t.quantity * p.price) AS total_revenue
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_type = 'sale'
  AND t.transaction_date BETWEEN '2024-10-01' AND '2024-10-31';
--
select sum(t.quantity * p.price) as total_revenue
from transactions t
join products p on t.product_id = p.product_id
where t.transaction_type = 'sale'
and t.transaction_date between '2024-10-01'  and '2024-10-31';

-- Select the product name and the total quantity sold
SELECT p.product_name, SUM(t.quantity) AS total_sold
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_type = 'sale'
AND t.transaction_date BETWEEN '2024-10-01' AND '2024-10-31'
GROUP BY p.product_name
ORDER BY total_sold DESC;
-- Select the transaction date and quantity from the Transactions table
SELECT t.transaction_date, t.quantity
FROM Transactions t
WHERE t.product_id = 2
AND t.transaction_type = 'purchase';

select t.transaction_date, t.quantity
from transactions t
where t.product_id = 2
and t.transaction_type = 'purchase';
  
select t.transaction_date, t.quantity
from transactions t
join products p on t.product_id= p.product_id
where t.transaction_type= 'sale'
and t.transaction_date = current_date;

-- Select the product name and quantity from the Products and Inventory tables
SELECT p.product_name, i.quantity
-- Join the Inventory table with the Products table using the product_id
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
-- Filter to include only products with product_id 1 or 2
WHERE p.product_id IN (1, 2);
select p.product_name, i.quantity
from inventory i 
join products on i.product = p.product_id;

-- Select the transaction date, product name, and quantity from the Transactions and Products tables
SELECT t.transaction_date, p.product_name, t.quantity
FROM Transactions t
JOIN Products p ON t.product_id = p.product_id
WHERE t.transaction_type = 'purchase';

select t.transaction_date, p.product_name, t.quantity from transactions t
join products p on transaction_id = p.product_id
where t.transaction_type = 'purchase';
-- Select the product name from the Products table
SELECT p.product_name
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.quantity = 0;

select p.product_name
from inventory i
join products p on i.product_id= p.product_id
where i.quantity = 2;