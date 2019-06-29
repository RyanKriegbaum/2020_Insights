#### This should only be run for initial setup, 
#### Should not need this file for Shiny

# Google Trends
library(gtrendsR)

# Data manipulation
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)


### Master Data Frame ###
# Create a master Data Frame, to limit the number of pulls from google trends
# gTrends pulls as a large list of tables, so we should clean and trim for Shiny

Master_gTrends <- gtrends(c("Bernie Sanders", "Pete Buttigieg", "Kirsten Gillibrand"),
                            time = "2019-04-04 2019-06-08",
                            geo = c("US"))

# Other_gTrends <- gtrends(keyword = c("Pete Buttigieg", "Elizabeth Warren"), 
#                           time = "2019-04-04 2019-06-08",
#                           geo = c("US"))
# 
# other_interest <- Other_gTrends$interest_over_time %>% 
#     as_tibble() %>%
#     mutate(date = ymd(date), hits = as.numeric(hits))

### For the Time Series ###

Master_interest <- Master_gTrends$interest_over_time %>%
    as_tibble() %>%
    mutate(date = ymd(date), hits = as.numeric(hits))

# If we want a csv
write.csv(Master_interest, file = "candidate_interest.csv")



### For the Maps ###

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


### CSV Creation

### Sanders map data
Sanders_before <- Regional_Interest("Bernie Sanders", bernie_fox_appearance-1, bernie_fox_appearance)
write.csv(Sanders_before, file = "sanders_before.csv")

Sanders_after <- Regional_Interest("Bernie Sanders", bernie_fox_appearance, bernie_fox_appearance+1)
write.csv(Sanders_after, file = "sanders_after.csv")

# Buttigieg map data
Pete_before <- Regional_Interest("Pete Buttigieg", pete_fox_appearance-1, pete_fox_appearance)
write.csv(Pete_before, file = "pete_before.csv")

Pete_after <- Regional_Interest("Pete Buttigieg", pete_fox_appearance, pete_fox_appearance+1)
write.csv(Pete_after, file = "pete_after.csv")


#Gillibrand map data
Gilli_before <- Regional_Interest("Kirsten Gillibrand", gilli_fox_appearance-1, gilli_fox_appearance)
write.csv(Gilli_before, file = "gilli_before.csv")

Gilli_after <- Regional_Interest("Kirsten Gillibrand", gilli_fox_appearance, gilli_fox_appearance+1)
write.csv(Gilli_after, file = "gilli_after.csv")

