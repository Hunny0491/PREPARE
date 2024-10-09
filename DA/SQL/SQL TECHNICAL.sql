select * from titanic

 --- Distinct function = for find unique values in row ---	
select distinct survived from titanic

	
 --- where function = to find that particular data ---
select fare from titanic where fare =35000

	
 --- between with where function = to find particular values in between ---
select fare from titanic where fare between 30000 and 50000

	
 --- update column name ---
update titanic set sex = 'female' , age = 49
where pclass = '1st'

	
 --- like query - find a name in which third character is " i " ---
select * from titanic   
where name like '__i%'

	
 --- Order by - like ascending / descending ---
select * from titanic 
order by age asc

	
select survived from titanic 
order by survived desc

	
 --- limit set for rows ---
select * from titanic
limit 25; 


 --- offset - used when the rows required from middle of the table like here wants a rom from 150 
select * from titanic
limit 25 offset 150;        --CL-VS-310347 --


 -- aggregator function by using (MIN , MAX, AVG, COUNT, SUM) --
select min(age) as minage
from titanic 
	
select max(age) from titanic

select SUM(age) from titanic

select AVG(age) from titanic

select COUNT(age) from titanic


 --- IN FUNCTION - used when to find particular in column ---
select * from titanic 
where pclass in('1st') 
	
 --- AS FUNCTION TO RENAME OR KNOWN AS ---
SELECT PCLASS AS CLASS  FROM TITANIC  ---- PCLASS NOW KNOWN AS CLASS 


---Having clause used when to specify conditions for groups or aggregations in SQL ---
select min(age),embarked from titanic 
group by embarked  hAving min(age) < 35;


 --- Union / Union All is used to combine the result-set of two or more queries.
---rules---

---They must have the same number of columns
---The columns must have the same data types
---The columns must be in the same order

select * from vibgyor
SELECT * FROM rainbow
	
SELECT vib_id, vib_name
FROM vibgyor
UNION
SELECT rain_id, rain_name
FROM rainbow
ORDER BY vib_id;


 --- Truncate = used to delete the whole data from the table expect the header or the structure of the table ---
select * from cricket
	truncate table cricket

	
--- Delete = used to delete the particular row from the table which you want to delete ---

select * from ticket
	delete from ticket
	where fare < 22000
	
 --- Drop = used to delete all the data from table with header ---
select * from policies
    drop table policies

	
--- Procedure / stored procedure = used to insert data with write the whole syntax of insert into ___ ---
 select * from rainbow
	
create or replace procedure raincolour (colour_id int, colour_name varchar, colour_type varchar)
	language plpgsql
	as $$
	begin
	insert into rainbow (rain_id, rain_name, rain_type)
	values(colour_id, colour_name, colour_type);
commit;
end;
$$;
	---now procedure has been created ---
-- call the procedure ---

call raincolour(12548,'ceramic','semi')
select * from rainbow


--- function =
---CASE (WHEN, IF ,ELSE) = USED WHEN THE CONDITIONS IS REQUIRED IN THE QUERY TO FIND THE RESULT...

create or replace function pass_class(pclass varchar)
Returns varchar as $$
Declare
    Output varchar;
Begin
	case
    when pclass = '1st' then output := 'CHEIF GUEST';
    when pclass = '2nd' then output := 'VIP';
    else output := 'ORDINARY';
    end case;
	return output;
end 
$$ language plpgsql;

--- call the function ---
select "pass_class" (pclass) from titanic


	
--- JOINS INFO ---
	
---INNER JOIN: Returns records that have matching values in both tables
---LEFT JOIN: Returns all records from the left table, and the matched records from the right table
---RIGHT JOIN: Returns all records from the right table, and the matched records from the left table
---FULL JOIN: Returns all records when there is a match in either left or right table 

select * from car
select * from company
	
--- LEFT JOIN = to join the left table and match records to the rigth table .---
	select r.brand_name,  min(rating), avg(rating) from car as c
	left join company as r 
	on r.brand_rank=c.brand_rank
	group by brand_name
	

--- RIGHT JOIN = to join the right table and match records to the left table .---
    select r.brand_name,  count(rating), avg(rating) from car as c
	right join company as r 
	on r.brand_rank=c.brand_rank
	group by brand_name


--- FULL JOIN = to join the both two table ---
	select r.model_id, c.brand_rank, c.brand_name, c.country from car as r
	full join company as c
	on r.brand_rank=c.brand_rank
	order by  brand_rank asc
	

