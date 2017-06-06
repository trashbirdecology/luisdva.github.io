---
title: "Tidy tables for collections-based research (Part 1)"
layout: post
excerpt: Wrangling commonly-used data formats for collections-based research. Part 1: GenBank accession tables. 
category: rstats
tags:
  - genbank
  - gather
  - dplyr
  - tidyr
  - melt
image:
  feature: featureMatrixInd.jpg
  credit: contains CC0 public domain elements from Pixabay
  creditlink: 
published: true
---
---
title: "Tidy tables for collections-based research (Part 1)"
layout: post
excerpt: Wrangling commonly-used data formats for collections-based research. Part 1: GenBank accession tables. 
category: rstats
tags:
  - separate
  - gather
  - dplyr
  - tidyr
  - melt
image:
  feature: featureCollsRes.jpg
  credit: Oxford Museum of Natural History CC0 public domain image from Pixabay
  creditlink: 
published: true
---

This series of posts will go through some simple steps to wrangle the data that often accompanies collections-based studies. This post is on handling multispecies tables of GenBank accession numbers, a common component of systematics and phylogeography papers.

As I work my way through the tables and appendices of various rodent phylogeny/morphology papers, I’ll continue to post more of the R code that has saved me lots of time by not having to edit large datasets by hand. 

In this case, I wanted to tidy up a pretty basic table from this 2013 [paper](http://onlinelibrary.wiley.com/doi/10.1111/jzo.12017/abstract) by Morgan and Alvarez. This supplementary table had species with their corresponding GenBank accession numbers for four different gene sequences. 

A subset of the data:

|       species       	|          X12S          	|          cytb          	|    GHR   	|           TTH          	|
|:-------------------:	|:----------------------:	|:----------------------:	|:--------:	|:----------------------:	|
|   Abrocoma cinerea  	|        AF520666        	|        AF244388        	| AF520643 	|                        	|
|    Cuniculus paca   	| AF433906 (Agouti paca) 	| AY206573 (Agouti paca) 	| AF433928 	| AF433881 (Agouti paca) 	|
| Dasyprocta punctata 	|        AF433921        	|                        	| AF433943 	|        AF433897        	|

This table in particular had an interesting twist: some of the accession numbers also included a species name for some special cases in which there have been taxonomic changes. This is useful information, and the original way of presenting it as merged cells in a table in a Word document was visually helpful. However, this format is not ideal for further analyses. We often need to download the sequences programmatically, or compute summary statistics about the taxa being studied, and this is all easier with tidier data. 

Let’s use some helpful **tidyverse** functions to change the overall structure of the data and separate the accession numbers from the species synonyms for those species that have any.

Setting up an example data frame from a subset of the actual table:

{% highlight r %}
appendixS1 <- 
data.frame(species = c("Aconaemys sagei", "Cuniculus paca", "Phyllomys pattoni", "Proechimys longicaudatus"), 
           X12S = c("AF520673","AF433906 (Agouti paca)", NA, "U12447"), 
           cytb = c(NA, "AY206573 (Agouti paca)","EF608187", "U35414 (Proechimys simonsi)"),stringsAsFactors = FALSE)

{% endhighlight %}

Looks like the example above.

{% highlight text %}
                   species                   X12S                        cytb
1          Aconaemys sagei               AF520673                        <NA>
2           Cuniculus paca AF433906 (Agouti paca)      AY206573 (Agouti paca)
3        Phyllomys pattoni                   <NA>                    EF608187
4 Proechimys longicaudatus                 U12447 U35414 (Proechimys simonsi)
{% endhighlight %}

First we can ‘melt’ the data into long form, gathering the columns with the accession numbers into a key-value pair. The Key will be the gene and Value the accession number. Note that I'm a recent convert to the _magrittr_ %<>% compound assignment operator. 

{% highlight r %}
# load packages
## install first if necessary
library(dplyr)
library(tidyr)
library(magrittr)

# melt into long form
appendixS1 %<>% gather(key=gene,value=accession,-species) %>% arrange(species)

{% endhighlight %}

Looks better 
{% highlight text %}
                   species gene                   accession
1          Aconaemys sagei X12S                    AF520673
2          Aconaemys sagei cytb                        <NA>
3           Cuniculus paca X12S      AF433906 (Agouti paca)
4           Cuniculus paca cytb      AY206573 (Agouti paca)
5        Phyllomys pattoni X12S                        <NA>
6        Phyllomys pattoni cytb                    EF608187
7 Proechimys longicaudatus X12S                      U12447
8 Proechimys longicaudatus cytb U35414 (Proechimys simonsi)
{% endhighlight %}

Next we split the accession numbers that also contain a synonym and clean up the synonym column to remove punctuation or extra whitespace. The _extra_ argument for _separate()_ tells the function to only split the values based on the length of the _into_ argument. In this case the function stops separating after the first split.

{% highlight r %}
# split the accession numbers that also contain a synonym
appendixS1 %<>% separate(accession, into = c("accNumber","synonym"),extra="merge")
# clean up the synonym column
appendixS1$synonym %<>% gsub("[[:punct:]]", "", .) %>% trimws()
{% endhighlight %}

Final structure
{% highlight text %}

                   species gene accNumber            synonym
1          Aconaemys sagei X12S  AF520673               <NA>
2          Aconaemys sagei cytb      <NA>               <NA>
3           Cuniculus paca X12S  AF433906        Agouti paca
4           Cuniculus paca cytb  AY206573        Agouti paca
5        Phyllomys pattoni X12S      <NA>               <NA>
6        Phyllomys pattoni cytb  EF608187               <NA>
7 Proechimys longicaudatus X12S    U12447               <NA>
8 Proechimys longicaudatus cytb    U35414 Proechimys simonsi

{% endhighlight %}

Pretty simple, but it beats having to manually cut out the synonyms. The original dataset had more genes and many more species but the principle is still the same.
