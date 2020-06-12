#requires Rtools
#requires JAGS


#install.packages("bbsBayes") 
library(bbsBayes)
library(tidyverse)
library(raster)
#install.packages("sf")
library(sf)
#install.packages("rgeos")
library(rgeos)
library(landscapemetrics)
library(landscapetools)
library(dplyr)
library(rgdal)
library(ggplot2)

#unzip("maps/All Routes 2019.kmz")
BBSroutes <- st_read("maps/doc.kml")
BBSroutes$Description  <- NULL


# BBSvalues <- BBSroutes
# BBSvalues$geometry <- NULL
# BBSvalues <- unlist(BBSvalues)
# BBSvalues <- str_replace_all(BBSvalues, "[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]", "")
# BBSvalues <- str_replace_all(BBSvalues, "[1234567890]", "")
# BBSvalues <- str_replace_all(BBSvalues, "[-'._È]", "")
# BBSvalues <- str_replace_all(BBSvalues, "[ ]", "")
# BBSvalues <- paste(BBSvalues, "1")
# BBSvalues <- as.integer(BBSvalues)
# BBSvalues <- data.frame(BBSvalues)
# BBSroutes[, "value"] <- BBSvalues
# remove(BBSvalues)
# BBSroutes$Name <- NULL


plot(BBSroutes)

## https://geocompr.robinlovelace.net/reproj-geo-data.html#when-to-reproject 
## above link has useful help for many geographical actions in R
st_crs(BBSroutes)
# Coordinate Reference System:
#   EPSG: 4326 
# proj4string: "+proj=longlat +datum=WGS84 +no_defs"

# convert to a lambert equal area projection centered on the approximate centre of the BBSroutes
bbs_laea = st_transform(BBSroutes,
                           crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=-90 +lat_0=50")

st_crs(bbs_laea)

#BBSroutes <- st_as_sf(BBSroutes)

bbs_laea <- st_buffer(bbs_laea, 5000)
# This should work now

#Not really sure if this worked the way it should?
### In st_buffer.sfc(st_geometry(x), dist, nQuadSegs, endCapStyle = endCapStyle,  : st_buffer does not correctly buffer longitude/latitude data
### I've looked up this error...still not sure exactly how it works but it has something to do with the coordinates 

CCS1991 <- st_read(dsn = "maps", layer = "1991CCS")

CCS1996 <- st_read(dsn = "maps", layer = "1996CCS")

CCS2001 <- st_read(dsn = "maps", layer = "2001CCS")

CCS2006 <- st_read(dsn = "maps", layer = "2006CCS")

CCS2011 <- st_read(dsn = "maps", layer = "2011CCS")

CCS2016 <- st_read(dsn = "maps", layer = "2016CCS")


CCS1991_laea = st_transform(CCS1991,
                                  crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=-90 +lat_0=50")

CCS1996_laea = st_transform(CCS1996,
                            crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=-90 +lat_0=50")

CCS2001_laea = st_transform(CCS2001,
                            crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=-90 +lat_0=50")

CCS2006_laea = st_transform(CCS2006,
                            crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=-90 +lat_0=50")

CCS2011_laea = st_transform(CCS2011,
                            crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=-90 +lat_0=50")

CCS2016_laea = st_transform(CCS2016,
                            crs = "+proj=laea +x_0=0 +y_0=0 +lon_0=-90 +lat_0=50")


plot.test = ggplot()+
  geom_sf(data = CCS1991_laea,colour = "red")+
  geom_sf(data = bbs_laea)

print(plot.test)




### trying an intersection instead of a union - this should be more efficient because it removes/ignores the non-overlapping areas

overlay1991 <- st_intersection(bbs_laea,CCS1991_laea)
overlay1996 <- st_intersection(bbs_laea,CCS1996_laea)
overlay2001 <- st_intersection(bbs_laea,CCS2001_laea)
overlay2006 <- st_intersection(bbs_laea,CCS2006_laea)
overlay2011 <- st_intersection(bbs_laea,CCS2011_laea)
overlay2016 <- st_intersection(bbs_laea,CCS2016_laea)

overlays <- list(o1991 = overlay1991,
                 o1996 = overlay1996,
                 o2001 = overlay2001,
                 o2006 = overlay2006,
                 o2011 = overlay2011,
                 o2016 = overlay2016)

save(list = c("overlays"),file = "Intersection_overlays.RData")

### this shoudl work now.


### Error in geos_op2_geom("union", x, y) : st_crs(x) == st_crs(y) is not TRUE
### so this error is telling you that the "crs" (coordinate reference system) are different for the two spatial objects

## some useful guidance on plotting sf objects
#https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html 




