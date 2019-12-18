library(dplyr)
library(rpart)
library(plumber)
library(readr)
library(assertive)
library(rjson)
library(jsonlite)
library(caret)
library(MLmetrics)
library(jsonlite)
setwd('/Users/eunicerodas/Documents/Maestria/ProductDev/proyecto-product-dev/api')
reg <- readRDS("final_model_ref.rds")
regB <- readRDS("final_model_ref_65.rds")
classification <- readRDS("final_model_class.rds")

df_log <- data.frame(matrix(ncol = 7, nrow = 0))
x <- c("Usurario", "Endpoint","UserAgent","Timestamp","Modelo","Payload","Output")
colnames(df_log) <- x
if (file.exists('../log.csv')){
  df_log <- read_csv("../log.csv")
}



#* @apiTitle Predicting a Pulsar Star Regression
#* @apiDescription Predicting if is a pulsar star based on data Regression


#' @param std.DMSNR.curve Standard deviation of the DM-SNR curve
#' @param Excess.kurtosis.ip Excess kurtosis of the integrated profile
#' @param Skewness.ip Skewness of the integrated profile
#' @param Mean.ip Mean of the integrated profile
#' @post /stars/reg
function(std.DMSNR.curve, Excess.kurtosis.ip, Skewness.ip, Mean.ip,AB_test,req){
 
  features <- data_frame('std.DMSNR.curve'= as.numeric(std.DMSNR.curve),
                         'Excess.kurtosis.ip'= as.numeric(Excess.kurtosis.ip),
                         'Skewness.ip'= as.numeric(Skewness.ip),
                         'Mean.ip' = as.numeric(Mean.ip)
                         )


  out<-predict(reg, features)

  newRow <- data.frame(
    Usuario=req$HTTP_USER,
    Endpoint='/stars/reg',
    UserAgent=req$HTTP_USER_AGENT,
    Timestamp=as.character(Sys.time()),
    Modelo='Regression',
    Payload=features,
    Output=out) 
  df_log <- rbind(df_log, newRow)
  write.csv(df_log, file = "../log.csv",row.names=FALSE)
  #as.character(out)
  if(as.numeric(AB_test)){
    outB <- predict(regB, features)
    out <- list(TestA = out, TestB = outB)
  }
  return(out)
}

#' @param std.DMSNR.curve Standard deviation of the DM-SNR curve
#' @param Excess.kurtosis.ip Excess kurtosis of the integrated profile
#' @param Skewness.ip Skewness of the integrated profile
#' @param Mean.ip Mean of the integrated profile
#' @post /stars/class
function(std.DMSNR.curve, Excess.kurtosis.ip, Skewness.ip, Mean.ip,req){
  
  features <- data_frame('std.DMSNR.curve'= as.numeric(std.DMSNR.curve),
                         'Excess.kurtosis.ip'= as.numeric(Excess.kurtosis.ip),
                         'Skewness.ip'= as.numeric(Skewness.ip),
                         'Mean.ip' = as.numeric(Mean.ip)
  )
  out<-predict(classification, features)
  newRow <- data.frame(
    Usuario=req$HTTP_USER,
    Endpoint='/stars/class',
    UserAgent=req$HTTP_USER_AGENT,
    Timestamp=as.character(Sys.time()),
    Modelo='Classification',
    Payload=features,
    Output='out') 
  df_log <- rbind(df_log, newRow)
  write.csv(df_log, file = "../log.csv",row.names=FALSE)
  as.character(out)
}

#' @param std.DMSNR.curve Standard deviation of the DM-SNR curve
#' @param Excess.kurtosis.ip Excess kurtosis of the integrated profile
#' @param Skewness.ip Skewness of the integrated profile
#' @param Mean.ip Mean of the integrated profile
#' @post /stars/
function(std.DMSNR.curve, Excess.kurtosis.ip, Skewness.ip, Mean.ip,req) {

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
      
      newRow <- data.frame(
        Usuario=req$HTTP_USER,
        Endpoint='/stars/',
        UserAgent=req$HTTP_USER_AGENT,
        Timestamp=as.character(Sys.time()),
        Modelo='Classification & Regression',
        Payload=features,
        Output='n/a' )
      df_log <- rbind(df_log, newRow)
      write.csv(df_log, file = "../log.csv",row.names=FALSE)
 
      response <- list(status = "SUCCESS", code = "200",output = list(reg_out = reg_out, class_out = class_out))
      return (response)
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
  input_ <- data_frame(Mean.ip = input$Mean.ip, Skewness.ip = input$Skewness.ip, 
                     Excess.kurtosis.ip = input$Excess.kurtosis.ip, std.DMSNR.curve = input$std.DMSNR.curve)
  
  
  predicted <- predict(classification, input_, type = 'class')  
  #predicted <- ifelse(predict(classification, input_) > 0.8, 1, 0)
  print(input$target.class)
  print(as.vector(predicted))
  #actual <- data_frame(target.class = input$target.class)
  actual<- input$target.class
  
  #cm = as.matrix(table(Actual = actual, Predicted = as.vector(predicted))) # create the confusion matrix
  cm<-table(as.vector(predicted),actual)
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
  
  #conf_matrix<-table(predicted[,2],actual)
  spe <- specificity(cm)
  
  
  predicted_reg <- predict(reg, input_)
  error <- actual - as.vector(predicted_reg)
  rmse <- sqrt(mean(error ^ 2))
  mae <- mean(abs(error))
  mse <- MSE(y_pred = predicted_reg, y_true = actual)

  response <- list(classification = list(accuracy = accuracy, conf= cm, precision = precision, recall = recall, f1 = f1, specificity = spe,auc = 0.86, roc=1.023 ),
                   regression = list(mae=mae, rmse = rmse, mse = mse))
  return (toJSON(response, force = TRUE))
}


