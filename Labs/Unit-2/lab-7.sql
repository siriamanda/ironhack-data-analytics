
select last_name from actor
group by last_name
having count(*) = 1;

# Which last names appear more than once? We would use the same logic as in the previous question but this time we want to include the last names of the actors where the last name was present more than once

select last_name from actor
group by last_name
having count(*) > 1;

# Using the rental table, find out how many rentals were processed by each employee.

select staff_id, count(rental_id) as rentals
from rental
group by staff_id;

# Using the film table, find out how many films were released each year.

select count(film_id) as films, release_year
from film
group by release_year;

# Other solution

select release_year, count(*) as num_films from sakila.film
group by release_year
order by release_year;

# Using the film table, find out for each rating how many films were there.

select rating, count(*) as num_films 
from film
group by rating
order by rating;

# What is the mean length of the film for each rating type. Round off the average lengths to two decimal places 

select rating, round(avg(length), 2) as mean_length
from film
group by rating
order by mean_length desc;

# Which kind of movies (rating) have a mean duration of more than two hours?

select rating, round(avg(length), 2) as mean_length
from film
group by rating
having mean_length > 120
order by mean_length desc;

