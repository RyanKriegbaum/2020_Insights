# UX

library(shiny)
library(shinydashboard)


# I think I like you're style a bit better, but I think we might want tabs up top eventually.
# This is osmething simple for testing the tabs etc

# This is tabs up top
ui <- fluidPage(

    titlePanel("Top Tabs - 2020 Insights"),

    sidebarLayout(

        sidebarPanel(
            box(selectInput("candidate_selected",
                            label = "Select a Candidate",
                            choices = c("Bernie Sanders" = 1,
                                        "Pete Buttigieg"  = 2,
                                        "Kirsten Gillibrand" = 3),
                            selected = 1)
            )
        ),

        mainPanel(
            tabsetPanel(
                tabPanel("Time Series", plotOutput("TS"))
            )
        )
    )
)