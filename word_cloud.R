library(tidytext)
library(dplyr)
library(ggwordcloud)
library(stringr)

# Data for related searches from gTrends 
# TODO: Speed up Shiny load times by converting to trimmed csv
source(file = "gtrends_script.R", local = TRUE)
source(file = "interesting_dates.R", local = TRUE)

# related <- list()
# 
# for(candidate in list_of_candidates){
#     related %>% 
# }
# list_of_candidates[1]

Bernie_related <- Master_gTrends(c("Bernie Sanders"))$related_queries
Pete_related <- Master_gTrends(c("Pete Buttigieg"))$related_queries
Gilli_related <- Master_gTrends(c("Kirsten Gillibrand"))$related_queries
Amy_related <- Master_gTrends(c("Amy Klobuchar"))$related_queries
Castro_related <- Master_gTrends(c("Julian Castro"))$related_queries

# Tidytext function to prep the words for the cloud
Word_Prep <- function(related_data){
    related_data %>% 
        unnest_tokens(word, value) %>%
        anti_join(stop_words) %>%
        count(word, sort = TRUE)%>%
        mutate(keyword = max(related_data$keyword))
}


library(ggwordcloud)
# Word Cloud Function
Word_Cloud <- function(candidate_related) {
    # Tidy Textified
    preped <- Word_Prep(candidate_related)
    
    # Creating a vecor of "too close to the keyword" terms
    filter_words <- str_split(tolower(max(preped$keyword)), " ") 
    filter_words <- as.vector(filter_words[[1]])
    
    preped %>% 
        filter(!word %in% filter_words) %>%
        head(25) %>% 
        collect() %>%
        with(ggwordcloud(word, n, min.freq = 1, random.order = FALSE,
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
Amy_Cloud <- Word_Cloud(Amy_related)
Castro_Cloud <- Word_Cloud(Castro_related)


# List of premade clouds for using our Shiny selection
# TODO: make these dynamically load to speed up initial load time
shiny_word_clouds <- list(Bernie_Cloud, Pete_Cloud, Gilli_Cloud, Amy_Cloud, Castro_Cloud)
