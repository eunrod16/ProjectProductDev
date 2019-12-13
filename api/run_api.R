library(plumber)
setwd('/Users/alanhurtarte/Galileo/Product Dev/Proyecto/api')
r <- plumb("prediction_api.R")
r$run(host = "0.0.0.0", port = 8001)
