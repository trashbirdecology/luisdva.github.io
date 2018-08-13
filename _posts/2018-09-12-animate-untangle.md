---
title: "Animate your data wrangling"
layout: post
excerpt:  Using _gganimate_ to animate the data-munging process.
category: rstats
tags:
  - unheadr
  - gganimate
  - gifs
  - tile plots
image:
  feature: featurePCKG.png
  credit: Unsplash photo by Maarten van den Heuvel
  creditlink: 
published: false
---

Yesterday I tweeted this gif showing what we can do about non-data grouping rows embedded in the data rectangle using the 'unheadr' package (we can and we should put them into their own variable in a tidier way). Please ignore the typo in the tweet. 

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">manage to animate what we can do about non-data grouping rows embedded in the data rectangle using my silly little <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a> package 📦<a href="https://t.co/QP1X6ORtH8">https://t.co/QP1X6ORtH8</a><a href="https://t.co/zJfVslUedN">https://t.co/zJfVslUedN</a> <a href="https://t.co/KnAYdSAmc7">pic.twitter.com/KnAYdSAmc7</a></p>&mdash; Luis D. Verde (@LuisDVerde) <a href="https://twitter.com/LuisDVerde/status/1028762367843291136?ref_src=twsrc%5Etfw">August 12, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

There was some interest in the code behind the animation, and I wanted to share it anyway because it’s based on actual data and I think that’s pretty cool. 

This is all made possible thanks to Thomas Lin Pedersen’s [gganimate](https://github.com/thomasp85/gganimate), a cool [usecase](https://coolbutuseless.github.io/2018/08/12/gganimate-with-bitmap-fonts/) with geom_tile() plots by [@mikefc](https://twitter.com/coolbutuseless), and this [post](https://rpubs.com/dgrtwo/tidying-enron) by [David Robison](https://twitter.com/drob) where he melts a table into long format with indices for each row and column and a variable holding the value for each cell. 

We can use real data from this table, originally from a book chapter about rodent sociobiology by Ojeda et al. (2016). I had a PDF version of the chapter, and I got the data into R following this [post](
https://rud.is/b/2018/07/02/freeing-pdf-data-to-account-for-the-unaccounted/) by [Bob Rudis](https://twitter.com/hrbrmstr). I highly recommend 'pdftools' and 'readr' for importing PDF tables.

<>screenshot

The first few lines of the table looked like this, and for this demo we can just set up the data directly as a tibble.


{% highlight r %}

{% endhighlight %}

There are grouping values for the taxonomic families that the different genera belong to, and these are interspersed within the taxon variable. All taxonomic families end with “dae”, so we can match this with regex easily. Install ‘unheadr’ from GitHub before proceeding.

{% highlight r %}

{% endhighlight %}

Once we have the original and ‘untangled’ version of the table, we define a function (inspired by drob) to melt the data and apply it to each one.

{% highlight r %}

{% endhighlight %}

Next we add two additional variables to the long-form tables, one for mapping fill colors and a label for facets (either in time or in space!). After binding the two together, we can plot the tables as geom_tiles and use the ‘tstep’ variable to view them side by side, or one after the other.

<side by side>

For now, gganimate is only available on GitHub. Once we have installed it, ‘transition_states’ does all the magic.

This approach seems like a good way to animate various types of common steps in data munging, and it should work nicely several dplyr or tidyr verbs. I’ll most like make more animations in the near future.
 
