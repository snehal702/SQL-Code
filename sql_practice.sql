/*create database films;
use films;
drop database films;*/
use lco_films;
show tables;
select * from category;
select * from film;
select * from film_category;
desc address;
#Q1) Which categories of movies released in 2018? Fetch with the number of movies. --first join together table film and category to get id and releae date
# next both are linked in film_category table use it 
-- combine film and film_cat to get cat_id in film and then o/p with cat to get answer
select a.film_id, name, release_year, b.category_id, count(a.film_id) from ((film a left join film_category b on a.film_id = b.film_id) 
right join category c on b.category_id = c.category_id) where release_year=2018 group by name;

-- combine cat and film_cat to get film_id in cat and then o/p with film to get answer
select name, release_year, a.film_id, c.category_id, count(a.film_id) from ((category c left join film_category a on a.category_id = c.category_id)
right join film b on a.film_id = b.film_id) where  release_year = "2018" GROUP BY c.category_id;

#Q2)Update the address of actor id 36 to “677 Jazz Street”.
select * from address;
update address
inner join actor on address.address_id = actor.address_id
set address.address ='677 Jazz Street' where actor.actor_id =36;
select * from address where address_id =35;

#Q3) Add the new actors (id : 105 , 95) in film  ARSENIC INDEPENDENCE (id:41).
select * from film_actor where film_id=41;
select * from film_actor where film_id =41; -- update multiple rows , add these two actors to the already set 41
desc film_actor; -- since actor and film id both are pk update on duplicate col is done
insert into film_actor(actor_id, film_id)
values(105,41), (95,41) as var
on duplicate key update actor_id = var.actor_id, film_id =var.film_id;

#Q4) Get the name of films of the actors who belong to India.
select * from country;
select * from film;
-- now film actor country countries are given by cities, cities of a country put together 
-- to reach country from films we have a flow filmactor se get actorid in films then actorid se addrid then addrid se cityid then cityid se countryid
select distinct(film.title) from (((((film inner join film_actor on  film_actor.film_id=film.film_id) inner join
actor on actor.actor_id = film_actor.actor_id) inner join address on address.address_id = actor.address_id) inner join
city on city.city_id = address.city_id) inner join country on country.country_id = city.country_id) where country='India';

#Q5) How many actors are from the United States?
select count(actor.actor_id) from (((actor inner join address on address.address_id = actor.address_id) inner join 
city on city.city_id = address.city_id) inner join country on country.country_id = city.country_id) where country='United States';

#Q6) Get all languages in which films are released in the year between 2001 and 2010.
select * from film;
select * from language;
select name, release_year,count(language.language_id) as no_of_films from language left join film on film.language_id = language.language_id 
where release_year between 2001 and 2010 group by name;

#Q7)The film ALONE TRIP (id:17) was actually released in Mandarin, update the info.
select * from film where film_id  = 17;
update film 
set film.language_id=(select language_id from language where name ='Mandarin') where film.film_id =17;
select * from film where film_id =17;

#Q8) Fetch cast details of films released during 2005 and 2015 with PG rating.
select * from film;
select * from actor;
select * from film_actor;
select concat(first_name, ' ', last_name) as cast, title, release_year, rating from actor inner join film_actor 
on film_actor.actor_id = actor.actor_id inner join film on film.film_id =film_actor.film_id where (release_year between 2005 and 2015) and rating ='PG';

#Q9) In which year most films were released?
use lco_films;
select * from film;
select count(distinct(film_id)) as movie_count, release_year from film group by release_year order by movie_count desc limit 1;

#Q10) In which year least number of films were released?
select * from film;
select count(distinct(film_id)) as movie_count, release_year from film group by release_year order by movie_count  limit 1;

#Q11) Get the details of the film with maximum length released in 2014 .
select *, name from film left join language on language.language_id = film.language_id where length =(select max(length) from film) and release_year=2014;

#Q12) Get all Sci- Fi movies with NC-17 ratings and language they are screened in.
select description, film.film_id, release_year, length,title, category.name, rating, language.name 
FROM film LEFT JOIN language ON language.language_id=film.language_id 
right join film_category on film.film_id  = film_category.film_id 
left join category on category.category_id =film_category.category_id   where category.name='Sci-Fi' and rating ='NC-17';

#Q13)The actor FRED COSTNER (id:16) shifted to a new address: 055,  Piazzale Michelangelo, Postal Code - 50125 , District - Rifredi at Florence, Italy.
#Insert the new city and update the address of the actor.  -- update on address table adddress, postalcode, district
#insert in city 
select * from address;
select * from city where country_id=49;
select country_id from country where country='Italy';
insert into city(city , country_id) values('Florida', (select country_id from country where country ='Italy')); -- just like insertion of a new record
select * from city where country_id=49;
update address
inner join actor on  address.address_id= actor.address_id
set address='055,  Piazzale Michelangelo', postal_code =50125, district ='Rifredi', city_id =(select city_id from city where city='Florida')
where actor.actor_id = 16;
select * from address where address_id=65 ;

/*Q14) A new film “No Time to Die” is releasing in 2020 whose details are : 
Title :- No Time to Die
Description: Recruited to rescue a kidnapped scientist, globe-trotting spy James Bond finds himself hot on the trail of a mysterious villain, who's armed with a dangerous new technology.
Language: English
Org. Language : English
Length : 100
Rental duration : 6
Rental rate : 3.99
Rating : PG-13
Replacement cost : 20.99
Special Features = Trailers,Deleted Scenes
Insert the above data. */
INSERT INTO film(`title`, `description`, `release_year`, `language_id`, `original_language_id`, `rental_duration`, `rental_rate`, 
`length`, `replacement_cost`, `rating`, `special_features`) VALUES 
("No Time to Die",  "Recruited to rescue a kidnapped scientist, globe-trotting spy James Bond finds himself hot on the trail of a mysterious villain, 
who's armed with a dangerous new technology.", 2020 , (SELECT language.language_id FROM language WHERE language.name = "English"), 
(SELECT language.language_id FROM language WHERE language.name = "English"), 6, 3.99, 100, 20.99, "PG-13", "Trailers,Deleted Scenes" );

select * from film where title='No Time to Die';
select * from film_category where film_id = 1001;
#Q15) Assign the category Action, Classics, Drama  to the movie “No Time to Die” .
insert into film_category(category_id,film_id) values
((select category_id from category where name ='Action'), (select film_id from film where title='No Time to Die')), #1st row for action cat
((select category_id from category where name ='Classics'), (select film_id from film where title='No Time to Die')), #2nd row for classic cat
((select category_id from category where name ='Drama'), (select film_id from film where title='No Time to Die')); #3rd row for drama cat

#Q16) Assign the cast: PENELOPE GUINESS, NICK WAHLBERG, JOE SWANK to the movie “No Time to Die” .
select * from film_actor where film_id =1001;
select * from actor;
insert into film_actor(actor_id , film_id) values
((select actor_id from actor where first_name='PENELOPE'and last_name='GUINESS'), (select film_id from film where title='No Time to Die')),
((select actor_id from actor where first_name='NICK' and last_name='WAHLBERG'), (select film_id from film where title='No Time to Die')),
((select actor_id from actor where first_name='JOE' and last_name='SWANK'), (select film_id from film where title='No Time to Die'));
select * from film_actor where film_id=1001;

#Q17) Assign a new category Thriller  to the movie ANGELS LIFE
select * from film where title ='Angels Life';
select * from film_category where film_id =25;
select * from category where category_id=13;
insert into category(name) values('Thriller');
insert into film_category(film_id, category_id) values((select film_id from film where title='ANGELS LIFE'),(select category_id from category where
name ='Thriller'));

select * from category where name='Thriller';
select * from film_category where film_id =(select film_id from film where title='ANGELS LIFE');

#Q18) Which actor acted in most movies?
select actor_id, count(film_id) as no_of_movies from film_actor group by actor_id order by no_of_movies desc limit 1;

#Q19) The actor JOHNNY LOLLOBRIGIDA was removed from the movie GRAIL FRANKENSTEIN. How would you update that record?
delete from film_actor where actor_id =(select actor_id from actor where first_name ='JOHNNY' and last_name ='LOLLOBRIGIDA') and
film_id = (select film_id from film where title = 'GRAIL FRANKENSTEIN');

