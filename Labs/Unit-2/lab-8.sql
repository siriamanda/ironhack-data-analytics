# Rank films by length (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, and the rank.  

select title, length, rank() over(order by length desc) as 'Ranks'
from film
where length <> ' ';

# Or second option

select title, length, rank() over(order by length desc) as 'Ranks'
from film
where length is not null and length > 0;

#  Rank films by length within the `rating` category (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, rating and the rank.  

select title, length, rating, rank() over (partition by rating order by length desc) as 'Rank' 
from film
where length is not null and length > 0;

# How many films are there for each of the categories in the category table. Use appropriate join to write this query

select COUNT(*) from category c
join film_category fc
on c.category_id = fc.category_id;

# List films of category 1
select * from category c
join film_category fc
on c.category_id = fc.category_id
where c.category_id = 1;

# Which actor has appeared in the most films?

# Join the actor and film_actor tables

select a.first_name, a.last_name, count(fa.film_id) as total
from actor a
join film_actor fa
on a.actor_id = fa.actor_id
group by a.last_name, a.first_name
order by total desc;

# Most active customer (the customer that has rented the most number of films)

select c.first_name, c.last_name, count(r.rental_id) as total
from customer c
join rental r
on c.customer_id = r.customer_id
group by c.last_name, c.first_name
order by total desc;

