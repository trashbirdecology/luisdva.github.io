---
title: "Get top values by group (animated)"
layout: post
excerpt: Animated explanation of dplyr::top_n() and code to create the gif.
category: rstats
tags:
  - dplyr
  - gganimate
  - gifs
  - luna
image:
  feature: featureAnimate.png
  credit: clipartXtras
  creditlink: 
published: false
---

Animated ggplots are in season:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Me too! Didn’t see that coming</p>&mdash; Thomas Lin Pedersen (@thomasp85) <a href="https://twitter.com/thomasp85/status/1029586660915326976?ref_src=twsrc%5Etfw">August 15, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Recently, I made this animated expository demonstration of various tidyerse functions piped together. And while I've 


Say we have a dataset with three dogs, three cats, and three birds. We have names for each one, and a totally objective cuteness rating.



The book cover.
<figure>
    <a href="/images/cavioms.jpg"><img src="/images/cavioms.jpg"></a>
        <figcaption>cute!</figcaption>
</figure>

The first few lines of the table looked like this, and for this demo we can just set up the data directly as a tibble.

<figure>
    <a href="/images/ojedaT1.png"><img src="/images/ojedaT1.png"></a>
        <figcaption>PDF table</figcaption>
</figure>
