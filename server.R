#Server

# Ok, I think I have the time_series running like I wanted, take a look. I kind of like your vline idea though
# Run the app from here


# Shiny 
library(shiny)
library(shinydashboard)

# Graphics
library(ggplot2)

# Google Trends
library(gtrendsR)

# Data manipulation
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)

# Time series
shinyServer(function(input,output){
    
    # Word Cloud
    output$wordcloud <- renderPlot({
        
        selected_candidate <- as.numeric(input$candidate_selected) # default is 1 for Bernie
        
        # function and data all defined in time_series.R
        source(file = "word_cloud.R", local = TRUE) 
        shiny_word_clouds[[selected_candidate]] 
        
    })
    
    # Time Series
    output$TS <- renderPlot({
        
        selected_candidate <- as.numeric(input$candidate_selected) # default is 1 for Bernie
        
        # function and data all defined in time_series.R
        source(file = "time_series.R", local = TRUE) 
        candidate_time_series(selected_candidate) 
        
    })

    # Before Map
    output$Before_Map <- renderPlot({
        
        selected_candidate <- as.numeric(input$candidate_selected) # this should be a global variable in app.R
        
        # function and data all defined in time_series.R
        source(file = "interest_maps.R", local = TRUE) 
        candidate_before_maps[[selected_candidate]]
    })

    #After map
    output$After_Map <- renderPlot({
        
        selected_candidate <- as.numeric(input$candidate_selected) # default is 1 for Bernie
        
        # function and data all defined in time_series.R
        source(file = "interest_maps.R", local = TRUE) 
        candidate_after_maps[[selected_candidate]]
    })
})