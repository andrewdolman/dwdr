
library(ggplot2)
library(reshape2)
library(plyr)
dat <- subset(station_monthly_temp_1981_2010, Name.der.Station=="LINDENBERG (OBS) ")
dput(names(dat))
dat_long <- melt(dat, id.vars=c("Name.der.Station", "Stations_ID", "Höhe.ü..NN", "Breite", "Länge", "Bundesland"), value.name="Temperature", variable.name="Monat")

p <- ggplot(subset(dat_long, Monat!="Jahr"), aes(x=Monat, y=Temperature))
p <- p + geom_bar(stat="identity")
p




#str(station_monthly_precip_1981_2010)
dat <- subset(station_monthly_precip_1981_2010, Name.der.Station=="LINDENBERG (OBS) ")
# dat <- subset(station_monthly_precip_1981_2010, Bundesland=="Brandenburg ")
# dat <- ddply(dat, .(Bundesland), numcolwise(mean))

dat_long <- melt(dat, id.vars=c("Name.der.Station", "Stations_ID", "Höhe.ü..NN", "Breite", "Länge", "Bundesland"), value.name="Precipitation", variable.name="Monat")

p <- ggplot(subset(dat_long, Monat!="Jahr"), aes(x=Monat, y=Precipitation))
p <- p + geom_bar(stat="identity") + scale_y_continuous(limits=c(0, 70))
p
