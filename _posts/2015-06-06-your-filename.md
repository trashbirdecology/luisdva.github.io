---
layout: post
title: Ordinal extinction risk models 
excerpt: "Modeling IUCN Red List data as ordered response variables "
tags: 
  - MCMCglmm
  - Probit model
  - extinction risk
published: true
---

## Ordinal extinction risk models in R. 
### Modeling and plotting phylogenetic generalized linear mixed models

In the past few weeks, the European Red Lists for both [birds](http://www.theguardian.com/environment/2015/may/14/a-third-of-europes-birds-under-threat-says-most-comprehensive-study-yet) and [marine fishes](http://www.theguardian.com/environment/2015/jun/03/40-of-europes-sharks-and-rays-face-extinction) 

We are interested in identtyfing the biological factors and/or the human pressures that explain why some species are more threatened than others. multivariate linear models 

```{r, 14-12-10-rworldmap, hide=TRUE, warning=FALSE, message=FALSE, echo=TRUE}
code <- "NTD_4"
year <- 2013
url <- paste0('http://apps.who.int/gho/athena/api/GHO/',code,'.csv?filter=COUNTRY:*;YEAR:',year)
#read query result into dataframe
dF <- read.csv(url,as.is=TRUE)
library(rworldmap)
sPDF <- joinCountryData2Map(dF, nameJoinColumn="COUNTRY", joinCode="ISO3")
mapCountryData(sPDF,nameColumnToPlot="Numeric",catMethod="fixedWidth",mapRegion="africa", mapTitle="Gambian sleeping sickness cases in 2013")

```

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

{% highlight css %}
#container {
  float: left;
  margin: 0 -240px 0 0;
  width: 100%;
# Load dplyr for data manipulation
require(dplyr)

# For reproducibility, read the table directly from the publication's URL 
PantheriaWebAddress <- "http://esapubs.org/archive/ecol/e090/184/PanTHERIA_1-0_WR05_Aug2008.txt"
pantheria <- read.table(file=PantheriaWebAddress,header=TRUE,sep="\t",na.strings=c("-999","-999.00"),stringsAsFactors = FALSE)


}
{% endhighlight %}
