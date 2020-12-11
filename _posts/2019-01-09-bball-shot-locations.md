---
title: "Shot distances and court locations for NBA games"
excerpt: Follow up post - Download, plot, and animate per-game shooting data.
category: rstats
tags:
  - booker
  - gganimate
  - nbastatr
header:
  image: /images/featureBallin.png
---

Here's a follow up to my previous [post](https://luisdva.github.io/rstats/bball-shots/) about using _nbastatr_ and _gganimate_ to visualize a player's shots throughout an NBA game.

[Mara Averick](https://twitter.com/dataandme) shared the post, and combined two gifs side by side for the tweet.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">🏀 nbastatR × gganimate w/ code!<br>&quot;Animate shot distances for NBA games&quot; ⛹️‍♂️ <a href="https://twitter.com/LuisDVerde?ref_src=twsrc%5Etfw">@LuisDVerde</a><a href="https://t.co/qP8hojEEHa">https://t.co/qP8hojEEHa</a> <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a> <a href="https://twitter.com/hashtag/dataviz?src=hash&amp;ref_src=twsrc%5Etfw">#dataviz</a><br>/* L·R panels combined by me bc I hate how Twitter does tall gifs */ <a href="https://t.co/9Tv8RSlAME">pic.twitter.com/9Tv8RSlAME</a></p>&mdash; Mara Averick (@dataandme) <a href="https://twitter.com/dataandme/status/1082362770874605568?ref_src=twsrc%5Etfw">January 7, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

___  

I had been playing with the short chart location data anyway, and the idea of having synced-up side by side animations seemed interesting.

The code in the gist below should be fully reproducible. First, we can use the same approach as in my previous post to plot the shot distances over game time. Then, plotting the XY shot locations is pretty straightforward. To show the shots on the court, we can borrow some functions from the [ballr](http://toddwschneider.com/posts/ballr-interactive-nba-shot-charts-with-r-and-shiny/) Shiny app by Todd Schneider and draw the court directly in _ggplot_. Finally, two gifs can be put side by using _magick_. I found a nice function written by [Patrick Toche](https://github.com/ptoche) to ease this along.

The animations were both rendered with default values, and I didn't need to resort to any cheap hacks to get the plots to look like I intented them to :)

## Shot distances and locations

Here's Devin Booker's 70 point game from 2017.

![gif demo]({{ site.baseurl }}/assets/images/booker.gif)
 
The code:
{% gist luisDVA/520cf544c9975c543e3db4168776d194%}

Keep ballin'
