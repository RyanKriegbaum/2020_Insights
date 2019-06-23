# UI - currently only fluid page, no real need for dashboard - yet

library(shiny)
library(shinydashboard)



ui <- fluidPage(
    titlePanel("The road to 2020"),
    tags$div(class="header", checked=NA,
             tags$p("Do Fox News town hall appearances affect Google search interest for 2020 candidates?")),
    hr(),
    
    sidebarLayout(
        sidebarPanel(
            selectInput("candidate_selected",
                        label = "Select a Candidate",
                        choices = c("Bernie Sanders" = 1,
                                    "Pete Buttigieg"  = 2,
                                    "Kirsten Gillibrand" = 3),
                        selected = 1)
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Related terms", 
                         fluidRow(
                             verbatimTextOutput("Word Cloud stuff"),
                             plotOutput("wordcloud")
                             )
                         ),
                tabPanel("Interest by region", 
                             plotOutput("Before_Map"),
                             plotOutput("After_Map")),
                tabPanel("Interest over time", plotOutput("TS"))
            )
        )
    )
)