# List number of films per 'category`.

select category_id as Category, count(film_id) from film_category
group by category_id;

# Full 
select c.name as Category, count(f.film_id) as NumFilms from sakila.category as c
left join sakila.film_category as f
on c.category_id = f.category_id
group by c.name
order by NumFilms DESC;

# Display the first and last names, as well as the address, of each staff member.

select s.first_name, s.last_name, a.address from sakila.staff as s
left join sakila.address as a
on s.address_id = a.address_id
group by staff_id;

# Display the total amount rung up by each staff member in August of 2005.

select p.staff_id, s.first_name, s.last_name, sum(p.amount) from payment p
join staff s      				# Inner join, only accepting the matches
on p.staff_id = s.staff_id
where date(payment_date) between date('2005-08-01') and date('2005-08-30')
group by s.staff_id;

# List each film and the number of actors who are listed for that film

Select f.film_id, f.title, count(a.actor_id) from sakila.film as f
left join sakila.film_actor as a
on f.film_id = a.film_id
group by film_id;

# Using the tables `payment` and `customer` and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.

Select c.customer_id, c.first_name, c.last_name, sum(p.amount) as TotalAmount from sakila.payment as p
left join sakila.customer as c
on p.customer_id = c.customer_id
group by customer_id
order by c.last_name ASC;

