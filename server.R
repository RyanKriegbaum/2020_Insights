#Server
# Run the app from here

# Time series
shinyServer(function(input,output){
    
    # Word Cloud
    output$wordcloud <- renderPlot({
        
        selected_candidate <- as.numeric(input$candidate_selected) # default is 1 for Bernie
        
        # function and data all defined in word_cloud.R
        source(file = "word_cloud.R", local = TRUE) 
        
        # Output from the function and selection
        shiny_word_clouds[[selected_candidate]] 
        
    })
    
    # Fox Time Series
    output$TS <- renderPlot({
        
        selected_candidate <- as.numeric(input$candidate_selected) # default is 1 for Bernie
        
        # function and data all defined in time_series.R
        source(file = "time_series.R", local = TRUE) 
        
        # Output from the function and selection
        candidate_time_series(selected_candidate, fox_data) 
        
    })
    
    # Before Map
    output$Before_Map <- renderPlot({
        
        selected_candidate <- as.numeric(input$candidate_selected) # we should move this selection to be a global variable in app.R
        
        # function and data all defined in interest_maps.R
        source(file = "interest_maps.R", local = TRUE) 
        
        # Output from the function and selection
        candidate_before_maps[[selected_candidate]]
    })

    #After map
    output$After_Map <- renderPlot({
        
        selected_candidate <- as.numeric(input$candidate_selected) # default is 1 for Bernie
        
        # function and data all defined in interest_maps.R
        source(file = "interest_maps.R", local = TRUE)
        
        # Output from the function and selection
        candidate_after_maps[[selected_candidate]]
    })
    
    #Interest_by_Viewers
    output$Interest_by_Viewers <- renderPlot({
        
        # function and data all defined in interest_maps.R
        source(file = "tv_views.R", local = TRUE)
        
        # Output from the function and selection
        Interest_by_Viewers
        
    })
    
    #Interest_by_Date
    output$Interest_by_Date <- renderPlot({
        
        # function and data all defined in interest_maps.R
        source(file = "tv_views.R", local = TRUE)
        
        # Output from the function and selection
        Interest_by_Date
        
    })
    
    #Viewers_by_Date
    output$Viewers_by_Date <- renderPlot({
        
        # function and data all defined in interest_maps.R
        source(file = "tv_views.R", local = TRUE)
        
        # Output from the function and selection
        Viewers_by_Date
        
    })
})