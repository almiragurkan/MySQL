
create or replace view usa_customers as 
select CustomerID,CustomerName,ContactName
from Customers
where Country = 'USA';


select *
from usa_customers join orders on usa_customers.CustomerID = orders.CustomerID;

create or replace view product_below_avg_price as
select ProductID,ProductName,Price
from Products
where Price<(select avg(Price)from Products);

select*from product_below_avg_price;