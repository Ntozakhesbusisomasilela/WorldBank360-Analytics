-- ===========================================
-- TESTING & DATA VALIDATION
-- ===========================================

-- Fix hidden characters
UPDATE DimCountry
SET geo_type = LTRIM(RTRIM(REPLACE(geo_type, CHAR(160), '')));

-- Check geo_type consistency
SELECT DISTINCT geo_type, LEN(geo_type)
FROM DimCountry;

-- Normalize country naming
UPDATE DimCountry
SET geo_type = 'country'
WHERE geo_type LIKE '%country%';

-- Row count check
SELECT COUNT(*) FROM Worldbank360_fact;

-- Inspect sample data
SELECT * FROM Worldbank360_fact;

-- View raw CSV (debugging)
SELECT TOP 5 *
FROM OPENROWSET(
    BULK 'C:\Users\Ntoza\Downloads\worldbank_fact_table.csv',
    SINGLE_CLOB
) AS RawData;

-- Check duplicates in staging
SELECT country_code, year, value, unit, COUNT(*)
FROM StagingFact
GROUP BY country_code, year, value, unit
HAVING COUNT(*) > 1;

-- Check duplicates in fact
SELECT country_id, time_id, indicator_id, COUNT(*)
FROM Worldbank360_fact
GROUP BY country_id, time_id, indicator_id
HAVING COUNT(*) > 1;

-- Indicator validation
SELECT DISTINCT indicator_name FROM DimIndicator;

-- Null check
SELECT COUNT(*) FROM Worldbank360_fact WHERE value IS NULL;

-- Latest year check
SELECT MAX(t.year)
FROM Worldbank360_fact wf
JOIN DimTime t ON wf.time_id = t.time_id;