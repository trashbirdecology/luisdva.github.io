---
title: "Plots for model-based clustering of ancestral populations"
layout: post
excerpt: Plot models of population structure with ggplot for arbitrary values of K.
category: rstats
tags:
  - DAPC
  - genomics
  - Admixture
  - Structure
image:
  feature: featurePigeon.png
  credit: 
  creditlink: 
published: false
---


Here’s one approach for plotting a set of faceted stacked barplots showing the output from programs such as (e.g. Structure, DAPC, or Admixture) used for population genetics/genomics and phylogeography. This code may come in handy when plotting individuals from different locations and models with different numbers of proposed ancestral populations. 

To make the plots with made up data, let’s write a quick function to generate random proportions for an arbitrary number of proposed ancestral populations and samples. We can leverage the ‘long’ output from tibble’s enframe function and end up with a ggplot-ready tibble. For real data such as Admixture Q files, this table shape can also be accomplished easily with the tidyr gather function (and pivot_longer going forward).
  
{% highlight r %}
{% endhighlight %} 

Next, we simulate random data for K = 2, 3, and 4, and merge it with some random ‘locations’ for the sampled individuals. Here I simulated data for 131 individuals in five generic locations. Each table is now in long form and ready for ggplot.

{% highlight r %}
{% endhighlight %} 

A quick glimpse of the resulting tibbles shows us how the plotting variables  (x,y, fill, and facet) are ready to go.  

{% highlight text %}
{% endhighlight %} 

This approach here lets us control the spacing of different locations by using facets, the expand arguments for the scales, and the panel.spacing argument for the overall plot theme. Note how the scales and space arguments to facet_grid help us accommodate the different number of individuals per location. Switch places the facet label below the plot. We can use forcats::fct_inorder to avoid alphabetic arrangement of the facets.

<figure>
    <a href="/images/k2plot.png"><img src="/images/k2plot.png"></a>
        <figcaption></figcaption>
</figure>
<br><br>  

{% highlight r %}
{% endhighlight %} 

After making some minor aesthetic choices, we can stack the plots for the different values of K in a single figure using patchwork. 


<figure>
    <a href="/images/allkplot.png"><img src="/images/allkplot.png"></a>
        <figcaption>patchwork!</figcaption>
</figure>
<br><br>  

The plots with simulated data probably look hideous to anyone who studies real populations, but this should be a useful outline for those who have real data. Thanks to urban evolutionary biologist Liz Carlen for the inspiration.
