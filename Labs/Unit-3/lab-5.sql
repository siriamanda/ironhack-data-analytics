# Lab 5: Subqueries

# How many copies of the film *Hunchback Impossible* exist in the inventory system?

# To get film id

select count(film_id) as Copies from inventory 
where film_id = (
select film_id from film where title = "Hunchback Impossible");

# List all films whose length is longer than the average of all the films.

SELECT title, length FROM film 
WHERE length > (SELECT avg(length) from film);

# Use subqueries to display all actors who appear in the film *Alone Trip*.

# Grab the actor_ids for actors in Alone Trip

select concat(first_name , ' ' , last_name) as Actor
from sakila.actor
where actor_id in (
select actor_id
from sakila.film_actor
where film_id = (
select film_id
from sakila.film
where title = 'ALONE TRIP'
)
);

# Wtihout subqueries

select concat(a.first_name,' ' ,a.last_name) as Actor from actor as a
join film_actor as f
on a.actor_id = f.actor_id
where f.film_id = 17;

# Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select concat(first_name , ' ' , last_name), email 
from sakila.customer
where address_id in (
select address_id 
from address
where city_id (
select city_id
from city
where country_id (
select country_id
from country
where country = "Canada")));

# Without subqueries

select title as Total from film_list 
where category = 'Family';

# Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

select concat(first_name , ' ' , last_name) as Customer_Name, email 
from sakila.customer
where address_id in (
select address_id 
from sakila.address
where city_id in (
select city_id
from sakila.city
where country_id in (
select country_id
from sakila.country
where country = "Canada")));

# Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

# Tables: film_actor and film

# Stage 1: finding the most prolific actor
# USING is a shorter way of linking tables in a join

select actor_id, count(film_id) from film_actor 
inner join film
using (film_id)        
group by actor_id
order by count(film_id) desc
limit 1;

# Stage 2: Get the list of films this person starred in

select film_id from film_actor
where actor_id =
(
select actor_id from film_actor 
inner join film
using (film_id)       
group by actor_id
order by count(film_id) desc
limit 1
);

# Stage 3: Find the names of the films

select a.film_id, f.title from film_actor as a
join film as f using (film_id)
where actor_id =
(
select actor_id from film_actor 
inner join film
using (film_id)       
group by actor_id
order by count(film_id) desc
limit 1
);


# Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select film_id, title 
from sakila.film
where film_id in (
select film_id 
from sakila.inventory
where inventory_id in (
select inventory_id
from sakila.rental
where customer_id in (
select sum(amount) group by customer
)));

# Customers who spent more than the average payments.

# Tables: Customer table, payment table

select customer_id, sum(amount) as payment
from customer
inner join payment
using (customer_id)
group by customer_id
having sum(amount)
> (
select avg(total_payment)
from
(
select customer_id, sum(amount) total_payment
from payment
group by customer_id
) as t
);


