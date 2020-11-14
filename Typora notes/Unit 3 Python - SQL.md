Add your 'ingredients'

```Python
import pymysql
from sqlalchemy import create_engine
import pandas as pd
import numpy as np
import matplotlib
%matplotlib inline
import matplotlib.pyplot as plt
import seaborn as sns 
```

The general Syntax for connecting Python to SQL:

```python
#'dialect+driver://username:password@host:port/database'
# to create the connection string

# Connect to MariaDB database:

connection_string = 'mysql+pymysql://guest:relational@relational.fit.cvut.cz:3306/world'
engine = create_engine(connection_string)

# Connect to the world database and select all from country table
data = pd.read_sql_query('SELECT * FROM world.Country', engine)
data.head()
```

Print all rows in x using for loop:

```python
# see all rows in language table of DB 
result = engine.execute('SELECT * FROM world.CountryLanguage')
for row in result:
    print(row)

rows = [row for row in result]
pd.DataFrame(rows)
```

```Python
#getting a data frame called df out of a sql query
#tip you can 1st practice and perfect your sql query inside a sql client

engine.execute("USE world")
query = 'select Continent as "Continent", Region as "Region", Name as "Country", FORMAT(Population,0) as "popln" , Round((Population/SurfaceArea),0) as "density"\
from world.Country  \
where Population <> 0 \
order by Density Desc \
limit 25'
data = pd.read_sql_query(query, engine)
data.head()
```

Print the descriptive statistics - describing the density field

```python
data.describe()
```

Plotting data using bath (horizontal bar chart)

```python
ax = data.plot.barh(x='Country', y='density')
```

What are the 25 most dense countries

Join to city table. In this case a left join would make more sense because we have less countries than cities:

```python
# join to city table 
query = "select c.Name as Country, FORMAT(c.Population,0) as countrypop, Round((c.Population/c.SurfaceArea),0) as density, FORMAT(t.Population,0) as citypop, t.Name, Round((t.Population/c.Population)*100,2) as proportion from world.Country c \
left join world.City t \
on c.Capital= t.ID \
order by c.Population desc \
limit 25"
dataf = pd.read_sql_query(query, engine)
dataf.head()
```

```python
dataf.describe()
```

```python
matplotlib.rc_file_defaults() 
#Restore the rc params from Matplotlib's internal default style
```

```python
ax1= sns.set_style(style=None, rc=None)
#This affects things like the color of the axes, whether a grid is enabled by default, and other aesthetic elements.
# https://seaborn.pydata.org/generated/seaborn.set_style.html
```

Combination chart

```python
fig, ax1 = plt.subplots(figsize=(10,6))
color = 'tab:green'
#bar plot creation
ax1.set_title('popln density', fontsize=16)
ax1.set_xlabel('country', fontsize=16)
ax1.set_ylabel('density', fontsize=16)
ax1 = sns.barplot(x='Country', y='density', data = dataf, palette='summer')
ax1.tick_params(axis='y')
plt.xticks(rotation=70)
plt.tight_layout()
#specify we want to share the same x-axis
ax2 = ax1.twinx()
color = 'tab:red'
#line plot creation
ax2.set_ylabel('capitalVcountry', fontsize=16)
ax2 = sns.lineplot(x='Country', y='proportion', data = dataf, sort=False, color=color)
ax2.tick_params(axis='y', color=color)
#show plot
plt.show()
```

Tuesday:

Activity 3.02 

Bank database: List districts together with total amount borrowed and average loan amount.

```mysql
select d.A2, sum(l.amount) as TotalBorrowed, avg(l.amount) as AvgLoan from bank.loan l
join account a
on l.account_id = a.account_id
join district d
on a.district_id = d.A1
group by d.A2;

# Or as a window function (not needed for this exercise)

select d.A2, sum(l.amount) OVER (Partition by a.district_id) as TotalBorrowed, avg(l.amount) OVER (Partition by a.district_id) as AvgLoan from loan l
join account a
on l.account_id = a.account_id
join district d
on a.district_id = d.A1
order by d.A2;
```

