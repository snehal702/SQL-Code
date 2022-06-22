use classicmodels;
show tables;
select * from products;
-- toal msrp for each product line
create table prodcutlinemsrp as
select productLine, sum(msrp) from products group by productLine;

select * from prodcutlinemsrp;
-- to get this sum of msrp in each row against its corr prtoduct kine in a sep col -- use windows fun -- ie. sum gives one agg vale but to get that agg value in a diff col acrross all rows based on product line
select p.productLine, p.*, sum(p.msrp) over(partition by p.productLine)  as total_msrp from products p;

-- row number : we get row numbers for each productline order by its partion in asc overall ordered by msrp
-- ie for each msrp value we wil get unique row num against it
select row_number() over(order by msrp) as rownum, msrp from products order by msrp;

-- rank() functions
use intro_sql;
create table demo(var_a int);
insert into demo values(101),(102),(103),(104),(105), (106);
insert into demo values(103),(106);
select * from demo;
select var_a, rank() over(order by var_a) as test_ranks from demo;

-- fisrt_value : returns the value of a specific expression wrt first row in the window frame
select * from telco_churn;
select customerID, max(TotalCharges) from telco_churn having max(TotalCharges); -- using having 
select customerID from telco_churn where TotalCharges =(select max(TotalCharges) from telco_churn); -- using nested query
select customerID from telco_churn order by TotalCharges desc limit 1; -- using nested query
select *, first_value(customerID) over(order by TotalCharges desc) as maxchargescust from telco_churn; -- using windows fun first_value
-- it gives the max total charges in a separate col against each row in the table

create table sales
(sales_employee varchar(50) not null, fiscal_year int not null, sale decimal(14,2) not null, primary key(sales_employee, fiscal_year));
insert into sales values ('Satya', 2016,100),('Satya', 2017,150),('Satya', 2018,200),('Ravi', 2016,150),('Ravi', 2017,100),('Ravi', 2018,200),
('Shalini', 2016,200),('Shalini', 2017,150),('Shalini', 2018,250);
select * from sales;
select s.fiscal_year,s.*,  sum(s.sale) over(partition by s.fiscal_year) as totalsale from sales s;



