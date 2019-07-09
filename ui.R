library(shiny)
library(shinydashboard)

# Header for the dashboard / page
insights_header <- dashboardHeader(title = "Insights on the Road to 2020",
                                   titleWidth = 400)

# Main body for dashboard / page
insights_body <- dashboardBody(
    h4("How does a Fox News town hall appearances affect a candidate's Google search interest?"),
    fluidRow(column(12, align = "left",
                    selectInput("candidate_selected", 
                                label = "Select a Candidate", 
                                choices = c("Bernie Sanders" = 1, 
                                            "Pete Buttigieg"  = 2,
                                            "Kirsten Gillibrand" = 3,
                                            "Amy Klobuchar" = 4,
                                            "Julian Castro" = 5),
                                selected = 1))
    ),
    fluidRow(
        tabBox(
            width = 12,
            # Tab for Search Interest over Time
            # time_series.R or stream.R
            tabPanel("Interest Over Time", 
                     "Search Interest over time, with selected candidates appearance date highlighted.",
                     hr(),
                     plotOutput("TS")
            ),
            
            # Tab for interest by regions 
            # interest_maps.R
            tabPanel("Interest by Region", 
                     "Regional Search Interest Before and After Appearance.",
                     hr(),
                     plotOutput("Before_Map"),
                     hr(),
                     plotOutput("After_Map")
            ),
            
            # Tab for related Terms
            # word_cloud.R or spark.R
            tabPanel("Related Terms",
                     "Word Cloud made up of related Google search terms for:",
                     hr(),
                     plotOutput("wordcloud")
            ),
            
            # Viewers over time
            # tv_views.R
            tabPanel("Viewers Over Time", 
                     "Viewership over time, and how it affected Interest.",
                     hr(),
                     plotOutput("Viewers_by_Date"),
                     hr(),
                     plotOutput("Interest_by_Date"),
                     hr(),
                     plotOutput("Interest_by_Viewers")
             )
                     
        ) # Closes tab box
    ) # Closes main body fluid row
) # Closes the body


# One call to each component above
# Disabling the sidebar which is a default of ShinyDashboard 
ui <- dashboardPage(insights_header, 
                    dashboardSidebar(disable = TRUE),
                    insights_body)