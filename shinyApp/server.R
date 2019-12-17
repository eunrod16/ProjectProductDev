#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(dplyr)
library(DT)
data_ <- read_csv("../log.csv")
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    username <- reactive({
        data_ %>%
            filter(Usuario == input$username)
    })
    observeEvent(username(), {

        choices <- unique(username()$Endpoint)
         if(length(choices)>0) choices <- prepend(choices, "all endpoints")
         updateSelectInput(session, 'endpoint', choices = choices)
        
    })
    endpoint <- reactive({
        if(input$endpoint!='all endpoints'){
            username() %>%
                filter(Endpoint == input$endpoint)
        }
        else
            username() 
    })
    observeEvent(endpoint(), {
        
        choices <- unique(endpoint()$UserAgent)
        if(length(choices)>0) choices <- prepend(choices, "all useragents")
        updateSelectInput(session, 'useragent', choices = choices)
        
    })
    useragent <- reactive({
        if(input$useragent!='all useragents'){
            endpoint() %>%
                filter(UserAgent == input$useragent)
        }
        else
            endpoint() 
    })
    observeEvent(useragent(), {
        
        choices <- unique(useragent()$Modelo)
        if(length(choices)>0) choices <- prepend(choices, "all modelos")
        updateSelectInput(session, 'modelo', choices = choices)
        
    })
    output$tbl <- renderDataTable({
        if(input$modelo!='all modelos'){
            useragent() %>%
                filter(Modelo == input$modelo)
        }
        else{
            useragent()
        }
        
    })
    

})
