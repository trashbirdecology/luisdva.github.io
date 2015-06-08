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
Assigning species into different threat categories can help to guide priorities for conservation investment, and produce a series of recommendations for conservation action for each category. Red Lists of threatened species can be compiled at various geographic levels (state/country/global), and they usually follow the rigurous quantitative methods set by the International Union for Conservation of Nature [(IUCN)](http://www.iucnredlist.org/). Red Lists are authoritative and objective systems for assessing large-scale, species-level extinction risk. 

As we learn more about the threat status for more animal and plant groups,  we can start  identyfing the biological factors and/or human pressures that explain why some species are more threatened than others. This usually involves using multivariate models to search for associations between a species’ level of threat (e.g. Red List data) and information on its distribution, biology, and the threats it faces. These comparative analyses implement various statistical methods to overcome the fact that evolutionary relatedness can introduce apparent correlations between species' traits. 

### Ordinal response

To date, most studies have treated Red List values of extinction risk as a continuous variable (i.e there are five main threat categories for living species, going from _Least Concern -> Near Threatened -> Vulnerable -> Endangered -> Critically Endangered_ and they can be treated as a coarse continous index from 1 to 5). This approach assumes that  extinction risk codes in the IUCN Red List are continuously varying. Instead, the Red List categorization of extinction risk is an ordinal, categorical estimate of extinction threat that represents an underlying continuous latent variable (the unknown true extinction risk). For example, the true difference in extinction risk may vary between categories of Least Concern and Near Threatened when compared with Critically Endangered and extinct. 

In a nifty 2011 paper, Matthews et al. address this issue, and they suggest that the coarse continuous index approach can produce elevated type I error rates because such treatment applies arithmetic operations that lose the variance structure of the original ordinal ranks. Specifically, the problem occurs when the ordinal ranks are separated by unequal distances along the underlying continuous variable that they measure, and we can't know this beforehand.

For my PhD research I studied extinction risk in mammals, and I used the IUCN Red List data as my response variable. My cosupervisor Simon blomberg convinced me to try and model the response as an ordinal index. At the time, few studies had done .. this.
Initially, we tried to code these models as ordinal logit models in JAGS - but as I struggled with the phylogenetic comparative aspect and the JAGS and Linux learning curves, a Reddit user pointed me to the MCMCglmm R package.  

since then I've seen ordinal extinction risk modeling used in 

roughly what

Although I shared all my data and described my methods as thoroughly as I could, I did not make my analysis code available for the 2013 PRSB paper. I deeply and

http://www.tandfonline.com/doi/abs/10.1080/08989621.2012.678688?url_ver=Z39.88-2003&rfr_id=ori%3Arid%3Acrossref.org&rfr_dat=cr_pub%3Dpubmed&


identify trends within each threat category, and it avoids losing information by aggregating classifications into dichotomous variables. We avoided elevated type I error
rates caused by not preserving the variance structure of the original ordinal ranks when assuming that categories are evenly spaced and continuously varying.




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
