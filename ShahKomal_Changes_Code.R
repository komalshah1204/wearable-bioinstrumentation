library(readxl)
library(tidyverse)

# Load data
df <- read_excel("Self_Tracking_Data.xlsx")

plot_delta <- ggplot(df, aes(x = Delta_Stress_Level, y = Delta_Heart_Rate)) +
  
  geom_point(size = 3, alpha = 0.8) +
  
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray") +
  
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  
  labs(
    title = "Within-Day Changes in Stress vs Heart Rate",
    x = expression(Delta*" Stress Level (Evening - Afternoon)"),
    y = expression(Delta*" Heart Rate (bpm)")
  ) +
  
  theme_minimal(base_size = 14)

print(plot_delta)


# Correlation between changes
cor_delta <- cor.test(df$Delta_Stress_Level, df$Delta_Heart_Rate)

print(cor_delta)

model_delta <- lm(Delta_Heart_Rate ~ Delta_Stress_Level, data = df)
summary(model_delta)