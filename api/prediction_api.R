library(dplyr)
library(rpart)
library(plumber)
library(assertive)
setwd('/Users/alanhurtarte/Galileo/Product Dev/Proyecto')
reg <- readRDS("final_model_ref.rds")
classification <- readRDS("final_model_class.rds")
#* @apiTitle Predicting a Pulsar Star Regression
#* @apiDescription Predicting if is a pulsar star based on data Regression
#' @param std.DMSNR.curve Standard deviation of the DM-SNR curve
#' @param Excess.kurtosis.ip Excess kurtosis of the integrated profile
#' @param Skewness.ip Skewness of the integrated profile
#' @param Mean.ip Mean of the integrated profile
#' @post /stars/reg
function(std.DMSNR.curve, Excess.kurtosis.ip, Skewness.ip, Mean.ip){
 
  features <- data_frame('std.DMSNR.curve'= as.numeric(std.DMSNR.curve),
                         'Excess.kurtosis.ip'= as.numeric(Excess.kurtosis.ip),
                         'Skewness.ip'= as.numeric(Skewness.ip),
                         'Mean.ip' = as.numeric(Mean.ip)
                         )
  out<-predict(reg, features)
  as.character(out)
}

#* @apiTitle Predicting a Pulsar Star Classification
#* @apiDescription Predicting if is a pulsar star based on data Classification
#' @param std.DMSNR.curve Standard deviation of the DM-SNR curve
#' @param Excess.kurtosis.ip Excess kurtosis of the integrated profile
#' @param Skewness.ip Skewness of the integrated profile
#' @param Mean.ip Mean of the integrated profile
#' @post /stars/class
function(std.DMSNR.curve, Excess.kurtosis.ip, Skewness.ip, Mean.ip){
  
  features <- data_frame('std.DMSNR.curve'= as.numeric(std.DMSNR.curve),
                         'Excess.kurtosis.ip'= as.numeric(Excess.kurtosis.ip),
                         'Skewness.ip'= as.numeric(Skewness.ip),
                         'Mean.ip' = as.numeric(Mean.ip)
  )
  out<-predict(classification, features)
  as.character(out)
}
