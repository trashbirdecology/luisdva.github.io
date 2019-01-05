---
title: "Animate shot distances for NBA games"
layout: post
excerpt: Download, plot, and animate per-game shooting data.
category: rstats
tags:
  - beard
  - gganimate
  - nbastatr
image:
  feature: featureBallin.png
  credit: 
  creditlink: 
published: false
---

I was asked to post the code for the animation in this tweet, which shows the distance for shots taken throughout a basketball game by two players. I wanted to check out the CRAN version of _gganimate_ by [Thomas Lin Pedersen](https://twitter.com/thomasp85), and was also meaning to explore NBA data for a while and this looked like an interesting way to show offensive activity. 

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">playing with <a href="https://twitter.com/hashtag/gganimate?src=hash&amp;ref_src=twsrc%5Etfw">#gganimate</a> and <a href="https://twitter.com/hashtag/nbastatr?src=hash&amp;ref_src=twsrc%5Etfw">#nbastatr</a> to visualize shooting distances during that exciting 76ers vs Hornets match-up back in November <br>🏀<a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a> <a href="https://t.co/RbQYA8SzkD">pic.twitter.com/RbQYA8SzkD</a></p>&mdash; Luis D. Verde (@LuisDVerde) <a href="https://twitter.com/LuisDVerde/status/1081192900367708160?ref_src=twsrc%5Etfw">January 4, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


The 'shot chart detail' data from the NBA stats API was accessed with [_nbastatr_](http://asbcllc.com/nbastatR/index.html) by [Alex Bresler](https://twitter.com/abresler). The shot chart data is already tidy and almost ready for use. Shot distances come in their own variable, and the time when each shot was taken appears in three columns: quarter, minutes remaining, and seconds remaining. This can all be converted to chronological time using _dplyr_ and _lubridate_. After that everything is pretty straightforward if we’re familiar with the basic grammar of ggplot and gganimate. 

Here are the shot distances for James Harden’s last three games:
Below is the code for the plot and animation. 



Hope you find this helpful!


