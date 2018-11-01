---
title: "No more bar charts with error bars please"
layout: post
excerpt: some ggplot2 alternatives to dynamite-plunger plots
category: rstats
tags:
  - bar chart
  - errorbar
  - dataviz
  - datavis
image: 
  feature:  
  credit: 
  creditlink: 
published: false
---

Computer scientists, psychologists, and statisticians have all studied how to create visualizations that communicate data effectively. Graphical perception experiments have shown that the human visual system is pretty good at decoding numerical data mapped to the spatial position of a graphical feature (Heer et al. 2010). This may be why bar charts are so popular and widely-used.  

To show counts or frequencies of observations for different groups, we can make the length of the bars represent the corresponding values. The problems start when bar charts are also used to show multiple observations for each group. What usually happens is that the length of the bars now represent the group means, and then silly-looking error bars are drawn on top to show standard errors or standard deviations for the means. These plots are also known as ‘dynamite plunger plots’ because they look like the detonator boxes we all know from cartoons.

Bar charts for multiple observations are not good because:
- they conceal the underlying data, so we cannot see the its distribution or the sample size  
- they look pretty lame  

I'm writing this quick post after teaching a ggplot workshop last month, followed by two biology conferences where I saw these plots used by students, plenary speakers, bioinformaticians, and various other researchers. In 2016, Helena Jambor also noted how prevalent these charts are, even in top journals. 

## Alternatives to the bar chart

I'm not the first to call for less of these plots, but I want to share some alernatives that I haven't seen implemented too often. 

First of all, why draw bars if we can show the underlying points, or at least show more information about the distribution of the data and some nice parametric summaries (e.g. box plots). 

This tweet speaks for itself, and all those options can be made in ggplot with the right packages and extensions (e.g. ggforce and beeswarm). 

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">Comparison of sina plot with other styles. This is a great suggestion. <a href="https://t.co/2Pf66E7PFi">pic.twitter.com/2Pf66E7PFi</a></p>&mdash; Tim Triche, Jr. (@timtriche) <a href="https://twitter.com/timtriche/status/1056898767985799168?ref_src=twsrc%5Etfw">October 29, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

If we absolutely need to plot bars for multiple observations per group, the approach below may be an option. 
The code for this is at the end of this post. At this point it's pretty hacky, but I think something like this could be made into a custom geom by anyone who is good at ggproto. The 

1. Generate random values within the bounds of the mean plus or minus the standard error.
2. Overlay semi-transparent bars to show the range of the standard error.
3. Draw a bars with an outline but no fill to show the point estimate (means).

This is not meant to show the sample size or underlying distribution of the data, but it shows the estimate and standard error without looking as lame. 

<figure>
    <a href="/images/failammac.png"><img src="/images/failammac.png"></a>
        <figcaption></figcaption>
</figure>

Heer, Jeffrey, Michael Bostock, and Vadim Ogievetsky. "A tour through the visualization zoo." Commun. Acm 53.6 (2010): 59-67.
https://queue.acm.org/detail.cfm?searchterm=Mind+Maps&id=1805128
