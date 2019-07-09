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
standardised <- function(csv_file){
    standardized_csv <- csv_file %>% 
        as_tibble() %>%
        mutate(date = ymd(date), hits = as.numeric(hits), region = as.character(region))
    return(standardized_csv)
}

# Step 1 
# Load the data (previously constructed in data.R)
### Sanders map data
sanders_before <- read.csv("Data/Sanders_before.csv") %>% standardised()
sanders_after <- read.csv("Data/Sanders_after.csv") %>% standardised()

# Buttigieg map data
pete_before <- read.csv("Data/Pete_before.csv") %>% standardised()
pete_after <- read.csv("Data/Pete_after.csv") %>% standardised()

# Gillibrand map data
gilli_before <- read.csv("Data/Gilli_before.csv") %>% standardised()
gilli_after <- read.csv("Data/Gilli_after.csv") %>% standardised()

# Klobuchar map data
amy_before <- read.csv("Data/Amy_before.csv") %>% standardised()
amy_after <- read.csv("Data/Amy_after.csv") %>% standardised()

# Castro
castro_before <- read.csv("Data/Castro_before.csv") %>% standardised()
castro_after <- read.csv("Data/Castro_after.csv") %>% standardised()

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


