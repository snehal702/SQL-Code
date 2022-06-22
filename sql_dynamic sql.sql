-- dynamic sql
use db2
Go
Declare @tables varchar(50)
Declare @colist varchar(1000)
Declare @Query varchar(1000)
Set @tables='employee';
Set @colist='EmpName, EmpEmail, EmpDept, salary';
Set @Query=concat('select ' ,@colist, ' from ' ,@tables);
print @Query
Execute (@Query);-- execute all together in a batch
-- we can change all the above varaiblees anytime we want before executing ie. any table abny cols any query
-- same thing can be done in a  sp as follows
create procedure sqldynamic(@tables varchar(50), @colist varchar(1000), @ename varchar(50))
as
begin
Declare @query varchar(1000)
set @query= concat('select ' ,@colist, ' from ' ,@tables, ' where EmpName=' ,''''+@ename+'''');

-- exec sp_rename 'employee.EmpName', 'Empname'
print(@query)
exec (@query)
end

exec sqldynamic 'employee','EmpName, EmpEmail, EmpDept, salary', 'rakesh';

-- to get rid of inverted comma along ename use exec sp_executesql

alter procedure sqldynamic(@tables varchar(50), @colist varchar(1000), @ename varchar(50))
as
begin
Declare @query nvarchar(1000)
set @query=concat('select ' ,@colist, ' from ' ,@tables, ' where Empname=@empname');
print(@query)
Exec sp_executesql @query,N'@empname varchar(50)',@empname=@ename
end

exec sqldynamic @tables='employee', @colist='EmpName, EmpEmail, EmpDept, salary',@ename= 'rakesh'

Declare @decision varchar(1)
Set @decision ='C'
Declare @fun varchar(100)
Declare @dynamicsql varchar(1000)

if(@decision ='C')
begin
	set @fun = 'count(*) as totalcount'
end
else if(@decision ='A')
begin
	set @fun = 'Avg(salary) as avgsal'
end
else
begin
	set @fun = 'sum(salary) as sumsal'
end
set @dynamicsql = concat('select ',@fun, ' from employee')
print(@dynamicsql)
exec(@dynamicsql)

select * from information_schema.tables
use [AdventureWorks2019]
select * from information_schema.TABLE_CONSTRAINTS where TABLE_NAME ='SalesPerson'


use db2
create table xyz(empid int, empname varchar(50), eccode varchar(50));
insert into xyz values(1,'John', '555-555-5555'),(2,'Cena', '575-895-5435'),(1,'John', '555-555-5555'),(3,'Bob', '666-666-6666'),(4,'Rina', '547-895-6531');

select * from xyz;
with t1 as
       (select *,  row_number() over(partition by empid order by empid) as rn from xyz) 
delete from t1 where rn >1;




UPDATE e
SET salary = t.salary
FROM employee e
JOIN (
    VALUES
        (4, 23000),
        (7, 19000),
		(8, 25000)
) t (Empid, salary) ON t.Empid = e.Empid

select Empname from employee where salary in (select salary from employee group by salary having count(*) >1) 