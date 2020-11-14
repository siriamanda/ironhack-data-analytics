Lab 1: SQL join

\1. List number of films per 'category`.

```mysql
select category_id as Category, count(film_id) from film_category
group by category_id;

# Full 
select c.name as Category, count(f.film_id) as NumFilms from sakila.category as c
left join sakila.film_category as f
on c.category_id = f.category_id
group by c.name
order by NumFilms DESC;
```

\2. Display the first and last names, as well as the address, of each staff member.

```mysql
select s.first_name, s.last_name, a.address from sakila.staff as s
left join sakila.address as a
on s.address_id = a.address_id
group by staff_id;
```

\3. Display the total amount rung up by each staff member in August of 2005.

```mysql
select p.staff_id, s.first_name, s.last_name, sum(p.amount) from payment p
join staff s      # Inner join, only accepting the matches
on p.staff_id = s.staff_id
where date(payment_date) between date('2005-08-01') and date('2005-08-30')
group by s.staff_id

# Can also use:
WHERE YEAR(payment_date) = 2005 AND MONTH(payment_date) = 08
WHERE p.payment_date like '2005-08-%'

```

\4. List each film and the number of actors who are listed for that film

```mysql
Select f.film_id, f.title, count(a.actor_id) from sakila.film as f
left join sakila.film_actor as a
on f.film_id = a.film_id
group by film_id;
```

\5. Using the tables `payment` and `customer` and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name.

```mysql
Select c.customer_id, c.first_name, c.last_name, sum(p.amount) as TotalAmount from sakila.payment as p
left join sakila.customer as c
on p.customer_id = c.customer_id
group by customer_id
order by c.last_name ASC;
```

lab 2: SQL Joins on multiple tables

\1. Write a query to display for each store its store ID, city, and country.

```mysql
select s.store_id, a.address, c.city, k.country from sakila.store as s
left join sakila.address as a
on s.address_id = a.address_id
join sakila.city as c
on a.city_id = c.city_id
join sakila.country as k
on c.country_id = k.country_id;
```

\2. Write a query to display how much business, in dollars, each store brought in.

```mysql
select s.store_id, t.total_sales from sakila.store as s
left join staff_list as l
on s.manager_staff_id = l.ID
join sales_by_store as t
on l.name = t.manager;
```

\3. What is the average running time of films by category?

```mysql
select fc.category_id, c.name as Category, avg(f.length) as AvgDuration from sakila.film as f
left join sakila.film_category as fc
on f.film_id = fc.film_id
join sakila.category as c
on fc.category_id = c.category_id
group by category_id;
```

\4. Which film categories are longest?

```mysql
select fc.category_id, c.name as Category, avg(f.length) as AvgDuration from sakila.film as f
left join sakila.film_category as fc
on f.film_id = fc.film_id
join sakila.category as c
on fc.category_id = c.category_id
group by category_id
order by AvgDuration DESC
limit 5;
```

\5. Display the most frequently rented movies in descending order.

```mysql
select f.title, count(r.inventory_id) as "NumRentals" from sakila.film as f
join sakila.inventory as i
using (film_id)
join sakila.rental as r
using (inventory_id)
group by title
order by NumRentals DESC
limit 20;
```

\6. List the top five genres in gross revenue in descending order.

```mysql
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
```

\7. Is "Academy Dinosaur" available for rent from Store 1?

```mysql
select f.title , i.store_id from sakila.film as f
join sakila.inventory as i
using(film_id)
where f.title = "Academy Dinosaur" and store_id = "1";
```

Lab 3: Self and Cross Joins

1. Get all pairs of actors that worked together.

   ```mysql
   select fa1.film_id, concat(a1.first_name, ' ', a1.last_name), concat(a2.first_name, ' ', a2.last_name)
   from sakila.actor a1
   inner join film_actor fa1 on a1.actor_id = fa1.actor_id
   inner join film_actor fa2 on (fa1.film_id = fa2.film_id) and (fa1.actor_id != fa2.actor_id)
   inner join actor a2 on a2.actor_id = fa2.actor_id;
   ```

2. Get all pairs of customers that have rented the same film more than 3 times.

   ```mysql
   select c1.customer_id, c2.customer_id, count(*) as num_films
   from sakila.customer c1
   inner join rental r1 on r1.customer_id = c1.customer_id
   inner join inventory i1 on r1.inventory_id = i1.inventory_id
   inner join film f1 on i1.film_id = f1.film_id
   inner join inventory i2 on i2.film_id = f1.film_id
   inner join rental r2 on r2.inventory_id = i2.inventory_id
   inner join customer c2 on r2.customer_id = c2.customer_id
   where c1.customer_id <> c2.customer_id
   group by c1.customer_id, c2.customer_id
   having count(*) > 3
   order by num_films desc;
   ```

3. Get all possible pairs of actors and films.

   ```mysql
   select concat(a.first_name,' ', a.last_name) as actor_name,
       f.title
   from sakila.actor a
   cross join sakila.film as f;
   ```

   Lab 4: Normalisation (Optional)

Lab 5: Subqueries

1. How many copies of the film *Hunchback Impossible* exist in the inventory system?

```mysql
# To get film id

select count(film_id) as Copies from inventory 
where film_id = (
  select film_id from film where title = "Hunchback Impossible");

```

2. List all films whose length is longer than the average of all the films.

```mysql
SELECT title, length FROM film 
WHERE length > (SELECT avg(length) from film);

```

3. Use subqueries to display all actors who appear in the film *Alone Trip*.

```mysql
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
```

4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

```mysql
select concat(first_name , ' ' , last_name), email 
from sakila.customer
where address_id in (
select address_id 
from address
where city_id (
select city_id
from city
where country_id(
select country_id
from country
where country = "Canada")));

# Without subqueries
select title as Total from film_list 
where category = 'Family';
```

