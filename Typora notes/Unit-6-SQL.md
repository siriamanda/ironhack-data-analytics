Thursday kata challenge: 

Join to tables and use a case statement. 

```mysql
select * ,
CASE
	  WHEN t.heads > t.arms OR b.tails > b.legs THEN 'BEAST'
    ELSE 'WEIRDO'
END as species
from top_half as t
join bottom_half as b
on t.id = b.id
ORDER BY species


select t.id, t.heads, b.legs, t.arms, b.tails, 
case when t.heads > t.arms or b.tails > b.legs then 'BEAST'
else 'WEIRDO'
end as species
from top_half t
join bottom_half b on t.id = b.id
order by species;


select t.id, t.heads, b.legs, t.arms, b.tails, 
case when t.heads > t.arms then 'BEAST' 
  when b.tails > b.legs  then 'BEAST' 
  else 'WEIRDO' end as species
from top_half t
join bottom_half b using(id)
order by species;


SELECT t.id, t.heads,b.legs,t.arms,b.tails,
CASE
    WHEN heads > arms  OR tails > legs OR heads > arms AND  tails > legs THEN 'BEAST'
    ELSE 'WEIRDO'
END AS species
FROM top_half t
JOIN bottom_half b on t.id = b.id
ORDER BY species;
```

Stored procudure

```mysql
delimiter //
create procedure proc_no_of_rows 
(out param1 int)
begin 
select Count(*) from account;
end;
// 
delimiter ;
```

Calling the procedure (without any particular condition, giving it the name x):

```mysql
call proc_no_of_rows(@x);
```

Activity 6.04.4

Write a simple stored procedure to find the number of movies released in the year 2006.

```mysql
delimiter //
create procedure proc_no_2006_release
(out param1 int)
begin 
select count(film_id) 
from film
where release_year = 2006;
end;
// 
delimiter ;
```

 Stored procedure (Sakila Database)

```mysql
DROP PROCEDURE IF EXISTS SP_FEATURES;
DELIMITER //
CREATE PROCEDURE SP_FEATURES @FEAT VARCHAR(30)
BEGIN
    SELECT COUNT(*) FROM FILM
    WHERE SPECIAL_FEATURES = @FEAT;
    END;
// DELIMITER ;
```

