## 🔗 Live Interactive Report
👉 https://eugene-analytics.github.io/night-shift-patrol-metrics-jan01/

# Night Shift Patrol Metrics — Jan 01, 2026

## Overview

This project analyses anonymised overnight patrol visit data using R.
It demonstrates an end-to-end workflow including:

- Excel data ingestion
- Time cleaning and midnight handling
- Data validation and outlier filtering
- KPI calculation
- Officer workload comparison
- Venue activity analysis
- Heatmap visualisation
- HTML reporting via Quarto

---

## Project Structure

scripts/ → Cleaning, analysis, visualisation scripts
report/ → Quarto report (.qmd + rendered HTML)
outputs/ → Generated tables and charts
data/ → Anonymised sample dataset


---

## Key Insights

- Patrol workload varies significantly across venues.
- Activity clusters in specific hours during the shift.
- Officer workload distribution can be quantitatively compared.
- Outlier detection was applied to ensure data quality.

---

## Tools Used

- R
- tidyverse
- lubridate
- readxl
- ggplot2
- Quarto

---

## How to Reproduce

1. Run `scripts/01_clean_data.R`
2. Run `scripts/02_analysis.R`
3. Run `scripts/03_visuals.R`
4. Render `report/jan01_report.qmd`

---

## Author

Eugene Timakin  
BSc Statistics (in progress)  
Auckland, New Zealand
