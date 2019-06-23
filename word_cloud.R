library(gtrendsR)
library(tidytext)

# Data for related searches from gTrends 
# Move to data to convert to csv somehow?

Bernie_related <- gtrends(c("Bernie Sanders"), time = "2019-04-04 2019-06-08", geo = c("US"))$related_queries
Pete_related <- gtrends(c("Pete Buttigieg"), time = "2019-04-04 2019-06-08", geo = c("US"))$related_queries
Gilli_related <- gtrends(c("Kirsten Gillibrand"), time = "2019-04-04 2019-06-08", geo = c("US"))$related_queries


# Tidytext function
Word_Prep <- function(related_data){
    related_data %>% 
        unnest_tokens(word, value) %>%
        count(word, sort = TRUE)   
}

# Textified
Bernie_related <- Word_Prep(Bernie_related)
Pete_related <- Word_Prep(Pete_related)     
Gilli_related <- Word_Prep(Gilli_related)


# Word Clouds
Bernie_Cloud <- Bernie_related %>%
    filter(!word == "bernie", !word == "sanders") %>% 
    head(20) %>% 
    collect() %>%
    with(ggwordcloud::ggwordcloud(
        word, 
        n,
        min.freq = 1,
        colors = c("#999999", "#E69F00", "#56B4E9","#56B4E9"))+
    labs(title = "\"Bernie Sanders\" related search terms",
         subtitle = paste("(April - June)"),
         caption = paste("Date: Google Trends related search terms"))
) # coral3 is TS color

Pete_Cloud <- Pete_related %>%
    filter(!word == "pete", !word == "buttigieg") %>% 
    head(20) %>% 
    collect() %>%
    with(ggwordcloud::ggwordcloud(
        word, 
        n,
        min.freq = 1,
        colors = c("#999999", "#E69F00", "#56B4E9","#56B4E9"))+
            labs(title = "\"Pete Buttigieg\" related search terms",
                 subtitle = paste("(April - June)"),
                 caption = paste("Date: Google Trends related search terms"))
        )

Gilli_Cloud <- Gilli_related %>%
    filter(!word == "kirsten", !word == "gillibrand") %>% 
    head(20) %>% 
    collect() %>%
    with(ggwordcloud::ggwordcloud(
        word, 
        n,
        min.freq = 1,
        colors = c("#999999", "#E69F00", "#56B4E9","#56B4E9"))+
            labs(title = "\"Kirsten Gillibrand\" related search terms",
                 subtitle = paste("(April - June)"),
                 caption = paste("Date: Google Trends related search terms"))
        ) # green3 is TS color

shiny_word_clouds <- list(Bernie_Cloud, Pete_Cloud, Gilli_Cloud)
