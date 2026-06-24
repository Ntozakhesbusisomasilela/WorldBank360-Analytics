# WorldBank360 Analytics Dashboard

## Project Overview

WorldBank360 Analytics is an end-to-end Business Intelligence and Data Analytics project built using Python, SQL Server, and Power BI. The project analyzes global economic and human development indicators from 1960 to 2025 using data extracted from the World Bank API.

The goal of the project was to transform raw international development data into interactive dashboards and meaningful analytical insights focused on:

* Economic growth
* Inflation trends
* Employment patterns
* Human development indicators
* Education trends
* Country-level comparisons

The project follows a complete analytics workflow:

* API Data Extraction (Python)
* Data Cleaning & Transformation (Pandas)
* Data Warehousing (SQL Server)
* Dimensional Modeling
* Power BI Dashboard Development
* Data Storytelling & Visualization

---

## Technologies Used

| Technology   | Purpose                         |
| ------------ | ------------------------------- |
| Python       | API extraction & preprocessing  |
| Pandas       | Data cleaning & transformation  |
| SQL Server   | Data warehousing & modeling     |
| Power BI     | Dashboard development           |
| DAX          | KPI calculations                |
| Git & GitHub | Version control & documentation |

---

## Dataset Source

Data was collected from the World Bank API and includes indicators such as:

* GDP per Capita
* GDP Growth
* Inflation Rate
* Life Expectancy
* Unemployment Rate
* School Enrollment

Coverage:

* 1960 – 2025
* 200+ countries and territories

---

## Data Pipeline

A custom Python ETL pipeline was developed to:

* Connect to the World Bank API
* Handle API pagination
* Extract multiple indicators dynamically
* Clean and standardize datasets
* Handle missing values and outliers
* Export processed data for SQL loading

The processed data was then loaded into SQL Server using a dimensional model.

---

## Data Warehouse Design

A star schema was implemented in SQL Server.

### Fact Table

* WorldBank360_Fact

### Dimension Tables

* DimCountry
* DimIndicator
* DimTime
* DimUnit

### Optimization Techniques

* One-to-many relationships
* Single-direction filtering
* Surrogate keys
* Reduced unnecessary columns
* Optimized Power BI relationships

---

## Dashboard Preview

### Executive Overview
<img width="2427" height="1365" alt="pg2" src="https://github.com/user-attachments/assets/86eb09c3-5b88-4993-887f-ad8135ea8572" />

### Human Development & Education Analysis
<img width="2376" height="1332" alt="pg5" src="https://github.com/user-attachments/assets/b124a64d-727a-4a89-a7cb-6063595c4a16" />

### Country Deep Dive
<img width="2376" height="1335" alt="pg6" src="https://github.com/user-attachments/assets/5b9e5811-4050-4235-8f5a-b9451ee7db85" />


## Dashboard Pages

### 1. Home page

### 2. Executive Overview

Provides a high-level summary of:

* GDP trends
* Inflation rates
* Unemployment patterns
* Life expectancy metrics

### 3. Economic Stability Analysis

Focuses on:

* Inflation trends over time
* Historical instability periods
* Hyperinflation analysis
* Country stability comparisons

### 4. Economic Growth & Employment

Explores:

* GDP vs unemployment relationships
* Top-performing economies
* Employment trends
* Economic comparisons between countries

### 5. Human Development & Education Analysis

Analyzes:

* Life expectancy trends
* School enrollment patterns
* GDP vs life expectancy relationships
* Education and unemployment comparisons
* Top-performing countries by development indicators

### 6. Country Deep Dive

Provides a drill-through analysis for individual countries including:

* GDP per capita trends
* Inflation history
* Unemployment patterns
* Life expectancy changes
* Country-specific KPI monitoring

---

## Key Insights

### Global Hyperinflation in the 1990s

One of the strongest findings from the analysis was the discovery of extreme inflation spikes during the 1990s.

Key observations included:

* Multiple countries exceeded inflation rates above 3,000%
* The Democratic Republic of Congo recorded inflation above 20,000%
* Post-Soviet economic instability significantly affected global averages
* The 1990s became the most economically unstable decade in the dataset

This highlighted how historical events can heavily distort long-term averages and why contextual analysis is important in Business Intelligence.

---

## Analytical Features

The dashboard includes:

* KPI cards
* Trend analysis
* Scatter plots
* Country comparisons
* Interactive filtering
* Dynamic DAX measures
* Business-focused storytelling

---

## Power BI Features

The dashboard incorporates several Business Intelligence capabilities:

* Drill-through navigation
* Interactive slicers
* Dynamic KPI cards
* Cross-filtering visuals
* Trend analysis
* Correlation analysis
* Country-level exploration
* Data storytelling dashboards

---

## Challenges Encountered

### Data Quality & Outliers

Extreme inflation values distorted averages and required additional analytical investigation.

### Dimensional Modeling

Relationship design and filtering behavior required careful schema planning to avoid ambiguity.

### Visualization Optimization

Several visuals required refinement to improve readability and storytelling quality.

---

## Skills Demonstrated

* Data analytics & visualization
* ETL pipeline development
* API integration
* SQL dimensional modeling
* Power BI dashboard development
* DAX calculations
* Data storytelling
* Economic trend analysis

---

## Future Improvements

Potential future enhancements include:

* Forecasting models
* Population-based analysis
* Regional comparison dashboards
* Real-time refresh pipelines
* Advanced statistical analysis

---

## Repository Structure

```text
WorldBank360-Analytics/
│
├── data/
├── python/
├── sql/
├── powerbi/
├── README.md
└── requirements.txt
```

---

## Conclusion

This project transformed raw World Bank API data into an interactive Business Intelligence solution capable of uncovering meaningful global economic and development trends.

The project strengthened practical skills in:

* Data analytics
* ETL development
* SQL modeling
* Power BI reporting
* Business storytelling
* End-to-end analytics workflows
