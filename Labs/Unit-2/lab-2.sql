# Select all the actors with the first name ‘Scarlett’.


select actor_id, first_name 
from actor 
where first_name = 'Scarlett';

# Select all the actors with the last name ‘Johansson’.

select actor_id, last_name 
from actor 
where last_name = 'Johansson';


# How many films (movies) are available for rent?

select count(film_ID) 
from film;

# How many films have been rented? 


select count(distinct inventory_id) 
from rental;

# What is the shortest and longest rental period?


select min(rental_duration) as 'shortest rental', max(rental_duration) as 'longest rental' 
from film;

# What are the shortest and longest movie duration? Name the values `max_duration` and `min_duration`.


select min(length) as 'min_duration', max(length) as 'max_duration' 
from film;


# What's the average movie duration?


select (sum(length)/count(film_id)) as 'average duration' 
from film;


# What's the average movie duration expressed in format (hours, minutes)?


select floor(sum(length)/count(film_id) / 60) as 'average duration hours', 
floor(sum(length)/count(film_id) % 60) as 'average duration minutes'
from film;


# How many movies longer than 3 hours?

select film_id, length 
from film where length > 180;

select count(length) from film where length > 180;

# Get the name and email of all customers, formatted nicely in two columns 


select CONCAT(first_name, last_name) as 'Name', 
email as 'Email' 
from customer;

# What's the length of the longest film title?

select max(length(title)) as 'Title length' 
from film;



