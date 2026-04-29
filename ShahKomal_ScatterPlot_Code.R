library(ggplot2)
library(readxl)
library(dplyr)
library(tidyr)
library(lubridate)


df <- read_excel("Self_Tracking_Data.xlsx")


plot_scatter <- ggplot(combined, aes(x = Stress, y = HeartRate)) +
  geom_point(size = 3, alpha = 0.8) +
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  labs(title = "Relationship Between Stress and Heart Rate", x = "Subjective Stress (1–10)", y = "Heart Rate (bpm)") + theme_minimal(base_size = 14)

print(plot_scatter)

# Correlation test
cor_result <- cor.test(combined$Stress, combined$HeartRate)

print(cor_result)


model <- lm(HeartRate ~ Stress, data = combined)
summary(model)