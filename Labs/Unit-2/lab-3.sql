
# How many distinct (different) actors' last names are there?

select count(distinct(last_name)) from actor;

# In how many different languages where the films originally produced? (Use the column `language_id` from the `film` table)

select count(distinct(language_id)) from film;

# How many movies were released with `"PG-13"` rating?

select count(rating) from film where rating = 'PG-13';

# Get 10 the longest movies from 2006.

select film_id, title, length 
from film 
where release_year = 2006
ORDER BY length DESC
LIMIT 10;

# How many days has been the company operating (check `DATEDIFF()` function)?

select datediff(max(substring_index(rental_date, ' ', 1)), min(substring_index(rental_date, ' ', 1))) 
as 'Days of Operation' 
from rental;

# Show rental info with additional columns month and weekday. Get 20.

select rental_id as 'Rental ID', substring_index(rental_date, ' ', 1) as 'Rental Date',
	date_format(convert(rental_date,date), '%M') as 'Month', 
	dayname(convert(rental_date,date)) as 'Day' 
from rental
limit 20;

# Add an additional column `day_type` with values 'weekend' and 'workday' depending on the rental day of the week.

select rental_id as 'Rental ID', substring_index(rental_date, ' ', 1) as 'Rental Date',
	date_format(convert(rental_date,date), '%M') as 'Month', 
	dayname(convert(rental_date,date)) as 'Day',
case 
when dayname(convert(rental_date,date)) = 'Monday' then 'Workday'
when dayname(convert(rental_date,date)) = 'Tuesday' then 'Workday'
when dayname(convert(rental_date,date)) = 'Wednesday' then 'Workday'
when dayname(convert(rental_date,date)) = 'Thursday' then 'Workday'
when dayname(convert(rental_date,date)) = 'Friday' then 'Workday'
else 'Weekend'
end as 'Day Type'
from rental;

# How many rentals were in the last month of activity?

select count(distinct(rental_id)) from rental where date_format(convert(rental_date,date), '%M') = 'February';