select * from film_actor where actor_id =(select actor_id from actor where first_name ='JOHNNY' and last_name ='LOLLOBRIGIDA'); -- no film_id as 375 to him

#Q20) The HARPER DYING movie is an animated movie with Drama and Comedy. Assign these categories to the movie.
select * from film where title = 'HARPER DYING';
select * from film_category where film_id = 402;
select * from category;
select * from film_category where film_id =(select film_id from film where title ='HARPER DYING');
select * from category; 
-- so need to update same key film_id = 402 pe 2,5,7 as cat_id ie. insert on duplicate key
insert into film_category(category_id, film_id) values
((select category_id from category where name ='Drama'), (select film_id from film where title ='HARPER DYING')),
((select category_id from category where name ='Comedy'), (select film_id from film where title ='HARPER DYING')) as var
on duplicate key update category_id= var.category_id ,film_id=var.film_id;

#Q21) The entire cast of the movie WEST LION has changed. 
#The new actors are DAN TORN, MAE HOFFMAN, SCARLETT DAMON. How would you update the record in the safest way?
delete from film_actor where film_id=(select film_id from film where title ='West Lion');
insert into film_actor (`actor_id`, `film_id`) VALUES ((SELECT actor_id FROM actor WHERE actor.first_name = "DAN" AND actor.last_name="TORN"), (SELECT film_id FROM film WHERE film.title="WEST LION")),
((SELECT actor_id FROM actor WHERE actor.first_name = "MAE" AND actor.last_name="HOFFMAN"), (SELECT film_id FROM film WHERE film.title="WEST LION")),
((SELECT actor_id FROM actor WHERE actor.first_name = "SCARLETT" AND actor.last_name="DAMON"), (SELECT film_id FROM film WHERE film.title="WEST LION"));

#Q22) The entire category of the movie WEST LION was wrongly inserted.
 #The correct categories are Classics, Family, Children. How would you update the record ensuring no wrong data is left?
 DELETE FROM film_category WHERE film_id = (SELECT film_id FROM film WHERE film.title = "WEST LION");
 INSERT INTO film_category(`category_id`, `film_id`) VALUES 
 ((SELECT category_id FROM category WHERE category.name = "Classics"), (SELECT film_id FROM film WHERE film.title="WEST LION")), 
 ((SELECT category_id FROM category WHERE category.name = "Family"), (SELECT film_id FROM film WHERE film.title="WEST LION")), 
 ((SELECT category_id FROM category WHERE category.name = "Children"), (SELECT film_id FROM film WHERE film.title="WEST LION"));
 
 #Q23) How many actors acted in films released in 2017?
 select count(*) as totalno_of_actors from film_actor inner join film on film.film_id = film_actor.film_id where release_year=2017;
 
 #Q24) How many Sci-Fi films released between the year 2007 to 2017?
 select count(film.film_id) from film_category inner join film on film.film_id = film_category.film_id where category_id =(select category_id from category 
 where name ='Sci-Fi') and release_year between 2007 and 2017;
 
 SELECT COUNT(*) FROM `film_category` INNER JOIN film ON film.film_id=film_category.film_id 
 INNER JOIN category ON category.category_id=film_category.category_id WHERE film.release_year BETWEEN 2007 AND 2017 AND category.name="Sci-Fi";
 
#Q25) Fetch the actors of the movie WESTWARD SEABISCUIT with the city they live in.
select concat(first_name,' ', last_name) as actor_name, city, title, film.film_id from ((((actor inner join film_actor on film_actor.actor_id = actor.actor_id)
inner join film on film.film_id= film_actor.film_id) inner join address on address.address_id =  actor.address_id) 
inner join city on city.city_id = address.city_id) where title = 'WESTWARD SEABISCUIT';
 
 
#Q26) What is the total length of all movies played in 2008?
select sum(length) from film where release_year=2008;

#Q27) Which film has the shortest length? In which language and year was it released?
select title, length, name, release_year from film f left join language l on l.language_id=f.language_id where length =(select min(length) from film);
select film.film_id, title, length, release_year ,name from film left join language on language.language_id = film.language_id 
where length =(select min(length) from film);

#Q28) How many movies were released each year?
select count(*) , release_year from film group by release_year order by release_year;

#Q29)  How many languages of movies were released each year?.-- ek language mei how many movies was released every year
select * from language;
select name, count(language.language_id) as langcnt from film inner join language on language.language_id = film.language_id 
group by name;
select name, release_year, count(language.language_id) as langcnt from film inner join language on language.language_id = film.language_id 
group by release_year;
#Q30) Which actor did least movies?
select  actor_id, count(actor_id) as no_of_movies from  film_actor group by actor_id order by no_of_movies limit 1;


## 2. lco_car_rentals
use lco_car_rentals;
show tables;	
#1Insert the details of new customer:-
select * from customer;
insert into customer(first_name, last_name, dob,driver_license_number,email)  values
('NancyPerry1988-05-16K59042656Enancy@gmail.com');

#Q2) The new customer (inserted above) wants to rent a car from 2020-08-25 to 2020-08-30. More details are as follows:
select * from rental; 
select * from vehicle; select * from vehicle_type;
select * from fuel_option;
select * from location; select * from customer;
insert into rental(start_date,end_date, customer_id, vehicle_type_id, fuel_option_id, pickup_location_id,drop_off_location_id) values
('2020-08-252020-08-30',(select id from customer where first_name ='Nancy'), (select id from vehicle_type where name ='Economy SUV'),
(select id from fuel_option where name ='Market'), (select id from location where street_address ='5150 W 55th St'),
(select id from location where street_address ='9217 Airport Blvd')); -- take zipcode instaed of name since name can be repeated

#Q3) The customer with the driving license W045654959 changed his/her drop off location to 1001 Henderson St,  
#Fort Worth, TX, zip - 76102  and wants to extend the rental upto 4 more days. Update the record.
select * from customer; select * from rental; select * from location;
update rental r
inner join customer c on r.customer_id =c.id
set drop_off_location_id = (select id from location where zipcode = 76102 ) , end_date =(select end_date +INTERVAL 4 DAY) -- from not wrote here bcoz endate from same table
where c.driver_license_number = 'W045654959'; 

#Q4) Fetch all rental details with their equipment type.
#ie. rental mei for each id of rental we have custid and all other ids so instead of id get their values from repective tables for each record in rental
select * from `equipment_type`; select * from rental; select * from `rental_has_equipment_type`; select * from equipment;
select * from vehicle_has_equiment; select * from location;
select concat(c.first_name, ' ', c.last_name) as custname, c.driver_license_number, r.start_date, r.end_date,
vt.name as veh_typename , fo.name as fuel_optionname, concat(pl.street_address, , pl.city, , pl.state, , pl.zipcode) as pickup_loc,
concat(dl.street_address, , dl.city, , dl.state, , dl.zipcode) as drop_off_loc, et.name as equip_type
from rental r inner join customer c on c.id = r.customer_id inner join vehicle_type vt on vt.id = r.vehicle_type_id inner join
fuel_option fo on fo.id = r.fuel_option_id inner join location pl on pl.id = r.pickup_location_id inner join location dl on dl.id = r.drop_off_location_id
inner join rental_has_equipment_type ret on ret.rental_id = r.id inner join equipment_type et on et.id  = ret.equipment_type_id;

#Q5) Fetch all details of vehicles. for each row in vehicles get their resp id columns ka values from resp tables
select v.brand, v.model, v.model_year, v.mileage, v.color,vt.name as vehicle_typename, 
concat(l.street_address, , l.city, , l.state, , l.zipcode) as current_loc from 
vehicle v inner join vehicle_type vt on vt.id = v.vehicle_type_id inner join location l on l.id = v.current_location_id;

#Q6) Get driving license of the customer with most rental insurances. -- count of rental id jiske pass max num of insurance id hoga uska licence num
select * from customer; select * from rental; select * from rental_has_insurance; select * from insurance;
select concat(c.first_name,' ',c.last_name) as custname, c.driver_license_number, count(ri.rental_id) as no_of_insurances
from customer c left join rental r on r.customer_id = c.id left join rental_has_insurance ri on ri.rental_id = r.id 
group by ri.rental_id order by no_of_insurances desc limit 1;
-- rental_id corresponds to cust _id

