# Drop column `picture` from `staff`.

alter table `staff`
drop column picture;

select * from staff    # To see the result

# A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.

select * from customer
where first_name = 'TAMMY' and last_name = 'SANDERS';

insert into staff(first_name, last_name, email, address_id, store_id, username)
values('TAMMY','SANDERS', 'TAMMY.SANDERS@sakilacustomer.org', 79, 2, 'tammy');

select * from staff;

# Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1 today.

select * from rental limit 5;

# First find the info needed to add the film to the store inventory

# get customer_id

select customer_id from sakila.customer where first_name = 'CHARLOTTE' and last_name = 'HUNTER';

# get film_id
select film_id from sakila.film where title = 'ACADEMY DINOSAUR';

# get inventory_id
select inventory_id from sakila.inventory where film_id = 1;

# get staff_id
select * from sakila.staff;

insert into sakila.rental(rental_date, inventory_id, customer_id, staff_id)
values (curdate(), 1, 130, 1);

select * from rental limit 5;

# Delete non-active users, but first, create a _*backup table*_ `deleted_users` to store `customer_id`, `email`, and the `date` the user was deleted.

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

