---
layout: post
title: annotater
excerpt: "RStudio addins to annotate R code with details on the packages being loaded"
category: rstats
tags: 
  - styler
  - reproducibility
  - scripts
  - version
image: 
  feature: featureAnnot.png
  credit: Image by Engin_Akyurt from Pixabay
published: true
---

Last year, I was helping some labmates with their R code, and I noticed that they couldn't run their analyses because their scripts had many `library()` calls for obscure packages they didn't need, some of which had installation issues, dependencies, and masked functions. 

📦 We started looking up each of these packages to see what they're for, and when working offline, we used the `utils::packageDescription()` function to parse the DESCRIPTION files for the already installed packages. For more informative scripts, we commented the `libary()` load calls with the 'Title' field from each package.

For example:

{% highlight text %}
# package load ------------------------------------------------------------
library(readr) # Read Rectangular Text Data
library(dplyr) # A Grammar of Data Manipulation
library(sensiPhy) # Sensitivity Analysis for Comparative Methods
library(tibble) # Simple Data Frames
library(weatherData) # Get Weather Data from the Web
{% endhighlight%}

✍️ After that, it seemed like a good idea to automate this annotation process. The [`annotater`](https://github.com/luisDVA/annotater){:target="_blank"} package comes with a few addins for RStudio so we can easily add these comments to our code. This package follows the approach in `styler` for automatically adapting code to a formatting style.  

Here's the addin in action:  

![look\!](https://raw.githubusercontent.com/luisdva/annotater/master/inst/media/annotcalls.gif)

Thanks to user feedback, there's a function to annotate `library()` calls with the repository sources for non-CRAN packages (e.g. GitHub, BioConductor, etc.). Much later, I saw this tweet with code used to illustrate a recent update to `ggplot2`

<blockquote class="twitter-tweet" data-dnt="true"><p lang="en" dir="ltr">geom_bar() + scale_x_binned() feels like it reads my mind about histogram bins. <a href="https://t.co/LdcQODqJr7">https://t.co/LdcQODqJr7</a> <a href="https://twitter.com/hashtag/ggplot2?src=hash&amp;ref_src=twsrc%5Etfw">#ggplot2</a> <a href="https://t.co/clILW7cOaR">pic.twitter.com/clILW7cOaR</a></p>&mdash; Allison Horst (@allison_horst) <a href="https://twitter.com/allison_horst/status/1236777911304114182?ref_src=twsrc%5Etfw">March 8, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

It seemed like good idea to also add the package version to the annotations to avoid confusion and when sharing code that uses development and/or CRAN releases.

Here's the other function in action:  

![look\!](https://raw.githubusercontent.com/luisdva/annotater/master/inst/media/repos1.gif)

I've been using these addins to annotate scripts in my own research, for previous posts on this site, and when sharing code with colleagues, and so far I've found it helpful. 

📦 Read more about `ànnotater `[here](https://github.com/luisDVA/annotater){:target="_blank"}   

Install from GitHub like so:  
{% highlight r %}
# install.packages("remotes")
remotes::install_github("luisdva/annotater")
{% endhighlight %}

All feedback is welcome!
