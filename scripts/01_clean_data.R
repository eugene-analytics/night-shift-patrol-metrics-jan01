# ============================================================
# 01_clean_data.R  — Clean Jan 01 night shift operational data
# Input : data/jan01_tidy.xlsx
# Output: outputs/tables/jan01_cleaned.csv
# ============================================================

library(tidyverse)
library(lubridate)
library(readxl)

# ---------- SETTINGS ----------
input_file  <- "data/p01_jan2026_cro_metrics_r.xlsx"
output_dir  <- "outputs/tables"
output_file <- file.path(output_dir, "jan01_cleaned.csv")

# Business-rule bounds for a single venue visit (minutes)
# Adjust later if needed (e.g., events can be longer)
MIN_MINUTES <- 1
MAX_MINUTES <- 240

# ---------- LOAD ----------
df_raw <- read_excel(input_file)

# ---------- BASIC CHECKS ----------
required_cols <- c("shift_date", "shift_type", "mpo_name", "venue", "visit_start", "visit_end")
missing_cols <- setdiff(required_cols, names(df_raw))
if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

# ---------- CLEAN ----------
df_clean <- df_raw %>%
  # remove blank rows that sneak in from Excel
  filter(!is.na(shift_date), !is.na(venue), !is.na(visit_start), !is.na(visit_end)) %>%
  mutate(
    shift_date = as.Date(shift_date),
    
    # visit_start / visit_end are imported as <dttm> like 1899-12-31 HH:MM:SS
    # Extract time as HH:MM:SS strings
    start_time = format(visit_start, "%H:%M:%S"),
    end_time   = format(visit_end, "%H:%M:%S"),
    
    # Build datetimes using the real shift_date + extracted time
    start_dt = ymd_hms(paste(shift_date, start_time), tz = "Pacific/Auckland"),
    end_dt   = ymd_hms(paste(shift_date, end_time),   tz = "Pacific/Auckland"),
    
    # If end earlier than start, assume it crossed midnight
    end_dt = if_else(end_dt < start_dt, end_dt + days(1), end_dt),
    
    # Duration + derived fields
    duration_minutes = as.numeric(difftime(end_dt, start_dt, units = "mins")),
    hour = hour(start_dt),
    
    # Optional: flag whether visit occurred after midnight (00:00–07:59 etc.)
    after_midnight = hour < 12 & start_dt > start_dt[1]  # rough, OK for a single-night dataset
  ) %>%
  # Remove impossible durations (fixes typos like 09:57 -> 09:00)
  filter(duration_minutes >= MIN_MINUTES, duration_minutes <= MAX_MINUTES) %>%
  # Keep columns tidy (you can keep more if you want)
  select(
    shift_date, shift_type, mpo_name, venue,
    everything(),
    start_dt, end_dt, duration_minutes, hour
  )

# ---------- OUTPUT FOLDERS ----------
dir.create("outputs", showWarnings = FALSE)
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# ---------- SAVE ----------
write_csv(df_clean, output_file)

# ---------- QUICK QA ----------
cat("✅ Clean file saved to:", output_file, "\n")
cat("Rows:", nrow(df_clean), " | Venues:", n_distinct(df_clean$venue), " | MPOs:", n_distinct(df_clean$mpo_name), "\n")
print(summary(df_clean$duration_minutes))

# Show worst (longest) 5 durations (sanity check)
df_clean %>%
  arrange(desc(duration_minutes)) %>%
  select(shift_date, mpo_name, venue, start_dt, end_dt, duration_minutes) %>%
  head(5) %>%
  print()