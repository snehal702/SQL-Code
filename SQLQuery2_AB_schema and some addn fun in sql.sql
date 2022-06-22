--schema and tablw  withion it created
create schema Secure_Audit authorization dbo 
create table Emp_Audit(emp_id int not null)

--create 2 users to provide security role/ some authrization to them for the schema created above : how will they be a=ble to 
--access the schema and tables within it
--create users and then provide security roles or some authoriztion to access schema adm tables within it
grant select on SCHEMA::Secure_Audit to staff_audit --user 1 granted access to select table under schema and manipulate it
deny select on SCHEMA::Secure_Audit to biz_user --user 2 denioed the same access

--some addditional functions in sql
select emp_no, last_name, len(last_name) as namelen from Employees --len fun
select emp_no, first_name, last_name, left(first_name,1) as Initial from Employees --left fun : gives no. of char specified for the exp from left
select emp_no, first_name, last_name, left(first_name,1)+'.'+left(last_name,1)+'.'  as NameInitials
from Employees --to use first and last name to get initials of aname
select emp_no, first_name, last_name, right(first_name,3) from Employees --to see right se char of a name
select * from Current_Personnel where CHARINDEX('N.',current_location) >0  --to see index of char in string with where it gives searched str as o/p
select CHARINDEX('etz',current_location)  as Match_position,* from Current_Personnel --w/o where at the start it gives index postn
select *,  replace(current_location,'N.', 'North') as updatedcol from Current_Personnel where CHARINDEX('N.',current_location) >0  --to see index of char in string

--loops in sql
declare @counter int = 1 --i =1, intialize i
while @counter < 25 --create lop and tell them run the loop 25times
begin --start the loop
print @counter --print the value before increment
set @counter = @counter + 1 --increment and rerun the lop till i<25
end --stope after completion of whole loop

declare @tdate table(wnum int, wdate date)
declare @num int = 1
declare @date date ='2020-12-31'
while @num < 53
begin
insert into @tdate(wnum, wdate)
values  ---to prict the var creadted using declare
(@num, dateadd(wk, @num, @date))
set @num =@num+1
end

select * from @tdate

---union and union all
select * from Departments --11rows
select * from Departments
union --takes only distinct or uniqiue values from both tables -unique 11 rows only
select * from Departments

select * from Departments
select * from Departments
union all--takes all values duplicates too from both tables -22rows of both tables
select * from Departments

--intersect and inner join both gives matching records but 1st filters null values later doesnt
select * from Departments
select * from Departments
intersect --excludes null
select * from Departments

select * from Departments 
select dep.sid_Department, dep.dept_no, dep1.dept_name from Departments dep inner join Departments dep1 on dep.sid_Department = dep1.sid_Department
--includes null

--to improve query performance : index option
select count(distinct(sid_Employee))  from Payroll.Employee_Payroll where Pay_Date ='2019-07-15'