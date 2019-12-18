library(dplyr)
library(readr)
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
library(corrplot)
library(tidyverse)
setwd('/Users/eunicerodas/Documents/Maestria/ProductDev/proyecto-product-dev/api')
data <- read_csv("../pulsar_stars.csv")
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

## 65% of the sample size
smp_size_65 <- floor(0.65 * nrow(data))

## set the seed to make your partition reproducible
set.seed(123)
train_ind <- sample(seq_len(nrow(data)), size = smp_size)
train_ind_65 <- sample(seq_len(nrow(data)), size = smp_size_65)

train <- data[train_ind, ]
test <- data[-train_ind, ]

train_65 <- data[train_ind_65, ]
test_65 <- data[-train_ind_65, ]

res <- cor(train)
round(res, 2)
corrplot(res, type = "full", order = "hclust", 
         tl.col = "black", tl.srt = 45)

linearMod <- lm(target_class ~ std.DMSNR.curve + Excess.kurtosis.ip + Skewness.ip + Mean.ip, data=train)

linearMod_65 <- lm(target_class ~ std.DMSNR.curve + Excess.kurtosis.ip + Skewness.ip + Mean.ip, data=train_65)
print(linearMod)
summary(linearMod)

Prediction <- predict(linearMod, test)
PredictionB <- predict(linearMod_65, test_65)
saveRDS(linearMod, "final_model_ref.rds")
saveRDS(linearMod_65, "final_model_ref_65.rds")

classification <- rpart(target_class ~ std.DMSNR.curve + Excess.kurtosis.ip + Skewness.ip + Mean.ip,
             method="class", data=train)
print(classification)
summary(classification)

Prediction <- predict(classification, test, type = "class")
saveRDS(classification, "final_model_class.rds")
