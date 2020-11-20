# 2. Create table

CREATE TABLE IF NOT EXISTS house_price_data (
	id int(11) NOT NULL,
	date char(20),
	bedrooms int(11),
	bathrooms float(11),
	sqft_living int(11),
	sqft_lot int(11),
	floors float(11),
	waterfront int(11),
	house_view int(11),
	house_condition int(11),
	grade int(11),
	sqft_above int(11),
	sqft_basement int(11),
	yr_built int(11),
	yr_renovated int(11),
	zipcode int(11),
	house_lat float(11),
	house_long float(11),
	sqft_living15 int(11),
	sqft_lot15 int(11),
	price int(11)
);

drop table if exists house_price_data;

# 3. Import dataset

SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/siriamanda/Desktop/Ironhack/ironhack-data-analytics/Unit-5-project/regression_data_sql_copy.csv'
INTO TABLE house_price_data
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

# 4. Select all data

select * from house_price_data;

# 5. Drop column 'date'

alter table house_price_data
drop column date;

select * from house_price_data;

# 6. Count the number of rows

select count(id) from house_price_data;

# 7. Unique values

select distinct(bedrooms) 
from house_price_data;

select distinct(bathrooms) 
from house_price_data;

select distinct(floors) 
from house_price_data;

select distinct(house_condition) 
from house_price_data;

select distinct(grade) 
from house_price_data;

# 8. Arrange the data in a decreasing order by the price of the house

select id as ID
from house_price_data
order by price DESC
LIMIT 10;

# 9. Average selling price

select avg(price) as "average_price"
from house_price_data;

# 10. Group by clauses

# Average price grouped by bedroom

select bedrooms, avg(price) as "average_price"
from house_price_data
group by bedrooms;

# Average `sqft_living`grouped by bedroom

select bedrooms, avg(sqft_living) as "avg_living_room_space"
from house_price_data
group by bedrooms;

# Average price grouped by waterfront

select waterfront, avg(price) as "average_price"
from house_price_data
group by waterfront;

# Is there correlation between the columns `condition` and `grade`?

select house_condition, sum(grade)
from house_price_data
group by house_condition
order by house_condition DESC;

# 11. Simple query that matches customer request

select *
from house_price_data
where (bedrooms = 3 or bedrooms = 4)
and bathrooms >= 3
and floors = 1
and waterfron = 0
and house_condition >= 3
and grade >= 5
having price < 300000;

# 12. Properties whose price are twice more than the average price of all properties

select *
from house_price_data
where price > (select avg(price) * 2 from house_price_data);

# 13. Create a view

create or replace view high_price_properties as
select *
from house_price_data
where price > (select avg(price) * 2 from house_price_data);

# 14. Difference in avg price 3 or 4 bedrooms

select bedrooms, avg(price) as avg_price
from house_price_data
where (bedrooms = 3 or bedrooms = 4)
group by bedrooms;

# 15. Locations

select distinct(zipcode)
from house_price_data;

# 16. Properties that have been renovated

select *
from house_price_data
where yr_renovated <> 0;

# 17. The 11th most expensive property

with cte_expensive_properties as (
select *
from house_price_data
order by price DESC
LIMIT 11
)
select * 
from cte_expensive_properties
order by price ASC
LIMIT 1;