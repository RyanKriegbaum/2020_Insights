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
source(file = "interesting_dates.R", local = TRUE)


# Function to declare a few data types to prevent errors and coersion later
standardized_maps <- function(csv_file){
    standardized_csv <- csv_file %>% 
        as_tibble() %>%
        mutate(date = ymd(date), hits = as.numeric(hits), region = as.character(region))
    return(standardized_csv)
}

### Step 1 
## Load the data (previously constructed in data.R)

# # directly from data.R
# source(file = "data.R", local = TRUE)

### Sanders map data
sanders_before <- read.csv("Data/sanders_before.csv") %>% standardized_maps()
sanders_after <- read.csv("Data/sanders_after.csv") %>% standardized_maps()

# Buttigieg map data
pete_before <- read.csv("Data/pete_before.csv") %>% standardized_maps()
pete_after <- read.csv("Data/pete_after.csv") %>% standardized_maps()

# Gillibrand map data
gilli_before <- read.csv("Data/gilli_before.csv") %>% standardized_maps()
gilli_after <- read.csv("Data/gilli_after.csv") %>% standardized_maps()

# Klobuchar map data
amy_before <- read.csv("Data/amy_before.csv") %>% standardized_maps()
amy_after <- read.csv("Data/amy_after.csv") %>% standardized_maps()

# Castro
castro_before <- read.csv("Data/castro_before.csv") %>% standardized_maps()
castro_after <- read.csv("Data/castro_after.csv") %>% standardized_maps()

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
sanders_map_before <- Make_Map(Map_Prep(sanders_before), "\"Bernie Sanders\" search interest before Fox appearance", bernie_fox_appearance-1, bernie_fox_appearance)
sanders_map_after <- Make_Map(Map_Prep(sanders_after), "\"Bernie Sanders\" search interest after Fox appearance", bernie_fox_appearance, bernie_fox_appearance+1)

# Make the Buttigieg maps
pete_map_before <- Make_Map(Map_Prep(pete_before), "\"Pete Buttigieg\" search interest before Fox appearance", pete_fox_appearance-1, pete_fox_appearance)
pete_map_after <- Make_Map(Map_Prep(pete_after), "\"Pete Buttigieg\" search interest after Fox appearance", pete_fox_appearance, pete_fox_appearance+1)

# Make the Gillibrand maps
gilli_map_before <- Make_Map(Map_Prep(gilli_before), "\"Kirsten Gillibrand\" search interest before Fox appearance", gilli_fox_appearance-1, gilli_fox_appearance)
gilli_map_after <- Make_Map(Map_Prep(gilli_after), "\"Kirsten Gillibrand\" search interest after Fox appearance", gilli_fox_appearance, gilli_fox_appearance+1)

# Make the Amy maps
amy_map_before <- Make_Map(Map_Prep(amy_before), "\"Amy Klobuchar\" search interest before Fox appearance", amy_fox_appearance-1, amy_fox_appearance)
amy_map_after <- Make_Map(Map_Prep(amy_after), "\"Amy Klobuchar\" search interest after Fox appearance", amy_fox_appearance, amy_fox_appearance+1)

# Make the Gillibrand maps
castro_map_before <- Make_Map(Map_Prep(castro_before), "\"Julian Castro\" search interest before Fox appearance", castro_fox_appearance-1, castro_fox_appearance)
castro_map_after <- Make_Map(Map_Prep(castro_after), "\"Julian Castro\" search interest after Fox appearance", castro_fox_appearance, castro_fox_appearance+1)


### For selection within the Shiny App

candidate_before_maps <- list(sanders_map_before, 
                              pete_map_before, 
                              gilli_map_before, 
                              amy_map_before, 
                              castro_map_before)

candidate_after_maps <- list(sanders_map_after, 
                             pete_map_after, 
                             gilli_map_after, 
                             amy_map_after, 
                             castro_map_after)


