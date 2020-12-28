call SelectAllCustomers();

set @city="Madrid";
call SelectCustomersByCity(@city);
select @city;

select count(orderID)
from orders join shippers on orders.shipperID=shippers.shipperID
where shipperName="United Package";

call GetOrderCountByShipper("United Package",@count);
select @count;

set @counter=1;
call Counter(@counter,1);
select @counter;
call Counter(@counter,5);