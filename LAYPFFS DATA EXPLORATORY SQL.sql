-- EXPLORATORY DATA ANALYSIS

-- Exploring the layoffs dataset to identify patterns, relationships and potential insights
-- Zero preconceived notion

SELECT *
FROM layoffs_stagging2; 

-- MAX LAID OFFS AND MAX PERCENTAGE LAID OFF IN ONE DAY

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_stagging2; 

select company,MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_stagging2
WHERE percentage_laid_off = 1
group by company
order by company asc;

SELECT location,SUM(funds_raised_millions)
FROM layoffs_stagging2
GROUP BY location
ORDER BY 2 DESC;

SELECT MIN(`date`),MAX(`date`)
FROM layoffs_stagging2; 

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY YEAR(`date`);

SELECT stage, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY(stage);

SELECT SUBSTRING(`date`,6,2) AS `month`, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY (`month`);

WITH Rolling_total AS
(SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS sum_off
FROM layoffs_stagging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL 
GROUP BY `month`
ORDER BY 1 ASC)
SELECT  `month`,sum_off,SUM(sum_off) OVER(ORDER BY `month`) AS Rolling_total
FROM Rolling_total;

-- LAYOFF PER YEAR

SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company,YEAR(`date`)
ORDER BY company ASC;

-- RANKING

WITH company_year(company, years, total_laid_off) AS
(SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company,YEAR(`date`)),
	company_years_ranking AS(
	SELECT*, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
	FROM company_year 
	WHERE years IS NOT NULL)
		SELECT *
		FROM company_years_ranking 
		WHERE ranking <=5;
 