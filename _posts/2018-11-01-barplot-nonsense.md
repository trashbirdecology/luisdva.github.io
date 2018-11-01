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

I'm not the first to call for less of these plots, but I was that I haven't seen implemented 

First of all, 
<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">Comparison of sina plot with other styles. This is a great suggestion. <a href="https://t.co/2Pf66E7PFi">pic.twitter.com/2Pf66E7PFi</a></p>&mdash; Tim Triche, Jr. (@timtriche) <a href="https://twitter.com/timtriche/status/1056898767985799168?ref_src=twsrc%5Etfw">October 29, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>



<figure>
    <a href="/images/failammac.png"><img src="/images/failammac.png"></a>
        <figcaption></figcaption>
</figure>

Heer, Jeffrey, Michael Bostock, and Vadim Ogievetsky. "A tour through the visualization zoo." Commun. Acm 53.6 (2010): 59-67.
https://queue.acm.org/detail.cfm?searchterm=Mind+Maps&id=1805128
