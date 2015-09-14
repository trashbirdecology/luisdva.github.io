---
layout: post
title: Getting elevation data for point occurrences in R using rgbif
excerpt: "Using R to fetch elevation for lat/long data through an API."
tags: 
  - error 400
  - rgbif
  - google elevation API
image: 
  feature: featureRGBIF.jpg
published: true
---


As part of an ongoing project on Phyllostomid bat macroecology, I was given a spreadsheet of point occurrences for Stenodermatines. All the records had georeferenced location data in Degrees/Minutes/Seconds, but some did not include original elevation data.  Thus, I wanted to fetch the elevation for the points with missing data – a simple enough task.  At first, I considered doing it the way I remembered from my undergraduate projects, by plugging the coordinates for individual localities into third-party websites that locate them in an embedded Google Map and show the elevation (for example: [mygeoposition.com](http://mygeoposition.com/)).

Then I remembered that it’s not 2004 and that I should know better. A quick search led me to the [rgbif](https://cran.r-project.org/web/packages/rgbif/index.html) package by the helpful folks from the [rOpenSci](https://ropensci.org/) project. _rgbif_ includes the _elevation_ function, which uses the [Google Elevation API](https://developers.google.com/maps/documentation/elevation/intro) to get the elevations for a data frame or list of points. 

In this post, I go through some reproducible example code for getting elevation data using rgbif, and try to document an important step in cleaning up the data to avoid confusing and time-consuming errors. Hopefully this post shows up when people do web searches for: rgbif error: (400) Bad Request. 

### Example code and data

When I received the point data, I was warned that records with no altitude used “9999” as the NA value. This was pretty obvious to spot and easy to put into the _na.strings_ argument when importing the data.

{% highlight r %}
# load packages
library(rgbif)
library(dplyr)

# read coordinate data
Localities <- read.csv("https://raw.githubusercontent.com/luisDVA/codeluis/master/rawCoords.csv", na.strings = 9999,stringsAsFactors = FALSE)

{% endhighlight %}

After loading the data, I used _dplyr_ to rename some columns, convert the coordinates into decimal degrees, and discard records with original elevation data. Then I tried out the _elevation_ function. Because I already had columns named 'decimalLatitude' and 'decimalLongitude', the only arguments needed were the name of the data frame and my Google Elevation API key (which is easy to obtain).


{% highlight r %}
# keep points with no elevation data and convert to decimal degrees
LocalitiesNoElevation <-   Localities %>%  filter(is.na(Elevation)) %>% 
  mutate(decimalLatitude= LatitudeDegrees + LatitudeMinutes/60 + LatitudeSeconds/3600,
         decimalLongitude= -(abs(LongitudeDegrees)) + LongitudeMinutes/60 + LongitudeSeconds/3600)


# fetch elevations, use your personal API key
missingElevations<- elevation(LocalitiesNoElevation,key = YOURPERSONALAPIKEYGOESHERE)

{% endhighlight %}

I kept getting the following error message: 
 
Error in getdata(input) : client error: (400) Bad Request

A "400" error basically means that the server was unable to understand the client request and process it. I struggled with this error for at least an hour, trying to diagnose issues with my internet connection, proxy settings, firewall, API key, etc. I started to subset my data to see if maybe the elevation API had a quota on the number of queries, and I found that the function worked fine most of the time. The original spreadsheet had thousands of records for hundreds of unique localities, but I managed to locate a few records with coordinate data that looked like this:

|Latitude Degrees|Latitude Minutes|Latitude Seconds|Longitude Degrees|Longitude Minutes|Longitude Seconds| 
|:--------|:-------:|--------:|--------:|--------:|--------:|
|99|99|99| -999| 99| 99|    


The NA strings in these records include both 99 and -999 and these got converted into decimal degrees. It didn’t occur to me that all this trouble could be caused by errors in my lat/long data. The elevation function assumes (reasonably) that the points actually occur on earth, within the bounds of a geographic coordinate system (bounded at ±90° and ±180°). 

There is no warning message written into the function for point occurrences with useless values. If any of the package developers are reading this, can you add a warning for nonsense coordinates?

In this case, the problems came from an inconsistent treatment of NA values in the original data. I used very hacky way to filter these records and then the elevation function worked fine.

{% highlight r %}
# remove weird NA cases
LocalitiesNoElevation <- LocalitiesNoElevation %>%  filter(LatitudeMinutes<60|LatitudeSeconds<60|LongitudeMinutes<60|LongitudeSeconds<60) 
# get elevations
missingElevations<- elevation(LocalitiesNoElevation,key = YOURAPIKEY)
{% endhighlight %}

The negative elevation values in the final data frame are actually depth locations on the sea floor, some of the coordinates in the data must be wrong.

There must be nifty tools out there for checking inconsistent NA values in raw data, and in this case the coordinates should be checked spatially before fetching elevations.  For now, I hope this post helps others when they get stuck while working with lat/long data and APIs.
