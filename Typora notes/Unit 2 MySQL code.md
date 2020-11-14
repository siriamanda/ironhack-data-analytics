Week 2

Monday 26.10.20: MySQL 

Basic SQL commands 'The film store'

Select the title column from table film

```mysql
select title
from film;
```

Get unique list of film languages under the alias language

```mysql
select name as language 
from language;
```

Find out how many stores and staff the company has

```mysql
select count(store_id) from `store`
select count(ID) from staff_list;
```

Return a list with employee names only 

```mysql
select name 
from staff_list;
```

Tuesday 27.10.20:

Codewars 

Return the capital of African countries starting with 'E'

```mysql
select capital
from countries
where continent like 'Afri_a'
and country like 'E%'
order by capital ASC
LIMIT 3;
```

Return the top five bestsellers

```mysql
select name, author, copies_sold
from books
order by copies_sold desc
limit 5;
```

Return a list of student that have not paid tuition fee

```mysql
select *
from students
where tuition_received = false;
```

Add your name to the participant list

```mysql
INSERT into participants (Name, Age, Attending)
values ('Siri', 29, True);
SELECT * FROM participants;
```

Select travelers from all countries except Mexico, Canada and USA

```mysql
select name, country 
from travelers
where country not in ('Mexico', 'Canada', 'USA');
```

'The bank case'

Excludes district ID's 1, 2, 3, 4

```mysql
select * from bank.`account`
where district_id <=10 NOT IN (1,2,3,4)
```

Use convert to change a date datatype from a integer to date or datetime

Arguments: (column, format)

```mysql
select account_id, district_id, frequency, convert(date,date) from bank.account;

select account_id, district_id, frequency, CONVERT(date,datetime) from bank.account;

```

Select district but exclue Prague and Central bohemia

```mysql
select distinct A3 from bank.district
where A3 not in ('Prague', 'Central bohemia');
```

Substring_index: Split a column where there is a space and return the first/last/second bit

```mysql
#next is a two step process:
select substring_index(issued, ' ', 1) from bank.card;
select convert(SUBSTRING_INDEX(issued, ' ', 1), date) from bank.card;
```

Convert a numeric date to a specific date format. Using little y, m, d returns short format.

```mysql
# converting the original format to the date format that we need:
select date_format(convert(date,date), '%Y-%M-%D') from bank.loan;
```

Example of date formats: https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html

Extract specific past of the date. This query is only returning the year:

```mysql
# if we just want to extract some specific part of the date
select date_format(convert(date,date), '%Y') 
from bank.loan;
```

The logical order of a SQL query

```mysql
# logical order of processing sql queries 
select * from bank.card
where type = 'classic'
order by card_id
limit 10;

select * from bank.order
where k_symbol = 'SIPO' and amount > 5000
order by order_id desc
limit 10;
```

ISNULL: Look for null values

```mysql
select isnull('Hello');
select isnull(card_id) from bank.card;

# this is used to check all the elements of a column.
# 0 means not null, 1 means null
select sum(isnull(card_id)) from bank.card;
```

Sometimes nulls are not nulls but spaces

```mysql
select * from bank.order
where k_symbol is null;
```

In that case we have to use:

```mysql
select * from bank.order
where k_symbol is not null and k_symbol = ' ';
```

Case statement (must use following order)

```mysql
select loan_id, account_id,
case
when status = 'A' then 'Good - Contract Finished'
when status = 'B' then 'Defaulter - Contract Finished'
when status = 'C' then 'Good - Contract Running'
else 'In Debt - Contract Running'
end as 'Status_Description'
from bank.loan;
```

In function:

```mysql
select A3 from bank.district;
select distinct A3 from bank.district;
select * from bank.order
where k_symbol in ('leasing', 'pojistine');
```

The between function:

```mysql
select * from bank.account
where district_id in (1,2,3,4,5);

# We are trying to get the same result using the between operator.
# Note that 1 and 5 are included in the range of values compared/evaluated

select * from bank.account
where district_id between 1 and 5;

select * from bank.loan
where amount - payments between 1000 and 10000;
```

