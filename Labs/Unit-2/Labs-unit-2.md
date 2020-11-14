Lab 1: SQL Intro

1. Review the tables in the database.

2. Explore tables by selecting all columns from each table or using the in built review features for your client.

3. Select one column from a table. Get film titles.

   ```mysql
   Select titles from film; 
   ```

4. Select one column from a table and alias it. Get unique list of film languages under the alias `language`. 

   ```mysql
   select name as "language" from language;
   ```

5. Using the `select` statements and reviewing how many records are returned, can you find out how many stores and staff does the company have? Can you return a list of employee first names only?

   ```mysql
   select count(store_id) from store;
   select count(staff_id) from staff;
   
   select first_name from staff;
   ```

6. Bonus: How many unique days did customers rent movies in this dataset?

   ```mysql
   select count(rental_date) from rental;
   
   select distinct date_format(convert(rental_date,date), '%Y-%m-%d')) from rental;
   ```

Lab 2: SQL Queries

Select all the actors with the first name ‘Scarlett’.

```mysql
select actor_id, first_name 
from actor 
where first_name = 'Scarlett';
```

Select all the actors with the last name ‘Johansson’.

```mysql
select actor_id, last_name 
from actor 
where last_name = 'Johansson';
```

How many films (movies) are available for rent?

```mysql
select count(film_ID) 
from film;
```

How many films have been rented? 

```mysql
select count(distinct inventory_id) 
from rental;
```

What is the shortest and longest rental period?

```mysql
select min(rental_duration) as 'shortest rental', max(rental_duration) as 'longest rental' 
from film;
```

What are the shortest and longest movie duration? Name the values `max_duration` and `min_duration`.

```mysql
select min(length) as 'min_duration', max(length) as 'max_duration' 
from film;

```

What's the average movie duration?

```mysql
select (sum(length)/count(film_id)) as 'average duration' 
from film;

```

What's the average movie duration expressed in format (hours, minutes)?

```mysql
select floor(sum(length)/count(film_id) / 60) as 'average duration hours', 
floor(sum(length)/count(film_id) % 60) as 'average duration minutes'
from film;
```

How many movies longer than 3 hours?

```mysql
select film_id, length 
from film where length > 180
select count(length) from film where length > 180;
```

Get the name and email of all customers, formatted nicely in two columns 

```mysql
select CONCAT(first_name, last_name) as 'Name', 
email as 'Email' 
from customer;
```

What's the length of the longest film title?

```mysql
select max(length(title)) as 'Title length' 
from film;
```

SQL lab 3: SQL Queries

\1. How many distinct (different) actors' last names are there?

```mysql
select count(distinct(last_name)) from actor;
```

\2. In how many different languages where the films originally produced? (Use the column `language_id` from the `film` table)

```mysql
select count(distinct(language_id)) from film;

```

\3. How many movies were released with `"PG-13"` rating?

```mysql
select count(rating) from film where rating = 'PG-13'
```

\4. Get 10 the longest movies from 2006.

```mysql
select film_id, title, length 
from film 
where release_year = 2006
ORDER BY length DESC
LIMIT 10;
```

\5. How many days has been the company operating (check `DATEDIFF()` function)?

```mysql
select datediff(max(substring_index(rental_date, ' ', 1)), min(substring_index(rental_date, ' ', 1))) 
as 'Days of Operation' 
from rental;
```

\6. Show rental info with additional columns month and weekday. Get 20.

```mysql
select rental_id as 'Rental ID', substring_index(rental_date, ' ', 1) as 'Rental Date',
	date_format(convert(rental_date,date), '%M') as 'Month', 
	dayname(convert(rental_date,date)) as 'Day' 
from rental
limit 20;
```

\7. Add an additional column `day_type` with values 'weekend' and 'workday' depending on the rental day of the week.

```mysql
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
```

\8. How many rentals were in the last month of activity?

```mysql
select count(distinct(rental_id)) from rental where date_format(convert(rental_date,date), '%M') = 'February';
```

lab 4: SQL Queries

\1. Get film ratings.

```mysql
select distinct(rating) from film;
```

\2. Get release years.

```mysql
select distinct(release_year) from film;
```

\3. Get all films with ARMAGEDDON in the title.

```mysql
select * from film
where title regexp 'ARMAGEDDON';
```

\4. Get all films with APOLLO in the title

```mysql
select * from film
where title regexp 'APOLLO';
```

\5. Get all films which title ends with APOLLO.

```mysql
select * from film
where title like '%APOLLO';
```

\6. Get all films with word DATE in the title.

```mysql
select * 
from film
where title regexp 'DATE';
```

\7. Get 10 films with the longest title.

```mysql
select title, length(title) as Length
from film 
order by length(title) DESC 
limit 10;
```

\8. Get 10 the longest films.

```mysql
select title, length
from film
order by length DESC
limit 10;
```

\9. How many films include ****Behind the Scenes**** content?

```mysql
select count(film_id)
from film
where special_features regexp 'Behind the Scenes';
```

\10. List films ordered by release year and title in alphabetical order.

```mysql
select *
from film 
order by release_year, title;
```

Lab 5: SQL Subqueries

\1. Drop column `picture` from `staff`.

```mysql
alter table `staff`
drop column picture;

select * from staff    # To see the result
```

\2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.

```mysql
select * from customer
where first_name = 'TAMMY' and last_name = 'SANDERS';

insert into staff(first_name, last_name, email, address_id, store_id, username)
values('TAMMY','SANDERS', 'TAMMY.SANDERS@sakilacustomer.org', 79, 2, 'tammy');

select * from staff;
```

