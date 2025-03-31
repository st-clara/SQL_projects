-- DATA CLEANING

-- 1. Remove dublicate 
-- 2.Ensure Data Consistency
-- 3.Remove Null values and populating null values 
-- 4.Remove Columns and Rows not needed 

-- Creating a stagged table to work with...
CREATE TABLE Layoffs_stagging
LIKE layoffs;

SELECT *
FROM Layoffs_stagging;

INSERT Layoffs_stagging
SELECT *
FROM layoffs;


-- 1. Remove dublicate 

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY  company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
FROM Layoffs_stagging;

WITH duplicate_cte AS 
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
FROM Layoffs_stagging )

SELECT *
FROM duplicate_cte  
WHERE row_num > 1; 

-- Creating a stagged table 2 to make updates off from.
CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_stagging2
WHERE row_num > 1;

INSERT INTO layoffs_stagging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
FROM Layoffs_stagging;

DELETE
FROM layoffs_stagging2
WHERE row_num > 1;

SELECT * 
FROM layoffs_stagging2;


-- 2. Ensure Data Consistency

SELECT *
FROM layoffs_stagging2;

-- COMPANY

SELECT company, TRIM(company)
FROM layoffs_stagging2;
 
UPDATE layoffs_stagging2
SET company = TRIM(company);

-- LOCATION

SELECT DISTINCT location
FROM layoffs_stagging2
ORDER BY 1;

-- INDUSTRY

SELECT DISTINCT industry
FROM layoffs_stagging2
ORDER BY 1;

SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_stagging2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

-- COUNTRY

SELECT DISTINCT COUNTRY
FROM layoffs_stagging2
ORDER BY 1;

SELECT *
FROM layoffs_stagging2
WHERE country LIKE 'united states.';

UPDATE layoffs_stagging2
SET country = 'united states'
WHERE country LIKE 'united states.';

-- DATE

SELECT `date`
FROM layoffs_stagging2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
AS new_date
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Changing the date data type from text to date.
ALTER TABLE layoffs_stagging2
MODIFY COLUMN `date` DATE;

-- 3.Remove Null values and populating null values

SELECT *
FROM layoffs_stagging2;

-- populating null values for industry

SELECT DISTINCT industry
FROM layoffs_stagging2
WHERE industry IS NULL 
OR industry = '';

SELECT*
FROM layoffs_stagging2
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM layoffs_stagging2 T1
JOIN layoffs_stagging2 T2
	ON T1.company = T2.company
    AND T1.location = T2.location
WHERE (T1.industry IS NULL OR T1.industry = '')
AND T2.industry IS NOT NULL;

UPDATE  layoffs_stagging2
SET industry = NULL 
WHERE industry = '';

SELECT  T1.industry,T2.industry
FROM layoffs_stagging2 T1
JOIN layoffs_stagging2 T2
	ON T1.company = T2.company
    AND T1.location = T2.location
WHERE (T1.industry IS NULL OR T1.industry = '')
AND T2.industry IS NOT NULL;

UPDATE  layoffs_stagging2 T1
JOIN  layoffs_stagging2 T2
	ON  T1.company = T2.company
SET T1.industry = T2.industry
WHERE  T1.industry IS NULL 
AND T2.industry IS NOT NULL;

-- TOTAL_LAID_OFF AND PERCENTAGE_LAID_OFF

SELECT TOTAL_LAID_OFF, PERCENTAGE_LAID_OFF
FROM layoffs_stagging2
WHERE TOTAL_LAID_OFF IS NULL
AND  PERCENTAGE_LAID_OFF IS NULL;

DELETE 
FROM layoffs_stagging2
WHERE TOTAL_LAID_OFF IS NULL
AND  PERCENTAGE_LAID_OFF IS NULL;

-- 4.Remove Columns and Rows not needed 

-- drouping columns from the table

ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;

