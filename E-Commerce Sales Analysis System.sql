create database Sales;
use Sales;
create table Customers ( Customer_ID int primary key, FirstName varchar(10), LastName varchar(10),
						Email varchar(50), Country varchar(10), SignupDate date);
                        insert into Customers( Customer_ID,FirstName,LastName,Email,Country, SignupDate)
                        values(1,'John','Doe','john.doe@gmail.com','USA','2023-01-15'),
                              (2,'Jane', 'Smith','jane.smith@yahoo.com','Canada','2023-03-20'),
                              (3,'Alice','Johnson','alice.j@gmail.com','UK','2023-02-10'),
                              (4,'Bob','Brown','bob.b@gmail.com','Australia','2023-04-05'),
                              (5,'Emma','Davis','emma.davis@outlook.com','USA','2023-01-30');
				
 create table Products ( Product_ID int primary key, ProductName varchar(30), Category varchar(30),
                        Price int, StockQuantity int);
                        insert into Products(Product_ID,ProductName,Category,Price,StockQuantity)
                        values(101,'Wireless Mouse','Electronics',20.00,50),
                              (102,'Keyboard','Electronics',30.00,35),
                              (103,'Office Chair','Furniture',120.00,15),
                              (104,'Water Bottle','Home & Kitchen',10.00,100),
                              (105,'Yoga Mat','Sports',25.00,60),
                              (106,'Smartphone','Electronics',300.00,20),
					          (107,'Laptop','Electronics',1000.00,10);
						
 create table Orders ( Order_ID int primary key, Customer_ID int, foreign key (Customer_ID) references Customers(Customer_ID),
					 OrderDate date, TotalAmount int);
                     insert into Orders(Order_ID,Customer_ID,OrderDate,TotalAmount)
                     values(201,1,'2023-05-01',350.00),
						   (202,2,'2023-05-03',60.00),
                           (203,3,'2023-05-05',130.00),
                           (204,4,'2023-05-10',30.00),
                           (205,5,'2023-05-12',320.00);
 create table OrderDetails ( OrderDetail_ID int primary key, Order_ID int , foreign key (Order_ID) references Orders(Order_ID),
                            Product_ID int, foreign key (Product_ID) references Products(Product_ID), Quantity int, PricePerUnit int);
                            insert into OrderDetails(OrderDetail_ID,Order_ID,Product_ID,Quantity,PricePerUnit)
                            values(301,201,106,1,300),
								 (302,201,101,2,20),
                                 (303,202,104,3,10),
                                 (304,202,105,1,25),
                                 (305,203,103,1,120),
                                 (306,203,102,1,30),
                                 (307,204,104,3,10),
                                 (308,205,106,1,300),
                                 (309,205,101,1,20);
                                 
 select ProductName,StockQuantity from Products where StockQuantity< 10;
 select FirstName,LastName from Customers where year(SignupDate)='2023';
 select Order_ID,OrderDate,TotalAmount from Orders where Customer_ID=1;
 select Products.ProductName, sum(OrderDetails.Quantity) as TotalSold
 from OrderDetails join Products on OrderDetails.Product_ID = Products.Product_ID
 group by Products.ProductName order by TotalSold desc limit 3;
 select month(OrderDate) as Month, sum(TotalAmount) as MonthlySales
 from Orders where year(OrderDate)= 2023 group by month(OrderDate)
 order by Month;
 select Customers.Customer_ID,Customers.FirstName,Customers.LastName,
 count(Orders.Order_ID) as TotalOrders from Customers 
 join Orders on Customers.Customer_ID=Orders.Customer_ID
 group by Customers.Customer_ID,Customers.FirstName,Customers.LastName
 having TotalOrders >3;
  select Products.Category, sum(OrderDetails.Quantity) as TotalSold
 from OrderDetails join Products on OrderDetails.Product_ID = Products.Product_ID
 group by Products.Category order by TotalSold desc limit 1;
  select Products.ProductName, sum(OrderDetails.Quantity*OrderDetails.PricePerUnit) as Revenue
 from OrderDetails join Products on OrderDetails.Product_ID = Products.Product_ID
 group by Products.ProductName order by Revenue desc;
 select Customers.Country , sum(Orders.TotalAmount) as TotalRevenue
 from Orders join Customers on  Customers.Customer_ID=Orders.Customer_ID
 group by Customers.Country order by TotalRevenue desc;
 select Customers.Customer_ID,Customers.FirstName,Customers.LastName,
 sum(Orders.TotalAmount) as TotalSpent,
 rank() over (order by sum(Orders.TotalAmount) desc) as SpendingRank
 from Customers join Orders on Customers.Customer_ID=Orders.Customer_ID
 group by  Customers.Customer_ID,Customers.FirstName,Customers.LastName;
 select OrderDate, sum(TotalAmount) as DailySales,
 sum( sum(TotalAmount)) over(order by OrderDate) as RunningTotal
 from Orders group by OrderDate order by OrderDate;
 select ProductName,Category,Price,
 rank() over(partition by Category order by Price desc) as RankinCategory
 from Products order by Category, RankinCategory;
 select OrderDate, sum(TotalAmount) as DailySales,
 avg(sum(TotalAmount)) over(order by OrderDate rows between 2
 preceding and current row) as MovingAverage
 from Orders Group by OrderDate order by OrderDate;
 select Products.ProductName, sum(OrderDetails.Quantity*OrderDetails.PricePerUnit)
 as Revenue, rank() over(order by sum(OrderDetails.Quantity*OrderDetails.PricePerUnit)desc)
 as ProductRank from OrderDetails join Products on OrderDetails.Product_ID=Products.Product_ID
 group by Products.ProductName;
 select Customers.Customer_ID,Customers.FirstName,Customers.LastName,Customers.Country,
 count(Orders.Order_ID) as TotalOrders, dense_rank() over(partition by Customers.Country
 order by count(Orders.Order_ID) desc) as RankinCategory from Orders join Customers on Orders.Customer_ID=Customers.Customer_ID
 group by Customers.Customer_ID,Customers.FirstName,Customers.LastName,Customers.Country
 order by Customers.Country, RankinCategory;
 select Products.ProductName, sum(OrderDetails.Quantity*OrderDetails.PricePerUnit) as
 Revenue, sum(sum(OrderDetails.Quantity*OrderDetails.PricePerUnit) ) over() as
 TotalRevenue, sum(sum(OrderDetails.Quantity*OrderDetails.PricePerUnit)*100 )/sum( sum(OrderDetails.Quantity*OrderDetails.PricePerUnit)) over() as RevenuePercentage
 from OrderDetails join Products on OrderDetails.Product_ID=Products.Product_ID
 group by Products.ProductName;
 select OrderDate,Order_ID,Customer_ID,
 row_number()over(order by OrderDate) as RowNumber
 from Orders order by OrderDate;
 select OrderDate, sum(TotalAmount) as DailySales,
 sum(TotalAmount)-lag(sum(TotalAmount))over(order by OrderDate)
 as SalesDifference from Orders group by OrderDate order by
 OrderDate;
 select Products.ProductName,OrderDetails.Order_ID,Orders.OrderDate,
 sum(OrderDetails.Quantity)over(partition by Products.ProductName
 order by Orders.OrderDate)as CumulativeQuantity
 from OrderDetails join Products
 on OrderDetails.Product_ID=Products.Product_ID
 join Orders on OrderDetails.Order_ID=Orders.Order_ID
 order by Products.ProductName,Orders.OrderDate;


 
 
 