Like function:

```mysql
select * from bank.district
where A3 like 'north%';

select * from bank.district
where a3 like 'north_M%';
# This would return all the results for
# 'north  Moravia', 'northMoravia', northMiami'
```

The regex function:

```mysql
select * from bank.district
where a3 regexp 'north';

# Now we will take a look at another table
# to see the difference between LIKE and REGEXP
# Regex useful for unstructured data
select * from bank.order
where k_symbol regexp 's';

# Capital S
select * from bank.order
where k_symbol regexp '^s';

# End of string
select * from bank.order
where k_symbol regexp 'o$';

# We can include multiple conditions at the same time with | between the conditions
select distinct k_symbol from bank.order
where k_symbol regexp 'ip|is';

select * from bank.district
where a2 regexp 'cesk[ey]';

select * from bank.district
where a2 regexp 'ch[e-r]';
```

Order by (Sort)

```mysql

select distinct a2 from bank.district
order by a2;

select distinct a2 from bank.district
order by a2 asc;

select * from bank.district
order by a3;

select * from bank.district
order by a3 desc;

#Note that, by default, (if not specified) the order is ascending.
#By default, in an ascending sort, special characters appear first, followed by numbers, and then letters.
#Null values appear first if the order is ascending.
#You can use any column from the table to sort the values even if that column is not used in the select statement.

# You can order by multiple columns
select * from bank.order
order by account_id, bank_to;

select * from bank.order
order by account_id, bank_to, k_symbol;
```

2.03 Activity 1

```mysql
select card_id, type, 
date_format(convert(SUBSTRING_INDEX(issued, ' ', 1), date), '%Y') as 'year_issued'
from card
where type = 'gold'
limit 10;
```

Return the year of the first issued card

```mysql
select date_format(convert(SUBSTRING_INDEX(issued, ' ', 1), date), '%Y') as 'year_issued'
from card
where type = 'gold'
ORDER BY issued ASC
LIMIT 1;
```

Same query using min( )

````mysql
select min(date_format(convert(SUBSTRING_INDEX(issued, ' ', 1), date), '%Y')) as 'year_issued'
from card
where type = 'gold'
````

Return the year of the first issued card in specific format:

We need to use SUBSTRING to cut out only the date

```mysql
select date_format(convert(SUBSTRING_INDEX(issued, ' ', 1), date), '%M %D, %Y') as year_issued,
       date_format(convert(SUBSTRING_INDEX(issued, ' ', 1), date), '%d of %M of %Y') as fecha_emision
from bank.card
limit 10;
```

Exercise 2.03

```mysql
select * from bank.district
where a3 like 'north%M%';

select * from bank.district
where a3 like 'north_M%';

select * from bank.district
where a2 regexp '^ch';
```

Exercise 2.04

```mysql
select distinct(type) from trans
order by type ASC;

select distinct(k_symbol) from trans
order by k_symbol ASC;

select account_id from account
order by district_id;
```

Wednesday. 'Bank data set'

DDL-Data definition language

Identify last client ID:

```mysql
select max(client_id) 
from client;
```

Insert new client to table'client':

```mysql
insert into client values (13999, 910408, 18)
```

Delete client from table 'client':

```mysql
delete from client 
where client_id = 13999;
```

Create database:

```mysql
create database if not exists bank_demo;
use bank_demo;
```

Run before creating table:

```mysql
drop table if exists district_demo;
```

Create table with primary key:

```mysql
CREATE TABLE district_demo (
  `A1` int(11) UNIQUE NOT NULL,					# Integer
  `A2` char(20) DEFAULT NULL,           # Characters
  `A3` varchar(20) DEFAULT NULL,				# Can be both numercial or categorical
  `A4` int(11) DEFAULT NULL,
  `A5` int(11) DEFAULT NULL,
  `A6` int(11) DEFAULT NULL,
  `A7` int(11) DEFAULT NULL,
  `A8` int(11) DEFAULT NULL,
  `A9` int(11) DEFAULT NULL,
  `A10` float DEFAULT NULL,
  `A11` int(11) DEFAULT NULL,
  `A12` float DEFAULT NULL,
  `A13` float DEFAULT NULL,
  `A14` int(11) DEFAULT NULL,
  `A15` int(11) DEFAULT NULL,
  `A16` int(11) DEFAULT NULL,
  CONSTRAINT PRIMARY KEY (A1)  -- constraint keyword is optional but its a good practice
);
```

