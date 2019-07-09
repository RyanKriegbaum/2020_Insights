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
            # Tab for related Terms
            # word_cloud.R or spark.R
            tabPanel("Related Terms",
                     "Word Cloud made up of related Google search terms for:", 
                     plotOutput("wordcloud")
            ),
            # Tab for interest by regions 
            # interest_maps.R
            tabPanel("Interest by Region", 
                     "Regional Search Interest Before and After Appearance:", 
                     plotOutput("Before_Map"),
                     plotOutput("After_Map")
            ),
            # Tab for Search Interest over Time
            # time_series.R or stream.R
            tabPanel("Interest Over Time", "Search Interest OverTime, with selected candidates appearance date highlighted.",
                     plotOutput("TS"))
        )
    )
)


# One call to each component above
# Disabling the sidebar which is a default of ShinyDashboard 
ui <- dashboardPage(insights_header, 
                    dashboardSidebar(disable = TRUE),
                    insights_body)