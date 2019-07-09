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

source(file = "trends_script.R", local = TRUE)
Master_Interest <- Master_gTrends(list_of_candidates)



### For the Time Series ###
Master_Interest <- Master_Interest$interest_over_time %>%
    as_tibble() %>%
    mutate(date = ymd(date), hits = as.numeric(hits))

# If we want a csv
write.csv(Master_Interest, file = "Candidate_Interest.csv")

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
Sanders_before <- Regional_Interest("Bernie Sanders", bernie_fox_appearance-1, bernie_fox_appearance)
write.csv(Sanders_before, file = "Sanders_before.csv")

Sanders_after <- Regional_Interest("Bernie Sanders", bernie_fox_appearance, bernie_fox_appearance+1)
write.csv(Sanders_after, file = "Sanders_after.csv")

#Buttigieg map data
Pete_before <- Regional_Interest("Pete Buttigieg", pete_fox_appearance-1, pete_fox_appearance)
write.csv(Pete_before, file = "Pete_before.csv")

Pete_after <- Regional_Interest("Pete Buttigieg", pete_fox_appearance, pete_fox_appearance+1)
write.csv(Pete_after, file = "Pete_after.csv")

#Gillibrand map data
Gilli_before <- Regional_Interest("Kirsten Gillibrand", gilli_fox_appearance-1, gilli_fox_appearance)
write.csv(Gilli_before, file = "Gilli_before.csv")

Gilli_after <- Regional_Interest("Kirsten Gillibrand", gilli_fox_appearance, gilli_fox_appearance+1)
write.csv(Gilli_after, file = "Gilli_after.csv")

#Amy map data
Amy_before <- Regional_Interest("Amy Klobuchar", amy_fox_appearance-1, amy_fox_appearance)
write.csv(Amy_before, file = "Amy_before.csv")

Amy_after <- Regional_Interest("Amy Klobuchar", amy_fox_appearance, amy_fox_appearance+1)
write.csv(Amy_after, file = "Amy_after.csv")

#Castro map data
Castro_before <- before_maps(list_of_candidates[5], fox_appearances[5])
write.csv(Castro_before, file = "Castro_before.csv")

Castro_after <- after_maps(list_of_candidates[5], fox_appearances[5])
write.csv(Castro_after, file = "Castro_after.csv")
