# This script draws Choropleth matps of Europe
# Downloaded from http://www.r-bloggers.com/maps-in-r-choropleth-maps/
#
# Paul changed paths and added links to data sources

library(maptools)
library(ggplot2)
library(ggmap)

gpclibPermit() # Test if the General Polygon Clipping Library for R is there
# gpclib is needed otherwise fortify() returns the Error: isTRUE(gpclibPermitStatus()) is not TRUE

# read administrative boundaries (change folder appropriately)
# Data from http://epp.eurostat.ec.europa.eu/portal/page/portal/gisco_Geographical_information_maps/popups/references/administrative_units_statistical_units_1
eurMap = readShapePoly(fn="rawdata/NUTS_2010_60M_SH/data/NUTS_RG_60M_2010")
# plot(eurMap) # Would draw the map of Europe at the NUTS-3 level.

# Transform eurMap to a data frame for use with ggplot2
# fortify() takes a long time.
# Place this in a load.r script and save the workspace
eurMapDf = fortify(eurMap, region='NUTS_ID')

# Read downloaded data (change folder appropriately)
eurEdu <- read.csv("rawdata/educ_thexp_1_Data.csv", stringsAsFactors = F)
eurEdu$Value <- as.double(eurEdu$Value) #format as numeric



################################
# Merge map and Education data #
################################
eurEduMapDf <- merge(eurMapDf, eurEdu, by.x="id", by.y="GEO")
eurEduMapDf <- eurEduMapDf[order(eurEduMapDf$order),]

# limit data to main Europe
europe.limits <- geocode(c("Cape Fligely, Rudolf Island, Franz Josef Land, Russia", "Gavdos, Greece", "Faja Grande, Azores", "Severny Island, Novaya Zemlya, Russia"))

eurEduMapDf <- subset(eurEduMapDf, long > min(europe.limits$lon) & long < max(europe.limits$lon) & lat > min(europe.limits$lat) & lat < max(europe.limits$lat))

# ggplot mapping
# data layer
names(eurEdu)
m0 <- ggplot(data=eurEduMapDf)
# empty map (only borders)
m1 <- m0 + geom_path(aes(x=long, y=lat, group=group), color='gray') + coord_equal()

# fill with education expenditure data
m2 <- m1 + geom_polygon(aes(x=long, y=lat, group=group, fill=Value))

# inverse order (to have visible borders)
m0 <- ggplot(data=eurEduMapDf)
m1 <- m0 + geom_polygon(aes(x=long, y=lat, group=group, fill=Value)) + coord_equal()
m2 <- m1 + geom_path(aes(x=long, y=lat, group=group), color='black')
m2

#################################
# Merge map and Employment data #
#################################
load("rawdata/EUROSTAT_forestry.RDATA")
for_emp_lfs$time = as.numeric(as.character(for_emp_lfs$time))
for_emp_lfs$value = for_emp_lfs$value*1000
emp2012 = subset(for_emp_lfs, sex=="T" & isced97=="TOTAL" & wstatus=="EMP" & !is.na(value) &
                     !geo %in% c("EA13", "EA17", "EA18", "EU15", "EU27", "EU28") &
                     time=="2012" & nace_r2 == "A02", 
                 select=c(geo, value))
# # limit data to main Europe
# europe.limits <- geocode(c("Cape Fligely, Rudolf Island, Franz Josef Land, Russia", "Gavdos, Greece", "Faja Grande, Azores", "Severny Island, Novaya Zemlya, Russia"))
# 
# eurMapDf <- subset(eurMapDf, long > min(europe.limits$lon) & long < max(europe.limits$lon) & lat > min(europe.limits$lat) & lat < max(europe.limits$lat))


# Merge map and data
eurEmpMapDf = merge(eurMapDf, emp2012, by.x="id", by.y="geo")

# limit data to main Europe
eurEmpMapDf <- subset(eurEmpMapDf, long > min(europe.limits$lon) & long < max(europe.limits$lon) & lat > min(europe.limits$lat) & lat < max(europe.limits$lat))


# ggplot mapping
# data layer
m0 <- ggplot(data=eurEmpMapDf)
# empty map (only borders)
############### 
##############  Doesn't work !!!
############
m1 <- m0 + geom_path(aes(x=long, y=lat, group=group), color='gray') + coord_equal()




# fill with Employment data
m2 <- m1 + geom_polygon(aes(x=long, y=lat, group=group, fill=value))

# Mapping
m0 <- ggplot(data=eurEmpMapDf)
m1 <- m0 + geom_polygon(aes(x=long, y=lat, group=group, fill=value)) + coord_equal()
m2 <- m1 + geom_path(aes(x=long, y=lat, group=group), color='black')
m2



###############
# Not working #
###############
# # over a GoogleMap (not working if not correctly projected)
# map <- get_map(location = 'Europe', zoom=4)
# m0 <- ggmap(map)
# m1 <- m0 + geom_polygon(aes(x=long, y=lat, group=group, fill=Value), data=eurEduMapDf, alpha=.9)
# m2 <- m1 + geom_path(aes(x=long, y=lat, group=group), data=eurEduMapDf, color='black')
# 
# # add text
# library(doBy)
# txtVal <- summaryBy(long + lat + Value ~ id, data=eurEduMapDf, FUN=mean, keep.names=T)
# m3 <- m2 + geom_text(aes(x=long, y=lat, label=Value), data=txtVal, col="yellow", cex=3)
