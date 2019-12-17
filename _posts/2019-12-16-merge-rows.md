---
layout: post
title: Merging rows in R
excerpt: "Verb-like function to identify and merge rows using R"
category: rstats
tags: 
  - merging
  - dplyr
  - tidyr
  - tidyeval
image: 
  feature: featurepls.png
published: false
---

Recently, I was tagged in a tweet seeking advice for rectangling a particularly messy data structure.  

<blockquote class="twitter-tweet" data-dnt="true"><p lang="en" dir="ltr">depending on whether they need to procrastinate on something even more odious, I could imagine <a href="https://twitter.com/nacnudus?ref_src=twsrc%5Etfw">@nacnudus</a> or <a href="https://twitter.com/LuisDVerde?ref_src=twsrc%5Etfw">@LuisDVerde</a> getting sucked in by certain aspects of this 😉</p>&mdash; Jenny Bryan (@JennyBryan) <a href="https://twitter.com/JennyBryan/status/1204242138357096449?ref_src=twsrc%5Etfw">December 10, 2019</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

The data in question and a nice way to restructure them are found in this [gist](https://gist.github.com/brooke-watson/ccf3d1b1f4449ab55a72f7835a52e599). I could not come up with a general approach, but there were several helpful solutions in the replies to the tweet, This data structure is now described as an [issue](https://github.com/nacnudus/unpivotr/issues/31) in the `unpivotr` repository by Duncan Garmonsway.

Although there wasn't much I could do, I noted that the data had two issues relevant to my work with the `unheadr` [package](https://github.com/luisDVA/unheadr/). 

- small multiples (subsets of the same data stacked on top of each other)
- broken rows (values of two contiguous rows broken up and padded with empty or NA values)

<img src="https://pbs.twimg.com/media/ELY0RkBWwAAGrJv?format=png&name=900x900" alt="star wars mess" width="300"/>

These data helped me complete work on a function to merge rows in a data frame. The `unbreak_rows()` function is now part of `unheadr`. Essentially, rows (or sets of rows) that can be identified with a regular expression in any of the columns are merged into a single row. The values of the lagging rows are pasted onto the values in the leading row, whitespace is squished, and the lagging row is dropped.

Let's try it out with an example using made up data about basketball records for different players and seasons.

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> v1 </th>
   <th style="text-align:left;"> v2 </th>
   <th style="text-align:left;"> v3 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Player </td>
   <td style="text-align:left;"> Most points </td>
   <td style="text-align:left;"> Season </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> in a game </td>
   <td style="text-align:left;"> (year ending) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sleve McDichael </td>
   <td style="text-align:left;"> 55 </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Dean Wesrey </td>
   <td style="text-align:left;"> 43 </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Karl Dandleton </td>
   <td style="text-align:left;"> 41 </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Most varsity </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> games played </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mike Sernandez </td>
   <td style="text-align:left;"> 111 </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Glenallen Mixon </td>
   <td style="text-align:left;"> 109 </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rey McSriff </td>
   <td style="text-align:left;"> 104 </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> Most rebounds </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> in a game </td>
   <td style="text-align:left;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kevin Nogilny </td>
   <td style="text-align:left;"> 24 </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Karl Dandleton </td>
   <td style="text-align:left;"> 21 </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Todd Bonzalez </td>
   <td style="text-align:left;"> 21 </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
</tbody>
</table>

This table has header rows embedded in the data, and for whatever reason the values are broken into separate cells. 
In this case, the variable `v2` has a repeating pattern ("Most...") that can be matched multiple times to identify the broken rows.

Let's see:

{% highlight r %}
# remotes::install_github("luisDVA/unheadr") # for the latest version
library(unheadr)
library(dplyr)
library(tidyr)
library(purrr)

# set up the data
bball2 <-
  data.frame(
    stringsAsFactors = FALSE,
    v1 = c(
      "Player", NA, "Sleve McDichael", "Dean Wesrey",
      "Karl Dandleton", NA, NA, "Mike Sernandez",
      "Glenallen Mixon", "Rey McSriff", NA, NA, "Kevin Nogilny",
      "Karl Dandleton", "Todd Bonzalez"
    ),
    v2 = c(
      "Most points", "in a game", "55", "43", "41", "Most varsity",
      "games played", "111", "109", "104",
      "Most rebounds", "in a game", "24", "21", "21"
    ),
    v3 = c(
      "Season", "(year ending)", "2001", "2000", "2002", NA, NA,
      "2000", "2002", "2001", NA, NA, "2002", "2000",
      "2001"
    )
  )
  
{% endhighlight %}

Unbreaking the rows 

{% highlight r %}
unbreak_rows(tibble::as_tibble(bball2), "^Most", v2)
{% endhighlight %}

Gives us this:

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> v1 </th>
   <th style="text-align:left;"> v2 </th>
   <th style="text-align:left;"> v3 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Player </td>
   <td style="text-align:left;"> Most points in a game </td>
   <td style="text-align:left;"> Season (year ending) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sleve McDichael </td>
   <td style="text-align:left;"> 55 </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Dean Wesrey </td>
   <td style="text-align:left;"> 43 </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Karl Dandleton </td>
   <td style="text-align:left;"> 41 </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Most varsity games played </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mike Sernandez </td>
   <td style="text-align:left;"> 111 </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Glenallen Mixon </td>
   <td style="text-align:left;"> 109 </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rey McSriff </td>
   <td style="text-align:left;"> 104 </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> Most rebounds in a game </td>
   <td style="text-align:left;">  </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kevin Nogilny </td>
   <td style="text-align:left;"> 24 </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Karl Dandleton </td>
   <td style="text-align:left;"> 21 </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Todd Bonzalez </td>
   <td style="text-align:left;"> 21 </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
</tbody>
</table>

It may be a good idea to fill in the empty subheaders. This approach uses `mutate_all()` to conditionally replace the empty values in each column with the value in the first row.
{% highlight r %}
unbreak_rows(tibble::as_tibble(bball2), "^Most", v2) %>%
  mutate_all(., ~ ifelse(. == "", .[1], .))
{% endhighlight %}

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> v1 </th>
   <th style="text-align:left;"> v2 </th>
   <th style="text-align:left;"> v3 </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Player </td>
   <td style="text-align:left;"> Most points in a game </td>
   <td style="text-align:left;"> Season (year ending) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sleve McDichael </td>
   <td style="text-align:left;"> 55 </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Dean Wesrey </td>
   <td style="text-align:left;"> 43 </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Karl Dandleton </td>
   <td style="text-align:left;"> 41 </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Player </td>
   <td style="text-align:left;"> Most varsity games played </td>
   <td style="text-align:left;"> Season (year ending) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mike Sernandez </td>
   <td style="text-align:left;"> 111 </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Glenallen Mixon </td>
   <td style="text-align:left;"> 109 </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rey McSriff </td>
   <td style="text-align:left;"> 104 </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Player </td>
   <td style="text-align:left;"> Most rebounds in a game </td>
   <td style="text-align:left;"> Season (year ending) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kevin Nogilny </td>
   <td style="text-align:left;"> 24 </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Karl Dandleton </td>
   <td style="text-align:left;"> 21 </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Todd Bonzalez </td>
   <td style="text-align:left;"> 21 </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
</tbody>
</table>

To rectangle this set of small multiples, this next approach tags each one (type of sporting record) so they can be grouped and split for iterative cleaning of the variable names before a final join.

{% highlight r %}
unbreak_rows(tibble::as_tibble(bball2), "Most", v2) %>%
  mutate_all(., ~ ifelse(. == "", .[1], .)) %>%
  mutate(award_label = ifelse(stringr::str_detect(v2, "^Most"), 1:1000, NA)) %>%
  fill(award_label) %>%
  group_split(award_label) %>%
  map(select, -award_label) %>%
  map(~ setNames(.x, .x[1, ])) %>%
  map(slice, -1) %>%
  reduce(full_join) %>%
  select(-`Season (year ending)`, everything())
{% endhighlight %}

A tidier version of the data:

<table class="table" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Player </th>
   <th style="text-align:left;"> Most points in a game </th>
   <th style="text-align:left;"> Most varsity games played </th>
   <th style="text-align:left;"> Most rebounds in a game </th>
   <th style="text-align:left;"> Season (year ending) </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sleve McDichael </td>
   <td style="text-align:left;"> 55 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Dean Wesrey </td>
   <td style="text-align:left;"> 43 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Karl Dandleton </td>
   <td style="text-align:left;"> 41 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mike Sernandez </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 111 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Glenallen Mixon </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 109 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rey McSriff </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 104 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kevin Nogilny </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 24 </td>
   <td style="text-align:left;"> 2002 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Karl Dandleton </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 21 </td>
   <td style="text-align:left;"> 2000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Todd Bonzalez </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:left;"> 21 </td>
   <td style="text-align:left;"> 2001 </td>
  </tr>
</tbody>
</table>



