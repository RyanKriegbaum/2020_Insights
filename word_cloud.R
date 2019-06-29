library(gtrendsR)
library(tidytext)
library(dplyr)
library(ggwordcloud)

# Data for related searches from gTrends 
# TODO: Speed up Shiny load times by converting to trimmed csv

Bernie_related <- gtrends(c("Bernie Sanders"), time = "2019-04-04 2019-06-08", geo = c("US"))$related_queries
Pete_related <- gtrends(c("Pete Buttigieg"), time = "2019-04-04 2019-06-08", geo = c("US"))$related_queries
Gilli_related <- gtrends(c("Kirsten Gillibrand"), time = "2019-04-04 2019-06-08", geo = c("US"))$related_queries


# Tidytext function to prep the words for the cloud
Word_Prep <- function(related_data){
    related_data %>% 
        unnest_tokens(word, value) %>%
        anti_join(stop_words) %>%
        count(word, sort = TRUE)%>%
        mutate(keyword = max(related_data$keyword))
}

# Word Cloud Function
Word_Cloud <- function(candidate_related) {
    # Tidy Textified
    preped <- Word_Prep(candidate_related)
    
    # Creating a vecor of "too close to the keyword" terms
    filter_words <- str_split(tolower(max(preped$keyword)), " ") 
    filter_words <- as.vector(filter_words[[1]])
    
    preped %>% 
        filter(!word %in% filter_words) %>% 
        collect() %>%
        with(ggwordcloud(word, n, min.freq = 1,
                         colors = c("#999999", "#E69F00", "#56B4E9","#56B4E9")
                         ) +
                 labs(title = paste0("\"",keyword, "\""),
                 subtitle = "(April - June)"),
                 caption = "Date: Google Trends related search terms")
}


# Word Clouds
Bernie_Cloud <- Word_Cloud(Bernie_related)
Pete_Cloud <- Word_Cloud(Pete_related)
Gilli_Cloud <- Word_Cloud(Gilli_related)

# List of premade clouds for using our Shiny selection
# TODO: make these dynamically load to speed up initial load time
shiny_word_clouds <- list(Bernie_Cloud, Pete_Cloud, Gilli_Cloud)
