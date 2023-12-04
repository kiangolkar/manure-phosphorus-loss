library(sf)
library(ggplot2)
library(raster)
library(ncdf4)
library(RColorBrewer)

LON <- c(1)
LAT <- c(1)
cluster <- c(0)
my_df <- data.frame(LON, LAT , cluster)

#  4 ==> 4 sat
matrix_data <- array(rep(1, 720*360*365*4), dim=c(720,360,365,4))

matrix_coefficient_of_variation <- array(rep(1, 720*360), dim=c(720,360))

setwd("D:\\M\\14010727_golkar\\golkar_data\\4\\dataset-insitu-gridded-observations-global-and-regional-110a9cda-db0e-454c-9b89-6c0f424754b3")
fn <- "GPCC_total_precipitation_mon_0.5x0.5_global_2000_v2020.0.nc"
nc <- nc_open(fn)

attributes(nc$var)
vfile = ncvar_get(nc, attributes(nc$var)$name[1])

for (lon in 1:720) {
  for (lat in 1:360) {
    for (time in 1:12) {
      matrix_data[lon,lat,time,1]  =vfile[lon,lat,time]
    }
  }
}

setwd("D:\\M\\14010727_golkar\\golkar_data\\4\\dataset-insitu-gridded-observations-global-and-regional-110a9cda-db0e-454c-9b89-6c0f424754b3")
fn <- "GPCC_total_precipitation_mon_0.5x0.5_global_2000_v2020.0.nc"
nc <- nc_open(fn)

attributes(nc$var)
vfile = ncvar_get(nc, attributes(nc$var)$name[1])

for (lon in 1:720) {
  for (lat in 1:360) {
    for (time in 1:365) {
      matrix_data[lon,lat,time,2]  =vfile[lon,lat,time]
    }
  }
}


setwd("D:\\M\\14010727_golkar\\golkar_data\\4\\dataset-insitu-gridded-observations-global-and-regional-d17a4b5a-43af-44da-ad70-eecc7ab3bffe")
fn <- "IMERG_total_precipitation_day_0.5x0.5_global_2000_v6.0.nc"
nc <- nc_open(fn)

attributes(nc$var)
vfile = ncvar_get(nc, attributes(nc$var)$name[1])

for (lon in 1:720) {
  for (lat in 1:360) {
    for (time in 1:365) {
      matrix_data[lon,lat,time,3]  =vfile[lon,lat,time]
    }
  }
}


setwd("D:\\M\\14010727_golkar\\golkar_data\\4\\dataset-insitu-gridded-observations-global-and-regional-f43208d3-8bca-4dde-b640-46f41f051ffe")
fn <- "CRU_total_precipitation_mon_0.5x0.5_global_2000_v4.03.nc"
nc <- nc_open(fn)

attributes(nc$var)
vfile = ncvar_get(nc, attributes(nc$var)$name[1])

for (lon in 1:720) {
  for (lat in 1:360) {
    for (time in 1:12) {
      matrix_data[lon,lat,time,4]  =vfile[lon,lat,time]
    }
  }
}


# cal sd and mean
for (lon in 1:720) {
  print(lon)
  for (lat in 1:360) {
    temp_count = 0
    temp_sum = 0
    v1 = 0
    v2 = 0
    v3 = 0
    v4 = 0
    
    for (time in 1:12) {
      if(!is.nan(matrix_data[lon,lat,time,1]) && !is.na(matrix_data[lon,lat,time,1])){
        temp_count = temp_count + 1
        temp_sum = temp_sum +matrix_data[lon,lat,time,1]
      }
    }
    if(temp_sum > 0){
      v1 = temp_sum/temp_count;
    }
    
    temp_count = 0
    temp_sum = 0
    for (time in 1:365) {
      if(!is.nan(matrix_data[lon,lat,time,2]) && !is.na(matrix_data[lon,lat,time,2])){
        temp_count = temp_count + 1
        temp_sum = temp_sum +matrix_data[lon,lat,time,2]
      }
    }    
    if(temp_sum > 0){
      v2 = temp_sum/temp_count;
    }
    
    temp_count = 0
    temp_sum = 0
    for (time in 1:365) {
      if(!is.nan(matrix_data[lon,lat,time,3]) && !is.na(matrix_data[lon,lat,time,3])){
        temp_count = temp_count + 1
        temp_sum = temp_sum + matrix_data[lon,lat,time,3]
      }
    }     
    if(temp_sum > 0){
      v3 = temp_sum/temp_count;
    }
    
    temp_count = 0
    temp_sum = 0
    for (time in 1:12) {
      if(!is.nan(matrix_data[lon,lat,time,4]) && !is.na(matrix_data[lon,lat,time,4])){
        temp_count = temp_count + 1
        temp_sum = temp_sum + matrix_data[lon,lat,time,4]
      }
    }     
    if(temp_sum > 0){
      v4 = temp_sum/temp_count;
    }
    
    list <- c(v1,v2,v3,v4);
    sd_mean = sd(list)/mean(list);
    if(!is.nan(sd_mean) && !is.na(sd_mean)){
      matrix_coefficient_of_variation [lon,lat]  =sd_mean;
    }else{
      matrix_coefficient_of_variation [lon,lat]  = 0;

    }
    
  }
}


for (lon in 1:720) {
  print(lon)
  for (lat in 1:360) {
    my_df[nrow(my_df) + 1,] <- c(lon,360-lat,matrix_coefficient_of_variation[lon,lat]);
  }
}






my_sf <- st_as_sf(my_df, coords = c('LON', 'LAT'))


# my_sf <- st_set_crs(my_sf, crs = 5)

#Plot it:
ggplot(my_sf) + 
  geom_sf(aes(color = cluster))+scale_colour_gradientn(colors =  brewer.pal(11, "RdYlBu"))
