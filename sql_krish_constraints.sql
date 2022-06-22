use customers;
create table students(
id int not null,
first_name varchar(25) not null,
last_name varchar(25) not null,
age int);

desc students;
alter table students
modify column age int not null;
alter table students
modify column id int not null unique; -- unique values in id col ; since we had id as not null already and now added unique constraint to it 
-- it became a primary key

alter table students
add unique(first_name);
alter table students
add constraint uc_students unique(age, first_name);
alter table students
drop constraint uc_students;

create table person(
id int not null,
first_name varchar(25) not null,
last_name varchar(25),
age int,
constraint pk_person primary key(id, last_name)); -- two primary keys

desc person;
alter table person
drop primary key;
drop table person;


create table person(
id int not null,
first_name varchar(25) not null,
last_name varchar(25),
age int,
constraint pk_person primary key(id, last_name)); -- two primary keys

drop table person;
-- foreign key
create table person(
id int not null,
first_name varchar(25) not null,
last_name varchar(25) not null,
age int,
salary int,
primary key(id));

desc person;
create table department(
id int not null,
dept_id int not null,
dept_name varchar(25) not null,
primary key(dept_id),
constraint fk_persondept foreign key (id) references person(id));
desc department;

drop table person;
drop table department;
create table person(
id int not null,
first_name varchar(25) not null,
last_name varchar(25) not null,
age int,
salary int,
primary key(id),
check(salary <50000));
desc person;

insert into person values(1, 'krsih', 'naik', 31, 55000); # it gives error saying check constraint violated on salary

alter table person
add constraint chk_person check(salary <50000 and age>=18);
alter table person
drop constraint chk_person ;
drop table person;

create table person(
id int not null,
first_name varchar(25) not null,
last_name varchar(25) not null,
age int,
salary int,
primary key(id),
check(salary <50000),
city varchar(25) default 'Banglore');
desc person;
alter table person
alter city drop default;

