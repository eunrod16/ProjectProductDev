#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(DT)
library(tidyverse)
data_ <- read_csv("../log.csv")
# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Log Project Product Dev"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("username", "User Name", choices = unique(data_$Usuario)),
            selectInput("endpoint", "EndPoint", choices = unique(data_$Endpoint)),
            selectInput("useragent", "User Agent", choices = unique(data_$UserAgent)),
            selectInput("modelo", "Modelo", choices = unique(data_$Modelo))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            DT::dataTableOutput("tbl")
        )
    )
))
