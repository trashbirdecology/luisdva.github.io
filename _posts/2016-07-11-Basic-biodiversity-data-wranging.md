---
published: false
---

At some point we all end up working with datasets that describe biodiversity in some form or another. For example: morphological measurements for museum specimens, occurrence records from bird surveys, ecological traits for many different species, etc. Becuse these datasets share some common features, there are certain tools and operations that we can use to get the rows, columns, and content into something we can use in our analyses. 

I'll admit here that as recently as 2012 - years into my PhD and with a statistics and programming expert as a supervisor, I still wasted a lot of time getting my data ready manually. I took a long time transitioning from xls spreadsheets, doing and a lot of copying and pasting, writing things down on paper, and retyping data. These examples deal with very basic operations, but I wish I knew all this when I first got into comparative analyses.

Hopefully people can find this post with web searches, but this also a reference for myself. I often have to  go through my old scripts to remember how to do these basic operations. This post walks through five data-wrangling tips, and I'll follow it up in the near future. 


# Separators

Sometimes the different parts of a scientific name are separated by non-whitespace characters (probably because many phylogenetic programs don’t like spaces). We can replace them all using pattern matching + replacement with _base::gsub_. 



| spNames                | Genus      | spEpithet   |
|------------------------|------------|-------------|
| Peromyscus_melanophrys | Peromyscus | melanophrys |
| Peromyscus_nasutus     | Peromyscus | nasutus     |
| Peromyscus_schmidlyi   | Peromyscus | schmidlyi   |
| Peromyscus_melanotis   | Peromyscus | melanotis   |
| Liomys_pictus          | Liomys     | pictus      |
| Baiomys_musculus       | Baiomys    | musculus    |


{% highlight r %}


{% endhighlight %}

# combining columns

Sometimes, we find that a scientific name has been split into separate columns when we open a table. This is particularly prevalent in IUCN Red List tables. In excel, I used to do this by concatenating cells with the "&" operator, then I would copy and paste the values into a new column before removing the one with the formula.

Using the same example table from above, we can use 

{% highlight r %}


{% endhighlight %}



"","spNames","Genus","spEpithet","binomial"
"1","Peromyscus_melanophrys","Peromyscus","melanophrys","Peromyscus melanophrys"
"2","Peromyscus_nasutus","Peromyscus","nasutus","Peromyscus nasutus"
"3","Peromyscus_schmidlyi","Peromyscus","schmidlyi","Peromyscus schmidlyi"
"4","Peromyscus_melanotis","Peromyscus","melanotis","Peromyscus melanotis"
"5","Liomys_pictus","Liomys","pictus","Liomys pictus"
"6","Baiomys_musculus","Baiomys","musculus","Baiomys musculus"

# change var order

For 
just to be more confortable in general


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