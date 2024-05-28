create DATABASE world_layoffs;
use world_layoffs;
select* from layoffs;


-- DATA CLEANING 

--  STEPS to clean
-- 1- REMOVE DUBLICATES
-- 2- standardize the data 
-- 2- Remove null and blank values
-- 4- Remove any row or column if nacessary


-- -------------------STEP 1 -------------------------------------
-- -----------------Remove dublicates-----------------------------
-- for safty perpouse i have created a dublicate table for transformation

create TABLE layoff2
like layoffs;


SELECT * 
from layoff2;

insert layoff2
SELECT * FROM
layoffs;

-- so There are no any primary column to identify dulicates 
-- so we need to CREATE a column for identify dublicates

select * , ROW_NUMBER() over(PARTITION BY  location , industry, total_laid_off, 
percentage_laid_off,'date',stage, country, funds_raised_millions
) as row_no from layoff2;

 with dublicates as (
 select * , ROW_NUMBER() over(PARTITION BY  location , industry, total_laid_off, 
percentage_laid_off,'date',stage, country, funds_raised_millions
) as row_no from layoff2)
SELECT * from dublicates
WHERE row_no >1;


CREATE TABLE `layoff3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_no int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * from layoff3 
where row_no >1;

INSERT into layoff3
select * , ROW_NUMBER() over(PARTITION BY  location , industry, total_laid_off, 
percentage_laid_off,'date',stage, country, funds_raised_millions
) as row_no from layoff2;


Delete 
from layoff3 
where row_no >1;

-- -------------------------STEP 2-----------------------------------------
-- ------------------------STANDARDIZE THE DATA----------------------------

SELECT* from layoff3;

select DISTINCT (company) from layoff3;
SELECT trim(company), company from layoff3;


UPDATE layoff3 
SET	 comapany = trim(company);

SELECT DISTINCT(location) from layoff3
;

SELECT * from layoff3;
SELECT * from layoff3;


UPDATE layoff3
set industry = "crypto"
where industry in ("crypto currency","cryptocurrency");


SELECT * from layoff3
where industry is null or " "
ORDER BY industry;

SELECT company, industry from layoff3
WHERE  company = "airbnb" ;

-- Here airbnb's industry name is missing lets correct it


UPDATE layoff3
set industry=null
WHERE industry = "";

UPDATE layoff3 t1
join  layoff3 t2
on t1.company= t2.company
set t1.industry=t2.industry
where t1.industry is null
and t2.industry is  not null;

SELECT DISTINCT(country) from layoff3
ORDER BY 1;

UPDATE layoff3
SET country = TRIM(TRAILING '.' FROM country);

-- lat's also fix DATE column using str_to date function

UPDATE lAyoff3
set `date` = str_to_date(`date`,"%m/%d/%Y");

ALTER TABLE layoff3
MODIFY column `date` DATE;

select * from layoff3;


-- remove any columns and rows we need to

select * from layoff3
WHERE total_laid_off  is null AND percentage_laid_off is null;


DELETE from layoff3
WHERE total_laid_off  is null AND percentage_laid_off is null;

ALTER TABLE layoff3
DROP column row_no ;

-- now DELETE extra column row_no which is not usefull column 
SELECT * from layoff3;