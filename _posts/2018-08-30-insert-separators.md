---
title: "Unnesting unsplittable strings"
layout: post
excerpt: Tidyng human-readable data by inserting suitable separators.
category: rstats
tags:
  - dplyr
  - tidyr
  - pdf
  - regex
image:
  feature: 
  credit: 
  creditlink: 
published: false
---

Here’s another quick post about turning human-readable data into something we can actually work with. 


For my research, I was cleaning some data about rodent specimens from different sites examined in [this](https://academic.oup.com/zoolinnean/article/155/1/220/2674296#81542563) publication by Araujo Fernandes et al (2009). Once I had managed to read the table into R, I recognized  the various little tricks commonly used to condense information and save space on a table without losing meaning. 

This is what the first few entries of the table look like.

fig

We are interested in the last column “Sex and collection number”. Two different variables have been condensed in a single column, but that’s fine because there are consistent delimiters and separators. Also, consecutive numbers have been shortened to imply a sequence. 

The trickiest part are the specimen ID values. These are made up of an acronym and a number, and in this case the collection IDs appear as wrapped inline text for each sampling location. When specimens from a single location come from more than one collection, there is no explicit separator, but we can tell that the ID numbers correspond to the collection that precede them until we see a new acronym that implies otherwise. None of this is explained in the table caption, but this is a common convention and it’s mostly self-explanatory.  


fig

The non-delimited collection acronyms are the obvious challenge here. I had encountered this issue before, and I always gave up and solved this through laborious manual editing. Now that I found an adequate solution, I’m using this post to share it and to document my progress with using tidyr and with writing regular expressions (instead of my previous method of blindly copying regex from StackOverflow and hoping it works).

Let’s load the required packages and set up a subset of the data for this demo:

code


First we can put the values of the sex variable into their own column, by splitting and unnesting and then separating on the existing delimiter.

code

We’re making progress, but we cannot do an further unnesting until we deal with the rows that have more than one collection.

Table


 



This is where the regex magic comes in, we can use a lookbehind and a backreference in the replacement argument to insert a new delimiter before all the instances of uppercase characters at a word boundary (i.e. the collection acronyms).

code, table

Now we can unnest the collections using these new delimiters

code, table

Afterwards, we can put the collection acronyms into a new variable and unnest the specimens (this part is a little hacky but it works).

code, table

The last issue are the series specimens with consecutive ID numbers. We need to expand these series before unnesting. I wrote a little function to do this and vectorized it to work inside mutate. Once the series are expanded into a delimited string we can finally unnest the specimens.



Now we can work with the 68 specimens originally mashed into six rows, one for each of the municipalities. We can get some summary data easily with this long-form tidy data model. For example: a tally of how many specimens of each sex there are from each location.
