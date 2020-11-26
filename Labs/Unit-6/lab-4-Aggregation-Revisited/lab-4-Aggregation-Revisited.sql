# Write the SQL queries to answer the following questions:

# Select the first name, last name, and email address of all the customers who have rented a movie.

select c.first_name, c.last_name, c.email, count(r.rental_id) as rentals
from customer c
inner join rental r on r.customer_id = c.customer_id
group by c.first_name, c.last_name, c.email
having count(r.rental_id) > 0
order by count(r.rental_id) desc;


# What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

select concat(c.first_name, ' ', c.last_name) as name, avg(p.amount) from customer c
join payment p
using (customer_id)
group by name;

# Select the name and email address of all the customers who have rented the "Action" movies.

# Write the query using multiple join statements

select first_name, last_name, c.email from customer c
join rental r
on c.customer_id = r.customer_id
join inventory i
on r.inventory_id = i.inventory_id
join film_category fc
on i.film_id = fc.film_id
join category ca
on fc.category_id = ca.category_id
group by first_name, last_name, c.email, ca.name
having ca.name = 'Action';

# Write the query using sub queries with multiple WHERE clause and IN condition

select first_name, last_name, c.email 
from customer c
where customer_id IN
(select customer_id from rental
where inventory_id IN
(select inventory_id from inventory
where film_id in
(select film_id from film_category
where category_id in
(select category_id from category
where name = 'Action')))
);


# Verify if the above two queries produce the same results or not

# Yes, but the subquery is faster

#Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.

select payment_id, amount,
CASE
	when amount between 0 and 2 then "low"
	when amount between 3 and 4 then "medium"
	else "high"
END as ValueClass
from payment;
