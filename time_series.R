library(dplyr)
library(lubridate)      # for cleaner dates, we can use basic if we need

library(ggplot2)
library(plotly)         # for dynamic graph if I can figure out a better way to show names (geom_text maybe if I can figure it out)
library(ggpmisc)        # again for annotation and cleaner code


### Dates of Interest

# Fox Appearance Dates
bernie_fox_appearance <- ymd("2019-04-15")
pete_fox_appearance <- ymd("2019-05-21")
gilli_fox_appearance <- ymd("2019-06-02")


# #Other interesting dates
# pete_ellen_appearance <- ymd("2019-04-12")
# warren_rejects_fox <- ymd("2019-05-14")

### Loading the Data

# reading the csv created in data.R
candidate_interest <- read.csv("candidate_interest.csv")

# declaring data types
candidate_interest <- candidate_interest %>%
    as_tibble() %>%
    mutate(date = ymd(date), hits = as.numeric(hits))

### Appearances

# Function to find the gTrends "hits" score for any dates of interest
hits_of_interest <- function(data_set, candidate, date_of_interest){
    appearance <- data_set %>% 
        filter(keyword == candidate, date == date_of_interest) %>%
        select(hits) %>% 
        as.numeric()
    return(appearance)
}

# Bernie Sanders appeared on Fox News on April 15, 2019; 
bernie_appearance_hits <- hits_of_interest(candidate_interest, "Bernie Sanders", bernie_fox_appearance)

#Pete Buttigieg appeared on May 21, 2019;
pete_appearance_hits <- hits_of_interest(candidate_interest, "Pete Buttigieg", pete_fox_appearance) 

#Kirsten Gillibrand appeared on June 2, 2019.
gilli_appearance_hits <- hits_of_interest(candidate_interest, "Kirsten Gillibrand", gilli_fox_appearance)

# Create labels for the points 
fox_appearance_labels <- data.frame(
    candidate <- c("Bernie Sanders's Appearance", "Pete Buttigieg's Appearance", "Kirsten Gillibrand's Appearance"),
    date <- c(bernie_fox_appearance, pete_fox_appearance, gilli_fox_appearance),
    hits <- c(bernie_appearance_hits, pete_appearance_hits, gilli_appearance_hits), 
    stored_labels <- c("coral3", "dodgerblue3", "green3")
)

# # Create labels for the points 
# other_interesting_labels <- data.frame(
#     candidate <- c("Pete Buttigieg's Ellen Appearance", "Warren Reject's a Fox Appearance"),
#     date <- c(pete_ellen_appearance, warren_rejects_fox),
#     hits <- c(bernie_appearance_hits, pete_appearance_hits, gilli_appearance_hits), 
#     stored_labels <- c("coral3", "dodgerblue3", "green3")
# )

# Plot the time series
candidate_time_series <- function(selection, labels){
    ggplot(candidate_interest, aes(date, hits, color = keyword)) +
        geom_line() +
        theme_minimal() +
        labs(x = "Date", y = "Google Trends Interest Score", color = "Search Term") +
        geom_point(data = labels,
                   size = 2, 
                   x = date[selection], 
                   y = hits[selection],
                   color = stored_labels[selection], 
                   fill = stored_labels[selection]) +
        geom_text(data = labels, 
                  inherit.aes = FALSE,
                  mapping = aes(x = date[selection], y = hits[selection], label = candidate[selection]),
                  nudge_y = 3)
}
