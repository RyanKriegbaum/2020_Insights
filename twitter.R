#twitter


############ Notes:############
## Hey Al, you have a few other key's in some of your code (access keys and tokens),
## I don't really understand those very well, would you like to create the Twitter APP and set this all up?
## Also, I should need to authorize you the first time you try to access this from a new computer, 
## if not, I have a security flaw!!! 
## - Ryan

### Twitter Setup, and Key Creation ###

# app name from Twitter API setup
appname <- "2020insights"

# API key
key <- "kVU104ByO5Ct4TiMZceSfa8Ix"

#API secret key
secret <- "wVvN72UTJmIMhQPI90d6mu06caQSCa68fCol5E9t3qeq9xU2Ui" 


## loading the twitter token into the R enviornment 
## (note I am on Linux, so this will only work for other Linux Distro's or Mac, Windows might need changes)

# create token named "twitter_token"
twitter_token <- rtweet::create_token(app = appname,
                                      consumer_key = key,
                                      consumer_secret = secret)


## path of home directory 
home_directory <- path.expand("~")

## combine with name for token
file_name <- file.path(home_directory,
                       "twitter_token.rds")
## save token to home directory
saveRDS(twitter_token, file = file_name)

## assuming you followed the procodures to create "file_name"
## from the previous code chunk, then the code below should
## create and save your environment variable.
cat(paste0("TWITTER_PAT=", file_name),
    file = file.path(home_directory, ".Renviron"),
    append = TRUE)


### Testing rtweet and API ###

Gillibrand <- rtweet::search_tweets(
    "#GillibrandTownHall", include_rts = TRUE
)

Gillibrand <- rtweet::search_tweets(
    "Gillibrand", include_rts = FALSE
)

Buttigieg_NBC <- rtweet::search_tweets(
    "#PetePlaysHardball", include_rts = TRUE
)


# these are no where near as many as I see on Twitter - need to check in with Al on whats wrong