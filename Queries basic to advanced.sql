-- Basic Level queries
-- List all distinct categories of products.

select
distinct(category) as Uniqueproducts
from products;

-- Retrieve the names of all salespeople.

select
 salesperson
 from people
 order by Salesperson;

-- Show all sales made for a specific product

select
 sa.PID,
 sum(sa.Amount) as Total,
 pr.Product
from 
sales as sa
join products as pr on pr.PID=sa.PID
where
pr.PID='P01';

-- Get the details of the geographic regions available.

select * from geo;

-- List all sales that involved more than 10 customers.
select * from sales
where Customers>10
order by Amount;

-- Find the details of products where the cost per box is greater than $5.
select * from products
where Cost_per_box>5;

-- Retrieve the number of boxes sold for each product.
select
 PID,
 sum(Boxes) as TotalBox 
 from sales
group by PID
order by TotalBox desc;

-- Find all sales made in a specific region

select
	 sa.geoid,
	 ge.geo,
	 ge.region,
	 sa.amount 
 from 
	sales as sa
join
	geo as ge on ge.GeoID=sa.GeoID
where
	ge.region='Europe';
    
-- sum of sales of all the region
select
	 sa.geoid,
	 ge.geo,
	 ge.region,
	 sum(sa.amount) TotalAmount 
 from 
	sales as sa
join
	geo as ge on ge.GeoID=sa.GeoID
group by sa.GeoID;

-- List the total number of sales (rows) recorded in the sales table.
select 
	count(*) as RowCount
from Sales;

-- Get all distinct product sizes available in the system.
select
 distinct(Size) as AvailableSize
 from products;

-- intermidiate level queries

-- Calculate the total number of customers served by each salesperson.

select 
	sa.spid,
	po.salesperson,
    sum(sa.Customers) as total_number_of_customer_served 
from 
	sales as sa
join 
	people as po on po.spid=sa.spid
group by 
	sa.spid
order by 
	sa.spid;

-- Get the top 5 regions with the highest amount of sales.

select
	g.geoid,
    g.geo, 
    sum(s.Amount) as total_amount 
from 
	geo as g
join 
	sales as s on s.GeoID=g.GeoID
group by 
	g.GeoID
order by 
	total_amount desc
limit 5;

-- Get the top 5 regions with the highest number of sales with total sales amount.

select 
	g.geoid,
    g.geo,
    count(g.geo) as total_number_of_sale, 
    sum(s.amount) as Total_sales_amount 
from
	geo as g
join
	sales as s on s.GeoID=g.GeoID
group by
	g.GeoID
order by 
	total_number_of_sale desc
limit 5;

-- Find all sales made for products of a specific category("bar")

select 
	p.product,
	p.category,
    s.Amount as TotalAmount,
    s.Boxes as TotalBox 
from 
	sales as s
join 
	products as p on  p.pid=s.pid
where 
	p.Category='Bars';

-- List the sales where the amount exceeds $10,000.
select * from sales
where amount>=10000
order by Amount desc;

-- Calculate the total revenue generated by each salesperson.

select
	s.spid,
	p.salesperson,
    sum(s.amount) as TotalSales
from 
	sales as s 
join 
	people as p on p.spid=s.spid
group by 
	s.SPID;

-- Retrieve all salespeople who have sold products in more than 3 regions.

select 
	pe.Salesperson, 
    count(distinct(s.GeoID)) as TotalRegion 
from 
	people as pe
join
	sales as s on s.SPID=pe.SPID
group by 
	pe.SPID
having 
	TotalRegion>3;

-- List all the products with the total sales revenue in each region.

select 
	sa.pid,
	pr.product,
    ge.Region,
    sum(sa.amount) as TotalSales 
from 
	sales as sa
join 
	products as pr on pr.PID=sa.PID
join 
	geo as ge on ge.GeoID=sa.GeoID
group by 
	sa.pid,ge.Region
order by 
	ge.Region, TotalSales desc;
    
-- Find the total revenue per region and product, but only for salespeople belonging to a specific team.

select 
    ge.Region,
    pr.Product,
    sum(sa.Amount) as TotalRevenue
from 
    sales sa
join 
    products pr on sa.PID = pr.PID
join 
    geo ge on sa.GeoID = ge.GeoID
join 
    people pe on sa.SPID = pe.SPID
where 
    pe.Team = 'Delish'
group by 
    ge.Region, pr.Product
order by 
    ge.Region, TotalRevenue desc;
    
-- Determine the salespeople who have sold more than 100 boxes in a single sale.

select 
    pe.SPID,
    pe.Salesperson,
    sa.PID,
    sa.Boxes
from 
    sales sa
join 
    people pe on sa.SPID = pe.SPID
where 
    sa.Boxes > 100
order by 
    pe.Salesperson;

-- List all the products with the highest sales revenue in each region.

select 
	PID,
	Product, 
    Region, 
    TotalSales
from (
    select
		sa.PID,
		pr.Product, 
        ge.Region, 
        sum(sa.Amount) as TotalSales,
	row_number() over (partition by ge.Region order by sum(sa.Amount) desc) as SalesRank
    from 
		sales as sa
    join 
		products as pr on pr.PID = sa.PID
    join 
		geo as ge on ge.GeoID = sa.GeoID
    group by 
		sa.PID, ge.Region
) as RankedSales
where SalesRank = 1;

-- Show the total number of customers served in each region.

select 
	sa.GeoID,
    geo.Geo,
    geo.region,
    (sa.Customers) as TotalCustomerServed 
