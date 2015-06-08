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

This June, the [European Red List of Birds](http://www.birdlife.org/europe-and-central-asia/european-red-list-birds-0) revealed that almost 20% of bird species in Europe are facing extinction. This publication is the result of three years of hard work by a consortium led by BirdLife International and financed by the European Commission. This list, and similar recent publications (i.e the [European Red List of marine fishes](http://www.theguardian.com/environment/2015/jun/03/40-of-europes-sharks-and-rays-face-extinction)  are expected to guide conservation and policy work over the coming years. 

Red Lists of threatened species can be compiled at various geographic levels (state/country/global), and they usually follow the rigurous quantitative methods set by the International Union for Conservation of Nature [(IUCN)](http://www.iucnredlist.org/). Red Lists are authoritative and objective systems for assessing large-scale, species-level extinction risk. 

As we learn more about the threat status for more animal and plant groups,  we can start  identyfing the biological factors and/or human pressures that explain why some species are more threatened than others. This usually involves multivariate models used to search for associations be
By synthesizing information across large numbers of species, comparative analyses can help explain why some species are more vulnerable than others (Fisher & Owens, 2004; Murray et al., 2014). A common approach involves searching for associations between a species’ level of endangerment and information on its biology, distribution, and threats (Figure 1). These ‘comparative extinction risk analyses’ are now common in conservation science and macroecology, and they are used to identify general patterns across large sets of species (Cardillo & Meijaard, 2012). Common findings for vertebrates are that large body size, restricted distribution, and human pressures all increase the likelihood of species for becoming extinct in the foreseeable future (Fisher & Owens, 2004).

The Red List categorization of extinction risk is an ordinal, categorical estimate of extinction threat that represents an underlying continuous latent variable (the unknown true extinction risk).Ordered threat categories can help to guide priorities for conservation investment among species and produce a series of recommendations for conservation action for each category. 

identify trends within each threat category, and it avoids losing information by aggregating classifications into dichotomous variables. We avoided elevated type I error
rates caused by not preserving the variance structure of the original ordinal ranks when assuming that categories are evenly spaced and continuously varying.
The use of PGLS or independent contrasts treats IUCN
extinction risk as a continuous variable [33,34]. Counter to
this assumption, extinction risk codes in the IUCN Red
List are not continuously varying. Instead, extinction risk is
an ordinal variable in which ranks probably vary in the
amount of difference in the actual underlying extinction
risk [32]. For example, the true (quantitative) difference in
extinction risk may differ between categories of near threa-tened and vulnerable, when compared with endangered
and critically endangered. Treating ordinal variables as continuous can produce elevated type 1 error rates because
such treatment applies arithmetic operations that do not pre-serve the variance structure of the original ordinal
ranks [35,36]. The problem occurs specifically when the
ordinal ranks are separated by unequal distances along the
underlying continuous variable that they measure, a point
acknowledged by Purviset al.[32].

For my PhD research I studied extinction risk in mammals, and I used the IUCN Red List data as my response variable. My cosupervisor Simon blomberg convinced me to .

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
