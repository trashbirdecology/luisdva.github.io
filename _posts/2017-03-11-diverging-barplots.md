---
published: false
---
> Note: I was not involved in creating the original figure or in how the data behind it was collected and processed, but I wanted to share my own take on showing the values for the different studies in a way that was easier to read given the importance of the issue.

I recently came across the following figure, tweeted by [Katharine Hayhoe](https://twitter.com/KHayhoe) on March 9, 2017. 

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">How much of our current warming is human-induced? Likely more than 100% - because according to natural factors, we should be cooling. <a href="https://t.co/LyUbDjIxDn">pic.twitter.com/LyUbDjIxDn</a></p>&mdash; Katharine Hayhoe (@KHayhoe) <a href="https://twitter.com/KHayhoe/status/839994424130174977">March 10, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The figure [(original source)](https://skepticalscience.com/graphics.php?g=57) is part of the graphical resources used in articles for the website [Skeptical science](https://skepticalscience.com), a site dedicated to explaining climate change science & rebutting global warming misinformation

Looking at the figure and at the original caption, we can see that the bars represent an independent variable (% contribution) for two categories (natural/human), with a color scheme to represent different studies. I was puzzled as to why the natural vs. human bars weren’t side-by-side (dodged), but I suppose that going with colors for the different studies precluded the use of color to distinguish the bars.

I tweeted my version of the figure, after which Katharine Hayhoe shared it on her own account. The tweet has been shared widely so I thought I should write this brief post with a few extra details on the datavis process.   

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">How could human factors be responsible for MORE than 100% of the observed warming? This new plot by <a href="https://twitter.com/LuisDVerde">@LuisDVerde</a> helps make it clear: <a href="https://t.co/pZt3ntFSED">pic.twitter.com/pZt3ntFSED</a></p>&mdash; Katharine Hayhoe (@KHayhoe) <a href="https://twitter.com/KHayhoe/status/840581942273810432">March 11, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I had previously written about [diverging bar plots](http://luisdva.github.io/Diverging-bar-plots/), and this looked like a good example to show some data visualization principles using my existing R code. In this case, a diverging stacked bar plot helps by: 

- not having to match up the colors with the bars across two separate sections of the axis with the abbreviated studies from the legend
- showing more information on each study directly on the axis
- being able to compare positive and negative values directly
- getting rid of the gradients and drop shadows in the original figure

The code to reproduce the figure is below, and here are the steps I used to produce it.

1. Digitize the original figure using [PlotDigitizer](http://plotdigitizer.sourceforge.net/) and set up columns with the studies and the grouping variable. 
2. Round the values. 
3. Plot the data, keeping the title and axis labels consistent with the original figure. The plot was made using ggplot2 and several of my favorite packages to improve its overall appearance. I used one of Google's Roboto fonts but if you don't have it on your system you may use any other font family.
4. Rotate the axes and reorder the x axis.
5. Highlight the y axis in a lighter color for extra coolness.
6. Note how I used functions from the forcats package within the ggplot arguments to wrangle the factor levels.

{% highlight r %}

library(dplyr)
library(ggplot2)
library(forcats)
library(artyfarty)
library(extrafont)

dat <- read.csv("https://raw.githubusercontent.com/luisDVA/codeluis/master/contributions.csv",stringsAsFactors = F) %>% 
          mutate(contribution=round(contribution,0))

loadfonts(device="win")

ggplot(dat,aes(x=fct_rev((fct_inorder(study))), y=contribution,fill=contributor))+
  geom_bar(stat="identity",position="identity",color="dark grey")+
  coord_flip()+ylim(-50,200)+
  geom_hline(yintercept=0,color =c("white"))+
  theme_flat()+
  xlab("study")+ylab("% contribution")+
  ggtitle("Contributors to Global Warming over the past 50-65 years")+
  scale_fill_manual(name="",values = c("#FFA373","#50486D"))+
  labs(caption="reproduced from skepticalscience.com")+
  theme(text=element_text(family="Roboto Medium"))
    
{% endhighlight %}
