## Fox Appearance Dates
# Bernie Sanders appeared on Fox News on April 15, 2019; 
# Pete Buttigieg appeared on May 21, 2019;
# Kirsten Gillibrand appeared on June 2, 2019.
# Amy appeared May 8, 2019
# Castro Appeared June 13

list_of_candidates <- c("Bernie Sanders", 
                        "Pete Buttigieg", 
                        "Kirsten Gillibrand", 
                        "Amy Klobuchar", 
                        "Julian Castro")



library(lubridate)

bernie_fox_appearance <- ymd("2019-04-15")
pete_fox_appearance <- ymd("2019-05-21")
gilli_fox_appearance <- ymd("2019-06-02")
amy_fox_appearance <- ymd("2019-05-08")
castro_fox_appearance <-ymd("2019-06-13")

fox_appearances <- c(bernie_fox_appearance, 
                     pete_fox_appearance, 
                     gilli_fox_appearance, 
                     amy_fox_appearance, 
                     castro_fox_appearance)

##Other interesting dates
#pete_ellen_appearance <- ymd("2019-04-12")
#warren_rejects_fox <- ymd("2019-05-14")
#harris_rejects_fox <- ymd("2019-05-15")