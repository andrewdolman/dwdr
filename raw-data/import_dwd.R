# process raw DWD data

# Station information for daily solar

ST_Tageswerte_Beschreibung_Stationen <- read.csv("raw-data/ST_Tageswerte_Beschreibung_Stationen.csv")
use_data(ST_Tageswerte_Beschreibung_Stationen)


# Nearest station to Arendsee

# Arendsee 52.891348, 11.470599

arendsee_lat_lon <- c(lat = 52.891348, lon = 11.470599)

library(dplyr)

ST_Tageswerte_Beschreibung_Stationen %>% 
  mutate(Distance_to_Arendsee = (((geoBreite - arendsee_lat_lon["lat"]) * (geoLaenge - arendsee_lat_lon["lon"])))^2,
         Rank_dist = rank(Distance_to_Arendsee)) %>% 
  filter(Rank_dist <= 5)
