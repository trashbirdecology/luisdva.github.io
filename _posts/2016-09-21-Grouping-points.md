---
layout: post
excerpt: Three ways to draw polygons around groups of points using ggplot.
tags:
  - rstats
  - ggplot
  - ggalt
  - datavis
image:
  feature: featureGroups.png
  credit: null
  creditlink: null
published: true
---
##Drawing polygons around groups of points in ggplot

> Esta publicación está disponible en español [aqui](http://luisdva.github.io/Agrupando-puntos/ "rock en tu idioma")

For various kinds of analyses, we often end up plotting point data in two dimensions for two or groups. This includes Principal Component Analyses, bioclimatic profiles, or any other combination of values on two axes. In some of my recent projects I’ve encountered three alternatives for drawing polygons around groups of points and I want to share code and examples for all three in this post.  

These methods are for _ggplot_, but I assume there are ways to do the same things using _base_ or other plotting engines. I wanted to use real data, so the following examples use data from [this](http://www.journals.uchicago.edu/doi/10.1086/688383 "Ben-Ezra and Burnes 2016") paper on the physiology of the Japanese quail. After loading (or installing if necessary) the required packages and downloading the data directly from Dryad, we can wrangle the data so we can plot length and mass data from several individual birds at 30 vs 40 days of age. 

{% highlight r %}

# load packages (install first if needed)
library(dplyr)
library(ggplot2)
library(plyr)
library(ggalt)
# load data directly from repository
birdData <- read.csv("http://www.datadryad.org/bitstream/handle/10255/dryad.124441/Morphology%20data.csv?sequence=1",stringsAsFactors = FALSE)
# split into DFs for 30 and 40 days of age
birds40 <- birdData %>% select(mass=Day.40.mass..g.,length=Day.40.head.bill.length..mm.) %>% mutate(age="day40")
birds30 <- birdData %>% select(mass=Day.30.mass..g.,length=Day.30.head.bill.length..mm.) %>% mutate(age="day30")
# bind and remove rows with missing data
birdsAll <- bind_rows(birds30,birds40) %>% na.omit()
# plot points only
ggplot(birdsAll,aes(x=mass,y=length,color=age))+geom_point()+theme_bw()

{% endhighlight %}

<figure>
    <a href="/images/pointsonly.png"><img src="/images/pointsonly.png"></a>
        <figcaption>just the points in 2d</figcaption>
</figure>

# Convex hulls

Convex hulls are one of the most common methods for grouping points. Convex hulls have a formal geometric definition, but basically they are like stretching a rubber band around the outermost points in the group. We can calculate the convex hulls for many groups using _grDevices::chull_ and an apply function (see this exchange for a worked example). 

{% highlight r %}

# calculating convex hulls
find_hull <- function(birdsAll) birdsAll[chull(birdsAll$mass, birdsAll$length), ]
hulls <- ddply(birdsAll, "age", find_hull)

#plot with hull
      ggplot(birdsAll,aes(x=mass,y=length,color=age))+geom_point()+
                geom_polygon(data=hulls,fill=NA)+ theme_bw()

{% endhighlight %}

<figure>
    <a href="/images/chullsimg.png"><img src="/images/chullsimg.png"></a>
        <figcaption>with convex hulls (no fill, no alpha)</figcaption>
</figure>

# Ellipses 
Another common alternative is to group points using ellipses. Ggplot has a flexbile geometry for drawing these elipses. It can inherit all the arguments and parameters so colors and legends are taken care of. 

{% highlight r %}

# plot with ellipse
  ggplot(birdsAll,aes(x=mass,y=length,color=age))+geom_point()+
          stat_ellipse()+ theme_bw()

{% endhighlight %}

<figure>
    <a href="/images/elips.png"><img src="/images/elips.png"></a>
        <figcaption>ellipse with default settings</figcaption>
</figure>

# Encircle
This third option is what I ended up using for my own figures. It uses _geomencircle_, a new geometry provided in the [ggalt](https://github.com/hrbrmstr/ggalt "ggalt on github") package. This geom uses polynomial splines to draw nice smoothed polygons around the groups of points. It has flexible options for color, fill, and the smoothness of the polygons that it draws. I feel that this method is mostly for highlighting groups visually and indicate cohesion, and not for performing any further analyses on the polygons themselves (e.g. using the areas or the amount of overlap for other subsequent tests).   

{% highlight r %}

# plot with spline encirclement
  ggplot(birdsAll,aes(x=mass,y=length,color=age))+geom_point()+
          geom_encircle(expand=0)+ theme_bw()
          
{% endhighlight %}

<figure>
    <a href="/images/encircle.png"><img src="/images/encircle.png"></a>
        <figcaption>ellipse with default settings</figcaption>
</figure>

Although I left them hollow, we can change the transparency and fill values of the different polygons for all three methods. This can be useful to highlight overlap between groups.
