# Netflix-Dataset-Analysis using SQL

![Netflix Logo](https://github.com/ridhit10/Netflix-Dataset-Analysis/blob/main/BrandAssets_Logos_01-Wordmark.jpg)

## Overview
This project uses SQL to analyze Netflix's movies and TV shows data. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives
-Analyze the distribution of content types (movies vs TV shows).
-Identify the most common ratings for movies and TV shows.
-List and analyze content based on release years, countries, and durations.
-Explore and categorize content based on specific criteria and keywords

## Schema

```sql
DROP TABLE IF EXISTS netflix5;
CREATE TABLE netflix5
(
    show_id VARCHAR(5),
    type VARCHAR(10),
    title VARCHAR(250),
    director VARCHAR(550),
    casts VARCHAR(1050),
    country VARCHAR(550),
    date_added VARCHAR(55),
    release_year INT,
    rating VARCHAR(15),
    duration VARCHAR(15),
    listed_in VARCHAR(250),
    description VARCHAR(550)
);
```
## Problems Solved



## 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type, 
    COUNT(*) 
FROM netflix5 
GROUP BY 1;
```


## 2. Find the Most Common Rating for Movies and TV Shows

```sql
WITH RatingCounts AS (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS rating_count 
    FROM netflix5 
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type, 
        rating, 
        rating_count, 
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank 
    FROM RatingCounts
)
SELECT 
    type, 
    rating AS most_frequent_rating 
FROM RankedRatings 
WHERE rank = 1;
```

## 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT *
FROM netflix5
WHERE release_year = 2020;
```

## 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT *
FROM (
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix5
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;
```
## 5. Identify the Longest Movie

```sql
SELECT *
FROM netflix5
WHERE type = 'Movie'
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC;
```

## 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix5
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

## 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT *
FROM (
    SELECT 
        *, 
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix5
) AS t
WHERE director_name = 'Rajiv Chilaka';
```

## 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM netflix5
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

## 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix5
GROUP BY 1;
```

