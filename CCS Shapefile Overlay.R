#requires Rtools
#requires JAGS

# install.packages("devtools")
# devtools::install_github("BrandonEdwards/bbsBayes", ref = "v2.0.0") 

install.packages("bbsBayes") # our package is now on CRAN
library(bbsBayes)
library(tidyverse)
library(raster)
install.packages("sf")
library(sf)
install.packages("rgeos")
library(rgeos)
library(landscapemetrics)
library(landscapetools)
library(dplyr)
library(rgdal)
library(ggplot2)

BBSroutes <- st_read("doc.kml")
BBSroutes$Description  <- NULL
BBSvalues <- BBSroutes
BBSvalues$geometry <- NULL
BBSvalues <- unlist(BBSvalues)
BBSvalues <- str_replace_all(BBSvalues, "[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]", "")
BBSvalues <- str_replace_all(BBSvalues, "[1234567890]", "")
BBSvalues <- str_replace_all(BBSvalues, "[-'._È]", "")
BBSvalues <- str_replace_all(BBSvalues, "[ ]", "")
BBSvalues <- paste(BBSvalues, "1")
BBSvalues <- as.integer(BBSvalues)
BBSvalues <- data.frame(BBSvalues)
BBSroutes[, "value"] <- BBSvalues
remove(BBSvalues)
BBSroutes$Name <- NULL

#BBSroutes <- raster(BBSroutes) ?
#rasterize?

plot(BBSroutes)
BBSroutes <- buffer(BBSroutes, 5000)

CCS1991 <- st_read(dsn = ".", layer = "1991CCS")

CCS1996 <- st_read(dsn = ".", layer = "1996CCS")

CCS2001 <- st_read(dsn = ".", layer = "2001CCS")

CCS2006 <- st_read(dsn = ".", layer = "2006CCS")

CCS2011 <- st_read(dsn = ".", layer = "2011CCS")

CCS2016 <- st_read(dsn = ".", layer = "2016CCS")

# overlay1991 <- overlay(BBSroutes, CCS1991, fun=function(x, y){return(x*y)})
# plot(overlay1991)

overlay1991 <- st_union(BBSroutes,CCS1991)
### assuming the projections are correctly interpreted and recorded in the files, this should work

## some useful guidance on plotting sf objects
#https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html 


plot.test = ggplot()+
  geom_sf(data = BBSroutes)+
  geom_sf(data = CCS1991,colour = "red")