#Q7) Insert a new equipment type with following details.
select * from equipment_type; select * from equipment;
insert into equipment_type (name, rental_value) values('Mini TV', 8.99);

#Q8) Insert a new equipment with following details:
select * from equipment_type; select * from equipment; select * from location;
insert into equipment (name, equipment_type_id,current_location_id) values
('Garmin Mini TV', (select id from equipment_type where name = 'Mini TV'), (select id from location where zipcode =60638));

#Q9) Fetch rental invoice for customer (email: smacias3@amazonaws.com).
select c.id as custid, concat(c.first_name,' ', c.last_name) as name,c.email,ri.rental_id, ri.car_rent, ri.equipment_rent_total, ri.insurance_cost_total,
ri.tax_surcharges_and_fees,ri.total_amount_payable, ri.discount_amount, ri.net_amount_payable
from rental_invoice ri left join rental r on r.id = ri.rental_id left join customer c on c.id = r.customer_id where c.email = 'smacias3@amazonaws.com';

-- whenever u want info for each row in a table use left join / right jpoin acc as per requ and inner only when common needed

#Q10) Insert the invoice for customer (driving license: ) with following details:-
select * from rental_invoice; select * from customer; select * from rental;
insert into rental_invoice(`car_rent`, `equipment_rent_total`, `insurance_cost_total`, `tax_surcharges_and_fees`, `total_amount_payable`, 
`discount_amount`, `net_amount_payable`, `rental_id`) values
(785.4, 114.65, 688.2, 26.2, 1614.45, 213.25, 1401.2,(select r.id from rental r inner join customer c on c.id = r.customer_id 
where c.driver_license_number = "K59042656E"));

#Q11) Which rental has the most number of equipment.
select * from rental; select * from rental_has_equipment_type;
select rental_id, count(rental_id) as num_of_equipment from rental_has_equipment_type group by rental_id order by num_of_equipment desc limit 1;

#Q12) Get driving license of a customer with least number of rental licenses.
select c.driver_license_number, count(ri.rental_id) as num_rental_licenses from 
customer c left join rental r on r.customer_id = c.id left join rental_has_insurance ri on ri.rental_id = r.id
group by ri.rental_id order by num_rental_licenses asc limit 1;

#Q13) Insert new location with following details.
select * from location;
insert into location(street_address, city, state, zipcode) values('1460  Thomas Street' , 'Burr RidgeIL', 61257);

#Q14) Add the new vehicle with following details:-
select * from vehicle;
insert into vehicle(`brand`, `model`, `model_year`, `mileage`, `color`, `vehicle_type_id`, `current_location_id`) values
('TataNexon', 2020, 17000, 'blue', (select id from vehicle_type where name = 'Economy SUV'), (select id from location where zipcode = 20011));

#Q15) Insert new vehicle type Hatchback and rental value: 33.88.
select * from vehicle; select * from vehicle_type;
insert into  vehicle_type(name, rental_value) values('Hatchback', 33.88);

#Q16) Add new fuel option Pre-paid (refunded).
select * from fuel_option;
INSERT INTO `fuel_option`(`name`, `description`) VALUES ("Pre-paid (refunded)" , 
"Customer buy a tank of fuel at pick-up and get refunded the amount customer don’t use.");

#Q17) Assign the insurance : Cover My Belongings (PEP), Cover The Car (LDW) to the rental started on 25-08-2020 (created in Q2) 
#by customer (Driving License:K59042656E).
select * from insurance; select * from rental; select * from rental_has_insurance; select * from customer;
insert into rental_has_insurance(rental_id,insurance_id ) values
((select id from rental where start_date = '2020-08-25'), (select id from insurance where name ='Cover My Belongings (PEP)')),
((select id from rental where start_date = '2020-08-25'), (select id from insurance where name ='Cover The Car (LDW)')) as x
on duplicate key update
rental_id=x.rental_id, insurance_id = x.insurance_id;
# or 
INSERT INTO `rental_has_insurance` (`rental_id`, `insurance_id`) VALUES 
((SELECT rental.id FROM rental INNER JOIN customer ON customer.id=rental.customer_id WHERE rental.start_date="2020-08-25" AND 
customer.driver_license_number="K59042656E"), (SELECT insurance.id FROM insurance WHERE insurance.name = "Cover My Belongings (PEP)")), 
((SELECT rental.id FROM rental INNER JOIN customer ON customer.id=rental.customer_id WHERE rental.start_date="2020-08-25" AND 
customer.driver_license_number="K59042656E"), (SELECT insurance.id FROM insurance WHERE insurance.name = "Cover The Car (LDW)"));

#Q18) Remove equipment_type :Satellite Radio from rental started on 2018-07-14 and ended on 2018-07-23.
select * from equipment_type; select * from rental_has_equipment_type; select * from rental;
delete from rental_has_equipment_type 
where rental_id= (select id from rental where start_date ='2018-07-14' and  end_date='2018-07-23')
and equipment_type_id = (select id from equipment_type where name ='Satellite Radio');
 # or #
delete from rental_has_equipment_type 
where rental_id = (select r.id as rental_id, e.id as equipid,e.name from rental r inner join rental_has_equipment_type ri on ri.rental_id=r.id 
inner join equipment_type e on e.id = ri.equipment_type_id where e.name='Satellite Radio' and r.start_date ='2018-07-14' and  r.end_date='2018-07-23');

#Q19) Update phone to 510-624-4188 of customer (Driving License: K59042656E).
select * from customer;
update customer
set phone = '510-624-4188' where driver_license_number = 'K59042656E';

#Q20) Increase the insurance cost of Cover The Car (LDW) by 5.65.
select * from insurance;
set sql_safe_updates =0;
update insurance
set cost = (select cost + 5.65) where name ='Cover The Car (LDW)';

#Q21) Increase the rental value of all equipment types by 11.25
update equipment_type
set rental_value = (select rental_value+11.25 );
select * from equipment_type;

#Q22) Increase the  cost of all rental insurances except Cover The Car (LDW) by twice the current cost.
select * from insurance;
update insurance
set cost = (select cost*2) where name <> 'Cover The Car (LDW)';

#Q23) Fetch the maximum net amount of invoice generated.
select max(net_amount_payable) from rental_invoice;

#Q24) Update the dob of customer with driving license V435899293 to 1977-06-22.
select * from customer;

#Q25)  Insert new location with following details.
update customer
set dob = '1977-06-22' where driver_license_number = 'V435899293';

#Q25)  Insert new location with following details.
insert into location(street_address, city, state, zipcode) values('468  Jett LaneGardenaCA', 90248);
select * from location;

#Q26) The new customer (Driving license: W045654959) wants to rent a car from 2020-09-15 to 2020-10-02. More details are as follows: 
select * from customer; select * from rental;
insert into rental(`start_date`, `end_date`, `customer_id`, `vehicle_type_id`, `fuel_option_id`, `pickup_location_id`, `drop_off_location_id`) 
values('2020-09-15','2020-10-02', (select id from customer where driver_license_number ='W045654959'),
(select id from vehicle_type where name = 'Hatchback'),(select id from fuel_option where name='Pre-paid (refunded)'),
(select id from location where zipcode = 90248),(select id from location where zipcode = 20011));

#Q27) Replace the driving license of the customer (Driving License: G055017319) with new one K16046265.
select * from customer;
update customer
set driver_license_number = 'K16046265' where driver_license_number = 'G055017319';

#Q28) Calculated the total sum of all insurance costs of all rentals. get the cost against each rental id and then take its sum
select * from rental_has_insurance;
select sum(cost) as totalsum from insurance i left join rental_has_insurance ri on ri.insurance_id = i.id;

#Q29) How much discount we gave to customers in total in the rental invoice?
select sum(discount_amount) as total_discount from rental_invoice;

#Q30) The Nissan Versa has been repainted to black. Update the record.
select * from vehicle;
update vehicle
set color = 'black' where brand = 'Nissan' and model = 'Versa';

use lco_motors;
#Q1) How would you fetch details of the customers  who cancelled orders?
select * from orders where status = 'Cancelled';
select c.*, o.status,o.customer_id from customers c left join orders o on o.customer_id = c.customer_id where o.status = 'Cancelled';

