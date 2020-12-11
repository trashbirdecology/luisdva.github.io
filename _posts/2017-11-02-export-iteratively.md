---
title: "Apply functions to grouped data and write each element to disk"
excerpt: Split a table by a grouping variable, apply functions to each element, and export to separate files. 
classes: wide
category: rstats
tags:
  - dplyr
  - each element
  - walk
  - purrr
header:
  image: /assets/images/featureRish.jpg
---

## May-2019: Updated again to keep up with changes to the _group\_map_ function in _dplyr_ 0.8.1.  
### Dec-2018: Updated the code in this post to use functions from _dplyr_ 0.8.0 and a tidier approach in general. Read more about this upcoming release [here](https://www.tidyverse.org/articles/2018/12/dplyr-0-8-0-release-candidate/). 

After running some data wrangling demo sessions with my research group, a lab mate emailed me with the following question:

> “I have a table with almost 20000 point occurrence records for bats in Peru. I need to split this into separate files for each species, keeping only distinct records (distinct latitude/longitude combinations).”

The only time I ever did something like that before I ended up cutting and pasting the records for each group by hand in Excel. I generally use one input file and one output file at a time, but this sounded like something that could be done in R.

Grouping data and removing duplicated rows is straightforward using _dplyr_, so the challenge would be to split the groups and apply functions to each one before finally exporting them as separate files. I’ve been getting into the _purrr_ package for iterating over lists and vectors, and after lots of trial and error all the steps worked out OK.

For this post, I’ll go over the steps for splitting a table by a grouping variable, then applying functions to each element created by the split, which are then exported to separate files. 

This example uses a random subsample of some point occurrence records for bats that I downloaded from the Universidad Nacional Autonóma de México (UNAM) [Open Data portal](https://datosabiertos.unam.mx/).

With the code below, we are going to:

- keep only the complete cases
- split the dataset by taxonomic families
- remove duplicates in each family (note the keep_all argument)
- export the table for each family as a csv file

{% highlight r %}
# load libraries
library(dplyr)  
library(purrr)
library(tidyr)
library(readr)

# read csv from web
batRecs <- read.csv("https://raw.githubusercontent.com/luisDVA/codeluis/master/batRecords.csv",stringsAsFactors = FALSE)

# preview how many files we should be ending up with
batRecs %>% count(family)


# drop na, split, remove duplicates, write to disk
batRecs %>%  drop_na() %>% 
  group_by(family) %>% group_map(~distinct(.x,decimal_latitude,decimal_longitude,.keep_all=TRUE),keep = TRUE) %>% 
  walk(~.x %>%  write_csv(path = paste0("dec_",unique(.x$family),".csv")))
{% endhighlight %}

We use _group\_by_ and _group\_map_ to create a grouped tibble and apply functions to each group. _group\_map_ returns a list, so we can use _paste0_ to create a path for each file to be written, including a custom prefix. In this case, the five new files (one for each bat family) will end up in the working directory, but if we want to do this with more files and dedicated directories then using the _here_ and _glue_ packages is probably a good idea. Note the _keep_ argument for _group\_map_, which we set to TRUE so that the grouping variable isn't discarded. 

I’m using _walk_ because _write\_csv_ returns nothing and writes csv files as a side effect, and as explained in the documentation, _walk_ calls functions for their side effects.   

Because I was so excited about actually getting everything to work, I put together this cheatsheet-style graphic to describe the workflow. This approach already saved me and my labmate lots of time. I hope others find it useful too. 

<figure>
    <a href="/assets/images/purrrPost.png"><img src="/assets/images/purrrPost.png"></a>
        <figcaption>somewhat out of date now</figcaption>
</figure>

