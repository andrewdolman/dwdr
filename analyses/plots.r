library(ggplot2)
library(reshape2)
library(plyr)

load("data/station_monthly_temp_1981_2010.Rdat")
load("data/station_monthly_precip_1981_2010.Rdat")


lindenberg_daily_recent_raw <- read.csv("excel_data/Lindenberg_daily_recent/produkt_klima_Tageswerte_20121011_20140413_03015.txt")

lindenberg_daily_recent <- within(lindenberg_daily_recent_raw, {
  library(lubridate)
  Datum <- as.Date(as.character(Mess_Datum), format="%Y%m%d")
  Monat <- month(Datum)
  Week <- week(Datum)
  Monat_cat <- month(Datum, label=T)
  Jahr <- year(Datum)
})



month_2013 <- ddply(subset(lindenberg_daily_recent, Jahr==2013), .(Jahr, Monat, Monat_cat), summarise, LUFTTEMPERATUR=mean(LUFTTEMPERATUR, na.rm=T), NIEDERSCHLAGSHOEHE = sum(NIEDERSCHLAGSHOEHE, na.rm=T))
week_2013 <- ddply(subset(lindenberg_daily_recent, Jahr==2013), .(Jahr, Monat, Monat_cat, Week), summarise, LUFTTEMPERATUR=mean(LUFTTEMPERATUR, na.rm=T), NIEDERSCHLAGSHOEHE = sum(NIEDERSCHLAGSHOEHE, na.rm=T))


lindenberg_daily_historic_raw <- read.csv("excel_data/Lindenberg_daily_historic/produkt_klima_Tageswerte_19060401_20121231_03015.txt")

lindenberg_daily_historic <- within(lindenberg_daily_historic_raw, {
  library(lubridate)
  Datum <- as.Date(as.character(Mess_Datum), format="%Y%m%d")
  Monat <- month(Datum)
  Week <- week(Datum)
  Monat_cat <- month(Datum, label=T)
  Jahr <- year(Datum)
  
  LUFTTEMPERATUR[LUFTTEMPERATUR < -100] <- NA  
})

#plot(LUFTTEMPERATUR~Datum, data=lindenberg_daily_historic, type="l")
#plot(NIEDERSCHLAGSHOEHE~Datum, data=lindenberg_daily_historic, type="l")

year_month <- ddply(lindenberg_daily_historic, .(Jahr, Monat, Monat_cat), summarise, LUFTTEMPERATUR=mean(LUFTTEMPERATUR, na.rm=T), NIEDERSCHLAGSHOEHE = sum(NIEDERSCHLAGSHOEHE, na.rm=T))

month <- ddply(year_month, .(Monat, Monat_cat), numcolwise(mean, na.rm=T))
month_1991_2010 <- ddply(subset(year_month, Jahr > 1990 & Jahr < 2011), .(Monat, Monat_cat), numcolwise(mean, na.rm=T))
#month_1991_2010_sd <- ddply(subset(year_month, Jahr > 1990 & Jahr < 2011), .(Monat, Monat_cat), numcolwise(sd, na.rm=T))

p <- ggplot(month_1991_2010, aes(x=Monat_cat, y=NIEDERSCHLAGSHOEHE))
p <- p + geom_bar(stat="identity", aes(fill="Lightblue")) 
p <- p + geom_point(data=month_2013, aes(colour="Darkblue"))
p <- p + theme_bw() + scale_fill_manual("" ,values="Lightblue", labels="Mean precipitation\n1991-2010")
p <- p + scale_colour_manual("", values=c("Black", "Darkblue"), labels="Precipitation 2013")
p <- p + scale_x_discrete("Month") + scale_y_continuous("Precipitation mm")
p

ggsave("figures/monthly_rain.png", p, width=6, height=4, dpi=300)


## Air temperature
p <- ggplot(month_1991_2010, aes(x=Monat_cat, y=LUFTTEMPERATUR))
p <- p + geom_bar(stat="identity", aes(fill="Orange"))
p <- p + geom_point(data=month_2013, aes(colour="Darkblue"))
p <- p + theme_bw() + scale_fill_manual("" ,values="Orange", labels="Mean temperature\n1991-2010")
p <- p + scale_colour_manual("", values=c("Black", "Darkblue"), labels="Temperature 2013")
p <- p + scale_x_discrete("Month") + scale_y_continuous("Temperature °C")
p

ggsave("figures/monthly_temp.png", p, width=6, height=4, dpi=300)



## Weekly temp
year_week <- ddply(lindenberg_daily_historic, .(Jahr, Week), summarise, LUFTTEMPERATUR=mean(LUFTTEMPERATUR, na.rm=T), NIEDERSCHLAGSHOEHE = sum(NIEDERSCHLAGSHOEHE, na.rm=T))

week <- ddply(year_week, .(Week, Jahr), numcolwise(mean, na.rm=T))
week_1991_2010 <- ddply(subset(week, Jahr > 1990 & Jahr < 2011), .(Week), numcolwise(mean, na.rm=T))


p <- ggplot(week_1991_2010, aes(x=Datum, y=LUFTTEMPERATUR))
p <- p + geom_bar(stat="identity", aes(fill="Orange"))
p <- p + theme_bw() + scale_fill_manual("" ,values="Orange", labels="Mean temperature\n1991-2010")
p <- p + scale_colour_manual("", values=c("Black", "Darkblue"), labels="Temperature 2013")
p <- p + scale_x_discrete("Week") + scale_y_continuous("Temperature °C")
p


unique(subset(lindenberg_daily_historic, Week %in% c(30:32))$Monat)




