library(tidyverse)
library(readxl)
library(lubridate)

tracking_data <- read_excel("Self_Tracking_Data.xlsx")
head(tracking_data)
colnames(tracking_data)

tracking_data <- tracking_data %>%
  mutate(DATE = as.Date(DATE, format = "%Y-%m-%d"))

tidy_tracking <- tracking_data %>%
  pivot_longer(
    cols = c(Afternoon_Heart_Rate, Evening_Heart_Rate, Afternoon_Stress_Level, Evening_Stress_Level, Delta_Stress_Level, Delta_Heart_Rate),
    names_to = "Feature",
    values_to = "Value"
  ) %>%
  arrange(DATE)

tidy_tracking <- tidy_tracking %>%
  mutate(id = row_number()) %>%
  select(id, DATE, Feature, Value)

tidy_tracking %>%
  tibble() %>%
  glimpse()

features_summary <- tidy_tracking %>%
  group_by(Feature) %>%
  summarise(
    Mean = mean(Value, na.rm = TRUE),
    SD = sd(Value, na.rm = TRUE),
    .groups = "drop"
  )

print(features_summary)