Drop table if exits always run before creating a table:

```mysql
drop table if exists district_demo;
```

Create table with foreign key only:

```mysql
CREATE TABLE account_demo (
  account_id int(11) UNIQUE NOT NULL,
  district_id int(11) DEFAULT NULL,
  frequency text,
  date int(11) DEFAULT NULL,
  CONSTRAINT PRIMARY KEY (account_id),
  CONSTRAINT FOREIGN KEY (district_id) REFERENCES district_demo(A1)
) ;
```

Add to table:

```mysql
insert into district_demo
values (1,'Hl.m. Praha','Prague',1204953,0,0,0,1,1,100,12541,0.29,0.43,167,85677,99107),
(2,'Benesov','central Bohemia',88884,80,26,6,2,5,46.7,8507,1.67,1.85,132,2159,2674),
 (3,'Beroun','central Bohemia',75232,55,26,4,1,5,41.7,8980,1.95,2.21,111,2824,2813),
 (4,'Kladno','central Bohemia',149893,63,29,6,2,6,67.4,9753,4.64,5.05,109,5244,5892);

```

```mysql
insert into account_demo values
(1,4,'POPLATEK MESICNE',950324),
(2,1,'POPLATEK MESICNE',930226),
(3,2,'POPLATEK MESICNE',970707);
```

Alter table:

```mysql
alter table account_demo
modify date date;
select * from account_demo;
```

Create tables client_demo and card_demo:

```mysql
drop table if exists client_demo;

CREATE TABLE client_demo (
	client_id int(11) UNIQUE NOT NULL,
  	birth_number char(11) DEFAULT NULL,
 	district_id int(11) DEFAULT NULL,
  CONSTRAINT PRIMARY KEY (client_id),
  CONSTRAINT FOREIGN KEY (district_id) REFERENCES district_demo(A1)
);

drop table if exists card_demo;

CREATE TABLE card_demo (
	card_id int(30) UNIQUE NOT NULL,
  	type char(11) DEFAULT NULL,
 	issued char(11) DEFAULT NULL,
  CONSTRAINT PRIMARY KEY (card_id)
);
```

Add to tables:

```mysql
insert into client_demo values (1,706213,2),(2,450204,1),(3,406009,1),(4,561201,4)

insert into card_demo values (100592,'classic','931107'),
                        (104588,'classic','940119')
```

Add new column:

```mysql
#Add a new column
alter table accountDemo
add column balance int(11) after date;
```

Delete from = clear a table 

```mysql
-- deletes the record where the condition is met
delete from account_demo where account_id = 1;

-- deletes all the contents from the table without deleting the table
delete from account_demo;
```

Drop table = delete full table

```mysql
#Drop a column
alter table district_demo
drop column A15;
```



```mysql
# Loading data

show variables like 'local_infile';
set global local_infile = 1;
delete from district_demo;

load data local infile './district.csv' -- this file is at files_for_lesson_and_activities folder
into table district_demo
fields terminated by ',';

delete from account_demo;

load data local infile './account.csv' -- this file is at files_for_lesson_and_activities folders
into table account_demo
fields terminated BY ',';


update district_demo
set A4 = 0, A5 = 0, A6 = 0
where A2 = 'Kladno';


-- what is the total amount loaned by the bank so far
select sum(amount) from bank.loan;

# Use group by to be able to compare the sum of different payment plans
select duration, sum(amount) from bank.loan
group by duration;

-- what is the total amount that the bank has recovered/received from the customers
select sum(payments) from bank.loan;

-- what is the average loan amount taken by customers in Status A
select avg(amount) from bank.loan
where Status = 'A';


select avg(amount) from bank.loan
group by Status;
select avg(amount) as Average, status from bank.loan
group by Status
order by Average asc;

```