#Q2) Fetch the details of customers who have done payments between the amount 5,000 and 35,000?
select * from payments where amount between 5000 and 35000;
select c.*, p.amount from customers c left join payments p on p.customer_id = c.customer_id where p.amount between 5000 and 35000;

#Q3) Add new employee/salesman with following details:-
select * from e where employee_id = 15657;
insert into e(employee_id,last_name,first_name,extension,email,office_code, reports_to, job_title) values
(15657,'RoyLakshmix4065lakshmiroy1@lcomotors.com',4,1088, 'Sales Rep');

#Q4) Assign the new employee to the customer whose phone is 2125557413 .
select * from customers where phone = 2125557413;
set sql_safe_updates =0;
UPDATE `customers` SET  customers.sales_employee_id = 15657 WHERE customers.phone = '2125557413';

#Q5) Write a SQL query to fetch shipped motorcycles.
select * from orders; select * from orderdetails; select * from products;
select p.product_name, p.product_code, p.product_line, od.order_id, o.shipped_date, o.status 
from orders o left join orderdetails od on od.order_id = o.order_id  left join products p on p.product_code = od.product_code 
where status = 'shipped' and product_line ='Motorcycles';

#Q6) Write a SQL query to get details of all emp/salesmen in the office located in Sydney.
select * from e; select * from o;
select e.*, o.city, o.country from employees e left join offices o on o.office_code = e.office_code where city = 'Sydney';

#Q7) How would you fetch the details of customers whose orders are in process?
select * from  customers; select * from orders;
select c.*, o.status, o.comments from customers c inner join orders o on o.customer_id = c.customer_id where status='In Process';

#Q8) How would you fetch the details of products with less than 30 orders?
select * from products; select * from orderdetails; select * from  orders;
select p.*, od.each_price, od.product_code,pl.product_line, pl.description
from products p right join productlines pl on p.product_line=pl.product_line -- since i need all product lines ka all decriptions
left join orderdetails od on od.product_code = p.product_code where quantity_ordered =30;

#Q9) It is noted that the payment (check number OM314933) was actually 2575. Update the record.
select * from payments;
update payments
set amount = 2575 where check_number ='OM314933';

#Q10) Fetch the details of salesmen/e dealing with customers whose orders are resolved.
select * from e; select * from customers; select * from orders;
SELECT DISTINCT e.employee_id, e.first_name ,e.last_name, e.email, e.job_title, 
e.extension, customers.customer_id, orders.order_id, orders.status FROM employees e LEFT JOIN customers 
ON customers.sales_employee_id = e.employee_id RIGHT JOIN orders ON orders.customer_id = customers.customer_id 
WHERE orders.status = "Resolved";

#Q11) Get the details of the customer who made the maximum payment.
select * from payments; select * from customers;
select c.*, p.check_number, p.payment_date, p.amount, max(p.amount) as maxpayment
from customers c right join payments p on  c.customer_id = p.customer_id where amount= (select max(amount) from payments);

SELECT * FROM customers RIGHT JOIN payments ON customers.customer_id = payments.customer_id WHERE payments.amount = (SELECT MAX(amount) from payments);

#Q12) Fetch list of orders shipped to France.
select o.*, c.country from orders o left join  customers c on c.customer_id= o.customer_id where country  = 'France' and status ='Shipped';

#Q13) How many customers are from Finland who placed orders.
select count(c.customer_id) from  orders o left join customers c on c.customer_id = o.customer_id where country = 'Finland';

#Q14) Get the details of the customer and payments they made between May 2019 and June 2019.
select * from customers; select * from payments;
select c.*, p.payment_date, p.amount from customers c left join payments p on p.customer_id= c.customer_id 
where (month(payment_date) between '05' and'06') and (year(payment_date)='2019');

#Q16) How many orders shipped to Belgium in 2018?
select count(o.order_id) from orders o inner join customers c on c.customer_id = o.customer_id where country ='Belgium' and year(shipped_date)='2018';
SELECT  COUNT(orders.order_id) FROM orders INNER JOIN customers ON customers.customer_id = orders.customer_id WHERE customers.country = "Belgium" AND orders.shipped_date BETWEEN '2019-01-01' AND '2019-12-31';

#Q17) Get the details of the salesman/employee with offices dealing with customers in Germany.
select  e.employee_id, e.first_name ,e.last_name, e.email, e.job_title, e.extension,c.customer_id, c.sales_employee_id,c.country,
o.office_code, o.address_line1, o.address_line2, o.phone, o.city, o.state, o.country, o.postal_code, o.territory
from employees e inner join offices o on o.office_code = e.office_code left join customers c on c.sales_employee_id = e.employee_id 
where c.country = 'Germany';

#Q18) The customer (id:496 ) made a new order today and the details are as follows:
select * from orders where customer_id =496; select * from orderdetails where order_id =10426;
insert into orders(order_id, order_date,required_date,status,customer_id) values
(10426, current_date(), current_date() + interval 10 day, 'In Process', 496);
insert into orderdetails(`order_id`, `product_code`, `quantity_ordered`, `each_price`, `order_line_number`) 
VALUES ( 10426 , "S12_3148" ,  41, 151, 11);

#Q19) Fetch details of employees who were reported for the payments made by the customers between June 2018 and July 2018.
/*select e.employee_id,e.last_name,e.first_name,e.extension, e.email, c.customer_id, c.sales_employee_id, p.* from
employees e left join customers c on c.sales_employee_id = e.employee_id right join payments p on p.customer_id = c.customer_id
where payment_date between '2018-06-01' and '2018-07-31'; */ -- not this bcoz asked is the detaiols of those employess to whom some employees reported is asked 
select * from employees;
SELECT reported_emp.employee_id, reported_emp.first_name , reported_emp.last_name, reported_emp.email, reported_emp.job_title, 
reported_emp.extension , employees.employee_id AS reported_by_employee, customers.customer_id FROM employees 
JOIN employees reported_emp ON reported_emp.employee_id = employees.reports_to LEFT JOIN customers 
ON customers.sales_employee_id = employees.employee_id RIGHT JOIN payments 
ON payments.customer_id = customers.customer_id WHERE payments.payment_date BETWEEN '2018-06-01' AND '2018-07-31';

#Q20) A new payment was done by a customer(id: 119). Insert the below details.
select * from payments where customer_id = 119;
insert into payments values(119,'OM314944', current_date(), 33789.55);

#Q21) Get the address of the office of the employees that reports to the employee whose id is 1102.
select o.address_line1, o.address_line2,o.city,o.state,o.country,o.postal_code,o.territory,
e.employee_id , e.office_code, e.reports_to from offices o left join employees e on e.office_code =o.office_code where reports_to = 1102;
select * from employees where reports_to=1102;

#Q22) Get the details of the payments of classic cars.
select * from products; select * from productlines; select * from payments;
select p.check_number,p.payment_date,o.order_id, p.amount,p.customer_id  as done_by, pr.product_name, pr.product_line
from payments p right join orders o on o.customer_id =p.customer_id left join orderdetails od on od.order_id = o.order_id left join
products pr on pr.product_code = od.product_code where product_line='Classic Cars';

#Q23) How many customers ordered from the USA?
select count(c.customer_id) from orders o left join customers c on c.customer_id = o.customer_id where country ='USA';

#Q24) Get the comments regarding resolved orders.
select customer_id,comments from orders where status = 'Resolved';

#Q25) Fetch the details of employees/salesmen in the USA with office addresses.
select e.employee_id, e.last_name, e.first_name,e.extension, e.email, o.address_line1, o.address_line2,o.city,o.state,o.country,
o.postal_code,o.territory from employees e left join offices o on o.office_code =e.office_code where country ='USA';

#Q26) Fetch total price of each order of motorcycles. (Hint: quantity x price for each record).
select * from products; select * from orderdetails;
select o.order_id, o.product_code, o.quantity_ordered,o.each_price,p.product_name, p.product_line,(quantity_ordered *each_price) as totalprice from
orderdetails o left join products p on p.product_code = o.product_code where product_line='Motorcycles';

#Q27) Get the total worth of all planes ordered.
select sum(quantity_ordered *each_price) as totalprice from
orderdetails o left join products p on p.product_code = o.product_code where product_line='Planes';

