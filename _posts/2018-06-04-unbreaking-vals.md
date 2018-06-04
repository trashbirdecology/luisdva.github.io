---
title: "Unbreaking values with R"
layout: post
excerpt: Wrangling grouped data with broken values and NA/empty rows per variable per group. 
category: rstats
tags:
  - unbreak
  - tidy eval
  - merged cells
  - pdf table hell
  - dplyr
image:
  feature: featureUnbrk.png
  credit: CC2.0, photo by Emmanuel Milou
  creditlink: 
published: true
---

The example below shows some data for three players on the 1999 New York Knicks roster. Tables often look like this one in reports, books, or publications. 

<figure>
    <a href="/images/knicks.png"><img src="/images/knicks.png"></a>
        <figcaption></figcaption>
</figure>

The table actually looks nice: it has merged cells, custom borders and lines, and some values for are wrapped across multiple lines so that everything is easy to read and fits on a sheet of paper or a computer screen. I often come across tables like this in the PDFs of relatively old scientific papers, and the trouble starts when I want to read or import the data from these tables into something more structured and manageable.

 Without cell merging, the data tends to look like this:
 
|player           | listed_height_m.|teams_chronological |position       |
|:----------------|----------------:|:-------------------|:--------------|
|Marcus Camby     |             2.11|Raptors             |Power forward  |
|NA               |               NA|Knicks              |Center         |
|NA               |               NA|Nuggets             |NA             |
|NA               |               NA|Clippers            |NA             |
|NA               |               NA|Trail Blazers       |NA             |
|NA               |               NA|Rockets             |NA             |
|NA               |               NA|Knicks              |NA             |
|Allan Houston    |             1.98|Pistons             |Shooting guard |
|NA               |               NA|Knicks              |NA             |
|Latrell Sprewell |             1.96|Warriors            |Small forward  |
|NA               |               NA|Knicks              |NA             |
|NA               |               NA|Timberwolves        |NA             |

