# Mini-Project 6 Validation

# clear workspace
rm(list = ls())

# load packages
library(tidyverse)
library(magrittr)

# load data
data <- read.csv('rrData.csv') # adjust path to where your .csv file is, data should be 250 obs. x 4 variables
data$participant <- factor(data$participant) # make participant variable a factor
table(data$participant) # should be 10 repeats per participant


# LINE PLOT ----
# reshape the data into long format so that there are 4 columns: participant, time, feature (rr or rr_fft), and value
data_long <- data %>% gather(key="feature", value="value", rr, rr_fft) # fill gather() to create data_long which should be 500 obs. x 4 variables

# line plot
ggplot(data_long, aes(x=time, y=value, color=feature)) + geom_line() + geom_point() + facet_wrap(~participant) + ggtitle("Figure 1: Line Plot") 

# BAR PLOT ----
# find the mean and standard deviation within each participant-feature
summary_data <- data_long %>% group_by(participant, feature) %>% summarize(mean_rr = mean(value), sd_rr = sd(value)) # fill in group_by() and summarize() functions, should be 50 obs. x 4 variables

# bar plot
ggplot(summary_data, aes(x=participant, y=mean_rr, fill=feature)) +
geom_bar(stat="identity", position=position_dodge()) + geom_errorbar(aes(ymin=mean_rr-sd_rr, ymax=mean_rr+sd_rr), width = 0.2, position=position_dodge(0.9)) + ggtitle("Figure 2: Bar Plot")


# SCATTER PLOT ----
# fit linear model to data, y = rr_fft, x = rr)
fit <- lm(data$rr_fft ~ data$rr)

# combine text for equation
eq <- substitute(italic(y) == a + b %.% italic(x)*", "~~italic(r)^2~"="~r2, 
                 list(a = format(unname(coef(fit)[1]), digits = 2),
                      b = format(unname(coef(fit)[2]), digits = 2),
                      r2 = format(summary(fit)$r.squared, digits = 2)))
text <- as.character(as.expression(eq));

# scatter plot
ggplot(data, aes(x=rr, y=rr_fft)) + geom_point(alpha=0.5) + geom_smooth(method="lm", color="blue") + ggtitle("Figure 3: Scatter Plot") + annotate("text", x = 30, y = 30, label = text, parse = TRUE) 


# BLAND-ALTMAN PLOT ----
# calculate and save the differences between the two measures and the averages of the two measures
data %<>% mutate(diff = rr-rr_fft, avg = (rr+rr_fft)/2)

#compute the mean and limits of agreement (LoA)
mean_bias <- mean(data$diff)
sd_diff <- sd(data$diff)
upper_loa <- mean_bias + (1.96*sd_diff)
lower_loa <- mean_bias - (1.96*sd_diff)

# Bland-Altman plot
ggplot(data, aes(x=avg, y=diff)) + geom_point(alpha=0.5) + geom_hline(yintercept=mean_bias) + geom_hline(yintercept=c(upper_loa, lower_loa)) + annotate("text", x=15, y=upper_loa+2, label=paste("Mean:", round(mean_bias, 2), "LoA:", round(lower_loa, 2), "-", round(upper_loa, 2))) + ggtitle("Figure 4: Bland-Altman Plot") 


# BOX PLOT ----
# box plot
ggplot(data, aes(x=participant, y=diff, fill=participant)) + geom_boxplot() + ggtitle("Figure 5: Box Plot") 