Add column and add information using case statement:

```mysql
alter table loan
add column description char(30) after status;
# Update instead of insert because we are not inserting new rows
update loan set description = case 
  when status = 'A' then 'Good - Contract Finished'
  when status = 'B' then 'Defaulter - Contract Finished'
  when status = 'C' then 'Good - Contract Running'
  else 'In Debt - Contract Running'
  end;
```

SQL katas

Select the minimum and maximum ages from the people table:

```mysql
select min(age) as age_min, max(age) as age_max from people;
```

Trim the list of characteristics of monsters, order by ID: 

```mysql
SELECT id,
       name, 
       split_part(characteristics, ',', 1) as characteristic
  FROM monsters
ORDER BY id
```

List the students depending on which hogwarts team they are going to be in: 

```mysql
select * from students
where 
((quality1 = 'evil' and quality2 = 'cunning')
or (quality1 = 'brave' and quality2 != 'evil')
or (quality1 = 'studious' or quality2 = 'intelligent')
or (quality1 = 'hufflepuff' or quality2 = 'hufflepuff'))
order by id;
```

Bank data:

Show the average amount, grouped by status:

```mysql
-- step1:
select round(avg(amount),2) as "Avg Amount", round(avg(payments),2) as "Avg Payment", status
from bank.loan
group by status
order by status;
```

show the average balance, grouped by status:

```mysql
-- step1:
select round(avg(amount),2) as "Avg Amount", round(avg(payments),2) as "Avg Payment", status
from bank.loan
group by status
order by status;
```

Group by function:

```mysql
-- step1:
select round(avg(amount),2) as "Avg Amount", round(avg(payments),2) as "Avg Payment", status
from bank.loan
group by status
order by status;
```

Group by and filter out empty fields:

```mysql
select round(avg(amount),2) as Average, k_symbol from bank.order
where k_symbol<> ' '      # <> is ´not equal to
group by k_symbol
order by Average asc;

```

2.07 Activity 1

`bank` database.

1. Find out how many cards of each type have been issued.

   ```mysql
   select type, count(type) as 'issued cards'
   from card 
   group by type;
   ```

2. Find out how many customers there are by the district.

   ```mysql
   select district_id as 'District', count(client_id) as 'Customers'
   from client
   group by district_id;
   ```

3. Find out average transaction value by type.

   ```mysql
   select type, avg(amount)
   from trans
   group by type;
   ```

   Using both group by and order by:

```mysql
select round(avg(amount),2) as Average, k_symbol from bank.order
where not k_symbol = ' '
group by k_symbol
order by Average asc;

select round(avg(amount),2) - round(avg(payments),2) as "Avg Balance", status, duration
from bank.loan
group by status, duration
order by status, duration;

select round(avg(amount),2) - round(avg(payments),2) as "Avg Balance", status, duration
from bank.loan
group by status, duration
order by duration, status;
```

Without the order by:

```mysql
#Query without the "order by" clause
select type, operation, k_symbol, round(avg(balance),2)
from bank.trans
group by type, operation, k_symbol;

# Without the blanks
select type, operation, k_symbol, round(avg(balance),2)
from bank.trans
where not k_symbol <> ' '
group by type, operation, k_symbol;

```



```mysql
-- Not the most efficient way of using the HAVING clause

select type, operation, k_symbol, round(avg(balance),2) as Average
from bank.trans
where k_symbol <> '' and k_symbol <> ' '
group by type, operation, k_symbol
having operation <> ''
order by type, operation, k_symbol;
```

if yiou using aggregations - use having rather than where.

Avtivity 2.07 3

1. Find the districts with more than 100 clients.

   ```mysql
   select district_id, count(client_id) as no_customers 
   from client 
   group by district_id
   having no_customers > 100
   order by no_customers;
   ```

   