Activity 3.2.05

```mysql
# Get a list of accounts from Central Bohemia using a subquery.
# Rewrite the previous as a join query.
# Discuss which method will be more efficient.

# Tables: account and district

# subquery
select a.account_id from bank.account a
where a.district_id in (
select A1 as "district"
from bank.district d
where A3 = "Central Bohemia");

select account_id from account
where district_id in (
select A1 from district 
where A3 = "Central Bohemia")
group by account_id;

# join
select a.account_id
from bank.account a
join bank.district d
on a.district_id = d.A1
where A3 = "Central Bohemia";

select account_id from account
inner join district
on district_id = A1
where A3 = "Central Bohemia";
```

3.05.3 Find the most active cusotmer for each district in Central Bohemia

```mysql
select district.A2 district_name, account_id, round(total) as total
from
(
  select ac.account_id, ac.district_id, sum(tr.amount) as total,
  rank() over (partition by district_id order by sum(tr.amount) desc) as position
  from bank.account ac
  inner join bank.trans tr
  using (account_id)
  group by ac.account_id
) as t
inner join district on t.district_id = district.A1
where position = 1
and district.A3 = 'central bohemia'
order by district_id;
```

```mysql
#inner joins as lookups

select * from bank.loan l
join bank.account a
on l.account_id = a.account_id;

select l.loan_id, l.account_id, l.amount, l.payments, a.district_id, a.frequency, a.date
from bank.loan l
join bank.account a
on l.account_id = a.account_id;

select * from bank.account a
join bank.loan l
on a.account_id = l.account_id;

# left joins 

select * from bank.loan l
left join bank.account a
on l.account_id = a.account_id;

select * from bank.account a
left join bank.loan l
on a.account_id = l.account_id;


# Write a query to extract information from the client and the district tables to get information for all the clients of the city and region they are from.



-- Step 1
select * from bank.client c join district d
on c.district_id = d.A1;

-- Step 2
select c.client_id, c.birth_number, c.district_id, d.A2, d.A3
from bank.client c join bank.district d
on c.district_id = d.A1;

#Write queries to extract information about the accounts:
#a) returning account_id, operation, frequency, sum of amount, sum of balance, b) where the balance is over 1000, c) operation type is VKLAD and d) that have an aggregated amount of over 500,000.

-- step1

select * from bank.trans t
left join bank.account a
on t.account_id = a.account_id;

-- step 2
select * from bank.trans t left join bank.account a on t.account_id = a.account_id
where t.operation = 'VKLAD' and balance > 1000;

-- step 3
select t.account_id, t.operation, a.frequency, sum(amount) as TotalAmount, sum(balance) as TotalBalance
from bank.trans t left join bank.account a on t.account_id = a.account_id
where t.operation = 'VKLAD' and balance > 1000
group by t.account_id, t.operation, a.frequency;

-- step 4
select t.account_id, t.operation, a.frequency, sum(amount) as TotalAmount, sum(balance) as TotalBalance
from bank.trans t left join bank.account a on t.account_id = a.account_id
where t.operation = 'VKLAD' and balance > 1000
group by t.account_id, t.operation, a.frequency
having TotalAmount > 500000
order by TotalAmount desc
limit 10;

#Get all the columns from 3 tables

select * from bank.disp d
join bank.client c
on d.client_id = c.client_id
join bank.card ca
on d.disp_id = ca.disp_id;

select d.disp_id, d.type, d.client_id, c.birth_number, ca.type from bank.disp d
join bank.client c
on d.client_id = c.client_id
join bank.card ca
on d.disp_id = ca.disp_id
where ca.type = 'gold';

# One more example - demo how to extract all the information from three tables (disp, client, and district):

select * from bank.disp d
join bank.client c
on d.client_id = c.client_id
join bank.district da
on da.A1 = c.district_id;

#temporary tables 

create temporary table bank.loan_and_account
select l.loan_id, l.account_id, a.district_id, l.amount, l.payments, a.frequency
from bank.loan l
join bank.account a
on l.account_id = a.account_id;

select * from bank.loan_and_account;

create temporary table bank.disp_and_account
select d.disp_id, d.client_id, d.account_id, a.district_id, d.type
from disp d
join account a
on d.account_id = a.account_id;

select * from bank.disp_and_account;

select * from bank.loan_and_account la
join bank.disp_and_account da
on la.account_id = da.account_id
and la.district_id = da.district_id;

# outer joins, more than 2 tables 

select a.account_id, a.district_id, a.frequency, d.A2, d.A3, l.loan_id, l.amount, l.payments
from bank.account a left join bank.district d
on a.district_id = d.A1
left join bank.loan l
on a.account_id = l.account_id
order by a.account_id;

# Notice the difference in the results if we remove the keyword left from the query above. The query with only inner joins for the same tables as above is shown below:

select a.account_id, a.district_id, a.frequency, d.A2, d.A3, l.loan_id, l.amount, l.payments
from bank.account a join bank.district d
on a.district_id = d.A1
join bank.loan l
on a.account_id = l.account_id
order by a.account_id;

# self joins - Here in this example we are trying to find the customers that are from the same district.

select * from bank.account a1
join bank.account a2
on a1.account_id <> a2.account_id
and a1.district_id = a2.district_id
order by a1.district_id;

select a1.account_id, a2.account_id, a1.district_id
from bank.account a1
join bank.account a2
on a1.account_id <> a2.account_id
and a1.district_id = a2.district_id
order by a1.district_id, a1.account_id;

# Here in this example we are trying to find the customers that are both the OWNER and DISPONENT (look at the table disp)

select * from bank.disp d1
join bank.disp d2
on d1.account_id = d2.account_id
and d1.type <> d2.type;

select d1.account_id, d1.type as Type1, d2.type as Type2
from bank.disp d1
join bank.disp d2
on d1.account_id = d2.account_id
and d1.type <> d2.type;

# As you will see, there are repeated values for each of the account ids. Lets try to solve this problem now.

select d1.account_id, d1.type as Type1, d2.type as Type2
from bank.disp d1
join bank.disp d2
on d1.account_id = d2.account_id and d1.type <> d2.type
where d1.type = 'DISPONENT';

# Or alt method 

drop temporary table if exists combo;

create temporary table combo
select d1.account_id, d1.type as Type1, d2.type as Type2, row_number() over(order by account_id) as RowNumber
from bank.disp d1
join bank.disp d2
on d1.account_id = d2.account_id and d1.type <> d2.type;

select * from combo
where RowNumber % 2 = 1;

# Lets say we want to find all the combinations of different card types and ownership of account. We have not talked about sub queries yet. We will cover sub queries in greater detail later.

select * from (
  select distinct type from bank.card
) sub1
cross join (
  select distinct type from bank.disp
) sub2;

# The CROSS JOIN is used to generate a paired combination of each row of the first table with each row of the second table. This join type is also known as cartesian join.

create temporary table bank.distinct_cards select distinct type from bank.card;

create temporary table bank.distinct_frequency select distinct frequency from bank.account;

select * from distinct_cards
cross join distinct_frequency;

# nb The CROSS JOIN have a high potential to consume more resources and they can cause performance issues as they are computationally very expensive. This is because it produces the number of rows that are returned is the product of number of rows in table 1 times the number of rows in the other table

#subqueries!!

#'way easier than they sound'

#Lets use the loan table from the bank database. We want to identify the customers who have borrowed amount which are more than the average amount of all customers. This would not be possible to achieve through simple queries that have used before (without using variables which we will take a look at, later in the course). For this we will use a subquery.

-- step 1: calculate the average
select avg(amount) from bank.loan;

-- step 2 --> pseudo code the main goal of this step ....
select * from bank.loan
where amount > "AVERAGE";

-- step 3 ... create the query
select * from bank.loan
where amount > (
  select avg(amount)
  from bank.loan
);
-- step 4 - Prettify the result. Let's find top 10 such customers
select * from bank.loan
where amount > (select avg(amount)
from bank.loan)
order by amount desc
limit 10;

#This is is a simple example where we are trying to show how subqueries are used. The same could also be achieved by using HAVING clause and no subquery.

select * from (
  select account_id, bank_to, account_to, sum(amount) as Total
  from bank.order
  group by account_id, bank_to, account_to
) sub1
where total > 10000;

#Sample A: The result from this query will be used again in later session to build further in the other topic we will cover.

#In this query we are trying to find those banks from the trans table where the average amount of transactions is over 5500.

#If we try to find this result directly, it would not be possible as we need only the names of the banks and not the averages in this case.
select bank from (
  select bank, avg(amount) as Average
  from bank.trans
  where bank <> ''
  group by bank
  having Average > 5500) sub1;
  
#Sample B : The result from this query will be used again in later session to build further in the other topic we will cover.
#In this query we are trying to find the k_symbols based on the average amount from the table order. The average amount should be more than 3000.
select k_symbol from (
  select avg(amount) as Average, k_symbol
  from bank.order
  where k_symbol <> ' '
  group by k_symbol
  having Average > 3000
  order by Average desc
) sub1; 

#In this query we will use the results from Sample A. In that query we found the banks from the trans table where the average amount of transactions is over 5500. Now we will use those results to filter the results from the order table where bank_to is in the list of banks found previously.
select * from bank.order
where bank_to in (
  select bank from (
    select bank, avg(amount) as Average
    from bank.trans
    where bank <> ''
    group by bank
    having Average > 5500
    ) sub1
)
and k_symbol <> ' ';

#In this query we will use the results from Sample B. In that query we found the k_symbols based on the average amount from the table order. The average amount was more than 3000. Now we will use the results from the query above to only see the transactions from the trans table where the k_symbol value is the result from the above query.
select * from bank.trans
where k_symbol in (
  select k_symbol as symbol from (
    select avg(amount) as Average, k_symbol
    from bank.order
    where k_symbol <> ' '
    group by k_symbol
    having Average > 3000
    order by Average desc
  ) sub1
);
```

