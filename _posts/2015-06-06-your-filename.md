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

This June, the [European Red List of Birds](http://www.birdlife.org/europe-and-central-asia/european-red-list-birds-0) revealed that almost 20% of bird species in Europe are facing extinction. This publication is the result of three years of hard work by a consortium led by BirdLife International and financed by the European Commission. A publication like this is expected to guide and policy work over the coming years. 

Red Lists of threatened species are widely recognised as authoritative and objective systems for assessing large-scale, species-level extinction risk. Red Lists can be compiled at various geographic levels, and they usually follow the rigurous quantitative methods set by the International Union for Conservation of Nature (IUCN). 

This June, the newly published European Red Lists for both  and [marine fishes](http://www.theguardian.com/environment/2015/jun/03/40-of-europes-sharks-and-rays-face-extinction) revealed that almost 1/3 of Europe's birds and 40% of Europe's sharks, skates and rays face extinction. The species that are threatened are not a random 

As we learn more about the for most species in a group (the proporiton of species with ...varies) We are interested in identyfing the biological factors and/or human pressures that explain why some species are more threatened than others. multivariate linear models 

For my PhD research I studied extinction risk in mammals, and I also used the IUCN Red List data as my measure of how likely a species..in the foreseaable future. 

The IUCN extinction risk is an ordinal, categorical estimate of extinction threat that represents an underlying continuous latent variable (the unknown true extinction risk).
Ordered threat categories can help to guide priorities for conservation
investment among species and produce a series of recommendations for conservation action for each category. Critically endangered species might get conservation priority over 

identify trends within each threat category, and it avoids losing information by aggregating classifications into dichotomous variables. We avoided elevated type I error
rates caused by not preserving the variance structure of the original ordinal ranks when assuming that categories are evenly spaced and continuously varying.

my cosupervisor Simon blomberg convinced me to .

we tried to code this on JAGS but couldn't get mixing..

since then I've seen ordinal extinction risk modeling used in 

roughly what

Although I shared all my data and described my methods as thoroughly as I could, I did not make my analysis code available for the 2013 PRSB paper. I deeply and

Below is a fully reproducible example for running and plotting a multivariate model of extinction risk in terrestrial carnivores (well-studied group) that takes into account phylogenetic relatedness between species, and the ordinal nature of Red List Data. 


{% highlight r %}

# Load dplyr for data manipulation
require(dplyr)

# For reproducibility, read the table directly from the publication's URL 
PantheriaWebAddress <- "http://esapubs.org/archive/ecol/e090/184/PanTHERIA_1-0_WR05_Aug2008.txt"
pantheria <- read.table (file=PantheriaWebAddress,header=TRUE,sep="\t",na.strings=c("-999","-999.00"),
                          stringsAsFactors = FALSE)


}
{% endhighlight %}



De Lisle, S. P., & Rowe, L. (2015) Independent evolution of the sexes promotes amphibian diversification. 282. doi:10.1098/rspb.2014.2213.

Seibold, S., Brandl, R., Buse, J., Hothorn, T., Schmidl, J., Thorn, S., et al. (2015) Association of extinction risk of saproxylic beetles with ecological degradation of forests in Europe. Conservation Biology.