#Q28) How many customers belong to France?
select count(*) as num_of_customers from customers where country='France';

#Q29) Get the payments of customers living in France.
select * from customers; select * from payments;
select c.customer_id, p.* from payments p left join customers c on c.customer_id = p.customer_id where country = 'France';

#Q30) Get the office address of the employees/salesmen who report to employee 1143.
select o.*, e.office_code,e.employee_id from offices o left join employees e on e.office_code= o.office_code where reports_to = 1143;

use lco_motors;
select * from orders;
select quarter(order_date), order_date from orders; -- quarter : 3 months period
select datediff(required_date,order_date) from orders; -- difference b/w 2 dates
select date_format(order_date, '%M') from orders;
select dayname(order_date) from orders;
select adddate(order_date, interval 5 day) from orders;
select adddate(order_date, interval 1 month) from orders; #similarly we can do year, quarter
select adddate(order_date, interval -1 month) from orders;#similarly we can do year, quarter, day : -ve num uses adddate to perform subtractionn task
select subdate(order_date, interval 1 month) from orders;
select subdate(order_date, interval -1 day) from orders; #-ve num makes sub work like add
select current_date(), current_time(), current_timestamp(), current_user(), sysdate(), system_user();
select adddate(order_date, interval -4 Quarter), order_date from orders; -- same quarter last year

#query to csv 
#https://www.mysqltutorial.org/mysql-export-table-to-csv/

#to sort by keeping 1 record at top and sort rest below it in asc/desc order
use fun;
create table test(CountryID varchar(50), CountryName varchar(50));
insert into test values (1,'Singapore'),(2,'United Kingdom'),(3,'Australia'),(4,'India'),(5,'Bangladesh'),(6,'China'),(7,'New Zealand');
select * from test order by  
case when CountryName ='India' then 1 else 2 end,CountryName; -- making india as 1st record (0) and the rest starting from row 1 & ,CountryName is used to 
#sort the rest starting fron row 1 in as order -- end as new col nhi toh changes in same column

select * from test order by  
case when CountryName ='India' then 0 
	 when CountryName ='New Zealand' then 1 else 2 end,CountryName desc; -- India and New Zealand fix at 0, 1 index and srt rest
     
select left(CountryName,3) from test;
select substr(CountryName,3,5) from test;

use fun;
create table wifi(id int, speed int , latency int , dt date);
insert into wifi values
(1,120,12,'2022-05-29'),
(1,120,12,'2022-05-28'),
(2,110,12,'2022-05-27'),
(1,111,12,'2022-05-26'),
(2,122,12,'2022-05-25'),
(1,89,12,'2022-05-24'),
(2,56,12,'2022-05-23'),
(1,130,12,'2022-05-22'),
(2,105,12,'2022-05-21'),
(2,100,12,'2022-05-20');
select * from wifi; 
#Q) find the avg speed for each wifi for last 7 days
select id, dt, avg(speed) from wifi
where dt >= date_add(sysdate(), interval -8 day) -- this gives records only for last 7 days and then do avg calc and groupby on these records
group by id, dt -- only id se karenge toh only 1,2 no dates will be visible to make 7 dates visible groupby dt also
order by dt desc; -- "last" 7 days so sort in desc
drop table worker;
CREATE table worker(
worker_id varchar(10),
first_name varchar(100), 
last_name varchar(100),
salary int,
joining_date datetime,
department varchar(10));

INSERT INTO worker values ("001", "Monika", "Arora", 100000, '2014-02-20 09:00:00', "HR");
INSERT INTO worker values ("002", "Niharika", "Verma", 80000, '2014-06-11 09:00:00', "Admin");
INSERT INTO worker values ("003", "Vishal", "Singhal", 300000, '2014-02-20 09:00:00', "HR");
INSERT INTO worker values ("004", "Amitabh", "Singh", 500000, '2014-02-20 09:00:00', "Admin");
INSERT INTO worker values ("005", "Vivek", "Bhati", 500000, '2014-06-11 09:00:00', "Admin");
INSERT INTO worker values ("006", "Vipul", "Diwan", 200000, '2014-06-11 09:00:00', "Account");
INSERT INTO worker values ("007", "Satish", "Kumar", 75000, '2014-01-20 09:00:00', "Account");
INSERT INTO worker values ("008", "Geetika Chauhan", "Arora", 90000, '2014-04-11 09:00:00', "Admin");
drop table bonus; drop table title;
CREATE table bonus(
worker_ref_id int,
bonus_date datetime,
bonus_amt int);

CREATE table title(
worker_ref_id int,
worker_title varchar(100), 
affected_from datetime);



INSERT INTO bonus values (1,'2016-02-20 00:00:00',5000);
INSERT INTO bonus values (2,'2016-06-11 00:00:00',3000);
INSERT INTO bonus values (3,'2016-02-20 00:00:00',4000);
INSERT INTO bonus values (1,'2016-02-20 00:00:00',4500);
INSERT INTO bonus values (2,'2016-06-11 00:00:00',3500);


INSERT INTO title values (1,'Manager','2016-02-20 00:00:00');
INSERT INTO title values (2,'Executive','2016-06-11 00:00:00');
INSERT INTO title values (8,'Executive','2016-06-11 00:00:00');
INSERT INTO title values (5,'Manager','2016-06-11 00:00:00');
INSERT INTO title values (4,'Asst. Manager','2016-06-11 00:00:00');
INSERT INTO title values (7,'Executive','2016-06-11 00:00:00');
INSERT INTO title values (6,'Lead','2016-06-11 00:00:00');
INSERT INTO title values (3,'Lead','2016-06-11 00:00:00');

 select * from worker; select * from bonus; select * from title;
 #fetch 1st name from worker in uppercase
 select upper(first_name) as name from worker;
 
 #fetch unique values of dept from worker
 select distinct department from worker;
  
#print 1st 3 char from firstname --part of str from whole str so substr
select substr(first_name, 1, 3) from worker;

#find postn of alphabet a in firstnamr  column
select first_name, position('a' in first_name) from worker;
select first_name, instr(first_name, 'a') from worker;

 #fetch unique values of dept from worker and print its length
 select distinct department , char_length (department) as len from worker; 
select distinct length(department), department from worker; 

#print details of worker who's first_name contains 'a'
select * from worker where first_name like '%a%';

##print details of worker who's first_name ends with 'h' and contains 6 alphabets
select * from worker where first_name like '%h' and length(first_name)=6;

#fetch teh no. workers in each dept in desc order
select department, count(*) no_of_workers from worker group by department order by no_of_workers desc;

#print details of the workers who are also managers -- inner join boz only those workers needed who are in both table and happen to be managers
select * from worker; select * from title;
select distinct w.first_name,w.last_name,w.salary, t.worker_title from worker w inner join title t 
on t.worker_ref_id = w.worker_id and t.worker_title='Manager';
select w.*, t.worker_title from worker w ,title t where  w.worker_id =t.worker_ref_id and worker_title='Manager';

#determine nth highest salary from the table
use fun;
select  salary from worker order by salary desc limit 4, 1; -- 1)
-- w/o top or limit 
select * from worker where salary = 
(select salary from (select  distinct(salary) from worker order by salary desc limit 4) t order by t.salary limit 1); -- max to min 4th highest sal

select *, dense_rank() over(order by salary desc ) as highestsalary from worker order by highestsalary desc limit 1;
select * from (select *,dense_rank() over(order by salary desc ) as highestsalary from worker)t where highestsalary =4;
select salary from worker w1 -- 5th highest salary
where 4 = (select count(distinct(w2.salary)) from worker w2 where w2.salary>=w1.salary);

select * from worker where salary =(select max(salary) from worker); -- max salary
select max(salary) from worker where salary <(select max(salary) from worker); -- 2nd highest : sal <total max sal and unn slaries se max sal

#show odd and even rows of worker
select * from worker where mod(worker_id,2)=0;
select * from worker where mod(worker_id,2)<>0;

#fetch list of employees with same salary
select * from worker where salary in (select salary from worker group by salary having count(*)>1);
-- just inner query writtens only one salary whose groupby count >1 so doesnt give both emp with same sal details but o nly one of them 
-- so to have all such emp details whose sal = sal whose grouby count came >1 we use this kind of nested query