MySQL day 8

```mysql
# CTES - common table expressions 
#https://www.mssqltips.com/sqlservertip/5118/sql-server-cte-vs-temp-table-vs-table-variable-performance-test/ 

#A very simple example to show the general syntax
#The query after the AS keyword can be any query (from a simple to a very complex)

with cte_loan as (
  select * from bank.loan
)
select * from cte_loan
where status = 'B';

#In this query, we want to find the total amount and total balance of each customer in the transactions table and then pull more information on those customers by using a join between the CTE and the account table:

with cte_transactions as (
  select account_id, sum(amount), sum(balance)
  from bank.trans
  group by account_id
)
select * from cte_transactions ct
join account a
on ct.account_id = a.account_id;

#Lets try it! CA 3.06.1 Use a CTE to display the first account opened by a district.

# Views 

#slide deck on views (3 pm 2)

#In this query, we are creating a view to find the current customers that might be risky in the future. For this we found the average balance for the current customers in category C and checked which are the customers that have balances more than the average balance for that status category:

create view running_contract_ok_balances as
with cte_running_contract_OK_balances  as (
  select *, amount-payments as Balance
  from bank.loan
  where status = 'C'
  order by Balance
)
select * from cte_running_contract_OK_balances
where Balance > (
  select avg(Balance)
  from cte_running_contract_OK_balances
)
order by Balance desc
limit 20;

#Lets try it! CA 3.06.2 In order to spot possible fraud, we want to create a view last_week_withdrawals with total withdrawals by client in the last week.

#The WITH CHECK OPTION prevents a view from updating or inserting rows that are not visible through it. In other words, whenever you update or insert a row of the base tables through a view, MySQL ensures that the insert or update operation is conformed with the definition of the view.

drop view if exists customer_status_D;

create view customer_status_D as
select * from bank.loan
where status = 'D'
with check option;
Or you can also use :

create or replace view customer_status_D as
select * from bank.loan
where status = 'D'
with check option;

#Now if we try to insert new values in the table through the view, it doesn't work as the check is not met for status D:

select * from customer_status_D;

insert into customer_status_D values (0000, 00000, 987398, 00000, 60, 00000, 'C');

#But, in this case we have removed the WITH CHECK OPTION and now, if we try to insert new values in the table through the view, it works even if the status D condition is not met:

create or replace view customer_status_D as
select * from bank.loan
where status = 'D';

select * from customer_status_D;

insert into customer_status_D values (0000, 00000, 987398, 00000, 60, 00000, 'C');

select * from  bank.loan
order by loan_id;

drop view if exists customer_status_D;

#lets try it - 3.06.3 

#The table client has a field birth_number that encapsulates client birthday and sex. The number is in the form YYMMDD for men, and in the form YYMM+50DD for women, where YYMMDD is the date of birth. Create a view client_demographics with client_id, birth_date and sex fields. Use that view and a CTE to find the number of loans by status and sex.

#Correlated subqueries - slides

#Here we will try to build on the same example that we looked at for self-contained subquery. We extracted the results only for those customers whose loan amount was greater than the average. Here is the self-contained subquery:

select * from bank.loan
where amount > (
  select avg(amount)
  from bank.loan
)
order by amount desc
limit 10;

#Now we want to find those customers whose loan amounts are greater than the average but only within the same status group; ie. we want to find those averages by each group and simultaneously compare the loan amount of that customer with its status group's average.

select * from bank.loan l1
where amount > (
  select avg(amount)
  from bank.loan l2
  where l1.status = l2.status
)
order by amount desc;

#key word is simultaneous 


```

