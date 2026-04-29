library(ggplot2)
library(readxl)
library(dplyr)
library(tidyr)
library(lubridate)

# heat maps

df <- read_excel("Self_Tracking_Data.xlsx")
df$DATE <- as.Date(df$DATE)

df <- df %>%
  mutate(Avg_Heart_Rate = (Afternoon_Heart_Rate+Evening_Heart_Rate)/2, Avg_Stress = (Afternoon_Stress_Level+Evening_Stress_Level)/2, DayOfWeek=factor(weekdays(DATE), levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")), Week=as.numeric(DATE-min(DATE)) %/% 7+1)

# heart rate heat map
ggplot(df, aes(x=DayOfWeek, y=as.factor(Week), fill=Avg_Heart_Rate)) + geom_tile(color="white") + scale_fill_gradient(low="#FEF9E7", high="#CB4335") + labs(title="Daily Average Heart Rate", x="Day of the Week", y="Week", fill="Avg Heart Rate")

# stress heat map
ggplot(df, aes(x=DayOfWeek, y=as.factor(Week), fill=Avg_Stress)) + geom_tile(color="white") + scale_fill_gradient(low="#EBF5FB", high="#21618C") + labs(title="Daily Average Stress", x="Day of the Week", y="Week", fill="Avg Stress")
