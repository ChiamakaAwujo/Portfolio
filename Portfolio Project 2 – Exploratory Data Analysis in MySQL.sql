-- Exploratory Data Analysis
-- Using Data Set: https://www.kaggle.com/datasets/swaptr/layoffs-2022 (Cleaned Version from Portfolio Project 1)

SELECT * 
FROM layoffs_staging;

--First checking the date range of the layoffs
SELECT MIN(date), MAX(date) 
FROM layoffs_staging;
-- Date ranges from 27/07/23 to 19/07/24 (around a year of results)

-- Looking at percentages to see how big these layoffs are 
SELECT MIN(percentage_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging;
-- ranges from 1% to 100%

-- Looking at Companies with layoffs of 100% 
SELECT * 
FROM layoffs_staging
WHERE percentage_laid_off = 1
ORDER BY stage DESC;
-- The majority of the companies are start ups (in the Seed or Series A-C stage of funding)

-- ordering by funds_raised
SELECT * 
FROM layoffs_staging
WHERE percentage_laid_off = 1
ORDER BY funds_raised DESC;
-- There are a lot of big companies, including 2 that had more than a billion dollars raised each


-- Looking at different categories with the most total layoffs 

-- Total layoffs grouped by company 
SELECT company, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;
-- Tesla had the largest number of total layoffs totaling to 14500 across 2 rounds of layoffs
-- However their first round of layoffs (of 1400) was only 1% their total workforce

-- Total layoffs grouped by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY industry
ORDER BY 2 DESC
LIMIT 10;
-- Transportation indsutry had the most number of layoffs, this is mainly due to the massive amount of layoffs from Tesla
-- However there are many null values in this industry so, this finding may not be the most accurate

-- Other industries with large layoff numbers are the Others catagory and Retail 
---- In the Others industry, this is due to large corporations such as Microsoft and SAP 
---- In the Retail industry, the layoffs were more evenly spread across multiple companies


-- Total layoffs grouped by country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY country
ORDER BY 2 DESC
LIMIT 10;
-- The country with the most amount of layoffs was the United States 
SELECT country, COUNT(DISTINCT company)
FROM layoffs_staging
GROUP BY country
ORDER BY 2 DESC;
-- This is probably due to there being significantly more US based companies in the dataset compared to any other country


-- Total layoffs grouped by location
SELECT location , SUM(total_laid_off)
FROM layoffs_staging
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;
-- the location with the most total layoffs in the SF Bay Area
SELECT location, COUNT(DISTINCT company)
FROM layoffs_staging
GROUP BY location
ORDER BY 2 DESC;
-- Looking further into the SF Bay Area, we can see that it has the most amount of companies based in the area, 
-- explaining why it has the most total layoffs of all loactions in this dataset 


-- Creating a rolling total of layoffs per month
SELECT SUBSTRING(date,1,7) AS MONTH, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY MONTH
ORDER BY 1 ASC;

-- using in a CTE
With Rolling_Total AS 
(
    SELECT SUBSTRING(date,1,7) AS MONTH, SUM(total_laid_off) AS total_off
    FROM layoffs_staging
    GROUP BY MONTH
    ORDER BY MONTH ASC
)

SELECT MONTH, total_off,SUM(total_off) OVER(ORDER BY MONTH) AS rolling_total
FROM Rolling_Total;

-- From this rolling total, we can see that the majority of layoff happed in 2024
-- as by the end of 2023, there was only around 35,000 layoffs, but by July 2024, there was around 122,000 layoffs

-- From this we can also see that the most with the most layoffs was January 2024, 
-- and the month with the fewest was March 2023
