# ============================================================
# 02_analysis.R  — Operational KPI & Summary Analysis
# Input : outputs/tables/jan01_cleaned.csv
# Output: outputs/tables/analysis_summary_*.csv
# ============================================================

library(tidyverse)

# ---------- LOAD CLEAN DATA ----------
df <- read_csv("outputs/tables/jan01_cleaned.csv")

# ---------- CREATE OUTPUT FOLDER ----------
dir.create("outputs/tables", showWarnings = FALSE)

# ============================================================
# 1️⃣ OVERALL SHIFT KPIs
# ============================================================

kpi_overall <- df %>%
  summarise(
    total_visits = n(),
    total_patrol_minutes = sum(duration_minutes),
    average_visit_minutes = mean(duration_minutes),
    median_visit_minutes = median(duration_minutes),
    min_visit_minutes = min(duration_minutes),
    max_visit_minutes = max(duration_minutes)
  )

print("===== OVERALL SHIFT KPIs =====")
print(kpi_overall)

write_csv(kpi_overall, "outputs/tables/kpi_overall.csv")


# ============================================================
# 2️⃣ VENUE PERFORMANCE SUMMARY
# ============================================================

venue_summary <- df %>%
  group_by(venue) %>%
  summarise(
    visits = n(),
    total_minutes = sum(duration_minutes),
    avg_minutes = mean(duration_minutes)
  ) %>%
  arrange(desc(total_minutes))

print("===== VENUE SUMMARY =====")
print(venue_summary)

write_csv(venue_summary, "outputs/tables/venue_summary.csv")


# ============================================================
# 3️⃣ OFFICER WORKLOAD COMPARISON
# ============================================================

officer_summary <- df %>%
  group_by(mpo_name) %>%
  summarise(
    visits = n(),
    total_minutes = sum(duration_minutes),
    avg_minutes = mean(duration_minutes)
  ) %>%
  arrange(desc(total_minutes))

print("===== OFFICER SUMMARY =====")
print(officer_summary)

write_csv(officer_summary, "outputs/tables/officer_summary.csv")


# ============================================================
# 4️⃣ HOURLY ACTIVITY DISTRIBUTION
# ============================================================

hourly_summary <- df %>%
  group_by(hour) %>%
  summarise(
    visits = n(),
    total_minutes = sum(duration_minutes)
  ) %>%
  arrange(hour)

print("===== HOURLY SUMMARY =====")
print(hourly_summary)

write_csv(hourly_summary, "outputs/tables/hourly_summary.csv")


# ============================================================
# 5️⃣ VENUE × OFFICER MATRIX
# ============================================================

venue_officer_matrix <- df %>%
  group_by(venue, mpo_name) %>%
  summarise(
    visits = n(),
    total_minutes = sum(duration_minutes),
    .groups = "drop"
  ) %>%
  arrange(venue)

print("===== VENUE × OFFICER MATRIX =====")
print(venue_officer_matrix)

write_csv(venue_officer_matrix, "outputs/tables/venue_officer_matrix.csv")

# ============================================================
cat("✅ Analysis complete. Tables saved in outputs/tables/\n")