
create table netflix5 
(show_id varchar, 
type  varchar,
title varchar,
director varchar,	
casts varchar,
country	varchar,
date_added varchar,
release_year TEXT,
rating	varchar,
duration	varchar,
listed_in	varchar,
description varchar);

-- 15 PROBLEMS 
-- Q1 Count the number of Movie vs TV Shows

select 
 type,
 count(*) as total_count
from netflix5
group by type


--Q2 Find the most common rating for movies and tv shows
select 
 type,
 rating
from
(
 select
   type,
   rating,
   count(*),
   rank() over(partition by type order by count(*) desc) as ranking
 from netflix5
 group by 1,2
) as t1

where ranking = 1

--Q3 List all the movies released in a specific year (e.g. 2020)
select *
from netflix5
where type = 'Movie' 
and 
release_year = '2020'


--Q4 Find the top 5 countries with the most content on Netflix
-- need to split countries in columns
select 
  unnest(string_to_array(country, ',')) as new_country,
  count(show_id) as total_content
 
from netflix5  
group by 1 
order by 2 desc
fetch first 5 rows only

-- Q5 Identify the longest movie
select * from netflix5
where  
   type = 'Movie'
   and
   duration = (select max(duration) from netflix5)

--Q6 Find content added in last 5 years
select *
from netflix5
where 
   to_date(date_added, 'Month DD, YYYY') >= current_date - Interval '5 years'

--Q7 Find all the movies/tv shows by director "Rajiv Chilaka"!
select * from netflix5
where director ilike '%Rajiv Chilaka%'

--Q8 List all tv shows with more than 5 seasons
select *
from netflix5
where type = 'TV Show' 
     and
	 split_part(duration, ' ', 1)::numeric >5

-- Q9 Count the number of items in each genre
select 
  unnest(string_to_array(listed_in, ',')) as genre,
  count(show_id)
from netflix5
group by 1
  








