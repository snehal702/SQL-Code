use Human_Resources
--default constraint
select * from Managers order by sid_Employee --and if i add a new record to it and dont mention particular value to it it will use default values for the cols pstn and from date we 
--specified as default with some default value
insert into Managers(sid_Employee, to_date)
values(100617, '2001-01-01')

--aggregate condn
select * from Employee_Location
select count(sid_Employee) as empcount, City from Employee_Location where CountryRegionName = 'Australia' group by City
--count takes all values / rows into consideration ..null/duplicates etc
select distinct(sid_Employee )from Employee_Location where CountryRegionName = 'Australia' and  City ='Rhodes' 

select count(emp_no) as empcount from Salary_History --- this gives 901617 as records

select count(distinct(emp_no)) as empcount from Salary_History --- this gives only distinct no null/ duplicateds values of the col- so only 258986

select sum(cast(current_salary as decimal(18,2))) from Current_Personnel --sum returns int only so cast decimal as int, cast converts decto int
select avg(cast(current_salary as decimal(18,2))) from Current_Personnel
select emp_no, min(current_salary) as minsal,  max(current_salary) as maxsal, abs(min(current_salary)-max(current_salary)) as hike
from Salary_History group by emp_no
select * from Salary_History

--having clause with agg
select emp_no, sum(current_salary) as totsal from Salary_History group by emp_no having sum(current_salary)>600000

-- variables in sql
Declare @myname as varchar(80) = 'Satyajit' --user defined variable, it works within this batch only
print @myname --user defined -- executing user defined var but always witj the declare batch above ie. run both  together

Declare @contactnum as int = 1000100010 --user defined variable, it works within this batch only
print @contactnum

Declare @decinum as Decimal(20,2) = 123456789123456789--user defined variable, it works within this batch only
print @decinum

Declare @contactnum as int  --user defined variable, it works within this batch only
set @contactnum =1000100010
select @contactnum

--system defined var
select @@VERSION , @@SERVERNAME

--system defined  vr along with db/ tables we have  
select * from Employees
select @@ROWCOUNT --count of all rows in the table / for the query

--Stored Procedure
---creation
create procedure EC @country varchar(80)
as 
select City, count(sid_Employee) as emp_count from Employee_Location where CountryRegionName = @country group by City order by emp_count desc

---execution/calling procedure
exec EC @country = 'Australia' ---run in a batch

--using another var not part of sp to get data for another country
declare @conty varchar(50) = 'France'
exec EC @country = @conty