\3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1 today.

```mysql
select * from rental limit 5;

# First find the info needed to add the film to the store inventory

# get customer_id
select customer_id from sakila.customer where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
# expected customer_id = 130

# get film_id
select film_id from sakila.film where title = 'ACADEMY DINOSAUR';
# expected film_id = 1

# get inventory_id
select inventory_id from sakila.inventory where film_id = 1;
# expected inventory_id = 1

# get staff_id
select * from sakila.staff;
# expected staff_id = 1

insert into sakila.rental(rental_date, inventory_id, customer_id, staff_id)
values (curdate(), 1, 130, 1);

select * from rental limit 5;

```

\4. Delete non-active users, but first, create a _*backup table*_ `deleted_users` to store `customer_id`, `email`, and the `date` the user was deleted.

```mysql
# check the current number of inactive users

select * from sakila.customer
where active = 0;

# drop table if exists deleted_users;

CREATE TABLE deleted_users (
  customer_id int UNIQUE NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  delete_date date
)

insert into deleted_users
select customer_id, email, curdate()
from sakila.customer
where active = 0;

select * from deleted_users;
delete from sakila.customer where active = 0;

# check how many inactive users there are now
select * from sakila.customer
where active = 0;

# Solution(creating new table customer_active):

select * from customer
where active = 1;

CREATE TABLE customer_active AS
	select * from customer
	where active = 1;
    
select * from customer_active limit 5;


```

Lab-6

Update table:

```mysql
update films_2020 set rental_duration = 3;

update films_2020 set rental_rate = 2.99, replacement_cost = 8.99;
```

SQL lab 7

In the table actor, which are the actors whose last names are not repeated? For example if you would sort the data in the table actor by last_name, you would see that there is Christian Arkoyd, Kirsten Arkoyd, and Debbie Arkoyd. These three actors have the same last name. So we do not want to include this last name in our output. Last name "Astaire" is present only one time with actor "Angelina Astaire", hence we would want this in our output list. 

```mysql
select last_name from actor
group by last_name
having count(*) = 1;
```

\2. Which last names appear more than once? We would use the same logic as in the previous question but this time we want to include the last names of the actors where the last name was present more than once

```mysql
select last_name from actor
group by last_name
having count(*) > 1;
```

\3. Using the rental table, find out how many rentals were processed by each employee.

```mysql
select staff_id, count(rental_id) as rentals
from rental
group by staff_id;
```

\4. Using the film table, find out how many films were released each year.

```mysql
select count(film_id) as films, release_year
from film
group by release_year;

# Other solution

select release_year, count(*) as num_films from sakila.film
group by release_year
order by release_year;
```

\5. Using the film table, find out for each rating how many films were there.

```mysql
select rating, count(*) as num_films 
from film
group by rating
order by rating;
```

\6. What is the mean length of the film for each rating type. Round off the average lengths to two decimal places 

```mysql
select rating, round(avg(length), 2) as mean_length
from film
group by rating
order by mean_length desc;
```

\7. Which kind of movies (rating) have a mean duration of more than two hours?

```mysql
select rating, round(avg(length), 2) as mean_length
from film
group by rating
having mean_length > 120
order by mean_length desc;
```

SQL Lab 8

\1. Rank films by length (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, and the rank.  

```mysql
select title, length, rank() over(order by length desc) as 'Ranks'
from film
where length <> ' ';

# Or second option

select title, length, rank() over(order by length desc) as 'Ranks'
from film
where length is not null and length > 0;
```

\2. Rank films by length within the `rating` category (filter out the rows that have nulls or 0s in length column). In your output, only select the columns title, length, rating and the rank.  

```mysql
select title, length, rating, rank() over (partition by rating order by length desc) as 'Rank' 
from film
where length is not null and length > 0;
```

\3. How many films are there for each of the categories in the category table. Use appropriate join to write this query

```mysql
select COUNT(*) from category c
join film_category fc
on c.category_id = fc.category_id;

# List films of category 1
select * from category c
join film_category fc
on c.category_id = fc.category_id
where c.category_id = 1;
```

\4. Which actor has appeared in the most films?

```mysql
# Join the actor and film_actor tables

select a.first_name, a.last_name, count(fa.film_id) as total
from actor a
join film_actor fa
on a.actor_id = fa.actor_id
group by a.last_name, a.first_name
order by total desc;
```

\5. Most active customer (the customer that has rented the most number of films)

```mysql
select c.first_name, c.last_name, count(r.rental_id) as total
from customer c
join rental r
on c.customer_id = r.customer_id
group by c.last_name, c.first_name
order by total desc;
```

Lab 9: SQL Queries

In this lab we will find the customers who were active in consecutive months of May and June. Follow the steps to complete the analysis.

- Create a table `rentals_may` to store the data from rental table with information for the month of May.

- Insert values in the table `rentals_may` using the table rental, filtering values only for the month of May.

- Create a table `rentals_june` to store the data from rental table with information for the month of June.

- Insert values in the table `rentals_june` using the table rental, filtering values only for the month of June.

- Check the number of rentals for each customer for May.

- Check the number of rentals for each customer for June.

- Create a Python connection with SQL database and retrieve the results of the last two queries (also mentioned below) as dataframes:

  - Check the number of rentals for each customer for May

  - Check the number of rentals for each customer for June

    **Hint**: You can store the results from the two queries in two separate dataframes.

- Write a function that checks if customer borrowed more or less books in the month of June as compared to May.

  **Hint**: For this part, you can create a join between the two dataframes created before, using the merge function available for pandas dataframes. Here is a link to the documentation for the [merge function](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.merge.html).

