library(plumber)
setwd('/Users/eunicerodas/Documents/Maestria/ProductDev/proyecto-product-dev/api')
r <- plumb("prediction_api.R")
r$run(host = "0.0.0.0", port = 8001)



