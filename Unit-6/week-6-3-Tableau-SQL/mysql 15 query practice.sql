CREATE DATABASE ORG;
SHOW DATABASES;
USE ORG;

CREATE TABLE Worker (
	WORKER_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT(15),
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25)
);

INSERT INTO Worker 
	(WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
		(001, 'Monika', 'Arora', 100000, '14-02-20 09.00.00', 'HR'),
		(002, 'Niharika', 'Verma', 80000, '14-06-11 09.00.00', 'Admin'),
		(003, 'Vishal', 'Singhal', 300000, '14-02-20 09.00.00', 'HR'),
		(004, 'Amitabh', 'Singh', 500000, '14-02-20 09.00.00', 'Admin'),
		(005, 'Vivek', 'Bhati', 500000, '14-06-11 09.00.00', 'Admin'),
		(006, 'Vipul', 'Diwan', 200000, '14-06-11 09.00.00', 'Account'),
		(007, 'Satish', 'Kumar', 75000, '14-01-20 09.00.00', 'Account'),
		(008, 'Geetika', 'Chauhan', 90000, '14-04-11 09.00.00', 'Admin');

CREATE TABLE Bonus (
	WORKER_REF_ID INT,
	BONUS_AMOUNT INT(10),
	BONUS_DATE DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Bonus 
	(WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
		(001, 5000, '16-02-20'),
		(002, 3000, '16-06-11'),
		(003, 4000, '16-02-20'),
		(001, 4500, '16-02-20'),
		(002, 3500, '16-06-11');
CREATE TABLE Title (
	WORKER_REF_ID INT,
	WORKER_TITLE CHAR(25),
	AFFECTED_FROM DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Title 
	(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM) VALUES
 (001, 'Manager', '2016-02-20 00:00:00'),
 (002, 'Executive', '2016-06-11 00:00:00'),
 (008, 'Executive', '2016-06-11 00:00:00'),
 (005, 'Manager', '2016-06-11 00:00:00'),
 (004, 'Asst. Manager', '2016-06-11 00:00:00'),
 (007, 'Executive', '2016-06-11 00:00:00'),
 (006, 'Lead', '2016-06-11 00:00:00'),
 (003, 'Lead', '2016-06-11 00:00:00');
 
 
 # Challenges : 
 
 # 1 Write an SQL query to print the FIRST_NAME from Worker table after removing white spaces from the right side.
 
 select rtrim(FIRST_NAME) as Name from Worker;
 
 # 2 Write an SQL query to print the DEPARTMENT from Worker table after removing white spaces from the left side.
 
 select ltrim(DEPARTMENT) as Department from Worker;
 
# 3 Write an SQL query to print the FIRST_NAME and LAST_NAME from Worker table into a single column COMPLETE_NAME. A space char should separate them.
 
 select concat(FIRST_NAME, ' ', LAST_NAME) as Full_Name from Worker;
 
 # 4 Write an SQL query to print all Worker details from the Worker table order by FIRST_NAME Ascending.
 
 select * from Worker
 order by FIRST_NAME;
 
 # 5 Write an SQL query to print all Worker details from the Worker table order by FIRST_NAME Ascending and DEPARTMENT Descending.

 select * from Worker
 order by FIRST_NAME, DEPARTMENT DESC;

#  6 Write an SQL query to print details of Workers with DEPARTMENT name as “Admin”.

select * from Worker
where department = 'Admin';

# 7  Write an SQL query to print details of the Workers whose FIRST_NAME contains ‘a’.

select * from Worker 
where first_name LIKE '%A%'
order by first_name;

# 8 Write an SQL query to print details of the Workers whose SALARY lies between 100000 and 500000.

select * from Worker
where salary between 100000 and 500000;

# 9  Write an SQL query to print details of the Workers who have joined in Feb 2014.

select * from Worker
where joining_date like '2014-02%';

select * from Worker
where year(joining_date) = 2014 and month(joining_date) = 2;

# 10 Write an SQL query to fetch the count of employees working in the department ‘Admin’.

select count(*) as NumEmployees from Worker
where department = 'Admin';

#  11 Write an SQL query to print details of the Workers who are also Managers.

select * from Worker w
join Title t
on w.worker_id = t.worker_ref_id
where worker_title = 'Manager';

# 12 Write an SQL query to show the current date and time.

select now();

# 13 Write an SQL query to show the top n (say 3) records of worker table by salary.

select * from worker
order by salary desc
limit 3;


# 14 Write an SQL query to determine the 3rd highest salary from the table.
Select * from 
(select * from worker
order by salary desc
limit 3
)t
order by salary asc
limit 1;

# 15 Write an SQL query to fetch the list of employees with the same salary.

select w.worker_id, w.first_name, w.salary
from worker w
join worker o
on w.salary = o.salary
and w.worker_id != o.worker_id;




