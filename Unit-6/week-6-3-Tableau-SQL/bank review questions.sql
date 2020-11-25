/*

Explore the bank database

*/

use bank;


-- How many clients and accounts are there, overall?

select count(distinct(client_id)), count(account_id) from disp;


-- How many clients are "owners" and how many "disponents" of the accounts?

select type, count(type)
from disp
group by type;

-- How many clients & accounts are there by region?

select d.A3 as Region, count(distinct(c.client_id)) as Client, count(distinct(a.account_id)) as Account from district d
join account a
on a.district_id = d.A1
join client c
on c.district_id = d.A1
group by A3;

-- Explore the loans given to clients
select d.client_id, l.loan_id, l.amount, l.duration, l.status 
from loan l
join disp d
using (account_id);

-- How could we define clients as valuable / not valuable?
select l.status, d.client_id, sum(l.amount) as totalloanamount
from loan l 
join disp d
using(account_id)
where status in ('B','D')
group by l.status, d.client_id ;


-- Once you've defined how to classify clients as valuable / not valuable:
	-- describe both groups of clients based on information you'll find accross all tables
    -- (what type of client they are, where do they live, what type of card, etc.)
    
