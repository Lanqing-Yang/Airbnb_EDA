library(shiny)
library(shinydashboard)
library(leaflet)
library(readr)
library(tidyverse)
library(tidytext)
library(tibble)
library(dplyr)
library(ggplot2)
library(DT)
library(wordcloud)
library(wordcloud2)
library(RColorBrewer)
#neighbourhood
listings.df <- readr::read_csv("./data/listing.df.csv")
listings.df <- as.data.frame(listings.df)
#map.df
map.df <- listings.df %>% filter(room_type != "Hotel room")
room_type <- c("Entire home/apt", "Private room", "Shared room")
room_color <- colorFactor(c("#e6194B", "#ffe119","#42d4f4"),
                           domain = room_type)
#wordcloud
word_cloud <- readr::read_csv("./data/wordcloud_df.csv")
word_cloud <- as.data.frame(word_cloud)
#subway
subway.df <- readr::read_csv("./data/subway_df.csv")
#seasonality
season.df <- readr::read_csv("./data/season.csv")
cal.df <- readr::read_csv("./data/calendar.df.csv")
season.df <- as.data.frame(season.df)
cal.df <- as.data.frame(cal.df)