library(dplyr)
library(lubridate)      # for cleaner dates, we can use basic if we need

library(ggplot2)
library(plotly)         # for dynamic graph if I can figure out a better way to show names (geom_text maybe if I can figure it out)
library(ggpmisc)        # again for annotation and cleaner code


### Dates of Interest
source(file = "interesting_dates.R", local = TRUE)

### Loading the Data

# # directly from data.R
# source(file = "data.R", local = TRUE)
# Candidate_Interest <- Master_Interest

# reading the csv created in data.R
Candidate_Interest <- read.csv("Data/Candidate_Interest.csv") %>%
    as_tibble() %>%
    mutate(date = ymd(date), hits = as.numeric(hits))

# For better display
Candidate_Interest$keyword <- factor(Candidate_Interest$keyword, levels = list_of_candidates)


# Function to find the gTrends "hits" score for any dates of interest
hits_of_interest <- function(data_set, candidate, date_of_interest){
    appearance <- data_set %>% 
        filter(keyword == candidate, date == date_of_interest) %>%
        select(hits) %>% 
        as.numeric()
    return(appearance)
}

hits_list_maker <- function(trends, candidates, dates) {
    hits <- c()
    i <- 1
    for(i in seq(1:length(candidates))){
        hits <- hits %>% 
            append( hits_of_interest(trends, candidates[i],dates[i]) )}
    return(hits)
}

fox_hits <- hits_list_maker(Candidate_Interest, list_of_candidates, fox_appearances)

# Plot labels
complete_labels <- c("Sanders' Appearance", 
                     "Buttigieg's Appearance",
                     "Gillibrand's Appearance", 
                     "Klobuchar's Appearance",
                     "Castro's Appearance")

# Label data_frame
fox_data <- data.frame(
    keyword <- list_of_candidates,  
    date <- fox_appearances,  
    hits <- fox_hits,
    candidate <- complete_labels)


# Plot the time series
candidate_time_series <- function(selection, labels_data){
    ggplot(Candidate_Interest, aes(date, hits, color = keyword)) +
        theme_minimal() +
        geom_line() +
        geom_point(data = labels_data,
                   inherit.aes = TRUE,
                   show.legend = FALSE,
                   size = 3,
                   aes(x = date[selection], 
                   y = hits[selection],
                   color = keyword[selection])) +
        geom_text(data = labels_data, 
                  inherit.aes = FALSE,
                  mapping = aes(x = date[selection], y = hits[selection], label = candidate[selection],
                                family = "sans", fontface = "plain"),
                  nudge_y = 3) +
        labs(x = "Date", y = "Google Trends Interest Score", color = "Search Term") +
        scale_color_brewer(palette="Set1")
        
}

candidate_time_series(1,fox_data)
