---
title: Getting elevation data for point occurrences in R using rgbif
excerpt: Using R to fetch elevation for lat/long data through an API.
category: rstats
tags: 
  - rspatial
  - rgbif
  - geonames
header: 
  overlay_image: /assets/images/featureRGBIF.jpg
  overlay_filer: 0.3
---
# > Updated on February 2020 to reflect changes to the `elevation` function and how it retrieves data from the web. The Google Elevation API was replaced by the GeoNames service.

> Update 12/10/2015: I found and fixed an error in the formula for converting latlong coordinates to decimal degrees. My bad.

> Update 14/9/2015: Scott Chamberlain of rOpenSci has added checks to the elevation function to warn when the input coordinates have impossible values, incomplete cases, and values at 0,0. 

As part of a project on bat macroecology, I was given a spreadsheet of point occurrences for Stenodermatines. All the records had georeferenced location data in Degrees/Minutes/Seconds, but some did not include original elevation data. I wanted to fetch the elevation for the points with missing data – a simple enough task. At first, I considered doing it the way I remembered from my undergraduate projects, by plugging the coordinates for individual localities into third-party websites that locate them in an embedded Google Map and show the elevation (for example: [mygeoposition.com](http://mygeoposition.com/)).

Then I remembered that it’s not 2004 anymore. A quick search led me to the [`rgbif`](https://cran.r-project.org/web/packages/rgbif/index.html) package by the helpful folks from the [rOpenSci](https://ropensci.org/) project. `rgbif` includes the `elevation` function, which queries the relevant web resources (DEMs) to get the elevations for a data frame or list of points. 

In this post, I go through some reproducible example code for getting elevation data using `rgbif`.

### Example code and data

When I received the point data, I was warned that records with no altitude used “9999” as the NA value. This was pretty obvious to spot and easy to put into the `na.strings` argument when importing the data.

{% highlight r %}
# load packages
library(rgbif) # Interface to the Global 'Biodiversity' Information Facility API
library(dplyr) # A Grammar of Data Manipulation

# read coordinate data
Localities <- read.csv("https://raw.githubusercontent.com/luisDVA/codeluis/master/rawCoords.csv", na.strings = 9999,stringsAsFactors = FALSE)

{% endhighlight %}

After loading the data, I used `dplyr` to rename some columns, convert the coordinates into decimal degrees, and discard records that already have elevation data. Then I tried out the `elevation()` function. Because I already had columns named 'decimalLatitude' and 'decimalLongitude', the only arguments needed were the name of the data frame and my GeoNames username (which is easy to obtain, see the help file for `elevation()`).

After signing up for GeoNames account and going through the account validation process, make sure to **enable Free Web Services** at the [account management page](https://www.geonames.org/manageaccount), otherwise you will get a 401 error and the `elevation` function will not run.  

{% highlight r %}
LocalitiesNoElevation <- Localities %>%
  filter(is.na(Elevation)) %>%
  filter(State!="UNKNOWN") %>% 
  mutate(
    decimalLatitude = LatitudeDegrees + LatitudeMinutes / 60 + LatitudeSeconds / 3600,
    decimalLongitude = (abs(LongitudeDegrees) + LongitudeMinutes / 60 + LongitudeSeconds / 3600) * -1
  )
  
# fetch elevations 
# use your GeoNames username after enabling webservices for it
missingElevations<- elevation(LocalitiesNoElevation,username = "YOURGEONAMESUSERNAMEHERE")
{% endhighlight %}


The distinct localities and their elevations (with the default setting for the Elevation Model) look like this:

{% highlight r %}
missingElevations %>% select(longitude,latitude,elevation_geonames) %>% distinct()
{% endhighlight %}

{% highlight text %}
longitude latitude elevation_geonames
1  -99.43389 18.73972               1005
2  -88.56861 18.34250                  9
3  -89.02167 18.20167                121
4  -88.55444 18.55333                 62
5  -89.00000 18.20167                128
6  -88.58694 18.52556                 30
7  -88.91306 18.19972                 95
8  -88.60139 18.53694                 33
9  -88.85778 17.92500                  5
10 -88.61917 18.34833                 31
11 -98.22333 20.39111               1121
12 -93.77139 16.28167                511
13 -97.00167 17.59028               1268
14 -99.60833 17.63083               1695
15 -98.78028 16.78222                285
16 -98.72000 16.78028                431
17 -98.74778 16.81278                267
{% endhighlight %}

For now, I hope this post helps others to fetch elevations programatically.
Let me know if there are any errors.
