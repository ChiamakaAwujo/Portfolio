-- SQL PROJECT: Data Cleaning
-- Using Dataset: https://www.kaggle.com/datasets/swaptr/layoffs-2022 

-- First selecting all values from the table to see what the raw data looks like
SELECT * 
FROM layoffs;

-- Steps for cleaning the data
    -- 1. Remove Duplicates
    -- 2. Standardise the data
    -- 3. Null Values or blank values
    -- 4. Remove any columns that are unnessesary

-- Creating a data staging (duplicate of the raw data)
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 1. IDENTIFYING AND REMOVING DUPLICATES (using CTE)
WITH duplicate_cte AS
(
    SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, location,
    industry, total_laid_off, percentage_laid_off, date, stage, 
    country, funds_raised) AS row_num 
FROM layoffs_staging
)
SELECT *
FROM duplicate_CTE
WHERE row_num > 1;
-- No duplicates were found, so no changes


-- 2. STANDARDISING THE DATA

---- Company (Trimming off the empty space on each side)
SELECT company, (TRIM(company))
FROM layoffs_staging;

UPDATE layoffs_staging
SET company = TRIM(company);

---- Industry (Making sure each company fits in one of the industry categories given)
SELECT DISTINCT industry 
FROM layoffs_staging
ORDER BY 1;

SELECT * 
FROM layoffs_staging
WHERE industry LIKE '';

-- There is one blank row 
SELECT *
FROM layoffs_staging
WHERE company = 'Appsmith';

-- As there is no other populated row for app smith, will change the blank value to a NULL for ease later 
UPDATE layoffs_staging
SET industry = NULL
WHERE company = 'Appsmith';

-- One company has a URL link in the industry value
SELECT * 
FROM layoffs_staging
WHERE industry LIKE 'https%';

SELECT *
FROM layoffs_staging
WHERE company = 'eBay'
-- As ebay had other populated rows in the table, can change the industry to that value

UPDATE layoffs_staging
SET industry = 'Retail'
WHERE industry LIKE 'https%';

---- Location (everything standard)
SELECT DISTINCT location
FROM layoffs_staging
ORDER BY 1;

---- Country (everything standard)
SELECT DISTINCT country
FROM layoffs_staging
ORDER BY 1;

---- Date (changing the data type from text to date)
SELECT date,
STR_TO_DATE(date, '%Y-%m-%d')
FROM layoffs_staging;

UPDATE layoffs_staging
SET date = STR_TO_DATE(date, '%Y-%m-%d');

ALTER TABLE layoffs_staging
MODIFY COLUMN date DATE;

---- total_laid_off (changing the data type from text to int)
ALTER TABLE layoffs_staging
MODIFY COLUMN total_laid_off INT;


-- 3. NULL AND BLANK VALUES

-- Columns, total_laid_off and percentage_laid_off are the only columns with blank values
SELECT * 
FROM layoffs_staging
WHERE total_laid_off = ''
OR percentage_laid_off = '';

-- There is no way to populate these columns using data from the table, so 
-- I will change all of these to NULL values for ease later on 
UPDATE layoffs_staging
SET total_laid_off = NULL
WHERE total_laid_off = '';

UPDATE layoffs_staging
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';



-- 4. Removing Unnecessary rows and columns
    -- Using the data to analyse company layoffs around the world
SELECT * 
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 5. FINAL CHECK OF THE CLEANED DATASET
SELECT * 
FROM layoffs_staging