select distinct w.worker_id, w.first_name, w.last_name,w.salary from worker w join worker w1 
on w.salary=w1.salary and w.worker_id<>w1.worker_id; -- same sal but diff ids to get all such emp

#fetch details of emp with second highest salary
select * from worker where salary in (select max(salary) from worker where salary <(select max(salary) from worker));
select * from worker order by salary desc limit 1,1;

#fetch 1st 50% records : count based on obv empid -unique 
select * from worker where worker_id <= (select count(worker_id)/2 from worker);
select * from worker where worker_id > (select count(worker_id)/2 from worker); -- last 50%

#fetch departments having less than five people in it
select * from worker;
select department, count(worker_id) from worker group by department having count(*) <4;

#name of employees with highest salary in each dept
select * from worker where salary in (select  max(salary) from worker group by department);

### Youtube practice interview questions - Learn at knowstar
#delete duplicate rows from a table
use fun;
select * from worker;
INSERT INTO worker values ("005", "Vivek", "Bhati", 500000, '2014-06-11 09:00:00', "Admin"),
("009", "Vivek", "Bhati", 500000, '2014-06-11 09:00:00', "Admin");

select first_name, last_name , count(*) from worker group  by first_name, last_name having count(*)>1;
set sql_safe_updates =0;
delete w1 from worker w1
inner join worker w2 
where (w1.first_name = w2.first_name and w1.last_name = w2.last_name) and (w1.worker_id< w2.worker_id);

delete from worker
where worker_id not in(select * from (select max(worker_id) from worker group by first_name, last_name)t);

delete from worker where worker_id in  -- rank greater than 1 are low id numbers since order by id desc done to retain high id num
(select worker_id from (select *, row_number() over(partition by first_name, last_name order by worker_id desc) as rn from worker)t where t.rn>1);
select * from worker;

#emp with nth highest salary
select * from worker;
select * from worker where salary =
(select salary from (select distinct salary from worker order by salary desc limit 3)t order by t.salary limit 1);

select * from (select *, dense_rank() over(order by salary desc) as rn from worker)t where t.rn =3;

#SQL Interview - Employee Manager Hierarchy - Self Join
use fun;
create table emp1(empid int auto_increment primary key, fname varchar(30), lname varchar(30), mgrid int);
insert into emp1(fname, lname, mgrid) values
('Adam', 'Owens',3),
('Mark', 'Hopkins',null),
('Natasha', 'Lee',2),
('Riley', 'Cooper',5),
('Jennifer', 'Hudson',2),
('David', 'Warner',5);
select * from emp1;
select concat(e.fname,' ',e.lname)as ename, concat(m.fname,' ',m.lname) as mgrname
from emp1 e inner join emp1 m on m.empid=e.mgrid;

#SQL Query - Convert data from Rows to Columns |Case | Pivot data
create table emp(name varchar(30), value varchar(30), id int);
insert into emp values('Name', 'Adam', 1),('Gender', 'Male', 1),('Salary', '50000',1),
('Name', 'Anita', 2),('Gender', 'Female', 2),('Salary', '80000',2);

select * from emp;
#1st way : CASE STATEMENT
select id, -- 1st col
max(case when name = 'Name' then value else '' end) as EName, -- name from row as 2nd col and value against it as its record..value in that col
max(case when name = 'Gender' then value else '' end) as EGender,
max(case when name = 'Salary' then value else '' end) as ESalary -- take each row in name col as a col and value against it as values in that new col 
-- max used since string values - safest way to agg them into one record or else they appear on different rows against same id so we need to groupby
-- and for that atleast one agg fun needed
from emp group by id;
#https://linuxhint.com/mysql_pivot/#:~:text=A%20database%20table%20can%20store,a%20table%20into%20column%20values.
drop table sales;
create table sales(Monthname varchar(30), salespermonth int);
insert into sales values
('April', 2000),
('January', 3000),
('March', 5000),
('May', 2000),
('February', 2500),
('October', 2000),
('June', 3000),
('August', 5000),
('September', 2000),
('July', 2500),
('December', 2000),
('November', 4000);
use fun;
select * from sales order by
case when Monthname='January' then 1
when Monthname='February' then 2
when Monthname='March' then 3
when Monthname='April' then 4
when Monthname='May' then 5
when Monthname='June' then 6
when Monthname='July' then 7
when Monthname='August' then 8
when Monthname='September' then 9
when Monthname='October' then 10
when Monthname='November' then 11
when Monthname='December' then 12
else null end;


create table Quarter_Sales(Year year, QuarterName varchar(5), Sales int);
insert into Quarter_Sales values
(2018, 'Q1', 5000),(2018, 'Q2', 5500),(2018, 'Q3', 2500),(2018, 'Q4', 10000),
(2019, 'Q1', 10000),(2019, 'Q2', 5500),(2019, 'Q3', 3000),(2019, 'Q4', 6000);

select * from Quarter_Sales;
select *, lag(Sales) over(partition by year order by QuarterName) as prev_quarter_sales from Quarter_Sales; -- to get value of prev sale
select *, -- to comment on prev sale
case when sales > lag(Sales) over(partition by year order by QuarterName) then 'higher sales than prev quarter'
when sales < lag(Sales) over(partition by year order by QuarterName) then 'lower sales than prev quarter'
when sales = lag(Sales) over(partition by year order by QuarterName) then 'equal sales as prev quarter'
else null end as prev_quarter_sales from Quarter_Sales;

-- using lead to get prev quarter sales
select *, lead(Sales) over(partition by year order by QuarterName desc) as prev_quarter_sales from Quarter_Sales; -- to get value of prev sale
select *, -- to comment on prev sale
case when sales > lead(Sales) over(partition by year order by QuarterName desc) then 'higher sales than prev quarter'
when sales < lead(Sales) over(partition by year order by QuarterName desc) then 'lower sales than prev quarter'
when sales = lead(Sales) over(partition by year order by QuarterName desc) then 'equal sales as prev quarter'
else null end as prev_quarter_sales from Quarter_Sales;

#Split concatenated string into columns | SplitString function
create table t1(empid int, Name varchar(30));
insert into t1 values(1,'Owens.Adam'),(2,'Hopkins.David'),(3,'Jones.Mary'),(4,'Rhodes.Susan');
select * from t1;
select Name, left(Name, position('.' in Name)-1) as Lname, right(Name, length(Name)-position('.' in Name)) as Fname from t1;
select Name, substr(Name,1, position('.' in Name)-1) as Lname, substr(Name, position('.' in Name)+1, length(Name)-position('.' in Name)) as Fname from t1;

select empid, name, substring_index(Name, '.', 1) as lname, substring_index(Name, '.', -1) as fname from t1;
#https://www.educba.com/mysql-split/ -- for substring_index

#https://www.sqlshack.com/sql-carriage-return-or-tab-in-sql-server-string/#:~:text=SQL%20Carriage%20Return%20(CR)%3A,the%20beginning%20of%20the%20line
#replace fucntion is used to replace both special(ascii/control char) and non control/special charactets -- refere knowstar youtube SQL Query | Replace special characters | Control Characters | REPLACE function

use lco_motors;
select * from orders;
select order_date,required_date, datediff(required_date,order_date) from orders;
select dayname(order_date), dayofweek(order_date), week(order_date) from orders;
select order_date,required_date,((DATEDIFF(required_date, order_date))+1 -
        ((WEEK(required_date) - WEEK(order_date)) * 2) -
        (case when dayname(required_date) = 'Saturday' then 1 else 0 end) -
        (case when dayname(order_date) = 'Sunday' then 1 else 0 end)) as DifD from orders;
select order_date,week(order_date) from orders;

select order_date, dayname(order_date), weekday(order_date), week(order_date) from orders;
-- https://stackoverflow.com/questions/18302181/mysql-function-to-count-days-between-2-dates-excluding-weekends

select order_date,required_date, WEEK(required_date) - WEEK(order_date), (WEEK(required_date) - WEEK(order_date))*2  from orders;
select datediff('2022-05-20', '2022-06-03'),datediff('2022-05-20', '2022-06-03')/7, mod(datediff('2022-05-20', '2022-06-03'),7);

# age from birthdate
use w3schools;
select birthdate, timestampdiff(year, birthdate,curdate()) as age from employees;

