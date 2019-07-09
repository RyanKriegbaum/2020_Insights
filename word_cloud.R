library(tidytext)
library(dplyr)
library(ggwordcloud)
library(stringr)

# Data for related searches from gTrends 
# TODO: Speed up Shiny load times by converting to trimmed csv

# Data from data.R
#source(file = "data.R", local = TRUE)

#Data from CSVs
standardized_related <- function(csv_file){
    standardized_csv <- csv_file %>% 
        as_tibble() %>%
        mutate(subject = as.character(subject), 
               related_queries = as.character(related_queries),
               value = as.character(value),
               geo = as.character(geo),
               keyword = as.character(keyword))
    return(standardized_csv)
}

sanders_related <- read.csv(file = "Data/sanders_related.csv") %>% standardized_related()
pete_related <- read.csv(file = "Data/pete_related.csv") %>% standardized_related()
gilli_related <- read.csv(file = "Data/gilli_related.csv") %>% standardized_related()
amy_related <- read.csv(file = "Data/amy_related.csv") %>% standardized_related()
castro_related <- read.csv(file = "Data/castro_related.csv") %>% standardized_related()

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
sanders_cloud <- Word_Cloud(sanders_related)
pete_cloud <- Word_Cloud(pete_related)
gilli_cloud <- Word_Cloud(gilli_related)
amy_cloud <- Word_Cloud(amy_related)
castro_cloud <- Word_Cloud(castro_related)


# List of premade clouds for using our Shiny selection
# TODO: make these dynamically load to speed up initial load time
shiny_word_clouds <- list(sanders_cloud, pete_cloud, gilli_cloud, amy_cloud, castro_cloud)
