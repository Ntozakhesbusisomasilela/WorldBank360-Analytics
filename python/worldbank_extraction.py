import requests
import pandas as pd
import pycountry
import time

# ==============================
# 1. CONFIG
# ==============================

BASE_URL = "https://data360api.worldbank.org/data360/data"

INDICATORS = {
    "gdp_per_capita": "WB_WDI_NY_GDP_PCAP_CD",
    "gdp_growth": "WB_WDI_NY_GDP_MKTP_KD_ZG",
    "inflation": "WB_WDI_FP_CPI_TOTL_ZG",
    "life_expectancy": "WB_WDI_SP_DYN_LE00_IN",
    "unemployment": "WB_WDI_SL_UEM_TOTL_ZS",
    "school_enrollment": "WB_WDI_SE_PRM_ENRR"
}

DATABASE_ID = "WB_WDI"

# ==============================
# 2. LOAD ISO COUNTRY CODES
# ==============================

iso_countries = {c.alpha_3 for c in pycountry.countries}

# ==============================
# 3. FETCH FUNCTION (WITH PAGINATION)
# ==============================

def fetch_indicator(indicator_code):
    all_data = []
    skip = 0
    limit = 1000

    while True:
        params = {
            "DATABASE_ID": DATABASE_ID,
            "INDICATOR": indicator_code,
            "skip": skip
        }

        response = requests.get(BASE_URL, params=params)

        if response.status_code != 200:
            print(f"Error fetching {indicator_code}")
            break

        data = response.json()

        rows = data.get("value", [])

        if not rows:
            break

        all_data.extend(rows)

        print(f"{indicator_code} → fetched {len(all_data)} rows")

        skip += limit
        time.sleep(0.3)  # avoid rate limit

    return pd.DataFrame(all_data)

# ==============================
# 4. CLASSIFICATION FUNCTIONS
# ==============================

def classify_geo(code):
    if code in iso_countries:
        return "country"
    else:
        return "aggregate"  # includes regions + income groups

def classify_indicator(code):
    parts = code.split("_")

    if len(parts) < 3:
        return "other"

    prefix = parts[2]

    mapping = {
        "NY": "GDP",
        "FP": "inflation",
        "SP": "health",
        "SL": "employment",
        "SE": "education"
    }

    return mapping.get(prefix, "other")

# ==============================
# 5. MAIN EXTRACTION LOOP
# ==============================

dfs = []

for name, code in INDICATORS.items():
    print(f"\nFetching {name} ({code})")

    df = fetch_indicator(code)

    if df.empty:
        continue

    # Keep only relevant columns
    df = df[[
        "REF_AREA",
        "TIME_PERIOD",
        "OBS_VALUE",
        "UNIT_MEASURE",
        "INDICATOR"
    ]]

    # Rename columns
    df.columns = ["country_code", "year", "value", "unit", "indicator_code"]

    # Convert types
    df["value"] = pd.to_numeric(df["value"], errors="coerce")
    df["year"] = pd.to_numeric(df["year"], errors="coerce")

    # Add metadata
    df["indicator_name"] = name
    df["category"] = df["indicator_code"].apply(classify_indicator)
    df["geo_type"] = df["country_code"].apply(classify_geo)

    dfs.append(df)

# ==============================
# 6. COMBINE DATA
# ==============================

final_df = pd.concat(dfs, ignore_index=True)

# ==============================
# 7. BASIC CLEANING
# ==============================

# Remove null values
final_df = final_df.dropna(subset=["value", "year"])

# Optional: remove aggregates (keep only countries)
# Comment this out if you want regions included
# final_df = final_df[final_df["geo_type"] == "country"]

# ==============================
# 8. EXPORT FOR SQL
# ==============================

final_df.to_csv("worldbank_fact_table.csv", index=False)

print("\nData saved to worldbank_fact_table.csv")