---INNER JOIN: Returns records that have matching values in both tables
    select r.model_id, c.brand_rank, c.brand_name, c.country from car as r
	inner join company as c
	on r.brand_rank=c.brand_rank
	order by  brand_rank asc

	---_________________________________________________________________________________________________________---
	
---- Aggregators with group by ---
select car_type, count(rating), avg(rating) as car_rating from car
group by car_type


---intersect =It helps to retrieve, gather the common data from various tables. 
	select * from vehicle
	select * from moped
	
SELECT  cc, model_name, type FROM vehicle
INTERSECT 
SELECT  cc, model_name, type from moped;


---alter = used to add or drop column from tha table or to modify the table as per requirment.
select * from bike

alter table bike add accident int;
alter table bike drop accident ;

---The main difference between ANY and ALL is that 
--ANY returns true if any of the subquery values meet the condition 
--whereas ALL returns true if all of the subquery values meet the condition.

--- ANY = used to verify if any single record of a query satisfies the required condition
SELECT * FROM titanic 
WHERE pclass>'ANY';
(SELECT name FROM titanic WHERE fare = 25000) --- on condition meet here in this query so no return output..

SELECT * FROM titanic 
WHERE pclass>'ANY';
(SELECT name FROM titanic WHERE fare = 75818)    --meet the condition so gives the output..


	
--- ALL = When we use the ALL operator with a WHERE clause, it filters the results of the subquery based on the specified condition.
SELECT * FROM titanic 
WHERE pclass='all';
(SELECT name, fare FROM titanic WHERE fare < 35000);


--- exists = used to verify whether a particular record exists in a SQL table , USING SUBQUERY..
SELECT * FROM company
SELECT * FROM car
	
SELECT * FROM car as v 
   WHERE EXISTS (
   SELECT brand_name FROM company as c
   WHERE v.model_id = model_id AND rating > 3);


--OR = operator returns true if at least one its operands evaluates to true, and false otherwise. use OR with WHERE CLAUSE..
 select model_name, car_type,rating from car
where rating < 2 or brand_rank > 25   --- in these rating condition is true so give the output for rating
	 
select model_name, car_type from car      --- in these brand_rank condition is true so give the output for brand_rank 
where rating < 1 or brand_rank > 15	    -- but the column is not selected for return..
   


---except = used to  compares the distinct values of the left query with the result set of the right query. 
SELECT brand_rank, country FROM company
EXCEPT 
SELECT brand_rank, car_type FROM car

	 
--- VIEW =   
create view faring  as select * from titanic
	 where fare < 50000;
-- call function view --
select *  from faring

UPDATE faring SET pclass = '2nd'
	WHERE survived = 6;
-- call function view --
select * from faring WHERE survived = 6 
	


--- DATE = used for know to current time and date - time ,timestamp, date , now.
SELECT NOW();  --- FOR CURRENT TIME AND DATE



-- REGEXP (REGRESSION EXPRESSION) = use to find the particular data with the help of this kind of expressions..

SELECT * FROM Titanic
	
select passenger_id from TITANIC 
	where passenger_id ~* '^[J-U]{2}-[a-z]{2}-[2|5]{2}$'


select name , sex from TITANIC 
where name ~* '^[a-z]{2}[a-z]$';


---TRIGGER = 
select *  from sales

create table table_report(
	product_id varchar primary key,
	sum_of_sales float,
	sum_of_quantity float,
	sum_of_profit float
)
	select * from table_report

select count (*) from sales where product_id = 'TEC-PH-10004977'
	
	select distinct quantity from sales where product_id = 'TEC-PH-10004977'
	select distinct profit from sales where product_id = 'TEC-PH-10004977'

update table_report set sum_of_sales = 190 , sum_of_quantity = 8 , sum_of_profit = 25
	
Create or replace function update_table_report()
returns trigger as $$
DECLARE
sumofSales float;
sumofQuantity float;
sumofProfit float;
count_report INT;
begin
select sum(sales), sum(quantity), sum(profit) into sumofSales, sumofQuantity, sumofProfit from sales
where product_id = new.product_id;
select count (*) into count_report from table_report where product_id = new.product_id;
if count_report = 0 then insert into table_report values (new.product_id, sumofSales, sumofQuantity, sumofProfit);
else
update table_report set sum_of_sales = sumofSales, sum_of_quantity = sumofQuantity, sum_of_profit = sumofProfit
where produt_id = new.product_id;
end if;
return new;
end;
$$ language plpgsql


