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

library(ggplot2)
library(ggpmisc)  


shinyServer(function(input,output){
    output$TS <- renderPlot({
        
        selected_candidate <- as.numeric(input$candidate_selected) # default is 1 for Bernie
        
        # function and data all defined in time_series.R
        source(file = "time_series.R", local = TRUE) 
        candidate_time_series(selected_candidate) 
        
    })
})
