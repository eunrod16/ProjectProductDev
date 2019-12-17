library(dplyr)
library(rpart)
library(plumber)
library(readr)
library(assertive)
library(rjson)
library(jsonlite)
setwd('/Users/eunicerodas/Documents/Maestria/ProductDev/proyecto-product-dev/api')
reg <- readRDS("final_model_ref.rds")
classification <- readRDS("final_model_class.rds")

df_log <- data.frame(matrix(ncol = 7, nrow = 0))
x <- c("Usurario", "Endpoint","UserAgent","Timestamp","Modelo","Payload","Output")
colnames(df_log) <- x
if (file.exists('../log.csv')){
  df_log <- read_csv("../log.csv")
}



#* @apiTitle Predicting a Pulsar Star Regression
#* @apiDescription Predicting if is a pulsar star based on data Regression

#* @filter setuser
function(req){
  un <- req$cookies$user
  # Make req$username available to endpoints
  req$username <- un
  plumber::forward()
}


#' Log system time, request method and HTTP user agent of the incoming request
#' @filter logger
function(req){
  print(req$HTTP_USER)
  plumber::forward()
}


#' @param std.DMSNR.curve Standard deviation of the DM-SNR curve
#' @param Excess.kurtosis.ip Excess kurtosis of the integrated profile
#' @param Skewness.ip Skewness of the integrated profile
#' @param Mean.ip Mean of the integrated profile
#' @post /stars/reg
function(std.DMSNR.curve, Excess.kurtosis.ip, Skewness.ip, Mean.ip,req){
 
  features <- data_frame('std.DMSNR.curve'= as.numeric(std.DMSNR.curve),
                         'Excess.kurtosis.ip'= as.numeric(Excess.kurtosis.ip),
                         'Skewness.ip'= as.numeric(Skewness.ip),
                         'Mean.ip' = as.numeric(Mean.ip)
                         )


  out<-predict(reg, features)
  newRow <- data.frame(
    Usuario='user',
    Endpoint='/stars/reg',
    UserAgent=req$HTTP_USER_AGENT,
    Timestamp=as.character(Sys.time()),
    Modelo='Regression',
    Payload=features,
    Output=out) 
  df_log <- rbind(df_log, newRow)
  print(df_log)
  write.csv(df_log, file = "../log.csv",row.names=FALSE)
  as.character(out)
}

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

#' @param std.DMSNR.curve Standard deviation of the DM-SNR curve
#' @param Excess.kurtosis.ip Excess kurtosis of the integrated profile
#' @param Skewness.ip Skewness of the integrated profile
#' @param Mean.ip Mean of the integrated profile
#' @post /stars/
function(std.DMSNR.curve, Excess.kurtosis.ip, Skewness.ip, Mean.ip) {

      features <- data_frame('std.DMSNR.curve'= as.numeric(std.DMSNR.curve),
                             'Excess.kurtosis.ip'= as.numeric(Excess.kurtosis.ip),
                             'Skewness.ip'= as.numeric(Skewness.ip),
                             'Mean.ip' = as.numeric(Mean.ip)
      )
      out<-predict(reg, features)
      reg_out <- as.character(out)
      
      features <- data_frame('std.DMSNR.curve'= as.numeric(std.DMSNR.curve),
                             'Excess.kurtosis.ip'= as.numeric(Excess.kurtosis.ip),
                             'Skewness.ip'= as.numeric(Skewness.ip),
                             'Mean.ip' = as.numeric(Mean.ip)
      )
      out<-predict(classification, features)
      class_out <- as.character(out)
 
      response <- list(status = "SUCCESS", code = "200",output = list(reg_out = reg_out, class_out = class_out))
      return (repsonse)
}

#' @param batch_size Batch size
#' @param data Process data by batch size
#' @post /stars/batch
function(batch_size, data) {
  
  response <- list(status = "SUCCESS", code = "200",output = list(reg_out = reg_out, class_out = class_out))
  return (repsonse)
}


#' @param data_to_test Load test
#' @post /stars/load_test
function(data_to_test) {
  instances <- jsonlite::fromJSON(data_to_test)
  input <- data.frame(instances)
  input <- data_frame(Mean.ip = input$Mean.ip, Skewness.ip = input$Skewness.ip, 
                     Excess.kurtosis.ip = input$Excess.kurtosis.ip, std.DMSNR.curve = input$std.DMSNR.curve)
  
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

  ## 75% of the sample size
  smp_size <- floor(0.75 * nrow(data))

  ## set the seed to make your partition reproducible
  set.seed(123)
  predicted <- predict(classification, input)
  print(nrow(input))
  train_ind <- seq(1, nrow(input))
  test <- data[train_ind, ]
  actual <- predict(classification, test)
  
  ## Confussino matrix
  print(nrow(actual))
  print(nrow(predicted))
  cm = as.matrix(table(Actual = actual, Predicted = predicted)) # create the confusion matrix

  ## Accuracy
  n = sum(cm) # number of instances
  nc = nrow(cm) # number of classes
  diag = diag(cm) # number of correctly classified instances per class 
  rowsums = apply(cm, 1, sum) # number of instances per class
  colsums = apply(cm, 2, sum) # number of predictions per class
  p = rowsums / n # distribution of instances over the actual classes
  q = colsums / n # distribution of instances over the predicted classes
  accuracy = sum(diag) / n 
  
  ## Precision
  precision = diag / colsums 
  recall = diag / rowsums 
  f1 = 2 * precision * recall / (precision + recall) 
  
  #response <- list(status = "SUCCESS", code = "200",
   #                output = list(accuracy = accuracy, conf= cm, precision = precision, recall = recall, f1 = f1))
  # return (response)
  response <- list(accuracy = accuracy, conf= cm, precision = precision, recall = recall, f1 = f1)
  return (toJSON(response, force = TRUE))
}


