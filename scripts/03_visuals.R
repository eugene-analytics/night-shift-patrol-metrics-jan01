# ============================================================
# 03_visuals.R — Operational Visualisations
# Input : outputs/tables/jan01_cleaned.csv
# Output: outputs/figures/*.png
# ============================================================

library(tidyverse)

# ---------- LOAD CLEAN DATA ----------
df <- read_csv("outputs/tables/jan01_cleaned.csv")

# ---------- CREATE FIGURE FOLDER ----------
dir.create("outputs/figures", showWarnings = FALSE)

# ============================================================
# 1️⃣ TOTAL MINUTES PER VENUE
# ============================================================

p1 <- df %>%
  group_by(venue) %>%
  summarise(total_minutes = sum(duration_minutes)) %>%
  arrange(desc(total_minutes)) %>%
  ggplot(aes(x = reorder(venue, total_minutes), y = total_minutes)) +
  geom_col(fill = "#2C3E50") +
  coord_flip() +
  labs(
    title = "Total Patrol Minutes per Venue",
    x = "Venue",
    y = "Total Minutes"
  ) +
  theme_minimal()

ggsave("outputs/figures/01_total_minutes_per_venue.png", p1, width = 9, height = 6)


# ============================================================
# 2️⃣ OFFICER WORKLOAD COMPARISON
# ============================================================

p2 <- df %>%
  group_by(mpo_name) %>%
  summarise(total_minutes = sum(duration_minutes)) %>%
  ggplot(aes(x = mpo_name, y = total_minutes, fill = mpo_name)) +
  geom_col() +
  labs(
    title = "Total Patrol Minutes by Officer",
    x = "Officer",
    y = "Total Minutes"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("outputs/figures/02_officer_workload.png", p2, width = 8, height = 5)


# ============================================================
# 3️⃣ VISITS BY HOUR
# ============================================================

p3 <- ggplot(df, aes(x = hour)) +
  geom_bar(fill = "#16A085") +
  labs(
    title = "Visit Frequency by Hour",
    x = "Hour of Shift",
    y = "Number of Visits"
  ) +
  theme_minimal()

ggsave("outputs/figures/03_visits_by_hour.png", p3, width = 8, height = 5)


# ============================================================
# 4️⃣ HEATMAP: VENUE × HOUR (ADVANCED LOOK)
# ============================================================

p4 <- df %>%
  group_by(venue, hour) %>%
  summarise(visits = n(), .groups = "drop") %>%
  ggplot(aes(x = hour, y = venue, fill = visits)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "#E74C3C") +
  labs(
    title = "Patrol Activity Heatmap (Venue × Hour)",
    x = "Hour",
    y = "Venue",
    fill = "Visits"
  ) +
  theme_minimal()

ggsave("outputs/figures/04_heatmap_venue_hour.png", p4, width = 10, height = 6)

cat("✅ Visualisations saved in outputs/figures/\n")