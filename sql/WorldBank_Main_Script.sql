-- ===========================================
-- DROP DATABASE IF EXISTS AND CREATE NEW
-- ===========================================

USE master;
GO

IF DB_ID('WorldBank_360_db') IS NOT NULL
BEGIN
    ALTER DATABASE WorldBank_360_db SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE WorldBank_360_db;
END
GO

CREATE DATABASE WorldBank_360_db;
GO

USE WorldBank_360_db;
GO

-- ===========================================
-- CLEANUP (DROP TABLES IF THEY EXIST)
-- ===========================================

IF OBJECT_ID('StagingFact') IS NOT NULL DROP TABLE StagingFact;
IF OBJECT_ID('DimCountry') IS NOT NULL DROP TABLE DimCountry;
IF OBJECT_ID('DimTime') IS NOT NULL DROP TABLE DimTime;
IF OBJECT_ID('DimIndicator') IS NOT NULL DROP TABLE DimIndicator;
IF OBJECT_ID('DimUnit') IS NOT NULL DROP TABLE DimUnit;
IF OBJECT_ID('Worldbank360_fact') IS NOT NULL DROP TABLE Worldbank360_fact;

-- ===========================================
-- STAGING TABLE
-- ===========================================

CREATE TABLE StagingFact(
    country_code varchar(3),
    year int,
    value varchar(50),
    unit varchar(255),
    indicator_code varchar(255),
    indicator_name varchar(255),
    category varchar(255),
    geo_type varchar(255)
);
GO

-- ===========================================
-- INSERTING DATA TO STAGING TABLE FROM CSV
-- ===========================================

BULK INSERT StagingFact
FROM 'C:\Users\Ntoza\Downloads\worldbank_fact_table.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK,
    CODEPAGE = '65001'
);
GO

-- ===========================================
-- DIMENSIONS
-- ===========================================

CREATE TABLE DimCountry(
    country_id int identity(1,1) primary key,
    country_code varchar(3),
    geo_type varchar(50)
);
GO

CREATE TABLE DimTime(
    time_id int identity(1,1) primary key,
    year int
);
GO

CREATE TABLE DimIndicator(
    indicator_id int identity(1,1) primary key,
    indicator_code varchar(255),
    indicator_name varchar(255),
    category varchar(255)
);
GO

CREATE TABLE DimUnit(
    unit_id int identity(1,1) primary key,
    unit varchar(50)
);
GO

-- ===========================================
-- INSERT INTO DIMENSIONS
-- ===========================================

INSERT INTO DimCountry(country_code, geo_type)
SELECT DISTINCT country_code, geo_type
FROM StagingFact;

INSERT INTO DimTime(year)
SELECT DISTINCT year
FROM StagingFact;

INSERT INTO DimIndicator(indicator_code, indicator_name, category)
SELECT DISTINCT indicator_code, indicator_name, category
FROM StagingFact;

INSERT INTO DimUnit(unit)
SELECT DISTINCT unit
FROM StagingFact;

-- ===========================================
-- CONSTRUCTING FINAL FACT TABLE FROM STAGING
-- ===========================================

CREATE TABLE Worldbank360_fact(
    factTable_id int identity(1,1) primary key,
    country_id int,
    time_id int,
    indicator_id int,
    unit_id int,
    value decimal(18,4),

    FOREIGN KEY (country_id) REFERENCES DimCountry(country_id),
    FOREIGN KEY (indicator_id) REFERENCES DimIndicator(indicator_id),
    FOREIGN KEY (time_id) REFERENCES DimTime(time_id),
    FOREIGN KEY (unit_id) REFERENCES DimUnit(unit_id)
);
GO

-- ===========================================
-- POPULATING FACT TABLE
-- ===========================================

INSERT INTO Worldbank360_fact (country_id, time_id, indicator_id, unit_id, value)
SELECT
    c.country_id,
    t.time_id,
    i.indicator_id,
    u.unit_id,
    TRY_CAST(s.value AS DECIMAL(18,4))
FROM StagingFact s
JOIN DimCountry c ON s.country_code = c.country_code
JOIN DimTime t ON s.year = t.year
JOIN DimIndicator i ON s.indicator_code = i.indicator_code
JOIN DimUnit u ON s.unit = u.unit
WHERE TRY_CAST(s.value AS DECIMAL(18,4)) IS NOT NULL;
GO

-- ===========================================
-- PERFORMANCE AND DATA INTEGRITY
-- ===========================================

UPDATE DimCountry
SET geo_type = LTRIM(RTRIM(geo_type));

-- ===========================================
-- CONSTRAINTS
-- ===========================================

ALTER TABLE Worldbank360_fact ALTER COLUMN country_id INT NOT NULL;
ALTER TABLE Worldbank360_fact ALTER COLUMN time_id INT NOT NULL;
ALTER TABLE Worldbank360_fact ALTER COLUMN indicator_id INT NOT NULL;
ALTER TABLE Worldbank360_fact ALTER COLUMN unit_id INT NOT NULL;
ALTER TABLE Worldbank360_fact ALTER COLUMN value DECIMAL(18,4) NOT NULL;

ALTER TABLE Worldbank360_fact
ADD CONSTRAINT UQ_Fact UNIQUE (country_id, time_id, indicator_id);

-- ===========================================
-- INDEXES
-- ===========================================

CREATE INDEX idx_fact_main
ON Worldbank360_fact (country_id, time_id, indicator_id);