from 
	Sales as sa
join
	geo on geo.GeoID=sa.GeoID
group by 
	sa.GeoID;

-- Find the average cost per box for each category of product.

select 
	category,
	avg(cost_per_box) as averagecost
from products
group by Category;

select Category, avg(Cost_per_box) as AvgCostPerBox
from products
group by Category;


-- Advanced/Expert Level

-- Calculate the total revenue and the number of sales for each product in each region.
select 
	sa.GeoID,
	sa.PID,
	pr.product,
    ge.geo,
    ge.region,
    count(SaleDate) as Numberofsale ,
    sum(sa.amount) as TotalSales 
from
	sales as sa
join
	geo as ge on ge.GeoID=sa.GeoID
join 
	products as pr on pr.PID=sa.PID
group by
	sa.GeoID,sa.PID
order by 
	sa.pid;

-- Identify the salesperson who generated the highest revenue.

select 
	sa.SPID,
	pe.Salesperson,
    sum(sa.amount) as TotalRevenue 
from 
	sales as sa
join 
	people as pe on pe.SPID=sa.SPID
group by
	sa.SPID
order by 
	TotalRevenue desc
limit 1;

-- Identify the salesperson who generated the highest revenue in the last year.

select 
	sa.SPID,
	pe.Salesperson,
    sum(sa.amount) as TotalRevenue 
from
	sales as sa
join
	people as pe on pe.SPID=sa.SPID
where 
	year(sa.SaleDate)=2021 
-- data is not updated so we can't use here: year(sa.SaleDate) = year(curdate()) - 1
group by 
	sa.SPID
order by 
	TotalRevenue desc
limit 1;

-- Find the region that had the lowest sales amount during the last quarter.

select 
    ge.Region,
    sum(sa.Amount) as TotalSales
from 
    sales as sa
join 
    geo as ge on ge.GeoID = sa.GeoID
where 
	quarter(sa.SaleDate) = quarter(curdate()) - 1  -- Filters for the last quarter
    and year(sa.SaleDate) = year(curdate())        -- Ensures it's within the current year
group by 
    ge.Region
order by 
    TotalSales asc
limit 1;  -- Only get the region with the lowest sales amount 
-- data is not updated here

-- rank all salespeople by the number of customers they've served
select 
    sa.SPID,
    po.Salesperson,
    sum(sa.Customers) as TotalCustomersServed
from 
    sales as sa
join 
    people as po on po.SPID = sa.SPID
group by 
    sa.SPID, po.Salesperson
order by 
    TotalCustomersServed desc;

-- using rank 
select 
    sa.SPID,
    po.Salesperson,
    sum(sa.Customers) as TotalCustomersServed,
    rank() over (order by sum(sa.Customers) desc) as Rank
from 
    sales as sa
join 
    people as po on po.SPID = sa.SPID
group by 
    sa.SPID, po.Salesperson
order by 
    Rank;
    
-- calculate the percentage contribution of each product to the total revenue of its category

select 
    pr.PID,
    pr.Product,
    pr.Category,
    sum(sa.Amount) as ProductRevenue,
    cat.TotalCategoryRevenue,
    (sum(sa.Amount) / cat.TotalCategoryRevenue) * 100 as PercentageContribution
from 
    sales as sa
join 
    products as pr on pr.PID = sa.PID
join 
    (
        select 
            Category,
            sum(sa.Amount) as TotalCategoryRevenue
        from 
            sales as sa
        join 
            products as pr on pr.PID = sa.PID
        group by 
            pr.Category
    ) as cat on pr.Category = cat.Category
group by 
    pr.PID, pr.Product, pr.Category, cat.TotalCategoryRevenue
order by 
    pr.Category, PercentageContribution desc;
-- another approach
select 
    pr.PID,
    pr.Product,
    pr.Category,
    sum(sa.Amount) as ProductRevenue,
    (sum(sa.Amount) / 
        (select sum(s.Amount) 
         from sales s 
         join products p on p.PID = s.PID 
         where p.Category = pr.Category)
    ) * 100 as PercentageContribution
from 
    sales sa
join 
    products pr on pr.PID = sa.PID
group by 
    pr.PID, pr.Product, pr.Category
order by 
    pr.Category, PercentageContribution desc;
    
-- Identify the most frequently sold product in each region.

select 
    regional_sales.GeoID,
    ge.Region,
    regional_sales.PID,
    pr.Product,
    regional_sales.TotalBoxes
from 
    (select 
         sa.GeoID,
         sa.PID,
         sum(sa.Boxes) as TotalBoxes,
         rank() over (partition by sa.GeoID order by sum(sa.Boxes) desc) as ProductRank
     from 
         sales sa
     group by 
         sa.GeoID, sa.PID
    ) as regional_sales
join 
    geo ge on regional_sales.GeoID = ge.GeoID
join 
    products pr on regional_sales.PID = pr.PID
where 
    regional_sales.ProductRank = 1
order by 
    ge.Region;

-- Create a monthly sales trend report showing total sales and revenue for each region.

select 
    year(sa.SaleDate) as Year,
    month(sa.SaleDate) as Month,
    ge.Region,
    sum(sa.Boxes) as TotalSales,
    sum(sa.Amount) as TotalRevenue
from 
    sales sa
join 
    geo ge on sa.GeoID = ge.GeoID
group by 
    Year, Month, ge.Region
order by 
    Year, Month, ge.Region;













