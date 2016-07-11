---
layout: post
title: "Basic biodiversity data-wrangling operations"
excerpt: "Manipulating variables and content in biodiversity datasets using base R and dplyr. "
tags: 
  - count how many
  - everything()
  - species names
  - separators
image: 
  feature: featureWrangling1.png
  credit: null
  creditlink: null
published: true
---

At some point we all end up working with datasets that describe biodiversity in some form or another. For example: morphological measurements for museum specimens, occurrence records from bird surveys, ecological traits for many different species, etc. Becuse these datasets share some common features, there are certain tools and operations that we can use to get the rows, columns, and content into something we can use in our analyses. 

I'll admit here that as recently as 2013 - already several years into my PhD program and with a statistics and programming expert as a supervisor, I still wasted a lot of time getting my data ready manually. I took a long time transitioning from xls spreadsheets, doing a lot of copying and pasting, writing things down on paper, and retyping data. These examples deal with very basic operations, but I wish I knew all this when I first got into comparative analyses. The first time I tackled some of these operations for a terrestrial mammal dataset of 3300 species, I wasted months organizing a single table, with the risk of introducing errors and no way of keeping track of what I did.  

Hopefully people can find this post with web searches, but this also a reference for myself. I often have to  go through my old scripts to remember how to do these basic operations. This post walks through five data-wrangling tips, and I'll follow it up in the near future.  

These little operations are all reproducible on their own, I put everything in code blocks so there is some redundance, just make sure to load _dplyr_. 


# Separators

Sometimes the different parts of a scientific name are separated by non-whitespace characters (probably because many phylogenetic programs don’t like spaces). We can replace them all using pattern matching + replacement with _base::gsub_. 

Set up an example table of Mesoamerican rodents

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


| spNames                | Genus      | spEpithet   |
|------------------------|------------|-------------|
| Peromyscus melanophrys | Peromyscus | melanophrys |
| Peromyscus nasutus     | Peromyscus | nasutus     |
| Peromyscus schmidlyi   | Peromyscus | schmidlyi   |
| Peromyscus melanotis   | Peromyscus | melanotis   |
| Liomys pictus          | Liomys     | pictus      |
| Baiomys musculus       | Baiomys    | musculus    |


We can also replace spaces with underscores, or with any other characters.


# Combining columns

Sometimes, we find that a scientific name has been split into separate columns when we open a table. This is particularly prevalent in IUCN Red List tables. In Excel, I used to do this by concatenating cells with the "&" operator, then I would copy and paste the values into a new column before removing the one with the formula.

Using the same example table from above, we can use: 

{% highlight r %}
# adding a new column with the binomial name, the default separator is a space
mice$binomial <- paste(mice$Genus,mice$spEpithet)
{% endhighlight %}


| spNames                | Genus      | spEpithet   | binomial               |
|------------------------|------------|-------------|------------------------|
| Peromyscus_melanophrys | Peromyscus | melanophrys | Peromyscus melanophrys |
| Peromyscus_nasutus     | Peromyscus | nasutus     | Peromyscus nasutus     |
| Peromyscus_schmidlyi   | Peromyscus | schmidlyi   | Peromyscus schmidlyi   |
| Peromyscus_melanotis   | Peromyscus | melanotis   | Peromyscus melanotis   |
| Liomys_pictus          | Liomys     | pictus      | Liomys pictus          |
| Baiomys_musculus       | Baiomys    | musculus    | Baiomys musculus       |

# Change the order of variables

With comparative data I'm always more comfortable having the column with taxon names at the very beginning. _dplyr_ comes in handy here.

Let's make a table in which the column with binomial names is at the end and not nice for when we scroll through. 

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


We can use the _everything()_ argument in _dplyr::select_ to put the species names first and then everything, no need to type all the column names.

{% highlight r %}
mice %>% select(binomial,everything())
#note that this is equivalent to 
mice %>% select(binomial,spNames,Genus, spEpithet, V1,V2,V3,V4,V5)
# or using : to refer to contiguous columns
mice %>% select(binomial,spNames:V5)
{% endhighlight %}

| binomial               | spNames                | Genus      | spEpithet   | V1                 | V2                | V3                 | V4                 | V5                 |
|------------------------|------------------------|------------|-------------|--------------------|-------------------|--------------------|--------------------|--------------------|
| Peromyscus melanophrys | Peromyscus_melanophrys | Peromyscus | melanophrys | -0.490526050918862 | -2.29797595130779 | 2.11160930871023   | -0.430962443007775 | 0.50344941399482   |
| Peromyscus nasutus     | Peromyscus_nasutus     | Peromyscus | nasutus     | -0.781036682214806 | 1.40044764539878  | -0.209455037987789 | -0.935971109894094 | -0.366825311604144 |
| Peromyscus schmidlyi   | Peromyscus_schmidlyi   | Peromyscus | schmidlyi   | -2.51591860901864  | -0.23778409071267 | -1.1462302628069   | 0.0739518575091712 | 0.107382290698513  |
| Peromyscus melanotis   | Peromyscus_melanotis   | Peromyscus | melanotis   | 1.37170335168867   | 1.44752591932182  | -0.12263680063621  | -0.552935232650411 | 1.27964207296267   |
| Liomys pictus          | Liomys_pictus          | Liomys     | pictus      | -0.575792000674879 | -1.22862981043979 | 0.400478776675252  | -2.41569084734938  | 0.184892341645976  |
| Baiomys musculus       | Baiomys_musculus       | Baiomys    | musculus    | 0.876058186669997  | 0.411338959287477 | -1.71683685761396  | -0.333207472623785 | 0.23739134255065   |

