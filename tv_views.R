# TV Info
# Adding data for scatterplot
# 
# scatter <- tibble::tribble(
#     ~candidate, ~viewers, ~search.spike,
#     "Bernie Sanders", 2600000, 78,
#     "Pete Buttigieg", 1100000, 16,
#     "Kirsten Gillibrand", 834000, 5,
#     "Amy Klobuchar",  1600000, 3
# )
#glimpse(scatter)
library(dplyr)

# Nielson estimated viewers for each appearance
# Keeping the same order, Bernie, Pete, Kirsten, Amy

source(file = "time_series.R", local = TRUE)

tv_data <- fox_data %>% 
    mutate(viewers = c(2.6, 1.1, .834, 1.6, 1.131))

# For better display
tv_data$keyword <- factor(tv_data$keyword, levels = list_of_candidates)



# viewers_model <- lm(data = original_labels, formula = hits~viewers)
# summary(viewers_model)
# 
# Should we add the LM information somehow, maybe another text overlay?
# Its obviously not a good fit, but should we annotate that?

library(ggplot2)


# Interest score explained by Viewers
Interest_by_Viewers <- ggplot(tv_data, aes(x = viewers, y = hits)) +
    geom_point(show.legend = FALSE, size = 4, aes(color = keyword))+
    theme_minimal() +
    labs(subtitle = "Google Search Interest by Estimated Viewers",
         x = "Viewers (in Millions)", y = "Google Search Interest Score" ) +
    geom_smooth(show.legend = FALSE,
                color = "black",
                fullrange = TRUE,
                method = 'lm', se = FALSE) +
    geom_label(aes(label = candidate),
               vjust = "top", hjust = "inward") +
    scale_color_brewer(palette="Set1")


# Viewers by Date
Viewers_by_Date <- ggplot(tv_data, show.legend = FALSE, aes(x = date, y = viewers )) +
    theme_minimal() +
    geom_smooth(show.legend = FALSE,
                color = "black",
                fullrange = TRUE,
                method = 'lm', se = TRUE) +
    geom_label(aes(label = candidate),
              vjust = "top", hjust = "inward") +
    geom_point(size = 4, show.legend = FALSE, aes(color = keyword)) +
    labs(subtitle = "Estimated Viewers by Date of Appearance",
         x = "Date", y = "Viewers (in Millions)" ) +
    scale_color_brewer(palette="Set1")


# Search interest score by Date
Interest_by_Date <- ggplot(tv_data, show.legend = FALSE, aes(x = date, y = hits )) +
    theme_minimal() +
    geom_smooth(show.legend = FALSE,
                color = "black",
                fullrange = TRUE,
                method = 'lm', se = FALSE) +
    geom_label(aes(label = candidate),
               vjust = "top", hjust = "inward") +
    geom_point(size = 4, show.legend = FALSE, aes(color = keyword)) +
    labs(subtitle = "Google Search Interest by Date of Appearance",
         x = "Date", y = "Google Search Interest Score" ) +
    scale_color_brewer(palette="Set1")

tv_viewer_plots <- c(Interest_by_Viewers, Interest_by_Date, Viewers_by_Date)