#select alphanumeric values from a data
use classicmodels;
select * from products;
select * from products where   productName  REGEXP '^[[:alnum:]]+$'; -- any char anywhere in string having either numbers/alphabets or both

#to remove leading and training zeros from a decimal value
use fun;
create table decimalvalues(amount varchar(50));
insert into decimalvalues values(10.0000),(10.0200),(10.2222),(0.22222),(1.0200);
select * from decimalvalues;
select amount, cast(amount as float) from decimalvalues;

# to get running totals or cumulative sums -- sum against each record
use techtfq;
select * from emp;
select * , sum(salary) over (order by empid) as runningtotal from emp;
select * , sum(salary) over (partition by deptid order by empid) as runningtotal from emp; -- each dept wise

# calulate ytd and mth total - windows framing
use classicmodels;
select *, sum(amount) over(partition by year(paymentdate) order by paymentdate) as YTD_total, -- normal sum but dup dates error in cal
sum(amount) over(partition by year(paymentdate) order by paymentdate rows between unbounded preceding and current row) as YTD_total_frame -- windows framing to handle dup records
from payments; -- ytd
select *, sum(amount) over(partition by month(paymentdate) order by paymentdate) as MTD_total, -- normal sum but dup dates error in cal
sum(amount) over(partition by year(paymentdate),month(paymentdate) order by paymentdate rows between unbounded preceding and current row) as MTD_total_frame -- windows framing to handle dup records
from payments; -- mtd
select *, sum(amount) over(partition by year(paymentdate),month(paymentdate) 
order by paymentdate rows between 2 preceding and current row) as last3_total_frame -- windows framing to handle dup records
from payments; --  to get total for last N days based on date rather than all pteceding records

select *, sum(amount) over(partition by year(paymentdate),month(paymentdate) 
order by paymentdate rows between 1 preceding and current row) as last3_total_frame -- windows framing to handle dup records
from payments;

# to get the 1st and last order number for the year
select * from orders; 
select ordernumber, orderdate, first_value(ordernumber) over(partition by year(orderdate) order by orderdate) as first_order,
first_value(ordernumber) over(partition by year(orderdate) order by orderdate rows between unbounded preceding and current row )as first_order_frm 
from orders;

select ordernumber, orderdate, last_value(ordernumber) over(partition by year(orderdate) order by orderdate) as last_order,
last_value(ordernumber) over(partition by year(orderdate) order by orderdate rows between current row and unbounded following)as last_order_frm,
last_value(ordernumber) over(partition by year(orderdate) order by orderdate range between unbounded preceding and unbounded following)as last_order_frame
from orders;

#SQL- Find employees with salary less than Dept average but more than average of any other Dept | ANY
use fun;
create table emp2(empkey int, firstname varchar(50), lastname varchar(50), departmentname varchar(50), salary int);
insert into emp2 values
(10, 'Ruth', 'Electrock', 'Production', 66000),
(16, 'Taylor', 'Maxwell', 'Production', 66000),
(19, 'Doris', 'Hartwig', 'Production', 66000),
(24, 'Stuart', 'Munson', 'Production', 66000),
(33, 'Alejandro', 'McGuel', 'Production', 66000),
(39, 'Simon', 'Rapler', 'Production', 66000),
(23, 'Peter', 'Kebes', 'Production Control', 51000),
(37, 'Vamai', 'Kuppa', 'Shipping and Receiving', 66000);

# 1) Employee with highest salary in the department
select first_name, last_name, salary from worker where salary in (select max(salary) from worker group by department);

select first_name, last_name, w.department, salary from worker w inner join (select department, max(salary) maxsal from worker group by department)t
on w.department = t.department and w.salary = t.maxsal;

select * from(select *, dense_rank() over(partition by department order by salary desc) as rn from worker)t where t.rn=1;

#2) Employees having greater than average salary of the department
select first_name, last_name, department, salary from worker w where (salary) > (select avg(salary) from worker w1 where w1.department=w.department);

select first_name, last_name, w.department, salary from worker w inner join (select department, avg(salary) avgsal from worker group by department)t
on w.department = t.department and w.salary > t.avgsal;

#3) Employees having more than average salary of the department but less than the overall average
select * from worker group by department;
select first_name, last_name, w.department, salary from worker w inner join (select department, avg(salary) avgsal from worker group by department)t
on w.department = t.department and w.salary > t.avgsal where w.salary <(select avg(salary) from worker);

set sql_safe_updates=0;
update worker
set salary = 138500 where first_name ='Monika';
select first_name, last_name, w.department, salary, t.avgsal from worker w inner join (select department, avg(salary) avgsal from worker group by department)t
on w.department = t.department and w.salary < t.avgsal where w.salary >any(select avg(salary) from worker group by department);

#to get employess with slaary greater than their manager salary
use fun;
create table empmgr(empkey int auto_increment primary key, fname varchar(30), lname varchar(30), department varchar(50),salary int, mgrkey int);
insert into empmgr (fname, lname,department, salary, mgrkey)values
('Ruth', 'Electrock', 'Production', 66000, 14),
('Taylor', 'Maxwell', 'Production Control', 66000, 14),
('Doris', 'Hartwig', 'Engineering', 72000,9),
('Stuart', 'Munson', 'Tool Design', 51000,10),
('Alejandro', 'McGuel', 'Tool Design', 85000,9),
('Simon', 'Rapler', 'Tool Design', 72000,8),
('Peter', 'Kebes', 'Marketing', 85000,8),
('Vamai', 'Kuppa', 'Marketing', 60000,1),
('Kim', 'Taehyung', 'Production', 60000,1),
('Park', 'Jimin', 'Production', 60000,11),
('Jeon', 'Jungkook', 'Shipping and Receiving', 51000,11),
('Seokjin', 'Kim', 'Shipping and Receiving', 80000,7),('Jung', 'Hoseok', 'Engineering', 95000, 7),('Min', 'Yoongi', 'Engineering', 75000,6);

update empmgr
set mgrkey = 6 where empkey=11;
select * from empmgr;
Select EmpKey, FName, LName, Department, Salary from empmgr emp 
WHERE salary > (Select salary from empmgr where empkey = emp.mgrkey); -- correlated subquery get the salary of mgr against each emp which then compares with emp salary

select  e.EmpKey, m.mgrkey, e.Department, e.Salary,m.salary from empmgr e join empmgr m on m.empkey = e.mgrkey and e.salary > m.salary;
select  e.EmpKey, e.Department, e.Salary,m.fname, m.lname, m.mgrkey, m.salary from empmgr e 
join(select empkey,mgrkey,fname, lname,salary from empmgr)m  on m.empkey = e.mgrkey and e.salary > m.salary;

#SQL Query | How to increment salaries of employees who have 2 years with the organization | Datediff
alter table empmgr
add column hiredate date;
set sql_safe_updates =0;
delete from empmgr where mgrkey is null;
use fun;
insert into empmgr(empkey,hiredate) values
(1,'2006-01-28'),(2,'2006-08-26'),(3,'2007-06-11'),(4,'2007-07-05'),(5,'2007-07-05'),(6,'2007-07-11'),(7,'2007-07-20'),
(8,'2007-07-20'),(9,'2007-07-26'),(10,'2007-08-06'),(11,'2007-08-06'),(12,'007-08-11'),(13,'2007-08-11'),(14,'2007-08-12') as var
on duplicate key update hiredate = var.hiredate;
select * from empmgr;
select empkey,fname, lname, department,salary,hiredate, timestampdiff(year, hiredate,'2021-12-31') as no_of_yrs_completed, salary*1.15 as updatedsal from empmgr
where timestampdiff(year, hiredate,'2021-12-31')>2;

with t as
	(select empkey,fname, lname, department,salary,hiredate, timestampdiff(year, hiredate,'2021-12-31') as no_of_yrs_completed from empmgr)
select *,
case when t.no_of_yrs_completed >=15 then salary *2 
	when t.no_of_yrs_completed <15 then salary *1.15 
    else salary 
    end as updatedsal -- har baar end toh hi har bar else warna one end and one else
from t;

