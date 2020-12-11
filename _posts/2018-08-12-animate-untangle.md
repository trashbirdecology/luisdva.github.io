---
title: "Animate your data wrangling"
excerpt:  Using gganimate to animate the data-munging process.
category: rstats
tags:
  - unheadr
  - gganimate
  - gifs
  - tile plots
header:
  image: /assets/images/featureAnimate.png
  caption: "credit: clipartXtras"
---

Yesterday I tweeted this gif showing what we can do about non-data grouping rows embedded in the data rectangle using the 'unheadr' package (we can and we should put them into their own variable in a tidier way). Please ignore the typo in the tweet. 

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">manage to animate what we can do about non-data grouping rows embedded in the data rectangle using my silly little <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a> package 📦<a href="https://t.co/QP1X6ORtH8">https://t.co/QP1X6ORtH8</a><a href="https://t.co/zJfVslUedN">https://t.co/zJfVslUedN</a> <a href="https://t.co/KnAYdSAmc7">pic.twitter.com/KnAYdSAmc7</a></p>&mdash; Luis D. Verde (@LuisDVerde) <a href="https://twitter.com/LuisDVerde/status/1028762367843291136?ref_src=twsrc%5Etfw">August 12, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

There was some interest in the code behind the animation, and I wanted to share it anyway because it’s based on actual data and I think that’s pretty cool. 

