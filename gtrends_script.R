# Tired of re-writing this.

### Google Data for all candidates
library(gtrendsR)
Master_gTrends <- function(list_of_candidates, between = "2019-04-04 2019-06-21"){
    gtrends(list_of_candidates,
            time = between,
            geo = c("US"))
}