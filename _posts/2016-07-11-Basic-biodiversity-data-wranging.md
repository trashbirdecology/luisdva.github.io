---
published: false
---

At some point we all end up working with datasets that describe biodiversity in some form or another. For example: morphological measurements for museum specimens, occurrence records from bird surveys, ecological traits for many different species, etc. Becuse these datasets share some common features, there are certain tools and operations that we can use to get the rows, columns, and content into something we can use in our analyses. 

I'll admit here that as recently as 2012 - years into my PhD and with a statistics and programming expert as a supervisor, I still wasted a lot of time getting my data ready manually. I took a long time transitioning from xls spreadsheets, doing and a lot of copying and pasting, writing things down on paper, and retyping data. These examples deal with very basic operations, but I wish I knew all this when I first got into comparative analyses.

Hopefully people can find this post with web searches, but this also a reference for myself. I often have to  go through my old scripts to remember how to do these basic operations. This post walks through five data-wrangling tips, and I'll follow it up in the near future. 


# Separators

Sometimes the different parts of a scientific name are separated by non-whitespace characters (probably because many phylogenetic programs don’t like spaces). We can replace them all using pattern matching + replacement with _base::gsub_. 

Lets make an example table of Mesoamerican rodents

{% highlight r %}

mice <- data.frame(spNames=c("Peromyscus_melanophrys","Peromyscus_nasutus",
                      "Peromyscus_schmidlyi","Peromyscus_melanotis",
                      "Liomys_pictus","Baiomys_musculus"),
           Genus=c(rep("Peromyscus",4),"Liomys","Baiomys"),
           spEpithet=c("melanophrys","nasutus","schmidlyi","melanotis",
                       "pictus","musculus"))
                       
{% endhighlight %}


| spNames                | Genus      | spEpithet   |
|------------------------|------------|-------------|
| Peromyscus_melanophrys | Peromyscus | melanophrys |
| Peromyscus_nasutus     | Peromyscus | nasutus     |
| Peromyscus_schmidlyi   | Peromyscus | schmidlyi   |
| Peromyscus_melanotis   | Peromyscus | melanotis   |
| Liomys_pictus          | Liomys     | pictus      |
| Baiomys_musculus       | Baiomys    | musculus    |

Let's rewrite the spNames column, with spaces instead of underscores

{% highlight r %}

mice$spNames <- gsub(pattern = "_",replacement = " ",deerMice$spNames)

{% endhighlight %}

We can also replace spaces with underscores, or with any other characters.

# Combining columns

Sometimes, we find that a scientific name has been split into separate columns when we open a table. This is particularly prevalent in IUCN Red List tables. In excel, I used to do this by concatenating cells with the "&" operator, then I would copy and paste the values into a new column before removing the one with the formula.

Using the same example table from above, we can use 

{% highlight r %}
# adding a new column with the binomial name, the default separator is a space
mice$binomial <- paste(mice$Genus,mice$spEpithet)
{% endhighlight %}



"","spNames","Genus","spEpithet","binomial"
"1","Peromyscus_melanophrys","Peromyscus","melanophrys","Peromyscus melanophrys"
"2","Peromyscus_nasutus","Peromyscus","nasutus","Peromyscus nasutus"
"3","Peromyscus_schmidlyi","Peromyscus","schmidlyi","Peromyscus schmidlyi"
"4","Peromyscus_melanotis","Peromyscus","melanotis","Peromyscus melanotis"
"5","Liomys_pictus","Liomys","pictus","Liomys pictus"
"6","Baiomys_musculus","Baiomys","musculus","Baiomys musculus"

# Change the order of variables variable 

With comparative data I'm always more comfortable having the column with taxon names at the very beginning. dplyr comes in handy here 

Let's make a table in which the column with binomial ends is at the end and not nice for when we scroll through. 

{% highlight r %}
mice <- data.frame(spNames=c("Peromyscus_melanophrys","Peromyscus_nasutus",
                             "Peromyscus_schmidlyi","Peromyscus_melanotis",
                             "Liomys_pictus","Baiomys_musculus"),
                   Genus=c(rep("Peromyscus",4),"Liomys","Baiomys"),
                   spEpithet=c("melanophrys","nasutus","schmidlyi","melanotis",
                               "pictus","musculus"))
# bind the first table with a matrix of random values (five columns, six rows)
mice <- bind_cols(mice,as.data.frame(replicate(5,rnorm(6))))
# use paste, and the new column gets added at the "end" of the table
mice$binomial <- paste(mice$Genus,mice$spEpithet)
{% endhighlight %}

| spNames                | Genus      | spEpithet   | V1                 | V2                  | V3                 | V4                | V5                 | binomial               |
|------------------------|------------|-------------|--------------------|---------------------|--------------------|-------------------|--------------------|------------------------|
| Peromyscus_melanophrys | Peromyscus | melanophrys | -0.265632782924824 | 0.327897273820304   | 0.219972954482649  | -0.64632767838069 | -1.89915607125176  | Peromyscus melanophrys |
| Peromyscus_nasutus     | Peromyscus | nasutus     | -0.973022546256686 | 0.333634724290662   | -0.395166433835357 | 1.91347143971885  | 0.957920666155521  | Peromyscus nasutus     |
| Peromyscus_schmidlyi   | Peromyscus | schmidlyi   | 0.799411588833332  | 0.275100569368765   | -0.366978824994484 | 0.824579802851748 | 1.47553578545787   | Peromyscus schmidlyi   |
| Peromyscus_melanotis   | Peromyscus | melanotis   | -1.71310752865598  | 0.4877680373641     | -1.30147483454924  | -1.65639349280446 | 0.562997113124786  | Peromyscus melanotis   |
| Liomys_pictus          | Liomys     | pictus      | -1.14047435456842  | 0.656050064169863   | 0.481688180071972  | 0.652645856842719 | 1.20831417376165   | Liomys pictus          |
| Baiomys_musculus       | Baiomys    | musculus    | 0.550892132837616  | -0.0246539689028568 | -0.260391572360798 | 0.803264181793322 | -0.583093143639412 | Baiomys musculus       |


# fill w existing colum

# how many of each






The data structure is ready for plotting, and this can all be done with _ggplot()_ to initialize a ggplot object and _geom\_bar()_ to draw the bars.
{% highlight r %}
#if you don't have the packages you can install them all from CRAN using install.packages()
library(ggplot) 
library(ggthemes)
library(palettetown)
# plot the data
ggplot(newDataFr)+
  geom_bar(aes(y=individuals,x=critter,fill=trapped),position="dodge",stat="identity")
{% endhighlight %}

<figure>
    <a href="/images/bars1.png"><img src="/images/bars1.png"></a>
        <figcaption>starting out</figcaption>
</figure>