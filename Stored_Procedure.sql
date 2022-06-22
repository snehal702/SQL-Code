create database sample
use sample

create table Employee(id int primary key , name varchar(30), Gender varchar(30), department int);

insert into Employee values
(1, 'imran', 'Male',1),
(2, 'ram', 'Male',1),
(3, 'Sara', 'Female',3),
(4, 'Todd', 'Male',2),
(5, 'Jhon', 'Male',3),
(6, 'Sara', 'Female',2),
(7, 'James', 'Male',1),
(8, 'Steve', 'Male',1),
(9, 'imran', 'Male',1),
(10, 'Pam', 'Female',2);

select * from Employee; -- sp w/o params
--SP w/o parameters
create procedure ED
as
begin
	select name, Gender from Employee
end

exec ED

-- SP with input parameters
create proc emp_dept @gender varchar(30), @deptid int
as
begin
	select name, Gender, department from Employee where Gender = @gender and department=@deptid
end

exec emp_dept @gender = 'Female' , @deptid = 3
exec emp_dept @deptid = 3, @gender = 'Female' --by interchanging the position of arg same as python
exec emp_dept 'Male' , 1 --w/o writing the arg name

-- to view/acccess sp code with help of system created sp helpttext
sp_helptext ED
sp_helptext emp_dept

-- to alter an existing sp

alter procedure ED
as
begin
	select name, Gender from Employee order by name
end

exec ED

-- drop a sp
drop proc ED

-- to hide the text of a sp --encrpytped format
alter procedure emp_dept @gender varchar(30), @deptid int
With Encryption
as
begin
	select name, Gender, department from Employee where Gender = @gender and department=@deptid order by name
end
exec emp_dept @gender ='Female', @deptid =3 

sp_helptext emp_dept -- this is shown : The text for object 'emp_dept' is encrypted.

--sp with output parameter : to display result from query
create proc empbygencount @gen varchar(30), @empcnt int out --output var
as
begin
	select @empcnt = count(id) from Employee where Gender = @gen
	-- select count(*) from emplyee where gender='Male' -- count of male emp / female em[p
end

declare @emptotal int -- output/result stored in a var & execute all 3 lines together
exec empbygencount @gen ='Male', @empcnt = @emptotal out
print @emptotal

declare @emptotal int -- output/result stored in a var & execute all 3 lines together
exec empbygencount @gen ='Male', @empcnt = @emptotal 
print @emptotal
if(@emptotal is null)
	print '@emptotal is null do add output/out keyword'
else
	print '@emptotal is not null'

-- use outside var to execute a sp
declare @newvar varchar(30) = 'Male'
exec emp_dept @gender= @newvar , @deptid = 1

sp_help emp_dept

sp_depends emp_dept

-- return variable --alternative of out to get o/p from query in a var
create proc totalrows
as
begin
	return(select  count(*) from Employee)
end
declare @NumRows int --stores o/p of return
exec @NumRows = totalrows
print @NumRows --or select @NumRows

