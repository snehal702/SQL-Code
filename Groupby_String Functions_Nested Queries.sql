USE TEST_DB
SELECT * FROM empinfo
UPDATE empinfo
SET state = 'Arizona'
WHERE first = 'John'
--GROUPBY CLAUSE
SELECT state, COUNT(*) FROM empinfo GROUP BY STATE --VALUE_COUNTS UNIQUE STATE CATEGORIES DF.GROUPBY(STATE)['STATE'].VALUE_COUNTS() 
SELECT AVG(age), state FROM empinfo GROUP BY STATE --STATE WISE AVG AGE

--AGGREGATE FUNCTIONS
SELECT MIN(age) FROM empinfo
SELECT MAX(age) FROM empinfo
SELECT AVG(age) FROM empinfo
SELECT COUNT(age) FROM empinfo
SELECT SUM(age) FROM empinfo
SELECT COUNT(first) FROM empinfo IN (select first from empinfo)
---NESTED QUERIES 
--SELECT EMP DETAILS WHERE AGE IS MIN
SELECT * FROM empinfo WHERE AGE = MIN(AGE) ---THIS IS IMPROPER USE OF GROUPBY 
--An aggregate may not appear in the WHERE clause unless it is in a subquery contained in a 
--HAVING clause or a select list, and the column being aggregated is an outer reference.
SELECT * FROM empinfo WHERE AGE IN (SELECT MIN(AGE) FROM empinfo) -- IN A SELECT LIST(IN OPRATOR ACTS LIKE LIST)
SELECT * FROM empinfo WHERE AGE = (SELECT MIN(AGE) FROM empinfo)
SELECT SUM(age), state FROM empinfo GROUP BY STATE HAVING SUM(age) >50 -- UPTIL GROUPBY WE HAVE ALREADY FILTERED OUT STAET WISE AVG AGE NOW 
--FURTHER FILTER THIS DATA WHERE SUM (AGE)>50 IE. WHERE WITH AGG FUN SUM --> SOO USING HAVING

SELECT * FROM empinfo
SELECT TOP 3 first FROM empinfo ORDER BY first 

-- string functions
SELECT concat(first,'_',last) as full_name from empinfo -- concat two strings put them together as one in a new col aliased as full_name 
--alias is just for that query runtime purpose
SELECT SUBSTRING(first, 1,4) as first_4_char , first from empinfo --1st 4 char of each string	
SELECT upper(first), first from empinfo
SELECT lower(first), first from empinfo
SELECT len(first), first from empinfo
SELECT reverse(first), first from empinfo


--NESTED QUERIES
use 
SELECT * FROM empinfo WHERE age IN (SELECT MIN(age) FROM empinfo)--IT RUNS INNNER QUERY FIRST WHERE WE GET THE MIN AGE IN EMPINFO TABLE I.E. 22 
--AND FOR AGE =22 IT RUNS OUTER QUERTY AND GIVVES EMPINFO
SELECT * FROM empinfo WHERE age >(SELECT age FROM empinfo WHERE first ='Gus' AND last ='Gray')

--VIEWS
CREATE VIEW EMPAGE AS SELECT * FROM empinfo WHERE age >(SELECT age FROM empinfo WHERE first ='Gus' AND last ='Gray')
--VIEW ACTS LIKE TABLE ONLY THING WE CANNOT UPDATE IT CN ONLY VIEW
SELECT * FROM EMPAGE

DROP VIEW EMPAGE