Activity 3.06.1: Use a CTE to display the first account opened by a district.

```mysql
# option 1
with cte_account as (
  select district_id, account_id, MIN(date) from account
  group by district_id, account_id
  order by district_id asc
)
select * from cte_account;

# option 2
with cte_account as (
  select * from account
)
select district_id, account_id, min(date) from cte_account
group by district_id, account_id;

```

Activity 3.06.2: In order to spot possible fraud, we want to create a view last_week_withdrawals with total withdrawals by client in the last week.

```mysql
CREATE VIEW last_week_withdrawals AS(
SELECT account_id, type, ROUND(SUM(amount),2)
FROM trans
WHERE type = 'VYDAJ' AND 
(SELECT DATE_ADD(MAX(date), INTERVAL 7 DAY) FROM trans)
GROUP BY account_id);

CREATE VIEW last_weeks_transactions AS
WITH cte_lastweek as 
(SELECT * FROM trans
 WHERE date > (SELECT max(date) - 7 as last_week FROM trans))
 SELECT account_id, sum(amount) as Tots FROM cte_lastweek
 GROUP BY account_id
 ORDER BY Tots DESC;
```

Self joins: Examples

```mysql
# Find out which employee that reports to which manager: To get who reports to whom, you use the self join as shown in the following query:

SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    sales.staffs e
INNER JOIN sales.staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager;

# Self join to find the customers who locate in the same city.
 
SELECT
    c1.city,
    c1.first_name + ' ' + c1.last_name customer_1,
    c2.first_name + ' ' + c2.last_name customer_2
FROM
    sales.customers c1
INNER JOIN sales.customers c2 ON c1.customer_id > c2.customer_id
AND c1.city = c2.city
ORDER BY
    city,
    customer_1,
    customer_2;
```

CTE Tables

```mysql
# This query uses a CTE to return the sales amounts by sales staffs in 2018:

WITH cte_sales_amounts (staff, sales, year) AS (
    SELECT    
        first_name + ' ' + last_name, 
        SUM(quantity * list_price * (1 - discount)),
        YEAR(order_date)
    FROM    
        sales.orders o
    INNER JOIN sales.order_items i ON i.order_id = o.order_id
    INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
    GROUP BY 
        first_name + ' ' + last_name,
        year(order_date)
)

SELECT
    staff, 
    sales
FROM 
    cte_sales_amounts
WHERE
    year = 2018;
```

