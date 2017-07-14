---
published: false
---

In recent weeks there has been much interest in making cool-looking plots of overlapping density distributions. Basically: stacking many overlapping polygons/ribbons to resemble the Joy Division Unknown Pleasures cover art that we all like. 

I saw this kind of plot a few weeks back in a New York Times [infographic](https://www.nytimes.com/interactive/2017/06/12/upshot/the-politics-of-americas-religious-leaders.html?mcubz=2" target="_blank), with several more examples appearing in my Twitter feed this month.   

The overlapping density plots are very appealing visually, and definitely very challenging to make. [Claus Wilke](https://twitter.com/ClausWilke) recently stepped up to the challenge and created [ggjoy](https://github.com/clauswilke/ggjoy/), an R package for creating the appropriately named JoyPlots. The name was coined in April and the ggjoy package is just a few days old, and both are already getting lots and lots of attention. 

 <blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">I guess joyplots are a thing now!<br>Congrats <a href="https://twitter.com/JennyBryan">@JennyBryan</a><a href="https://twitter.com/hashtag/joyplot?src=hash">#joyplot</a> <a href="https://twitter.com/hashtag/joyplots?src=hash">#joyplots</a> <a href="https://t.co/dYdugsbhcu">pic.twitter.com/dYdugsbhcu</a></p>&mdash; Diogo Aguiam (@diogoaguiam) <a href="https://twitter.com/diogoaguiam/status/885801611448201217">July 14, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I feel that Kernel densities look good and that they work well for big datasets with clear unimodal or bimodal distributions. However, with smaller datasets I feel that density functions reflect the choice of smoothing parameters more than they reflect the actual distribution of the underlying data. The optimally-smoothed kernels may not be the prettiest, and so it is probably worth trying to show densities as well as the underlying data.   

With density plots, it’s difficult to see where the data actually are, and as Andrew Gelman [commented](http://andrewgelman.com/2009/11/25/whats_wrong_wit/):
> '_I’d rather just see what’s happening … rather than trying to guess by taking the density estimate and mentally un-convolving the kernel._'

For this post, I go through some code for making density plots that also show the underlying data. As usual, I show this using the best type of data: dog data. 

jangolino

To plot the distribution of variable values for different groups, I used the maximum jump distance for several hundred dogs that participated in the SplashDogs ([http://www.splashdogs.com/](http://www.splashdogs.com/)) ‘Super Air’ dock jumping competition during 2016. Dock jumping is essentially a long jump sport for dogs. Dogs run along a ~12 meter dock and jump into the water, usually chasing a toy. Jumps are measured from the edge of the dock to the point where the base of the dog's tail first enters the water.

labradoooor

This post has three main steps: scraping the jump distance data, wrangling it, and plotting it. This post in particular could not be possible without all the resources and advice from [Bob Rudis](https://rud.is/b/) that are floating around the web. This includes posts on his blog, answers on random Stack Overflow questions, tweets, and his helpful R packages. I tried to add links to all the hrbrverse resources that helped me along the way, and I’m probably missing some.

## Web scraping

I did not find and Terms of Service prohibiting automated data grabbing anywhere on the SplashDogs website or in the site’s robots.txt file. Remember to always check if scraping is allowed and adhere to all Terms and Conditions. Here’s a [brief guide](https://blog.scrapinghub.com/2016/08/25/how-to-crawl-the-web-politely-with-scrapy/) on how to crawl the web politely. Take breaks between sequential requests, be kind to web servers when scraping, and just be nice in general. What would the dogs think if you crashed a site! 

To scrape the data, I used _rvest_ to interact with the web form on the site, making queries for event results by breed and year. I was only after data for a few breeds, and I managed to abstract the scraping into a function and use _purrr_ (a first for me!) to iterate through a small vector of breeds that I chose following two main criteria: (personal bias, and representation in the competitions). I wanted to compare groups with several hundred entries (Labradors) vs groups with just a few (American Pit Bull Terriers). 

{% highlight r%}
{% endhighlight %}

## Data wrangling

After putting the html tables into data frames, it was a straightforward process to summarize the data. I cleaned up some unnecessary spaces in the handler names, and kept only the maximum jump distance for each dog.  

{% highlight r%}
{% endhighlight %}

## Plotting

My approach was to create a one-sided beeswarm plot object for different groups and plot it over the respective density. For comparison, I made two versions. One in which the densities and the point swarm are scaled, and one without scaling. I’m using faceting here, and I didn’t try to make the densities overlap. 
This code is clunky and it needs different data frames with pre-summarized information, but I’m happy with the results. The forcats package was very useful for reordering the factor levels whenever I had to arrange the groups for plotting.

Here's the result with scaled densities and point swarms.
<figure>
    <a href="/images/unscaledDens.png"><img src="/images/unscaledDens.png"></a>
        <figcaption>Everything rescaled (0-1)</figcaption>
</figure>

Here's a version with unscaled densities and point swarms.

<figure>
    <a href="/images/scaledDens.png"><img src="/images/scaledDens.png"></a>
        <figcaption>Unscaled</figcaption>
</figure>

{% highlight r%}
{% endhighlight %}

For comparison here’s a plot of the same data using geom_joy and some theming to make the plot extra cool. It looks really crisp, and the default geom_joy can be built with a single line of code. 
I suspect that what I’ve done with the beeswarm points can be made into a geom to accompany geom_joy. If you’re good at ggproto let me know and we can try it out. 

Finally, 
The visual appeal and coolness of joyplots can make us get carried away, but as tjmahr hsve pointed out, , they can be used to show the posterior distribution and 
https://vuorre.netlify.com/post/2017/visualizing-varying-effects-posteriors-with-joyplots/
https://twitter.com/tjmahr/status/884577726308507649
https://stackoverflow.com/questions/15867263/ggplot2-geom-text-with-facet-grid