This is all made possible thanks to Thomas Lin Pedersen’s ['gganimate'](https://github.com/thomasp85/gganimate){:target="_blank"} package, a cool [usecase](https://coolbutuseless.github.io/2018/08/12/gganimate-with-bitmap-fonts/){:target="_blank"} with _geom\_tile()_ plots by [@mikefc](https://twitter.com/coolbutuseless){:target="_blank"}, and this [post](https://rpubs.com/dgrtwo/tidying-enron){:target="_blank"} by [David Robison](https://twitter.com/drob){:target="_blank"} where he melts a table into long format with indices for each row and column and a variable holding the value for each cell. 

We can use real data from this table, originally from a book chapter about rodent sociobiology by Ojeda et al. (2016). I had a PDF version of the chapter, and I got the data into R following this [post](
https://rud.is/b/2018/07/02/freeing-pdf-data-to-account-for-the-unaccounted/){:target="_blank"} by [Bob Rudis](https://twitter.com/hrbrmstr){:target="_blank"}. I highly recommend 'pdftools' and 'readr' for importing PDF tables.

The book cover.
<figure>
    <a href="/assets/images/cavioms.jpg"><img src="/assets/images/cavioms.jpg"></a>
        <figcaption>cute!</figcaption>
</figure>

The first few lines of the table looked like this, and for this demo we can just set up the data directly as a tibble.

<figure>
    <a href="/assets/images/ojedaT1.png"><img src="/assets/images/ojedaT1.png"></a>
        <figcaption>PDF table</figcaption>
</figure>

Setting up the data.
{% highlight r %}
# load libraries
library(tibble)
library(dplyr)
library(unheadr)
library(purrr)
library(gganimate)
# tibble
table1 <- tribble(
  ~Taxon,                                     ~Ecoregions,                      ~Macroniches,    ~Body_mass,
  "Erethizontidae",                                              NA,                                NA,            NA,
  "Chaetomys",                           "Atlantic Rainforest",              "Arboreal-herbivore",        "1300",
  "Coendou",                 "Atlantic Rainforest, Amazonia",   "Arboreal-frugivore, herbivore",   "4000–5000",
  "Echinoprocta",                                      "Amazonia",            "Scansorial-frugivore",         "831",
  "Erethizon", "Tundra grasslands, forests, desert scrublands",            "Scansorial-herbivore",  "5000–14000",
  "Sphiggurus",                           "Atlantic Rainforest",              "Arboreal-herbivore",   "1150–1340",
  "Chinchillidae",                                              NA,                                NA,            NA,
  "Chinchilla",                                         "Andes",            "Saxicolous-herbivore",     "390–500",
  "Lagidium",                                     "Patagonia",            "Saxicolous-herbivore",    "750–2100",
  "Lagostomus",                           "Pampas, Monte Chaco",         "Semifossorial-herbivore",   "3520–8840",
  "Dinomyidae",                                              NA,                                NA,            NA,
  "Dinomys",                                      "Amazonia", "Scansorial-frugivore, herbivore", "10000–15000",
  "Caviidae",                                              NA,                                NA,            NA,
  "Cavia",                      "Amazonia, Chaco, Cerrado",           "Terrestrial-herbivore",     "550–760"
)

{% endhighlight %}

There are grouping values for the taxonomic families that the different genera belong to, and these are interspersed within the taxon variable. All taxonomic families end with “dae”, so we can match this with regex easily. Install ‘unheadr’ from GitHub before proceeding.

{% highlight r %}
table1_tidy <- table1 %>%  untangle2("dae$",Taxon,Family) 
{% endhighlight %}

Once we have the original and ‘untangled’ version of the table, we define a function (inspired by _@drob_) to melt the data and apply it to each one.

{% highlight r %}
longDat <- function(x){
  x %>%
    setNames(seq_len(ncol(x))) %>%
    mutate(row = row_number()) %>%
    tidyr::gather(column, value, -row) %>%
    mutate(column = as.integer(column)) %>%
    ungroup() %>%
    arrange(column, row)
}

long_tables <- map(list(table1,table1_tidy),longDat)
{% endhighlight %}

Next we add two additional variables to the long-form tables, one for mapping fill colors and a label for facets (either in time or in space!). 

{% highlight r %}
tab1_long_og <- long_tables[[1]] %>% 
  mutate(header=as.character(str_detect(value,"dae$"))) %>% 
  group_by(header) %>% mutate(headerid = row_number()) %>% 
  mutate(celltype=
           case_when(
             header=="TRUE"~ as.character(headerid),
             is.na(header)  ~ NA_character_,
             TRUE~"data"
           )) %>% ungroup() %>% mutate(tstep="a")

tab1_long_untangled <- long_tables[[2]] %>% 
  mutate(header=as.character(str_detect(value,"dae$"))) %>% 
  filter(header==TRUE) %>% distinct(value) %>% mutate(gpid=as.character(1:n())) %>% 
  right_join(long_tables[[2]]) %>% mutate(celltype=if_else(is.na(gpid),"data",gpid)) %>% 
  mutate(tstep="b")

{% endhighlight %}

After binding the two together, we can plot the tables as geom_tiles and use the ‘tstep’ variable to view them either side by side, or one after the other.

{% highlight r %}
longTabs_both <- bind_rows(tab1_long_og,tab1_long_untangled)

ggplot(longTabs_both,aes(column, -row, fill = celltype)) +
  geom_tile(color = "black") + 
  theme_void()+facet_wrap(~tstep)+
  scale_fill_manual(values=c("#247ba0","#70c1b3","#b2dbbf","#ff1654","#ead2ac","gray"),
                    name="",
                    labels=c(c(paste("group",seq(1:4)),"data","NA")))
{% endhighlight %}


<figure>
    <a href="/assets/images/sidebyside.png"><img src="/assets/images/sidebyside.png"></a>
        <figcaption>with facet wrapping</figcaption>
</figure>

For now, 'gganimate' is only available on GitHub. Once we have installed it, ‘transition_states’ does all the magic.

{% highlight r %}
ut_animation <-  
  ggplot(longTabs_both,aes(column, -row, fill = celltype)) +
  geom_tile(color = "black")+ 
  theme_void()+
  scale_fill_manual(values=c("#247ba0","#70c1b3","#b2dbbf","#ff1654","#ead2ac","gray"),
                   name="",
                   labels=c(c(paste("group",seq(1:4)),"data","NA")))+
  transition_states(
    states            = tstep, # variable in data
    transition_length = 1,   # all states display for 1 time unit
    state_length      = 1    # all transitions take 1 time unit
  ) +
  enter_fade() +             # How new blocks appear
  exit_fade() +              # How blocks disappear
  ease_aes('sine-in-out')  

{% endhighlight %}

Check it out!

![gif demo]({{ site.baseurl }}/assets/images/untangledemo.gif)


Once the animation is rendered we can save it to disk using _anim\_save()_.

This approach seems like a good way to animate various types of common steps in data munging, and it should work nicely to illustrate how several 'dplyr' or 'tidyr' verbs work. I’ll make more animations in the near future.
 
Thanks for reading!