# SQL Query | How to calculate Biweekly Friday dates in an Year | Date Functions
select dayname('2020-12-04') , dayofweek('2020-12-04'); -- friday is a 6so obv next fri is 7 days apart
select case when 
dayofweek('2022-01-01') > 6 then date_add('2022-01-01', interval (6-dayofweek('2022-01-01')+7) day)
else date_add('2022-01-01', interval 6-dayofweek('2022-01-01') day) end as first_fri;

select case when dayofweek('2022-01-01') > 6 
then date_add('2022-01-01', interval (6-dayofweek('2022-01-01')+14) day)
else date_add('2022-01-01', interval (6-dayofweek('2020-01-01'))+14 day) end as biweekley_fri;

use fun;
create table t3(ename varchar(50));
insert into t3 values('Anita|Shekar|Salve'), ('Rucha|Rahul|Dhamke'), ('Karan|Mihir|Patel'), ('Krishna|Kanhya|kumar'),('Pritesh|Shivaji|Sanap');
select ename, substring_index(ename,'|',1) as fname, substring_index(substring_index(ename,'|',2),'|', -1) as mname,
substring_index(substring_index(ename,'|',3),'|', -1) as lname from t3;
alter table t3 
add  fname varchar(20), 
add  mname varchar(20), 
add  lname varchar(20);
set sql_safe_updates = 0; 
update t3
set fname = substring_index(ename,'|',1) , mname=substring_index(substring_index(ename,'|',2),'|', -1), 
lname =substring_index(substring_index(ename,'|',3),'|', -1); 
select * from t3;


select dayname('2020-12-03') , dayofweek('2020-12-03');
select case when dayofweek('2022-01-01') >5 then
date_add('2022-01-01', interval (5-dayofweek('2022-01-01'))+7 day)
else date_add('2022-01-01', interval 5-dayofweek('2022-01-01') day)
end as first_thu;

#to generate 2 digit sequence of characters/ alphabetic sequence
use adventureworks;
select * from employee;
-- with t as
-- (select *, row_number() over(order by employeeid) as rn from employee)
select * from employee;
select concat(char((((employeeid-1)/26) +65) using utf8mb4), char(65+((employeeid-1) %26) using utf8mb4))  as sequence from employee;

# to find employees hired in last n months
use fun;
create table emp3(fname varchar(30), lname varchar(30), hiredate date);
insert into emp3 values
('Ruth', 'Electrock', '2021-01-07'),
('Taylor', 'Maxwell', '2021-01-06'),
('Doris', 'Hartwig', '2020-12-06'),
('Stuart', 'Munson', '2020-11-05'),
('Alejandro', 'McGuel', '2020-10-04'),
('Simon', 'Rapler', '2020-08-04'),
('Peter', 'Kebes', '2020-07-04'),
('Vamai', 'Kuppa', '2020-04-03'),
('Kim', 'Taehyung', '2019-11-02'),
('Park', 'Jimin', '2019-10-02'),
('Jeon', 'Jungkook', '2019-01-02'),
('Seokjin', 'Kim', '2019-03-02'),('Jung', 'Hoseok', '2018-05-09'),('Min', 'Yoongi', '2018-11-07');

with t as
(select e.*, timestampdiff(month,hiredate,'2021-12-31') as num_months from emp3 e)
select * from t where t.num_months<=15; -- emp hired in last 15 months

# how to capitalize first letter of a string
drop table title;
create table title(fname varchar(30));
insert into title values ('snehal'),('namjoon'),('seokjin'), ('yoongi'),('hoseok'),('jimin'),('taehyung'),('jungkook');
select * from title;
select fname, concat(upper(left(fname,1)),substring(fname,2,length(fname))) as titlecase from title;

#to get emp retiring at the end of the month
create table retire(fname varchar(30), lname varchar(30), birthdate date);
insert into retire values
('Ruth', 'Electrock', '1981-11-12'),
('Taylor', 'Maxwell', '1962-02-28'),
('Doris', 'Hartwig', '1962-03-01'),
('Stuart', 'Munson', '1974-07-23'),
('Alejandro', 'McGuel', '1974-07-23'),
('Simon', 'Rapler', '1962-02-26'),
('Peter', 'Kebes', '1974-10-17'),
('Vamai', 'Kuppa', '1974-10-17'),
('Kim', 'Taehyung', '1962-02-26'),
('Park', 'Jimin', '1962-02-28');
select r.*,  date_add(birthdate, interval 60 year) as retireyear from retire r;
select r.*, date_add(birthdate, interval 60 year) as retireyear from retire r where  date_add(birthdate, interval 60 year)<=last_day(curdate());

# to count occurences of a char in a string
create table survey(surveyid int, response varchar(30));
insert into survey values(1,'YYNNXYXNNNXXYXNXXYYYYXXXNNN'), (2,'XXXNNNYYYYNYNYNYXYXYN');
select * from survey;
with t as
(select surveyid, response , length(response) as comp_str, length(replace(response,'Y','')) as str_wo_char from survey)
select *,t.comp_str-t.str_wo_char as num_occurence_Y from t;

#how to find strings with lower case characters only
select database();
create table lcase(fname varchar(30), initials varchar(20));
insert into lcase values ('Raj Rane', 'RR'),('Sam Samr', 'SS'),('Akash Rane', 'AR'),('Sham Kumar', 'sk'),('Anil Khan', 'ak'),('Ram Kapoor', 'rk'),
('Sheetal Kumar', 'SK');
select upper(initials),initials from lcase
where  upper(initials) collate utf8mb4_0900_as_cs != initials ;

#difference between count(*), count(1), count(colname) -- which is faster?
use fun;
set sql_safe_updates=0;
select * from retire order by fname, lname;
insert into retire values ('JoLynn', null, '1961-02-16'),
('Ruth', 'Electrock', '1981-11-12'),
('Taylor', 'Maxwell', '1962-02-28');
update retire set lname = null where fname ='JoLynn';
select count(*) from retire; -- entire count with all records
select count(fname) from retire; -- non null+duplicates
select count(lname) from retire; -- non null+duplicates
select count(1) from retire;  -- same as count(*) no difference at all not even  in execution plan same speed 1 can be any number
select count(distinct lname) from retire; -- no duplicates + non null

#to get n condsecutive order dates see sql_stored_functions : row_number, date_add fun, count(*)
# to get days for no sales for n consecutive days: identify dayte gaps
use fun;
create table factsales(orderdate date, customerkey int);
insert into factsales values('2021-04-01', 21768),
('2021-04-01', 21768),
('2021-04-02', 28389),
('2021-04-03', 25863),
('2021-04-04', 14501),
('2021-04-09', 11003),
('2021-04-10', 27645),
('2021-04-11', 16624),
('2021-04-13', 11005),
('2021-04-16', 11011),
('2021-04-18', 27621),
('2021-04-22', 27616);
select * from factsales;
with t as
(select *,  lead(orderdate) over(order by orderdate) as nextrecord, datediff((lead(orderdate) over(order by orderdate)), orderdate) as diff
from factsales)
select *, diff-1 as exact_date from t where diff >1;

#to find the closest macthing string
use fun;
create table rivers(rname varchar(30));
insert into rivers values('Blue Nile'),('White Nile'),('Amazon'),('Congo'),('Ganges'),('Seine'),('Nile');
select rname, length(rname)-length('Nile') as len from rivers where rname like '%Nile%' order by length(rname)-length('Nile');

#how to find numbers of emails from the same domain
use fun;
create table t2(id int not null auto_increment primary key, email varchar(30));
insert into t2(email)values('jon24@adventure-works.com'),('ruben35@knowstar.org'),('elizabeth5@gmail.com'),('macro14@adventure-works.com'),
('shannon38@knowstar.org'), ('seth46@toyfactory.com'),('ethan20@adventure-works.com'),('russell7@gmail.com'),('jimmy9@skill.com'),('denise10@yahoo.com');

select count(*), right(email, length(email)-position('@' in email)) as substr from t2 group by right(email, length(email)-position('@' in email));

-- how to pad zeros to a number
use fun;
drop table pading;
create table pading(num int);
insert into pading values(1),(2),(3),(44),(100);
-- alter table pading add column changeddtype right((concat('0000' ,cast(num as char(4)))),4);
select * from pading;
-- change your col dtype to a varchar 9 : same question as above
select right((concat('0000' ,cast(num as char(4)))),4) as changeddtypecol from pading;