5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

```mysql
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
```



6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

```mysql
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

```

7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

```mysql
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
```

8. Customers who spent more than the average payments.

```mysql
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
```

Lab 6: SQL Advanced Queries

1. List each pair of actors that have worked together.

```

```

2. For each film, list actor that has acted in more films.

```

```

Lab 3.07: SQL Rolling Calculations

1. Get number of monthly active customers.

```mysql
with customer_activity as (
 select customer_id, convert(rental_date, date) as Activity_date,
date_format(convert(rental_date,date), '%M') as Activity_Month,
 date_format(convert(rental_date, date), '%Y') as Activity_Year
 from sakila.rental
)
select count(distinct customer_id) as Active_Users, Activity_Year, Activity_Month from customer_activity
group by Activity_Year, Activity_Month
order by Activity_Year, Activity_Month;
```

2. Active users in the previous month.

```

```

3. Percentage change in the number of active customers.

````

````

4. Retained customers every month.

```

```

Lab 8: Making predictions 

In order to optimize our inventory, we would like to know which films will be rented next month and we are asked to create a model to predict it.

1. Create a query or queries to extract the information you think may be relevant for building the prediction model. It should include some film features and some rental features.

   ```mysql
   # General film information
   
   select f.film_id,
    		f.title, 
    		f.description,
    		fc.category_id,
    		f.language_id,
    		f.length/60 as hours_length,
    		f.rating,
    		f.release_year, 
    		f.rental_duration,
    		f.special_features, 
    		count(actor_id) as actors_in_film,
    		avg(f.rental_duration) * 24 as avg_hours_rental_allowed,
    		avg(f.replacement_cost) as avg_replacement_cost
    from film f
    join film_category as fc
    using(film_id)
    join film_actor as fa
    using(film_id)
    group by 1,2,3,4,5,6,7,8,9,10
    order by film_id;
    
    # Rental information
    
    select i.film_id,
   		count(r.rental_id) as num_rent_times,
   		avgp.amount as rental_cost,
   		avg(timestampdiff(hour, r.rental_date, r.return_date)) as avg_hours_rented
   from rental as r
   join payment as p on p.rental_id = r.rental_id
   join inventory as i on r.inventory_id = i.inventory_id
   group by 1, 3;
   ```

   

2. Read the data into a Pandas dataframe

   ```python
   # In Python
   
   # Connect to the database
   
   import pymysql
   from sqlalchemy import create_engine
   import pandas as pd
   import getpass  # To get the password without showing the input
   password = getpass.getpass()
   
   db_url = f'mysql+pymysql://root:{password}@localhost/sakila'
   
   # Query
   
   query_1 = '''
   select i.film_id,
       round(avg(p.amount),2) avg_rental_cost,
       round(avg(timestampdiff(hour, r.rental_date, r.return_date)),2) as hours_rented,
        count(ifnull(r.rental_id, 0)) as num_rent_times
   from rental r
   join payment p on p.rental_id = r.rental_id
   join inventory i on i.inventory_id = r.inventory_id
   group by 1
   order by 1,2,3,4;
   '''
   query_2 = '''
   select
     act2.film_id,
     group_concat(act2.actor_id separator ',') actor_list,
     sum(act2.actor_fame) total_actor_fame,
     sum(act2.actor_influence) total_actor_influence
   from (
     select fa.film_id, act1.*
       from (
         select
           fa1.actor_id,
           count(distinct(fa1.film_id)) actor_fame,
           count(distinct(fa2.actor_id)) actor_influence
           from
             film_actor fa1
             join film_actor fa2 on fa2.film_id = fa1.film_id
             group by fa1.actor_id
       ) act1
       join film_actor fa on fa.actor_id = act1.actor_id
   ) act2
   group by act2.film_id;
   '''
   query_3 = '''
   select  f.film_id,
          f.title,
        f.description,
        fc.category_id,
        f.language_id,
        avg(f.rental_duration) * 24  as avg_hours_rental_allowed,
        f.length / 60  as hours_length,
        avg(f.replacement_cost) as avg_replacement_cost,
        f.rating,
        f.special_features,
        count(fa.actor_id) actors_in_film
   from film f
   join film_category fc on fc.film_id = f.film_id
   join film_actor fa on fa.film_id = f.film_id
   group by 1,2,3,4,5,7,9,10
   order by 1,4,5,6,7;'''
   
   # Add the queries to a data frame
   
   data = pd.read_sql(query_1, db_url)
   data
   
   data_1 = pd.read_sql(query_2, db_url)
   data_1
   
   data_2 = pd.read_sql(query_3, db_url)
   data_2
   
   # Concatenate the datasets vertically
   
   frames = [data, data_1, data_2]
   
   df = pd.concat(frames, axis = 1) 
   ```

3. Analyze extracted features and transform them. You may need to encode some categorical variables, or scale numerical variables.

   ```python
   df.shape
   
   df.dtypes
   
   df.describe()
   
   # Count the null values
   # Check the difference null values and number of columns
   # If the percentage of null values is low we can drop the null values
   
   df.isnull().sum()
   
   df.columns
   
   #Drop null values
   # Need to add 'inplace = True'
   
   df.dropna(axis = 0, inplace = True)
   
   # film_id occurs three times, therefore we can remove two of the columns
   
   df_1 = df.loc[:,~df.columns.duplicated()]
   
   # Check correlations
   
   df_1.corr()
   
   ```

4. Create a query to get the list of films and a boolean indicating if it was rented last month. This would be our target variable

   ```
   
   ```

5. Create a logistic regression model to predict this variable from the cleaned data.

   ```
   
   ```

6. Evaluate the results.

```

```

