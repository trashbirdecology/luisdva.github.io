---
title: "Tidy tables for collections-based research (Part 2)"
layout: post
excerpt: Wrangling commonly-used data formats. Part 2 - Compound values.
category: rstats
tags:
  - separate
  - gather
  - dplyr
  - tidyr
  - melt
image:
  feature: featureCollsRes.jpg
  credit: Oxford Museum of Natural History CC0 public domain image from Pixabay
  creditlink:
published: true
---

This is Part Two (of many) in series of posts will go through some simple steps to wrangle the data that is often provided as part of collections-based studies. Data wrangling involves importing, cleaning, and transforming raw data into useful information that is ready for analysis. It is a time-consuming process, so having a reusable and flexible suite of scripts and code can really save us time in the long run. 

> for Part 1 click [here](http://luisdva.github.io/rstats/collections-based1/).

This post is on handling multispecies tables of species trait values in which two related values appear together in the same observation or ‘cell’. For example: showing original and transformed values together using some form of punctuation or special character to separate the different values. This saves space when presenting tables in publications and is relatively common in comparative datasets, but if we only want to work with one of the two values that appear together we need to separate them first.

As I work my way through the tables and appendices of various rodent phylogeny/morphology papers, I’ll continue to post more of the R code that has saved me lots of time by not having to edit large datasets by hand. This series of posts are a medium for me to document my code in a way that may help others, and not at all a critique of how different authors present their data, which in many cases is influenced by space restrictions from the journals.

For this post, I wanted to tidy up a simple table in [this](http://onlinelibrary.wiley.com/doi/10.1111/j.1095-8312.2008.01057.x/abstract) paper from 2008 by Lessa et al. on the morphological evolution of caviomorph rodents. The table contains discretised values and the original data used to derive them helpfully placed next to each value in parentheses. The table actually looks pretty crisp in the PDF version of the paper, but this format is not the best in case we want to work with the values directly.

A subset of the data showing the issues that need to be wrangled:

|           Taxa          	| 1. Burrow structure 	| 2. Deltoid process 	| 3. Epicondylar width 	|
|:-----------------------:	|:-------------------:	|:------------------:	|:--------------------:	|
|  Octodontomys gliroides 	|          2          	|      1 (0.33)      	|       1 (0.24)       	|
|      Octomys mimax      	|          2          	|        1 (*)       	|       1 (0.22)       	|
|   Eucelophorus zaratei  	|          ?          	|        2 (†)       	|         1 (†)        	|
| Xenodontomys ellipticus 	|          ?          	|          ?         	|           ?          	|
| Praectenomys rhombidens 	|          ?          	|        2 (‡)       	|         1 (‡)        	|
|   Proechimys poliopus   	|          1          	|          1         	|           1          	|

Simple enough, but notice that:
- not all the variables have compound values
- there are missing values in some observations
- there are special characters instead of values in some cases (these are used to explain data sources in the table caption) 

Let’s load a few packages and set up the example data. This is how the table looked after reading in a csv file created directly from the html version of the paper.

{% highlight r %}
# load packages
# install first if you don't have them already
library(tidyverse)
library(janitor)
library(stringi)
library(magrittr)

# set up example data
lessa08 <- data.frame(
              Taxa = c("Octodontomys gliroides", "Octomys mimax", 
                        "Eucelophorus zaratei", "Xenodontomys ellipticus", "Praectenomys rhombidens", 
                          "Proechimys poliopus"), 
              X1..Burrow.structure = c("2", "2", "?", "?", "?", "1"), 
              X2..Deltoid.process = c("1 (0.33)", "1 (*)", "2 (†)", "?", "2 (‡)", "1"), 
              X3..Epicondylar.width = c("1 (0.24)", "1 (0.22)", "1 (†)", "?", "1 (‡)", "1"))
{% endhighlight %}

The output.

{% highlight text %}
                     Taxa X1..Burrow.structure X2..Deltoid.process X3..Epicondylar.width
1  Octodontomys gliroides                    2            1 (0.33)              1 (0.24)
2           Octomys mimax                    2               1 (*)              1 (0.22)
3    Eucelophorus zaratei                    ?               2 (†)                 1 (†)
4 Xenodontomys ellipticus                    ?                   ?                     ?
5 Praectenomys rhombidens                    ?               2 (‡)                 1 (‡)
6     Proechimys poliopus                    1                   1                     1
{% endhighlight %}

We can start by replacing the question marks for the missing values with _NA_. Then cleaning up the variable names. The spaces in these names get garbled when importing the data, and a prefix was added automatically because variable names aren’t originally allowed to start with a number. With the _janitor_ package and then some regex we can clean up the spaces and prefixes in the column names. 

{% highlight r %}
# replace question marks with NA
## remember to escape the question mark
lessa08 %<>% mutate_all(funs(gsub("\\?",NA,.)))

# clean up the variable names
lessa08 %<>% clean_names()

# use regex to remove the prefix in the variable names
## match until the first occurrence of the underscore
### ( ) capture the expression inside the parentheses
### ^ match start of line
### .* match anything, ? non-greedily until the underscore
names(lessa08) %<>% stri_replace_first_regex("^(.*?)_","")
{% endhighlight %}

With clean variable names

{% highlight text %}
                     taxa burrow_structure deltoid_process epicondylar_width
1  Octodontomys gliroides                2        1 (0.33)          1 (0.24)
2           Octomys mimax                2           1 (*)          1 (0.22)
3    Eucelophorus zaratei             <NA>           2 (†)             1 (†)
4 Xenodontomys ellipticus             <NA>            <NA>              <NA>
5 Praectenomys rhombidens             <NA>           2 (‡)             1 (‡)
6     Proechimys poliopus                1               1                 1
{% endhighlight %}

To split the compound values easily, we can melt the data into long form using _tidyr_ to gather the columns with the species traits into a key-value pair. The Key will be the variable name and the Value the species trait value. 

{% highlight r %}
# before separating
## melt into long form
lessa08 %<>% gather(varname,value,-taxa)
{% endhighlight %}

The first few lines look like this:

{% highlight text %}
> head(lessa08)
                     taxa          varname value
1  Octodontomys gliroides burrow_structure     2
2           Octomys mimax burrow_structure     2
3    Eucelophorus zaratei burrow_structure  <NA>
4 Xenodontomys ellipticus burrow_structure  <NA>
5 Praectenomys rhombidens burrow_structure  <NA>
6     Proechimys poliopus burrow_structure     1
{% endhighlight %}

We can now split the Value column to get the discrete and raw/original values into separate columns. Here the separator is simply the space between the two. The new variable with the original species trait values has some special characters that we can clean up with regex before converting to numeric.

{% highlight r %}
# separate values
lessa08 %<>% separate(value,c("discrete","original"),sep=" ")
# clean up the original values column
# regex keeps only numbers and periods (for decimals)
lessa08$original %<>% stri_replace_all_regex(.,"[^0-9.]","") %>% as.numeric(.)
{% endhighlight %}

{% highlight text %}
> head(lessa08)
                     taxa          varname discrete original
1  Octodontomys gliroides burrow_structure        2       NA
2           Octomys mimax burrow_structure        2       NA
3    Eucelophorus zaratei burrow_structure     <NA>       NA
4 Xenodontomys ellipticus burrow_structure     <NA>       NA
5 Praectenomys rhombidens burrow_structure     <NA>       NA
6     Proechimys poliopus burrow_structure        1       NA
{% endhighlight %}

To change the data back from wide to long form, I figured it was simpler to do one variable type (discrete/original) at a time. This makes it easier to add a suffix that identifies variables as discrete or original before joining everything.

{% highlight r %}
# discrete values for each variable
lessa08disc <- lessa08 %>% select(-original) %>%  
  spread(varname,discrete)
# add a suffix to the var names
## using some indexing on the names to avoid modifying the taxa column
names(lessa08disc)[-1] %<>% paste0("_disc")

# original values for each variable
lessa08og <- lessa08 %>% select(-discrete) %>%  
  spread(varname,original)
# add a suffix to the var names
## using some indexing on the names to avoid modifying the taxa column
names(lessa08og)[-1] %<>% paste0("_og")
# join original and discrete and arrange the columns
lessa08 <- left_join(lessa08disc,lessa08og) %>% select(taxa,order(colnames(.)))
{% endhighlight %}

Here’s another way of looking at the new data frames. This is for the discrete values.

{% highlight text %}
> glimpse(lessa08disc)
Observations: 6
Variables: 4
$ taxa                   <chr> "Eucelophorus zaratei", "Octodontomys gliroides", "Octo...
$ burrow_structure_disc  <chr> NA, "2", "2", NA, "1", NA
$ deltoid_process_disc   <chr> "2", "1", "1", "2", "1", NA
$ epicondylar_width_disc <chr> "1", "1", "1", "1", "1", NA
{% endhighlight %}

After joining the separate data frames for the different variables, the final table is ready for analysis. For example: if we want to subset the table to keep only the original data, we can use the convenience and power of dpylr’s _select()_ and the _contains_ argument to only keep columns that contain a specific string.

{% highlight r %}
# example
# for subsetting only the discrete vals
lessa08 %>% select(taxa,contains('disc'))
{% endhighlight %}

The subset:

{% highlight text %}
> glimpse(lessa08)
Observations: 6
Variables: 7
$ taxa                   <chr> "Eucelophorus zaratei", "Octodontomys gliroides", "Octomys mimax", "Praectenomys r...
$ burrow_structure_disc  <chr> NA, "2", "2", NA, "1", NA
$ burrow_structure_og    <dbl> NA, NA, NA, NA, NA, NA
$ deltoid_process_disc   <chr> "2", "1", "1", "2", "1", NA
$ deltoid_process_og     <dbl> NA, 0.33, NA, NA, NA, NA
$ epicondylar_width_disc <chr> "1", "1", "1", "1", "1", NA
$ epicondylar_width_og   <dbl> NA, 0.24, 0.22, NA, NA, NA
{% endhighlight %}

Simple enough, but I have the feeling that I’ll be using this code to clean up the tables of several papers in the near future. 
