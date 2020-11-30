# Select one column from a table. Get film titles.

Select title from film; 


# Select one column from a table and alias it. Get unique list of film languages under the alias `language`. 

select name as "language" from language;


# Using the `select` statements and reviewing how many records are returned, can you find out how many stores and staff does the company have? Can you return a list of employee first names only?


select count(store_id) from store;
select count(staff_id) from staff;
   
select first_name from staff;


# Bonus: How many unique days did customers rent movies in this dataset?


select count(rental_date) from rental;
   
select distinct date_format(convert(rental_date,date), '%Y-%m-%d')
from rental;