create trigger update_report_trigger
After insert on sales
for each row
execute function update_table_report()

select * from sales
select sum(sales), sum(quantity), sum(profit) from sales where product_id = 'TEC-PH-10004977'

--sum(sales) = 5401.7300000000005
--sum(quantity) = 38
--sum(profit) = 860.8371999999999
	
select * from sales order by order_line DESC
insert into sales(order_line,order_id,order_date,ship_date,ship_mode,customer_id,product_id,sales,quantity,discount,profit)
values(9998,'CA-2016-152156','2021-05-16','2024-08-21','Standard Class','CG-12520','TEC-PH-10004977',110,6,2,22)

select * from sales order by order_line DESC
   
select  sum_of_profit from table_report
where product_id = 'TEC-PH-10004977'
select  sum_of_quantity from table_report
where product_id = 'TEC-PH-10004977'


--- SUBQUERY = used to retrieve and compare data from multiple tables, and to filter and manipulate results. 
	--They can be used in the SELECT, WHERE, FROM, and HAVING clauses of a SQL query.

	select passenger_id, name, sex, age from titanic
	where  fare IN (SELECT FARE FROM TITANIC WHERE AGE < 45) 

---INDEX
SELECT * FROM BIKE
	CREATE INDEX age_IND ON BIKE (age)
	
SELECT * FROM BIKE WHERE age = 60;

ALTER INDEX age_IND RENAME TO AGEING


---TO_CHAR = 

select current_timestamp, TO_CHAR(current_timestamp,'YYYY')
	,TO_CHAR(current_timestamp,'YY')
	,TO_CHAR(current_timestamp,'BC')

select current_TIMESTAMP, to_char(current_date, 'yyyy'),
	to_char(current_timestamp, 'MI') AS MINUTES,
	to_char(current_timestamp, 'SS') AS SECONDS

select current_timestamp, TO_CHAR(current_timestamp,'DD') as "day"
select current_timestamp,	TO_CHAR(current_timestamp,'MONTH') as "month"
select current_timestamp,	TO_CHAR(current_timestamp,'YYYY') as "YEAR"
select current_timestamp,	TO_CHAR(current_timestamp,'HH') as "Hour"
select current_timestamp,	TO_CHAR(current_timestamp,'MI') as "min"
select current_timestamp,	TO_CHAR(current_timestamp,'SS') as "SEC"
select current_timestamp,	TO_CHAR(current_timestamp,'AM') as "morning or evening"


--- HOW TO CREATE ADMIN - GRANT & REVOKE THE PERMISSION TO USER
SELECT * FROM STUDENT
create user da9user with password  'a123'	nocreateDB
GRANT SELECT , insert on college to da9user
REVOKE insert on college from da9user

	
--- SQL CONSTRAINTS = are used to limit the type of data that can go into a table.

--The following constraints are commonly used in SQL:

--NOT NULL - Ensures that a column cannot have a NULL value
--UNIQUE - Ensures that all values in a column are different
--PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Uniquely identifies each row in a table
--FOREIGN KEY - Prevents actions that would destroy links between tables
--CHECK - Ensures that the values in a column satisfies a specific condition
--DEFAULT - Sets a default value for a column if no value is specified
--CREATE INDEX - Used to create and retrieve data from the database very quickly


CREATE TABLE table_name (
    column1 datatype constraint,
    column2 datatype constraint,
    column3 datatype constraint,
    ....);


--- Some of The Most Important SQL Commands
--SELECT - extracts data from a database
--UPDATE - updates data in a database
--DELETE - deletes data from a database
--INSERT INTO - inserts new data into a database
--CREATE DATABASE - creates a new database
--ALTER DATABASE - modifies a database
--CREATE TABLE - creates a new table
--ALTER TABLE - modifies a table
--DROP TABLE - deletes a table
--CREATE INDEX - creates an index (search key)
--DROP INDEX - deletes an index
--HOW TO COPY DATA FROM CSV = copy "FILE NAME" from 'COPY AS PATH' delimiter ',' csv header
--CAST = function is used to explicitly convert a value from one data type to another. 
	   ---It allows you to change the data type of an expression or a column in a query result..









