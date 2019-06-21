### ALY 6110
### Practice with Spark Assignment
### Ryan Kriegbaum
### 
### Word Cloud Version 
### Flights & Zillow Versions moved to drafts

#######################
# gTrends for Aquiring the Data
library(gtrendsR)

# Need more time to figure out how to load gtrends directly into spark,
# for now, the file is saved locally, then I coerce it into a .txt file
# to be loaded back in for examining frequency

# Related Queries for "Bernie Sanders"
Local_Bernie <- gtrends(c("Bernie Sanders"), time = "2019-04-04 2019-06-08", geo = c("US"))$related_queries


# Pulling just the text from the related searches as a value to be written to the text file
bernie_related <- Local_Bernie %>% 
    select(value) %>% 
    as.character()

# Writing the .txt file
fileConn<-file("bernie_related.txt")
writeLines(bernie_related, fileConn)
close(fileConn)

# Related Queries for "Pete B uttigieg"
Local_Pete <- gtrends(c("Pete Buttigieg"), time = "2019-04-04 2019-06-08", geo = c("US"))$related_queries

# Pulling just the text from the related searches as a value to be written to the text file
pete_related <- Local_Pete %>% 
    select(value) %>% 
    as.character()

# Writing the .txt file
fileConn<-file("pete_related.txt")
writeLines(pete_related, fileConn)
close(fileConn)

#### SPARK ###
library(sparklyr)
library(dplyr)

# I am using spark_home to reference the spark installation we did for the Scala / spark-shell
# I chose to install spark in /opt/spark
sc <- spark_connect(master = "local", spark_home = "/opt/spark")


# Loading the texts into Spark
Spark_Bernie <- spark_read_text(sc, "bernie_text", "bernie_related.txt", overwrite = TRUE)
Spark_Pete <- spark_read_text(sc, "pete_text", "pete_related.txt", overwrite = TRUE)


### Here is a complete run through for the processing for Bernie

bernie_words <- Spark_Bernie %>%                                            # Selecting candidate
    mutate(regarding = "bernie") %>%                                        # adding a vector for later
    filter(nchar(line) > 0) %>%                                             # filtering out empty segments
    mutate(line = regexp_replace(line, "[_\"\'():;,.!?\\-]", " ")) %>%      # regular expression character replacement
    ft_tokenizer(input_col = "line",
                 output_col = "word_list") %>%                              # tokenization
    ft_stop_words_remover(input_col = "word_list",
                          output_col = "wo_stop_words") %>%                 # stop word removal       
    mutate(word = explode(wo_stop_words)) %>%                               # Spark NLP explode
    select(word, regarding) %>%                                             
    filter(nchar(word) > 2) %>%
    compute("bernie_words")                                                    # Spark NLP compute

# To see what we can see (examine the word list)
glimpse(bernie_words)

# Grouping by unique words, tallying the number of occurrences and sorting from highest to lowest
bernie_word_count <- bernie_words %>%
    filter(!word == "bernie", !word == "sanders") %>% 
    group_by(word) %>%
    tally() %>%
    arrange(desc(n)) 

bernie_word_count


# And the word count for Pete

pete_words <- Spark_Pete %>%                                                # Selecting candidate
    mutate(regarding = "pete") %>%                                          # adding a vector for later
    filter(nchar(line) > 0) %>%                                             # filtering out empty segments
    mutate(line = regexp_replace(line, "[_\"\'():;,.!?\\-]", " ")) %>%      # regular expression character replacement
    ft_tokenizer(input_col = "line",
                 output_col = "word_list") %>%                              # tokenization
    ft_stop_words_remover(input_col = "word_list",
                          output_col = "wo_stop_words") %>%                 # stop word removal       
    mutate(word = explode(wo_stop_words)) %>%                               # Spark NLP explode
    select(word, regarding) %>%                                             
    filter(nchar(word) > 2) %>%
    compute("pete_words")                                                    # Spark NLP compute

# To see what we can see (examine the word list)
glimpse(pete_words)

# Grouping by unique words, tallying the number of occurrences and sorting from highest to lowest
pete_word_count <- pete_words %>%
    filter(!word == "pete", !word == "buttigieg") %>% 
    group_by(word) %>%
    tally() %>%
    arrange(desc(n)) 

pete_word_count


# For display
library(ggwordcloud)
Bernie_Cloud <- bernie_word_count %>%
    head(20) %>% 
    collect() %>%
    with(ggwordcloud::ggwordcloud(
        word, 
        n,
        min.freq = 1,
        colors = c("#999999", "#E69F00", "#56B4E9","#56B4E9")))

Pete_Cloud <- pete_word_count %>%
    head(20) %>% 
    collect() %>%
    with(ggwordcloud::ggwordcloud(
        word, 
        n,
        min.freq = 1,
        colors = c("#999999", "#E69F00", "#56B4E9","#56B4E9")))



Bernie_Cloud

Pete_Cloud

Unique_Words <- bernie_word_count %>%
    dplyr::anti_join(pete_word_count, by = "word") %>%
    arrange(desc(n)) %>%
    compute("unique_words")

Unique_Words

Unique_Cloud <- Unique_Words %>%
    collect() %>%
    with(ggwordcloud::ggwordcloud(
        word, 
        n,
        min.freq = 1,
        colors = c("#999999", "#E69F00", "#56B4E9","#56B4E9")))

Unique_Cloud

Shared_Words <- bernie_word_count %>%
    dplyr::inner_join(pete_word_count, by = "word") %>%
    arrange(desc(n)) %>%
    compute("shared_words")

words_in_both
