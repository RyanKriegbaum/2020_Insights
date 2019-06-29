library(tidyr)
library(dplyr)
library(stringr)
library(ggplot2)
library(lubridate)
library(maps)

# build the US map
statesMap = ggplot2::map_data("state")

### Dates of Interest

# Fox Appearance Dates
bernie_fox_appearance <- ymd("2019-04-15")
pete_fox_appearance <- ymd("2019-05-21")
gilli_fox_appearance <- ymd("2019-06-02")

# Function to declare a few data types to prevent errors and coersion later
standardised <- function(csv_file){
    standardized_csv <- csv_file %>% 
        as_tibble() %>%
        mutate(date = ymd(date), hits = as.numeric(hits), region = as.character(region))
    return(standardized_csv)
}

# Step 1 
# Load the data (previously constructed in data.R)
### Sanders map data
Sanders_before <- read.csv("sanders_before.csv") %>% standardised()
Sanders_after <- read.csv("sanders_after.csv") %>% standardised()

# Buttigieg map data
Pete_before <- read.csv("pete_before.csv") %>% standardised()
Pete_after <- read.csv("pete_after.csv") %>% standardised()

# Gillibrand map data
Gilli_before <- read.csv("gilli_before.csv") %>% standardised()
Gilli_after <- read.csv("gilli_after.csv") %>% standardised()


# For joining the data on geographic data
Map_Prep <- function(candidate_data){
    geo_data <- merge(statesMap, candidate_data, by = "region")     #merge the ggplot created map
    geo_data <- candidate_data %>%                                  #join the data on the region
        left_join(x = ., y = statesMap, by = "region")
    return(geo_data)
}

# Helper Function for displaying the dates in the subtitles
display_date <- function(date){
    return(format(date, format = "%B %d"))
}

# Map making function
# Requires several inputs 
# map_info is fed from Map_Prep
# Map title is user written string
# date1 and date2 are the date bookeneds "From date1 to date2"
Make_Map <- function(map_info, map_title, date1, date2) {
    
    new_map <- ggplot(map_info, aes(x = long, y = lat)) +
        theme_void() +
        geom_polygon(aes(group = group,
                         fill = hits)) +
        labs(title = map_title,
             subtitle = paste("(", paste(display_date(date1), display_date(date2), sep = " - "), ")", sep = ""),
             caption = paste("Data: Google Trends search interest for \"", map_info$keyword[1], "\"", sep = ""),
             color = "Interest Score")+
        coord_fixed(1.3) +
        scale_fill_gradient(low = "#ffffff", high = "#0072b2",
                            space = "Lab", na.value = "black", guide = "colourbar",
                            aesthetics = "fill", position = "left", limits = c(0,100))
    
    return(new_map)
}


# Make the Sanders maps
Sanders_map_before <- Make_Map(Map_Prep(Sanders_before), "\"Bernie Sanders\" search interest before Fox appearance", bernie_fox_appearance-1, bernie_fox_appearance)
Sanders_map_after <- Make_Map(Map_Prep(Sanders_after), "\"Bernie Sanders\" search interest after Fox appearance", bernie_fox_appearance, bernie_fox_appearance+1)

# Make the Buttigieg maps
Pete_map_before <- Make_Map(Map_Prep(Pete_before), "\"Pete Buttigieg\" search interest before Fox appearance", pete_fox_appearance-1, pete_fox_appearance)
Pete_map_after <- Make_Map(Map_Prep(Pete_after), "\"Pete Buttigieg\" search interest after Fox appearance", pete_fox_appearance, pete_fox_appearance+1)

# Make the Gillibrand maps
Gilli_map_before <- Make_Map(Map_Prep(Gilli_before), "\"Kirsten Gillibrand\" search interest before Fox appearance", gilli_fox_appearance-1, gilli_fox_appearance)
Gilli_map_after <- Make_Map(Map_Prep(Gilli_after), "\"Kirsten Gillibrand\" search interest after Fox appearance", gilli_fox_appearance, gilli_fox_appearance+1)

# For selection within the Shiny App
candidate_before_maps <- list(Sanders_map_before, Pete_map_before, Gilli_map_before)
candidate_after_maps <- list(Sanders_map_after, Pete_map_after, Gilli_map_after)


# ### For specific hit differences - would be nice to be able to click on a state and see these
# ### in a plotly environment
# 
# hitfinder <- function(dataset, state){
#     dataset %>% 
#     filter(region == state) %>% 
#     select(hits)
# }
# 
# # These can be made a intereactive based on selections in Shiny if we have time
# # Cadidate selection based on candidate selected
# # States as new selection - can I do this based on plotly clicks?
# 
# change <- function(before, after, state){
#     hitfinder(after, state)-hitfinder(before, state) 
# }
# 
# 
# # Test case
# bern_change <- change(Sanders_before, Sanders_after, "oregon")
# bern_change
