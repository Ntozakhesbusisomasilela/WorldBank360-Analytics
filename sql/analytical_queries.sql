--Quering

--GDP TREND OVER TIME

SELECT t.year,
AVG(wf.value) AS avg_gdp_per_capita
FROM Worldbank360_fact wf
JOIN DimTime t on wf.time_id = t.time_id
JOIN DimIndicator i on wf.indicator_id = i.indicator_id
WHERE i.indicator_name = 'gdp_per_capita'
GROUP BY t.year
ORDER BY t.year;

--TOP COUNTRIES BY GDP
--AVERAGE TOP 10
SELECT TOP 10
c.country_code,
AVG(wf.value)AS avg_gdp_per_capita
FROM Worldbank360_fact wf
JOIN DimCountry c ON wf.country_id = c.country_id
JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
WHERE i.indicator_name = 'gdp_per_capita' AND c.geo_type = 'country'
GROUP BY c.country_code
ORDER BY avg_gdp_per_capita DESC;

--RECENT GDP TRENDS/TOP 10

WITH LatestYear AS (
    SELECT MAX(t.year) AS max_year
    FROM Worldbank360_fact wf
    JOIN DimTime t ON wf.time_id = t.time_id
    JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
    WHERE i.indicator_name = 'gdp_per_capita'
)
SELECT TOP 10
c.country_code,
wf.value AS gdp_per_capita
FROM Worldbank360_fact wf
JOIN DimCountry c ON wf.country_id = c.country_id
JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
JOIN DimTime t ON wf.time_id = t.time_id
JOIN LatestYear ly ON t.year = ly.max_year
WHERE i.indicator_name = 'gdp_per_capita' AND c.geo_type = 'country'
ORDER BY wf.value DESC;

--JUST COMPARING
/*WITH LatestYear AS (
    SELECT MAX(t.year) AS max_year
    FROM Worldbank360_fact wf
    JOIN DimTime t ON wf.time_id = t.time_id
    JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
    WHERE LOWER(i.indicator_name) = 'gdp_per_capita'
)
SELECT TOP 10
    c.country_code,
    wf.value AS gdp_per_capita,
    RANK() OVER (ORDER BY wf.value DESC) AS rank_position
FROM Worldbank360_fact wf
JOIN DimCountry c ON wf.country_id = c.country_id
JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
JOIN DimTime t ON wf.time_id = t.time_id
JOIN LatestYear ly ON t.year = ly.max_year
WHERE LOWER(i.indicator_name) = 'gdp_per_capita'
  AND c.geo_type = 'country'
ORDER BY wf.value DESC;*/


-- GDP VS INFLATION
-- LATEST iNFLATION TRENDS

WITH LatestYear AS (
    SELECT MAX(t.year) AS max_year
    FROM Worldbank360_fact wf
    JOIN DimTime t ON wf.time_id = t.time_id
    JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
    WHERE i.indicator_name = 'inflation'
)
SELECT TOP 10
c.country_code,
wf.value AS inflation_rate
FROM Worldbank360_fact wf
JOIN DimCountry c ON wf.country_id = c.country_id
JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
JOIN DimTime t ON wf.time_id = t.time_id
JOIN LatestYear ly ON t.year = ly.max_year
WHERE i.indicator_name = 'inflation'
AND c.geo_type = 'country'
ORDER BY wf.value DESC

--NOW COUNTRIES WITH STABLE ECONOMIES
WITH LatestYear AS (
    SELECT MAX(t.year) AS max_year
    FROM Worldbank360_fact wf
    JOIN DimTime t ON wf.time_id = t.time_id
    JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
    WHERE i.indicator_name = 'inflation'
)
SELECT TOP 10
c.country_code,
wf.value AS inflation_rate
FROM Worldbank360_fact wf
JOIN DimCountry c ON wf.country_id = c.country_id
JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
JOIN DimTime t ON wf.time_id = t.time_id
JOIN LatestYear ly ON t.year = ly.max_year
WHERE i.indicator_name = 'inflation'
AND c.geo_type = 'country'
ORDER BY wf.value

--GDP VS eMPLOYMENT INSIGHT

