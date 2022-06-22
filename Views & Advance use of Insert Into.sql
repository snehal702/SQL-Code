use[Human_Resources]
select * from View_1 --view created from ssms

--view created by query
create view SView as
select emt1.sid_Employee, emt1.FullName EmpName, emt1.sid_Manager , emt2.FullName ManagerName
from Management.EmployeeManagerTree emt1 left join Management.EmployeeManagerTree emt2 on emt1.sid_Manager = emt2.sid_Employee

select * from SView

--INTO CLAUSE : create a new table from existing columns available in tables in db
select emp_no, birth_date, first_name, hire_date, emp.gender, gender_name
Into fbdate --stores o/p of query in a new table
from [dbo].[Employees] emp inner join [dbo].[Gender] gen on emp.gender = gen.gender where gen.gender ='F'
order by birth_date --now store the o/p of this query as a new table using into clause after clause after col selections and prior to from

select * from fbdate

---advance usage of Insert command/statemne

select * from Employees where emp_no = 10021 --its availvble in master data
select * from Current_Personnel where emp_no = 10021 --its not available here means he was present in company but nnot anymore
--so we now need to readd him in all employee related tables since we rehired him..ie update this eid details baack in all tables

--so first check in all tables for this eid details where emp_npo col is there in hr db
select 'Employees' as T1, * from Employees where emp_no = 10021
select 'Emp location' as T2, * from Employee_Location where emp_no = 10021
select 'Emp Movement' as T3, * from Employee_Movements_History where emp_no = 10021
select 'Emp Position' as T4, * from Employee_Position_History where emp_no = 10021
select 'Emp Salary' as T5, * from Salary_History where emp_no = 10021 order by  5 desc --always take last 5 withdrawl salaries by the emp

--now based on last withdrawl salary amt we need to update the current persobnnel table for this eid emp
--since all tables have data for this eid no need to update them only update current personel table where its not present
-- so first we need to take all these columns in above tables for the eid =10021 into one--joins
insert into Current_Personnel(sid_Employee, emp_no, current_salary, current_location, sid_Department, sid_Location, sid_position)
select emp.sid_Employee, emp.emp_no, (select max(current_salary) from Salary_History where emp_no =emp.emp_no) as current_salary,
el.City,emh.sid_Department,  el.sid_Location,eph.sid_Position
from Employees emp inner join Employee_Location el on emp.sid_Employee = el.sid_Employee 
inner join Employee_Movements_History emh on emp.sid_Employee = emh.sid_Employee
inner join Employee_Position_History eph on emp.sid_Employee = eph.sid_Employee
--inner join Salary_History sh on emp.sid_Employee = sh.sid_Employee --this gives all current salary for that eid avaialble in 
--salaryhistory table but we rehire on basis of last updated salary only so we need only the last max salary record and not all by that eid
--so for that we have to use agg fubn with where clause so nested query and remove this join since salary detail will be taken acre in neted query
where emp.emp_no=10021

select * from Current_Personnel where emp_no = 10021--rexecuting to see update record entry for eid-10021

--now the new issue we see is there is no info for sid_location we need that value : check in other tables
--now each sid_loc has a location name for it cuurent_location, so if we find out what is dunkerque ka sid_loc we can update the same here
--and we know all loc details ka master table is geograpghy table so we wil see what is sid_loc for city = dunkerque in geography table
select * from Geography where City = 'Dunkerque' -- we found out that corresponding sidloc is116
--so now need to update this in cp table lets get these multiple cols from multiple tables into one table using joins
update Current_Personnel
set sid_Location = geo.sid_Location
from Geography geo inner join Current_Personnel cp on geo.City = cp.current_location where sid_Employee =21 --i.e record no 21 in cp table
--we can also use empno=10021 in where to get that row

select * from Current_Personnel where emp_no = 10021

--concatenate 2 cols using + operator and cast function to typecast into str to concatenate and then back to int
select * from Employee_Movements_History
alter table Employee_Movements_History
add Test int
--add test mei values as concatenated values of sid_employee and dept
update Employee_Movements_History
set Test = Cast(Cast(sid_Employee as varchar(8)) + cast(sid_Department as varchar(8)) as int)

create database customers
use customers
create table customer_info(id int identity, first_name varchar(25), last_name varchar(25), salary int, primary key(id));
insert into customer_info(first_name, last_name, salary) values('John', 'Daniel', 50000), ('Krish', 'Naik', 60000), ('Darius', 'Bengali', 70000), ('Chandan', 'Kumar', 40000),
 ('Ankit', 'Sharma', NULL)
 select * from customer_info
alter table customer_info add dob int;
 create table xyz(id int identity, dob int, primary key(id));
 insert into xyz(dob) values(1993),(1994),(1995),(1996);
 select * from xyz;

 alter table customer_info add email varchar(25);

 create table xyz1(id int identity, email varchar(25))
 insert into xyz1(email) values('john.daniel@gmail.com'), ('krish.naik@gmail.com'), ('darius.bengali@gmail.com'),('darius.bengali@gmail.com');
 select * from xyz1;

update customer_info
set email = new.email
from xyz1 new inner join customer_info cp on new.id = cp.id 
select * from customer_info

 update customer_info
 set customer_info.dob = xyz.dob 
 from xyz inner join customer_info on customer_info.id = xyz.id
