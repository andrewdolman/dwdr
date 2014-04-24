## Read long term monthly averages
library(xlsx)
station_monthly_temp_1981_2010 <- read.xlsx("excel_data/Long term 1981-2010 monthly averages.xlsx", "Temperature", encoding="UTF-8")
save(station_monthly_temp_1981_2010, file="data/station_monthly_temp_1981_2010.Rdat")

station_monthly_precip_1981_2010 <- read.xlsx("excel_data/Long term 1981-2010 monthly averages.xlsx", "Precipitation", encoding="UTF-8")
save(station_monthly_precip_1981_2010, file="data/station_monthly_precip_1981_2010.Rdat")





