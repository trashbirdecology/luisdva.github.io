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
published: false
---

Last year, I was helping some labmates with their R code, and I noticed that they couldn't run their analyses because their scripts had many `library()` calls for obscure packages they didn't need, some of which had installation issues, dependencies, and masked functions. 

We started looking up each of these packages to see what they're for, and when working offline, we used the `utils::packageDescription()` function to parse the DESCRIPTION files for the already installed packages. For more informative scripts, we commented the `libary()` load calls with the 'Title' field from each package.

For example:

{% highlighttext %}
# package load ------------------------------------------------------------
library(readr) # Read Rectangular Text Data
library(dplyr) # A Grammar of Data Manipulation
library(sensiPhy) # Sensitivity Analysis for Comparative Methods
library(tibble) # Simple Data Frames
library(weatherData) # Get Weather Data from the Web
{% endhighlight%}

After that, it seemed like a good idea to automate this annotation process. The `annotater` package adds a few addins to RStudio so we can easily add these comments to our code. This package follows the approach in `styler` package for automatically adapting code to a formatting style.  



To illustrate  a recent update to `ggplot2`, 



[`unheadr`](https://unheadr.liomys.mx){:target="_blank"} 
0.2.1 is now on CRAN, so here is an updated example for using the two main functions in the package.

The screenshot below comes from a spreadsheet with data from a regional event for the American Kennel Club’s Coursing Ability Test ([CAT](https://www.akc.org/sports/coursing/coursing-ability-test/){:target="_blank"}), which consists of timed 100-yard dashes for dogs. This is a subsample of an original xlsx file that I found online at some point and randomized.

 <figure>
    <a href="/images/fastcat.png"><img src="/images/fastcat.png"></a>
        <figcaption>cell and font formatting</figcaption>
</figure>
<br><br>
