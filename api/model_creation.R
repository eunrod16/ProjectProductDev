library(dplyr)
library(readr)
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
library(corrplot)
library(tidyverse)
setwd('/Users/alanhurtarte/Galileo/Product Dev/Proyecto')
data <- read_csv("pulsar_stars.csv")
data <- as_tibble(data)
data <- data %>%
  rename(
    Mean.ip = 'Mean of the integrated profile',
    std.ip = 'Standard deviation of the integrated profile',
    Excess.kurtosis.ip = 'Excess kurtosis of the integrated profile',
    Skewness.ip = 'Skewness of the integrated profile',
    Mean.DMSNR.curve = 'Mean of the DM-SNR curve',
    std.DMSNR.curve = 'Standard deviation of the DM-SNR curve',
    Excess.kurtosis.DMSNR.curve = 'Excess kurtosis of the DM-SNR curve',
    Skewness.DMSNR.curve = 'Skewness of the DM-SNR curve',
    target_class = 'target_class'
  )
colnames(data)

## 75% of the sample size
smp_size <- floor(0.75 * nrow(data))

## set the seed to make your partition reproducible
set.seed(123)
train_ind <- sample(seq_len(nrow(data)), size = smp_size)

train <- data[train_ind, ]
test <- data[-train_ind, ]

res <- cor(train)
round(res, 2)
corrplot(res, type = "full", order = "hclust", 
         tl.col = "black", tl.srt = 45)

linearMod <- lm(target_class ~ std.DMSNR.curve + Excess.kurtosis.ip + Skewness.ip + Mean.ip, data=train)
print(linearMod)
summary(linearMod)

Prediction <- predict(linearMod, test)
saveRDS(linearMod, "final_model_ref.rds")

classification <- rpart(target_class ~ std.DMSNR.curve + Excess.kurtosis.ip + Skewness.ip + Mean.ip,
             method="class", data=train)
print(classification)
summary(classification)

Prediction <- predict(classification, test)
saveRDS(classification, "final_model_class.rds")