WITH LatestYear AS (
    SELECT MAX(t.year) AS max_year
    FROM Worldbank360_fact wf
    JOIN DimTime t ON wf.time_id = t.time_id
    JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
    WHERE indicator_name IN ('gdp_per_capita', 'unemployment')
    GROUP BY t.year
    HAVING COUNT(DISTINCT i.indicator_name) = 2
    )
SELECT
c.country_code,
MAX (CASE WHEN
        i.indicator_name = 'gdp_per_capita'
        THEN wf.value
        END) AS gdp_per_capita,

        MAX (CASE WHEN
        i.indicator_name = 'unemployment'
        THEN wf.value
        END) AS unemployment

FROM Worldbank360_fact wf
JOIN DimCountry c ON wf.country_id = c.country_id
JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
JOIN DimTime t ON wf.time_id = t.time_id
JOIN LatestYear ly ON t.year = ly.max_year
WHERE c.geo_type = 'country'
AND i.indicator_name IN ('gdp_per_capita', 'unemployment')
GROUP BY c.country_code
HAVING 
    MAX(CASE WHEN i.indicator_name = 'gdp_per_capita' THEN wf.value END) IS NOT NULL
AND MAX(CASE WHEN i.indicator_name = 'unemployment' THEN wf.value END) IS NOT NULL
ORDER BY gdp_per_capita DESC

--life_expectancy VS GDP

WITH LatestYear AS (
    SELECT MAX(t.year) AS max_year
    FROM Worldbank360_fact wf
    JOIN DimTime t ON wf.time_id = t.time_id
    JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
    WHERE indicator_name IN ('gdp_per_capita', 'life_expectancy')
    GROUP BY t.year
    HAVING COUNT(DISTINCT i.indicator_name) = 2
    )
SELECT
c.country_code,
MAX (CASE WHEN
        i.indicator_name = 'gdp_per_capita'
        THEN wf.value
        END) AS gdp_per_capita,

        MAX (CASE WHEN
        i.indicator_name = 'life_expectancy'
        THEN wf.value
        END) AS life_expectancy

FROM Worldbank360_fact wf
JOIN DimCountry c ON wf.country_id = c.country_id
JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
JOIN DimTime t ON wf.time_id = t.time_id
JOIN LatestYear ly ON t.year = ly.max_year
WHERE c.geo_type = 'country'
AND i.indicator_name IN ('gdp_per_capita', 'life_expectancy')
GROUP BY c.country_code
HAVING 
    MAX(CASE WHEN i.indicator_name = 'gdp_per_capita' THEN wf.value END) IS NOT NULL
AND MAX(CASE WHEN i.indicator_name = 'life_expectancy' THEN wf.value END) IS NOT NULL
ORDER BY gdp_per_capita DESC

--sCHOOL ENROLLMENT VS GDP

WITH LatestYear AS (
    SELECT MAX(t.year) AS max_year
    FROM Worldbank360_fact wf
    JOIN DimTime t ON wf.time_id = t.time_id
    JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
    WHERE indicator_name IN ('school_enrollment', 'unemployment')
    GROUP BY t.year
    HAVING COUNT(DISTINCT i.indicator_name) = 2
    )

SELECT
c.country_code,
MAX (CASE WHEN
        i.indicator_name = 'unemployment'
        THEN (wf.value)
        END) AS unemployment,

        MAX (CASE WHEN
        i.indicator_name = 'school_enrollment'
        THEN (wf.value)
        END) AS school_enrollment

FROM Worldbank360_fact wf
JOIN DimCountry c ON wf.country_id = c.country_id
JOIN DimIndicator i ON wf.indicator_id = i.indicator_id
JOIN DimTime t ON wf.time_id = t.time_id
WHERE c.geo_type = 'country'
AND i.indicator_name IN ('unemployment', 'school_enrollment')
GROUP BY c.country_code
HAVING 
    MAX(CASE WHEN i.indicator_name = 'unemployment' THEN (wf.value) END) IS NOT NULL
AND MAX(CASE WHEN i.indicator_name = 'school_enrollment' THEN (wf.value) END) IS NOT NULL
ORDER BY unemployment DESC