# Complete NA values in one column with data from another column

If we have a column with gaps, and we want to replace these missing values with values from another columnn in the same table, we can use an _ifelse_ statement to find NA values and replace them with the value on the same row but for a different column. 

I often use this when working with body mass data from various sources.


{% highlight r %}
mice <- data.frame(spNames=c("Peromyscus_melanophrys","Peromyscus_nasutus",
                             "Peromyscus_schmidlyi","Peromyscus_melanotis",
                             "Liomys_pictus","Baiomys_musculus"),
                   Genus=c(rep("Peromyscus",4),"Liomys","Baiomys"),
                   spEpithet=c("melanophrys","nasutus","schmidlyi","melanotis",
                               "pictus","musculus"),
                   tailLength= c(90,NA,NA,123,NA,60),
                   tailLengthNew = c(92,100,119,144,89,68))
{% endhighlight %}

| spNames                | Genus      | spEpithet   | tailLength | tailLengthNew |
|------------------------|------------|-------------|------------|---------------|
| Peromyscus_melanophrys | Peromyscus | melanophrys | 90         | 92            |
| Peromyscus_nasutus     | Peromyscus | nasutus     | NA         | 100           |
| Peromyscus_schmidlyi   | Peromyscus | schmidlyi   | NA         | 119           |
| Peromyscus_melanotis   | Peromyscus | melanotis   | 123        | 144           |
| Liomys_pictus          | Liomys     | pictus      | NA         | 89            |
| Baiomys_musculus       | Baiomys    | musculus    | 60         | 68            |


{% highlight r %}

# a new variable with the gaps filled in
mice$tailLengthBoth <- ifelse (test=is.na(mice$tailLength),
                               yes = mice$tailLengthNew, no= mice$tailLength )
{% endhighlight %}

| spNames                | Genus      | spEpithet   | tailLength | tailLengthNew | tailLengthBoth |
|------------------------|------------|-------------|------------|---------------|----------------|
| Peromyscus_melanophrys | Peromyscus | melanophrys | 90         | 92            | 90             |
| Peromyscus_nasutus     | Peromyscus | nasutus     | NA         | 100           | 100            |
| Peromyscus_schmidlyi   | Peromyscus | schmidlyi   | NA         | 119           | 119            |
| Peromyscus_melanotis   | Peromyscus | melanotis   | 123        | 144           | 123            |
| Liomys_pictus          | Liomys     | pictus      | NA         | 89            | 89             |
| Baiomys_musculus       | Baiomys    | musculus    | 60         | 68            | 60             |


# Count how many of each

We often need to group our data and count how many instances we have of each group.

{% highlight r %}
mice <- data.frame(spNames=c("Peromyscus_melanophrys","Peromyscus_nasutus",
                             "Peromyscus_schmidlyi","Peromyscus_melanotis",
                             "Liomys_pictus","Baiomys_musculus"),
                   Genus=c(rep("Peromyscus",4),"Liomys","Baiomys"),
                   spEpithet=c("melanophrys","nasutus","schmidlyi","melanotis",
                               "pictus","musculus"))
                               
# this gives us a nice table of how many in each group
mice %>% count(Genus)
# this adds a new variable with the count data
mice %>% group_by(Genus) %>% mutate(howMany=n())
        
{% endhighlight %}

Output from the _count_ function

|    Genus   | n |
|:----------:|:-:|
|   Baiomys  | 1 |
|   Liomys   | 1 |
| Peromyscus | 4 |

Using mutate and the _n()_ alternative to _count()_


| spNames                | Genus      | spEpithet   |  howMany |
|------------------------|------------|-------------|----------|
| Peromyscus_melanophrys | Peromyscus | melanophrys |  4       |
| Peromyscus_nasutus     | Peromyscus | nasutus     |  4       |
| Peromyscus_schmidlyi   | Peromyscus | schmidlyi   | 4        |
| Peromyscus_melanotis   | Peromyscus | melanotis   |  4       |
| Liomys_pictus          | Liomys     | pictus      |  1       |
| Baiomys_musculus       | Baiomys    | musculus    |  1       |

That's it for now, I'll post five more next month. If there is any mistake in the code please let me know. I hope this helps.
