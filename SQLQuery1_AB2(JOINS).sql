use [Human_Resources]
select * from [dbo].[Employees]
select* from dbo.Gender
--inner joins
select a.[emp_no], a.[birth_date], a.[first_name], b.[gender], b.[gender_name]
from [dbo].[Employees] a inner join [dbo].[Gender] b on a.gender = b.gender

--or can write like this also
select emp_no, birth_date, first_name,gender_name, emp.gender from Employees emp inner join Gender gen on gen.gender = emp.gender

--left join
select emp_no, first_name, last_name, position, from_date, emp.sid_Employee from Employees emp left join Managers mgr on emp.sid_Employee = mgr.sid_Employee
--sorting this data on postion col
select emp_no, first_name, last_name, position, from_date, emp.sid_Employee from Employees emp left join Managers mgr 
on emp.sid_Employee = mgr.sid_Employee order by position desc --order by can be done by col number also (4) instaed of position
--since lots of null vaues in mgr table it needs too be updted not maintained correctly

--right join
select gen.gender,gender_name, emp_no, birth_date, first_name from Employees emp right join Gender gen on gen.gender = emp.gender

--full outer join
select * from Current_Personnel --this incudes info abt emp still active in the organization
select * from Geography --this gives geographical location/demographic details of all emp
select emp_no, current_location, City, CountryRegionName from Current_Personnel cp full join Geography geo 
on cp.sid_Location = geo.sid_Location order by emp_no -- null in emp_no cp table yet tobe updated may be new joinees no id

--same joins on multiple tables together
select emp.emp_no, first_name, last_name, position,from_date, sh.current_salary, sh.sal_from_date, sh.sal_to_date 
from Employees emp inner join Managers mgr on emp.sid_Employee = mgr.sid_Employee  --1st join 2 tables on common col and then
inner join Salary_History sh on emp.sid_Employee = sh.sid_Employee--their o/p with 3rd table on common col from either of 2 tables and 3rd table

--multiple join types on multiple tables
---req is we need to verify emp details of emp provided by them if they have given correct address/ loc details with comparison to master data from geo table
--i.e. local zipcode given by emp is correct / not by geo table
-- so we will first get details of emp common/ available in both employee n loc table then for those emp loc we need to match and see if 
--avialble in master geo table so only matching records (like lookup) from master table needed as per our 1st o/p so left join
select emp.emp_no, first_name, last_name, el.PostalCode as localcode, geo.PostalCode as globalcode
from Employees emp inner join Employee_Location el on emp.sid_Employee = el.sid_Employee 
left join Geography geo on el.PostalCode = geo.PostalCode --since only matching records of our 1st o/p needed to verify with master data from geo table
--if both local and global matches its corrdct info else not so either emp entered wrong or master table not updated

--self join
select * from Management.EmployeeManagerTree --empid his mgr id and name of emp
--if we see 1000 record mgrid 1000 is obv alos eid of company but there is null against his mgr id since he is ceo and reports to none
--so we see eid 1000 who is mgr to eid1 georgia is actually ceo and georgia cfo who directly reports to ceo 1000
--now we have eid.mid, ename,mname all these 4 col data in 3 cols only ename and mname in same col fullname
--so requirement is to extract 3 cols ka data from same table into sep 4 cols as i mentioned ename n mname sep against their resp ids
--so we need to do self join on same table itself and join on col of similar dtypes i.e. eid and mid here
select emt1.sid_Employee, emt1.FullName, emt1.sid_Manager, emt2.FullName 
from Management.EmployeeManagerTree emt1 left join Management.EmployeeManagerTree emt2 on emt1.sid_Manager = emt2.sid_Employee
--so this on col will give last fumllname col details of all mgrid which are empid i.e. for 1000mid wherever in eid its present give the name against it
--and so we get eid enmae mid mname since name is available for eid and each mid is a eid so where mid = eid uske against ka naam de do
select emt1.sid_Employee, emt1.FullName as empname, emt1.sid_Manager, emt2.FullName  as mgrname
from Management.EmployeeManagerTree emt1 left join Management.EmployeeManagerTree emt2 on emt2.sid_Employee = emt1.sid_Manager 

use [join_sql]
select * from test
select * from [dbo].[export]
select * from [dbo].[iris_test]
select * from [dbo].[export] where prod_name like '[MAP]%'
select * from [dbo].[export] where prod_name like '[M-P]%'