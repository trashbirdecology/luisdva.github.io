---
title: "Reshaping and tidying data from awkward spreadsheet formats"
layout: post
excerpt: Wrangle duplicated variable names, weird header rows, and footnotes.
category: rstats
tags:
  - spreadsheets
  - iterate
  - purrr
  - untangle
  - dog rescue
image:
  feature: featureAwk.jpg
  credit: LD 
  creditlink: 
published: true
---
> la versión en español de esta publicación está [aquí](http://luisdva.github.io/hojas-de-calculo-apiladas/)

The table below is a subset of data from a directory of dog rescue resources put together by [Speaking of Dogs](https://www.speakingofdogs.com/){:target="_blank"}, a volunteer-based dog rescue organization in Toronto, Canada. The information is real, but for this example I garbled the original data into a particular ‘spreadsheet’ format that I struggled with recently.  I chose this source of data in support of the Clear The H*ckin Shelters campaign happening this week (read more [here](https://www.gofundme.com/clear-the-hckin-shelters){:target="_blank"} and support dog shelters in general).

**Organization**|**Contact name**|**phone**|**website**|**Organization**|**Contact name**|**phone**|**website**
:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:
"Small Breed"| | | |"Bulldog (English)"| | | 
Happy Tails Rescue|Judy|905-357-5096|www.happytailsrescue.ca|Homeward Bound Rescue*|Kathy|905-987-1104|www.homewardboundrescue.ca
LOYAL Rescue Inc.|Anne|888-739-1221|www.loyalrescue.com|unknown|Joan†|416-738-6059 |unknown
Pomeranian and Small Breed Rescue|Shelley|416-225-6808|www.psbrescue.com|"Labrador Retriever "| | | 
Tiny Paws Rescue|Brenda|1-800-774-8315|www.tpdr.ca|Labrador Retriever Adoption Service|Laura or Karen |289-997-5227|www.lab-rescue.ca
"Senior Dogs"| | | |Dog Rescuers Inc|Joan|416-567-6249 ‡|www.thedogrescuersinc.ca
Speaking of Dogs Rescue|Lorraine|705-444-7637|www.speakingofdogs.com| | | |

Footnotes for the table:
-  \* includes other Flat faced dogs: Bulldogs, Boxers, Bostons, Pugs etc
- † limited foster care available
- ‡ phone may not be up to date

This data is not ‘analysis-ready’. Notice the three main issues that need to get sorted: 

- The table has repeated columns. It appears that the table has been split in two (vertically) and the columns are stacked side-by-side in a sort of ‘wide’ format. We don’t really want duplicated variables because having duplicated column names is a very unnatural, complicated, and risky format for keeping data.

- There are header rows sprinkled throughout the Organization column. These non-data rows are used quite often when we want to save space by having the value in one cell somehow apply to cells below (until we find the next header row used for grouping). These are easy for humans to parse, but not computers. Read more about header rows [here](http://rpubs.com/jennybc/untangle-tidyeval){:target="_blank"}.

- Some ‘cells’ have special characters, these are used to refer to footnotes/information in the table caption, but in this case we would prefer to have this information inside the data rectangle.

# rstats time

This post goes through a possible solution to reshape the table and deal with the header rows and footnotes. Make sure you have the necessary R packages installed, and once you do all the code in this block should be fully reproducible.  

Start by putting the data into a character vector by simply pasting the table, delimited by tabs and line breaks. 

{% highlight r %}
# load packages
library(dplyr)
library(magrittr)
library(tidyr)
library(rlang)
library(purrr)

# chr vector with delimited data
resc <- 
c("Organization	Contact name	phone	website	Organization	Contact name	phone	website
'Small Breed'				'Bulldog (English)'			
Happy Tails Rescue	Judy	905-357-5096	www.happytailsrescue.ca	Homeward Bound Rescue*	Kathy	905-987-1104	www.homewardboundrescue.ca
LOYAL Rescue Inc.	Anne	888-739-1221	www.loyalrescue.com	unknown	Joan†	416-738-6059 	unknown
Pomeranian and Small Breed Rescue	Shelley	416-225-6808	www.psbrescue.com	'Labrador Retriever'			
Tiny Paws Rescue	Brenda	1-800-774-8315	www.tpdr.ca	Labrador Retriever Adoption Service	Laura or Karen 	289-997-5227	www.lab-rescue.ca
'Senior Dogs'				Dog Rescuers Inc	Joan	416-567-6249‡	www.thedogrescuersinc.ca
Speaking of Dogs Rescue	Lorraine	705-444-7637	www.speakingofdogs.com")				
{% endhighlight %}

Make each line a row in a tibble, then separate into the corresponding variables (yes, they are still duplicated).

{% highlight r %}
# lines to rows
rescDF <- data_frame(unsep=unlist(strsplit(resc,"\n")))

# separate into variables (tab delimited)
rescDF %<>% separate(unsep,into=unlist(strsplit(rescDF$unsep[1],"\t")),sep ="\t")
{% endhighlight %}

Now, to stack the table into a long form. When I asked for advice on Twitter the consensus was to use the _gather_ function in _tidyr_ after sorting out the duplicated variable names (or by referring to columns by number). The sensible answer for this issue is to not have duplicated names in the first place, and there are various tools and functions for avoiding or fixing them. 

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/hashtag/rstats?src=hash">#rstats</a> crew: how can I use <a href="https://twitter.com/hashtag/purrr?src=hash">#purrr</a> to stack a &#39;wide&#39; df with duplicated variable names? <br>(I know I shouldn&#39;t have them in the first place) <a href="https://t.co/yxJoHMQ6N3">pic.twitter.com/yxJoHMQ6N3</a></p>&mdash; Luis D. Verde (@LuisDVerde) <a href="https://twitter.com/LuisDVerde/status/895439984966197249">August 10, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

However, the real world is a harsh place and duplicated variables are pretty common. I found this [post](https://stackoverflow.com/questions/38839048/r-reshape-dataframe-from-duplicated-column-names-but-unique-values){:target="_blank"} on Stack Overflow for this exact problem, and SO user _akrun_ had a pretty clever solution.
The suggestion was to:

- iterate through the unique names to extract all the observations for each variable name 
- unlist them  
- put them into a data frame (with variable names)

All I did was replace _lapply_ with _map_ and used a tibble instead of a data frame for the output because I’m in the process of learning _purrr_, and because tibbles never convert strings to factors or create row names.

{% highlight r %}
# stack into long form
rescDFstacked <- 
map(unique(names(rescDF)), ~
      unlist(rescDF[names(rescDF)==.x], use.names = FALSE)) %>% 
  as.data.frame(stringsAsFactors = FALSE) %>% 
  set_names(unique(names(rescDF)))
{% endhighlight %}

The data is looking better but we still need to sort out the awkward header rows. Fortunately, there’s a function for that. Read about it [here](http://rpubs.com/jennybc/untangle-tidyeval){:target="_blank"}. In brief, my bumbling attempt at tidy evaluation received a makeover from [Jenny Bryan](https://twitter.com/JennyBryan){:target="_blank"} and now we can define and use the _untangle2_ function.  When that happened, it was like having Xzibit knocking at my door offering to enhance my car. Since then, the _untangle2_ function has been helping me shred through other people’s data because in my field everything follows a taxonomic hierarchy and everyone likes to use header rows. I feel that _untangle_ belongs in _tidyr_, and maybe when I’m confident enough I’ll try to contribute to the _tidyverse_. 

In this table, the header rows are quoted, making for smooth untangling.

{% highlight r %}
# define untangle fn
untangle2 <- function(df, regex, orig, new) {
  orig <- enquo(orig)
  new <- sym(quo_name(enquo(new)))
  
  df %>%
    mutate(
      !!new := if_else(grepl(regex, !! orig), !! orig, NA_character_)
    ) %>%
    fill(!! new) %>%
    filter(!grepl(regex, !! orig))
}


# deal with header rows (anything quoted)
rescDFstacked %<>% untangle2("'",Organization,Category)
{% endhighlight %}

After that, there are some repeated, empty, and NA rows that need to be filtered out.

{% highlight r %}
# remove repeated, NA, and empty rows
rescDFstacked %<>% filter(Organization != "Organization" & Organization != " ", !is.na(Organization))
{% endhighlight %}

The footnotes are the last major issue. To bring them into the data rectangle, I used _case\_when_ inside _mutate_ to add the footnote text conditionally, but I’m not very happy with this approach. To figure out the columns to match with the different individual _grepl_ statements I used _map_ to iterate through the columns.

Ideally, I wanted to iterate though the special characters and the columns at the same time, because any given observation could have any combination of footnotes. I couldn’t figure out _map2_ and list columns :( 

{% highlight r %}

# bring footnotes into data rectangle
rescDFstacked %<>% mutate(observation = case_when(
  grepl("\\*",Organization)~"includes other Flat faced dogs: Bulldogs, Boxers, Bostons, Pugs etc",
  grepl("\u0086",`Contact name`)~"limited foster care available",
  grepl("\u0087",phone)~"phone may not be up to date"
  ))


# how I figured out which columns contained which special char
rescDFstacked %>% map(~grepl("\\*",.x)) %>% map(~.x[.x==TRUE]) %>% unlist() %>% names()
rescDFstacked %>% map(~grepl("\u0086",.x)) %>% map(~.x[.x==TRUE]) %>% unlist() %>% names()
rescDFstacked %>% map(~grepl("\u0087",.x)) %>% map(~.x[.x==TRUE]) %>% unlist() %>% names()

# DIDNT WORK
# map2(rescDFstacked,c("\\*","\u0086","\u0087"),~ grepl(.y,.x))
{% endhighlight %}

Because the footnotes were informative enough, we can wrap things up by removing all the special characters.

{% highlight r %}

# remove special chars
rescDFstacked %<>% mutate_all(funs(gsub("[†|‡|'|\\*]","",.)))
{% endhighlight %}

The final table looks like this:

**Organization**|**Contact name**|**phone**|**website**|**Category**|**observation**
:-----:|:-----:|:-----:|:-----:|:-----:|:-----:
Happy Tails Rescue|Judy|905-357-5096|www.happytailsrescue.ca|Small Breed|NA
LOYAL Rescue Inc.|Anne|888-739-1221|www.loyalrescue.com|Small Breed|NA
Pomeranian and Small Breed Rescue|Shelley|416-225-6808|www.psbrescue.com|Small Breed|NA
Tiny Paws Rescue|Brenda|1-800-774-8315|www.tpdr.ca|Small Breed|NA
Speaking of Dogs Rescue|Lorraine|705-444-7637|www.speakingofdogs.com|Senior Dogs|NA
Homeward Bound Rescue|Kathy|905-987-1104|www.homewardboundrescue.ca|Bulldog (English)|includes other Flat faced dogs: Bulldogs
unknown|Joan|416-738-6059 |unknown|Bulldog (English)|limited foster care available
Labrador Retriever Adoption Service|Laura or Karen |289-997-5227|www.lab-rescue.ca|Labrador Retriever|NA
Dog Rescuers Inc|Joan|416-567-6249|www.thedogrescuersinc.ca|Labrador Retriever|phone may not be up to date

That’s it. Let me know if anything isn’t working. 
For reference, the table that inspired this post was Table 2 in [this](http://onlinelibrary.wiley.com/doi/10.1111/bij.12164/abstract){:target="_blank"} 2013 paper by Alvarez et al.
