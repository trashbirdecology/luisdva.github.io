---
published: false
---

## Getting elevation data for point occurrences in R using rgbif

As part of an ongoing project on Phyllostomid bat macroecology, I was given a spreadsheet of point occurrences for Stenodermatines. All the records had georeferenced location data in Degrees/Minutes/Seconds, but some did not include original elevation data.  Thus, I wanted to fetch the elevation for the points with missing data – a simple enough task.  At first, I considered doing it the way I remembered from my undergraduate projects, by plugging the coordinates for individual localities into third-party websites that locate them in an embedded Google Map and show the elevation (eg mygeoposition.com).

Then I remembered that it’s not 2004 and that I should know better. A quick search led me to the rgbif package by the helpful folks from the rOpenSci project. Rgbif includes the elevation function, which uses the Google Elevation API to get the elevations for a data frame or list of points. 

In this post, I go through some reproducible example code for getting elevation data for point occurrences using rgbif, and try to document an important step in cleaning up the data to avoid confusing and time-consuming errors. Hopefully this post shows up when people do web searches for: rgbif error: (400) Bad Request. 

Example code and data

When I received the point data, I was warned that records with no altitude data used “9999” as the NA value. This was pretty obvious to spot and easy to put into the na.strings argument when importing the data.
After loading the data, I used dplyr to rename some columns, convert the coordinates into decimal degrees, and discard records with original elevation data. 
Then I tried out the elevation function. Because I already had columns named decimalLatitude and decimalLongitude, the only arguments needed were the name of the data frame and my Google Elevation API key (which is easy to obtain).
I kept getting the following error message 
 
Error in getdata(input) : client error: (400) Bad Request

A 400 error basically means that the server was unable to understand the client request and process it. I struggled with this error for at least an hour, trying to diagnose issues with my internet connection, proxy settings, firewall, API key, etc. I started to subset my data to see if maybe the elevation API had a quota on the number of queries, and I found that the function worked fine most of the time. The original spreadsheet had thousands of records for hundreds of unique localities, but I managed to locate a few records that looked like this:


The NA strings in these records include both 99 and -999 and these got converted into decimal degrees. It didn’t occur to me that all this trouble could be caused by errors in my lat/long data. The elevation function assumes (reasonably) that the points actually occur on earth, within the bounds of a geographic coordinate system (bounded at ±90° and ±180°). 

There is no warning message written into the function for point occurrences with useless values. If any of the package developers are reading this, can you add a warning for nonsense coordinates?

In this case, the problems came from an inconsistent treatment of NA values in the original data. I used very hacky way to filter these records and then the elevation function worked fine.

There must be nifty tools out there for checking inconsistent NA values in raw data, and in this case the coordinates can be checked spatially before fetching elevations.  For now, I hope this post helps others when they get stuck while working with lat/long data and APIs.
