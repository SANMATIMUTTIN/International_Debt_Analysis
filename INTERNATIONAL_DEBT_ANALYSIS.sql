CREATE DATABASE INTERNATIONAL_DEBT_ANALYSIS;

USE INTERNATIONAL_DEBT_ANALYSIS;

-- 1. The World Bank's international debt data 

SELECT * 
FROM international_debt
LIMIT 10;

-- 2. Finding the number of distinct countries

SELECT 
    COUNT(DISTINCT country_name) AS total_distinct_countries
FROM international_debt;

-- 3. Finding out the distinct debt indicators

SELECT DISTINCT indicator_code AS distinct_debt_indicators
FROM international_debt
ORDER BY distinct_debt_indicators;

-- 4. Totaling the amount of debt owed by the countries

SELECT 
    ROUND(SUM(debt) / 1000000, 2) AS total_debt
FROM international_debt;

-- 5. Country with the highest debt

SELECT 
    country_name, 
    SUM(debt) AS total_debt
FROM international_debt
GROUP BY country_name
ORDER BY total_debt DESC
LIMIT 1;

-- 6. Average amount of debt across indicators

SELECT 
    indicator_code AS debt_indicator,
    indicator_name,
    AVG(debt) AS average_debt
FROM international_debt
GROUP BY debt_indicator, indicator_name
ORDER BY average_debt DESC
LIMIT 10;

-- 7. The highest amount of principal repayments

SELECT 
    country_name, 
    indicator_name
FROM international_debt
WHERE debt = (SELECT 
                 MAX(debt)
             FROM international_debt
             WHERE indicator_code = 'DT.AMT.DLXF.CD');
             
-- 8. The most common debt indicator

SELECT indicator_code, COUNT(indicator_code) AS indicator_count
FROM international_debt
GROUP BY indicator_code
ORDER BY indicator_count DESC, indicator_code DESC
LIMIT 20;

-- 9. Other viable debt issues 

SELECT country_name,
MAX(debt) AS maximum_debt
FROM international_debt
GROUP BY country_name
ORDER BY maximum_debt DESC
LIMIT 10;

-- 10. Identifying countries with debt greater than the average debt

SELECT 
    country_name, 
    ROUND(SUM(debt), 2) AS total_debt
FROM international_debt
GROUP BY country_name
HAVING SUM(debt) > (SELECT AVG(debt) FROM international_debt)
ORDER BY total_debt DESC;

-- 11. Percentage contribution of each indicator to the total debt

SELECT 
    indicator_code, 
    indicator_name, 
    ROUND(SUM(debt) / (SELECT SUM(debt) FROM international_debt) * 100, 2) AS percentage_contribution
FROM international_debt
GROUP BY indicator_code, indicator_name
ORDER BY percentage_contribution DESC;

-- 12. Finding the country with the most debt indicators

SELECT 
    country_name, 
    COUNT(DISTINCT indicator_code) AS total_indicators
FROM international_debt
GROUP BY country_name
ORDER BY total_indicators DESC
LIMIT 1;

-- 13. Comparing bilateral and multilateral debt totals

SELECT 
    CASE 
        WHEN indicator_code LIKE '%.BLAT.%' THEN 'Bilateral Debt'
        WHEN indicator_code LIKE '%.MLAT.%' THEN 'Multilateral Debt'
        ELSE 'Other Debt'
    END AS debt_type,
    ROUND(SUM(debt), 2) AS total_debt
FROM international_debt
GROUP BY debt_type
ORDER BY total_debt DESC;

-- 14. Long-term debt trends: total disbursements vs. interest payments

SELECT 
    'Disbursements' AS category, 
    ROUND(SUM(debt), 2) AS total_amount
FROM international_debt
WHERE indicator_code LIKE '%.DIS.%'
UNION ALL
SELECT 
    'Interest Payments', 
    ROUND(SUM(debt), 2)
FROM international_debt
WHERE indicator_code LIKE '%.INT.%';

-- 15. Identifying the top 5 debt indicators by total debt and their countries

SELECT 
    indicator_code, 
    indicator_name, 
    country_name, 
    ROUND(SUM(debt), 2) AS total_debt
FROM international_debt
GROUP BY indicator_code, indicator_name, country_name
ORDER BY total_debt DESC
LIMIT 5;