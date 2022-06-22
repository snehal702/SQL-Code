create database fun;
use fun;
create table players( player_id int, player_name varchar(25), country varchar(25), goals int, primary key(player_id));
insert into players values
(901, 'Sunil', 'India', 5),(902, 'Daniel', 'England', 12),(903, 'Christiano', 'Portugal', 15),(904, 'Zlatan', 'Sweden', 12),
(905, 'Rodriguez', 'Columbia', 11),(906, 'Henry', 'England', 10),(907, 'Nani', 'Portugal', 2),(908, 'Neymar', 'Brazil', 14),
(909, 'Jindal', 'Iran', 5),(910, 'Martial', 'France', 9);
-- if we have year wise records datetime col added than player ifd wont6 be unique since each yer there will be multiple values for each player..keeps changing
select * from players;
-- list of players who scored more than 6 goals in tournament
select * from players where goals>6;
-- creating a SP for this task
delimiter &&
create procedure playergoal()
begin
select * from players where goals> 6 order by goals desc;
end && delimiter ; 

call playergoal()
-- lets create a procedure which returns the top players based on goals
select * from players order by goals desc limit 3; -- top 3 players based on goals
delimiter //
create procedure topscorers(IN x int)
begin
select * from players order by goals desc limit x;
end // delimiter ;
call topscorers(3)
SET SQL_SAFE_UPDATES =0;
-- suppose we need to update the goals of some players after each match so we can do either by writing multiple update queries or put it in a sp
delimiter //
create procedure updategoals(IN num int, IN pname varchar(25))
begin
update players set goals = num where player_name = pname;
end // delimiter ;
call updategoals(17, 'Christiano')
select * from players;

-- SP using out to gget some values/ output from the query
delimiter //
create procedure num_records(out x int)
begin
select count(*) from players into x;
end // delimiter ;
call num_records(@totalrows)
select @totalrows as Total_count

-- find total copunt of players based on country
select country, count(*) from players group by country;
delimiter //
create procedure count_of_players_per_country(IN var varchar(25), OUT x int)
begin
select count(*) from players where country = var into x;
end // 
delimiter ;
call count_of_players_per_country ('England' , @rowcount)
select @rowcount as Rowcount


