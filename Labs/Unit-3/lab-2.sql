# Write a query to display for each store its store ID, city, and country.

select s.store_id, a.address, c.city, k.country from sakila.store as s
left join sakila.address as a
on s.address_id = a.address_id
join sakila.city as c
on a.city_id = c.city_id
join sakila.country as k
on c.country_id = k.country_id;

# Write a query to display how much business, in dollars, each store brought in.

select s.store_id, t.total_sales from sakila.store as s
left join staff_list as l
on s.manager_staff_id = l.ID
join sales_by_store as t
on l.name = t.manager;

# What is the average running time of films by category?

select fc.category_id, c.name as Category, avg(f.length) as AvgDuration from sakila.film as f
left join sakila.film_category as fc
on f.film_id = fc.film_id
join sakila.category as c
on fc.category_id = c.category_id
group by category_id;

# Which film categories are longest?

select fc.category_id, c.name as Category, avg(f.length) as AvgDuration from sakila.film as f
left join sakila.film_category as fc
on f.film_id = fc.film_id
join sakila.category as c
on fc.category_id = c.category_id
group by category_id
order by AvgDuration DESC
limit 5;

# Display the most frequently rented movies in descending order.

select f.title, count(r.inventory_id) as "NumRentals" from sakila.film as f
join sakila.inventory as i
using (film_id)
join sakila.rental as r
using (inventory_id)
group by title
order by NumRentals DESC
limit 20;

# List the top five genres in gross revenue in descending order.

select c.name, sum(p.amount) as "GrossAmount" from sakila.category as c
join sakila.film_category as fc
using (category_id)
join sakila.inventory as i
using (film_id)
join sakila.rental as r
using (inventory_id)
join sakila.payment as p
using (rental_id)
group by c.name
order by GrossAmount DESC;

# Is "Academy Dinosaur" available for rent from Store 1?

select f.title , i.store_id from sakila.film as f
join sakila.inventory as i
using(film_id)
where f.title = "Academy Dinosaur" and store_id = "1";


