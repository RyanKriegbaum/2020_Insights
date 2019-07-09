#### This should only be run for initial setup, 
#### Should not need this file for Shiny

# Data manipulation
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)



### Master Data Frame ###
# Create a master Data Frame, to limit the number of pulls from google trends
# gTrends pulls as a large list of tables, so we should clean and trim for Shiny
source(file = "interesting_dates.R", local = TRUE)

source(file = "gtrends_script.R", local = TRUE)
Master_DF <- Master_gTrends(list_of_candidates)



### For the Time Series ###
Master_Interest <- Master_DF$interest_over_time %>%
    as_tibble() %>%
    mutate(date = ymd(date), hits = as.numeric(hits))

# If we want a csv
write.csv(Master_Interest, file = "Data/Candidate_Interest.csv", row.names = FALSE)

##########################
###### For the Maps ######
##########################

# master_table <- tibble::tribble(
#     candidate, date, viewers, hits,
#     "Bernie Sanders", ymd("2019-04-15"), 2600000, 78,
#     "Pete Buttigieg", ymd("2019-05-21"), 1100000, 16,
#     "Kirsten Gillibrand", ymd("2019-06-02"), 834000, 5,
#     "Amy Klobuchar",  ymd("2019-05-08"), 1600000, 3,
#     "Julian Castro", ymd("2019-06-13"), 1131000, 
# )

# To get the regional interest information for maping 
Regional_Interest <- function(candidate, date1, date2) {
    Trend <- gtrends(candidate, 
                     time = paste(date1, date2, sep = " "),
                     geo = c("US"))$interest_by_region
    Trend <- Trend %>%
        mutate(hits = as.numeric(hits),
               hits = replace_na(hits, 0),
               region = str_to_lower(location),
               date = date2)
    return(Trend)
}



before_maps <- function(candidate, appearance){
    Regional_Interest(candidate, appearance-1, appearance)
}

after_maps <- function(candidate, appearance){
    Regional_Interest(candidate, appearance, appearance+1)
}

### CSV Creation

#Sanders map data
sanders_before <- Regional_Interest("Bernie Sanders", bernie_fox_appearance-1, bernie_fox_appearance)
#write.csv(sanders_before, file = "sanders_before.csv", row.names = FALSE)

sanders_after <- Regional_Interest("Bernie Sanders", bernie_fox_appearance, bernie_fox_appearance+1)
#write.csv(sanders_after, file = "sanders_after.csv", row.names = FALSE)

#Buttigieg map data
pete_before <- Regional_Interest("Pete Buttigieg", pete_fox_appearance-1, pete_fox_appearance)
#write.csv(pete_before, file = "pete_before.csv", row.names = FALSE)

pete_after <- Regional_Interest("Pete Buttigieg", pete_fox_appearance, pete_fox_appearance+1)
#write.csv(pete_after, file = "pete_after.csv", row.names = FALSE)

#Gillibrand map data
gilli_before <- Regional_Interest("Kirsten Gillibrand", gilli_fox_appearance-1, gilli_fox_appearance)
#write.csv(gilli_before, file = "gilli_before.csv", row.names = FALSE)

gilli_after <- Regional_Interest("Kirsten Gillibrand", gilli_fox_appearance, gilli_fox_appearance+1)
#write.csv(gilli_after, file = "gilli_after.csv", row.names = FALSE)

#Amy map data
amy_before <- Regional_Interest("Amy Klobuchar", amy_fox_appearance-1, amy_fox_appearance)
#write.csv(amy_before, file = "amy_before.csv", row.names = FALSE)

amy_after <- Regional_Interest("Amy Klobuchar", amy_fox_appearance, amy_fox_appearance+1)
#write.csv(amy_after, file = "amy_after.csv", row.names = FALSE)

#Castro map data
castro_before <- before_maps(list_of_candidates[5], fox_appearances[5])
#write.csv(castro_before, file = "castro_before.csv", row.names = FALSE)

castro_after <- after_maps(list_of_candidates[5], fox_appearances[5])
#write.csv(castro_after, file = "castro_after.csv", row.names = FALSE)


### Related Searches
sanders_related <- Master_DF$related_queries %>% 
    filter(keyword == list_of_candidates[1])

pete_related <- Master_DF$related_queries %>% 
    filter(keyword == list_of_candidates[2])

gilli_related <- Master_DF$related_queries %>% 
    filter(keyword == list_of_candidates[3])

amy_related <- Master_DF$related_queries %>% 
    filter(keyword == list_of_candidates[4])

castro_related <- Master_DF$related_queries %>% 
    filter(keyword == list_of_candidates[5])

sanders_test <- Master_gTrends(list_of_candidates[1])$related_queries


write.csv(sanders_related, file = "Data/sanders_related.csv", row.names = FALSE)
write.csv(pete_related, file = "Data/pete_related.csv", row.names = FALSE)
write.csv(gilli_related, file = "Data/gilli_related.csv", row.names = FALSE)
write.csv(amy_related, file = "Data/amy_related.csv", row.names = FALSE)
write.csv(castro_related, file = "Data/castro_related.csv", row.names = FALSE)