2. Find the transactions (type, operation) with a mean amount greater than 10000.

   ```mysql
   select type, operation, round(avg(`amount`),2) from trans
   group by type, operation
   having avg(amount) > 10000;
   ```

   Window function:

```mysql
select loan_id, account_id, amount, payments, duration, amount-payments as "Balance",
avg(amount-payments) over (partition by duration) as Avg_Balance
from bank.loan
where amount > 100000
order by duration, balance desc;


# You can also have ORDER BY clause followed by partition by as shown below:


select loan_id, account_id, amount, payments, duration, amount-payments as "Balance",
avg(amount-payments) over (partition by duration order by duration asc, amount desc) as Avg_Balance
from bank.loan
where amount > 100000;
```

Continue..

```mysql
# Goal is to rank the customers based on the amount of loan borrowed.
# This will help us to find the nth highest amount in the table

select *, rank() over (order by amount desc) as 'Rank'
from bank.loan;

select *, row_number() over (order by amount desc) as 'Row Number'
from bank.loan;

# In this query, we are trying to rank the customers based on the amount of loan
# they have borrowed, in each of the "k_symbol" categories

select * , rank() over (partition by k_symbol order by amount desc) as "Ranks"
from bank.order
where k_symbol <> " ";

select *, rank() over(order by amount asc) as 'RANK'
from bank.order
where k_symbol <> ' ';

# or 

select *, dense_rank() over(order by amount asc) as 'RANK'
from bank.order
where k_symbol <> ' ';

select * from bank.account a
join bank.loan l on a.account_id = l.account_id
limit 10;

# Building on the same query to add some filters and order by

select * from bank.account a
join bank.loan l on a.account_id = l.account_id
where l.duration = 12
order by l.payments
limit 10;

# Select a few columns to join using am alias (in this case a and l)

select a.account_id, a.frequency, l.loan_id, l.amount, l.duration, l.payments, l.status
from bank.account a
join bank.loan l on a.account_id = l.account_id
where l.duration = 12
order by l.payments
limit 10;

# Some test code to see how many distinct account id's we have in table account vs table loan, that is how many rows the left and right joins will return

select count(distinct account_id) from bank.account;
select count(distinct account_id) from bank.loan;

# Left Join

select a.account_id, a.frequency, l.loan_id, l.amount, l.duration, l.payments, l.status
from bank.account a
left join bank.loan l on a.account_id = l.account_id
order by a.account_id;

# Right Join

select a.account_id, a.frequency, l.loan_id, l.amount, l.duration, l.payments, l.status
from bank.account a
right join bank.loan l on a.account_id = l.account_id
order by a.account_id;


```

Rank districts by different variables

```mysql
# Compare number of inhabitants wihtin districts per each region of czech rep.

select *, rank() over (partition by A3 order by A4 desc) as 'rank'
from district; 
```

select rank() order by rank

Challenge for your breakout rooms:

1 Write a query to extract for each client: account_id, operation, frequency, sum of amount, sum of balance, 

b) where the balance is over 1000, 

c) operation type is VKLAD and 

d) that have an aggregated amount of over 500,000 shown in descendent. Then get the top 10.

```mysql
Select a.account_id, a.frequency, t.operation, sum(t.amount) as TotalAmount, round(sum(t.balance), 2) as TotalBalance from bank.account as a
left join bank.trans as t
on a.account_id = t.account_id
where t.operation = 'VKLAD' and t.balance > 1000
group by t.account_id, t.operation, a.frequency
having TotalAmount > 500000
order by TotalAmount desc
limit 10;
```

Codewars katas 03.11.2020

Return the *firstname* and *lastname* column concatenated, separated by a space, into a single *shortlist* column, and capitalise the first letter of each name.

```mysql
SELECT CONCAT(INITCAP(firstname), ' ', INITCAP(lastname)) AS shortlist     # Initcap capitalises the first letter
FROM elves
WHERE firstname LIKE '%tegil%' OR lastname LIKE '%astar%'
```