There is an inconsistent number of empty or NA values padding out the vertical space in some of the columns. Lately I’ve had to ‘unbreak’ the values in these types of tables and get rid of all the unnecessary NAs before doing any further wrangling. I’ve written about unbreaking values in the [past](https://luisdva.github.io/rstats/Tidyeval-pdf-hell/){:target="_blank"}, but that approach was tailored for a very specific use case and not very flexible. I was getting nowhere until I found this post by [Mark Needham](https://twitter.com/markhneedham){:target="_blank"} about [squashing multiple rows per group into one](https://markhneedham.com/blog/2015/06/27/r-dplyr-squashing-multiple-rows-per-group-into-one/){:target="_blank"}. 

Mark’s post took advantage of how _dplyr::summarize()_ reduces multiple values down to a single value, and fed this output into the _paste()_ function. My sneaky upgrade to his post was to first sort out a grouping variable, and then use _summarize\_all()_ to summarize multiple columns, using an _na.omit()_ call to get rid of the NA values. Thanks to _tidyeval_, I was able to write this into a function that has saved me lots of time. 

Let’s check it out, using the example from before.

**Set up the data**
{% highlight r %}
# load all the necessary packages
library(dplyr)
library(tibble)
library(rlang)
library(tidyr)
# set up the data
nyk <- tribble(
                                          ~player, ~listed_height_m., ~teams_chronological,           ~position,
                                   "Marcus Camby",               2.11,              "Raptors",  "Power forward",
                                               NA,                 NA,               "Knicks",         "Center",
                                               NA,                 NA,              "Nuggets",               NA,
                                               NA,                 NA,             "Clippers",               NA,
                                               NA,                 NA,        "Trail Blazers",               NA,
                                               NA,                 NA,              "Rockets",               NA,
                                               NA,                 NA,               "Knicks",               NA,
                                  "Allan Houston",               1.98,              "Pistons", "Shooting guard",
                                               NA,                 NA,               "Knicks",               NA,
                               "Latrell Sprewell",               1.96,             "Warriors",  "Small forward",
                                               NA,                 NA,               "Knicks",               NA,
                                               NA,                 NA,         "Timberwolves",               NA
                               )

{% endhighlight %}

The tibble formatting in RStudio shows the NA mess. 

<figure>
    <a href="/images/knickstibb.png"><img src="/images/knickstibb.png"></a>
        <figcaption></figcaption>
</figure>

For _summarize()_ to work on grouped data, we use _tidyr::fill()_ to populate missing values in a column with the previous entry until the value changes.

{% highlight r %}
nyk %>% fill(player)
{% endhighlight %}

{% highlight text%}
# A tibble: 12 x 4
   player           listed_height_m. teams_chronological position      
   <chr>                       <dbl> <chr>               <chr>         
 1 Marcus Camby                 2.11 Raptors             Power forward 
 2 Marcus Camby                NA    Knicks              Center        
 3 Marcus Camby                NA    Nuggets             NA            
 4 Marcus Camby                NA    Clippers            NA            
 5 Marcus Camby                NA    Trail Blazers       NA            
 6 Marcus Camby                NA    Rockets             NA            
 7 Marcus Camby                NA    Knicks              NA            
 8 Allan Houston                1.98 Pistons             Shooting guard
 9 Allan Houston               NA    Knicks              NA            
10 Latrell Sprewell             1.96 Warriors            Small forward 
11 Latrell Sprewell            NA    Knicks              NA            
12 Latrell Sprewell            NA    Timberwolves        NA            

{% endhighlight %}

This structure is ready for the _summarize\_all()_ approach

{% highlight r %}
nyk %>% fill(player) %>% 
        group_by(player) %>% 
        summarize_all(funs(paste(na.omit(.), collapse=", ")))
{% endhighlight %}

{% highlight text %}
# A tibble: 3 x 4
  player           listed_height_m. teams_chronological                    position     
  <chr>            <chr>            <chr>                                  <chr>        
1 Allan Houston    1.98             Pistons, Knicks                        Shooting gua~
2 Latrell Sprewell 1.96             Warriors, Knicks, Timberwolves         Small forward
3 Marcus Camby     2.11             Raptors, Knicks, Nuggets, Clippers, T~ Power forwar~
{% endhighlight %}

It works!

Now let’s write that into a function that takes in the data, the name of the grouping variable, and whatever we want to use to separate the pasted values (i.e. the _collapse_ argument).

{% highlight r %}
unwrap_cols <- function(df,groupingVar,separator){
    groupingVar <- enquo(groupingVar)
      
    df %>% 
      fill(!!groupingVar) %>% 
      group_by(!!groupingVar) %>% 
      summarise_all(funs(paste(na.omit(.), collapse=separator)))
  }  

nyk %>% unwrap_cols(groupingVar = player, separator = ", ")
{% endhighlight %}
Using the function should give us the same output as before.
{% highlight r %}
nyk %>% unwrap_cols(groupingVar = player, separator = ", ")
{% endhighlight %}

{% highlight text %}
# A tibble: 3 x 4
  player           listed_height_m. teams_chronological                    position     
  <chr>            <chr>            <chr>                                  <chr>        
1 Allan Houston    1.98             Pistons, Knicks                        Shooting gua~
2 Latrell Sprewell 1.96             Warriors, Knicks, Timberwolves         Small forward
3 Marcus Camby     2.11             Raptors, Knicks, Nuggets, Clippers, T~ Power forwar~
{% endhighlight %}


I’m not referring to this as squashing or squishing because those terms are already used in other packages and they mean different things. I´ll stick with unbreaking. Note that _stri\_wrap()_ from the _stringi_ package does more or less the opposite of this. Finally, this also works with blank values, we just need to replace empty with NA. 

Let me know if you find this useful, or if anything is working as advertised. Thanks for reading.
