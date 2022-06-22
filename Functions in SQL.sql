use db2
-- FUNCTIONS:
create table employee
(Empid int not null identity primary key,
EmpName varchar(30) not null,
EmpContact varchar not null,
EmpEmail varchar(50) not null,
EmpDept varchar(30) not null,
EmpCity varchar(30) not null,
salary int not null)

alter table employee
alter column EmpContact varchar(30)

insert into employee(EmpName,EmpContact,EmpEmail, EmpDept, EmpCity, salary) values
('rakesh', '9924194054', 'rakeshchavda404@gmail.com', 'computer', 'ahemdabad', 20000),
('karan', '9874000123', 'kk@ymail.com', 'account', 'mumbai', 19000),
('Keval', '8425225523', 'keval@gmail.com', 'management', 'mumbai', 17000),
('rina', '7021194054', 'rina@yahoo.in', 'account', 'ahemdabad', 25000),
('rahul', '9935780541', 'rahul707@gmail.com', 'account', 'vishakapatnam', 15000),
('rohan', '9987524054', 'rohan123@yahoo.in', 'computer', 'vishakapatnam', 10000),
('ketan', '8875894054', 'krtan09@yahoo.com', 'computer', 'mumbai', 16000),
('aman', '9924132895', 'aman@gmail.com', 'management', 'ahemdabad', 23000)

-- inline table valued function
create function fnempinfo() -- fun creation with no i/p parameters : table variable returned whose value comes from single select statement
returns Table
as
return (select * from employee)

select * from fnempinfo()

-- multi statement table valued fun : create a fun for empname , empid, salary
create function fn_multistatementinfo()
returns @Emp Table -- explicitylit declare table variable
(Empid int ,
EmpName varchar(30),
salary int)
as
begin
insert into @Emp select e.Empid, e.EmpName, e.salary from employee e
update @Emp set salary =25000 where Empid=2
return 
end

select * from fn_multistatementinfo()


-- scalar valued function : returns a single value based on actions performed in the functions
create function fn_singlevalueds(@EmpContact nchar(15), --i/p parameters to the fun
   @EmpEmail nvarchar(50),  
   @EmpCity varchar(30)  
)  
returns varchar(101)
as
begin
return (select @EmpContact+' '+@EmpEmail+' '+@EmpCity);
end

select dbo.fn_singlevalueds(EmpContact, EmpEmail, EmpCity)  as name, salary from employee

-- system valued function
create function fn_printnum() -- returns a decimal value
returns decimal(7,2)
as
begin
return 1003.12
end
print dbo.fn_printnum()

-- fn to add two nums -- scalar func
create function fn_addnum(@num1 int, @num2 int)
returns int
as
begin
declare @result int
set @result = @num1 + @num2
return @result
end

print dbo.fn_addnum(2,3)


-- multi valued fun
create function splitstr(@str varchar(101), @delimiter nvarchar(1)) -- delimiter on which char its splitting
returns @table table(splited_str varchar(10) not null)
as
begin
insert into @table select value from string_split(@str, @delimiter) where value <> '' -- making sure retunred value after split is not null
return
end

select * from splitstr('a,b,c,d,e', ',')




