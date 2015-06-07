---
layout: post
title: Ordinal extinction risk models 
excerpt: "Modeling IUCN Red List data as ordered response variables "
tags: 
  - MCMCglmm
  - Probit model
  - extinction risk
published: false
---

## Ordinal extinction risk models in R. 
### Modeling and plotting phylogenetic generalized linear mixed models

In the past few weeks, the European Red Lists for both [birds](http://www.theguardian.com/environment/2015/may/14/a-third-of-europes-birds-under-threat-says-most-comprehensive-study-yet) and [marine fishes](http://www.theguardian.com/environment/2015/jun/03/40-of-europes-sharks-and-rays-face-extinction) 

We are interested in identtyfing the biological factors and/or the human pressures that explain why some species are more threatened than others. multivariate linear models 


The IUCN extinction risk is an ordinal, categorical estimate of extinction threat that represents an underlying continuous latent variable (the unknown true extinction risk).
Ordered threat categories can help to guide priorities for conservation
investment among species and produce a series of recommen-dations for conservation action for each category. 

identify trends within each threat category, and
it avoids losing information by aggregating classifications
into dichotomous variables. We avoided elevated type I error
rates caused by not preserving the variance structure of the
original ordinal ranks when assuming that categories are
evenly spaced and continuously varying.

my cosupervisor Simon blomberg convinced me to .

we tried to code this on JAGS but couldn't get mixing..

since then I've seen ordinal extinction risk modeling used in 

roughly what

{% highlight r %}

# Load dplyr for data manipulation
require(dplyr)

# For reproducibility, read the table directly from the publication's URL 
PantheriaWebAddress <- "http://esapubs.org/archive/ecol/e090/184/PanTHERIA_1-0_WR05_Aug2008.txt"
pantheria <- read.table (file=PantheriaWebAddress,header=TRUE,sep="\t",na.strings=c("-999","-999.00"),
                          stringsAsFactors = FALSE)


}
{% endhighlight %}
