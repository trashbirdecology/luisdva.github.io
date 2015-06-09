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




### Red Lists of Threatened Species

This June, the [European Red List of Birds](http://www.birdlife.org/europe-and-central-asia/european-red-list-birds-0) revealed that almost 20% of bird species in Europe are facing extinction. This report is the result of three years of hard work by a consortium led by BirdLife International. This list, and similar recent publications (i.e the [European Red List of marine fishes](http://www.theguardian.com/environment/2015/jun/03/40-of-europes-sharks-and-rays-face-extinction))  are expected to guide conservation and policy work over the coming years. 
Assigning species into different threat categories can help to guide priorities for conservation investment, and produce different recommendations for conservation action for each category. Red Lists of threatened species can be compiled at various geographic levels (state/country/global), and they usually follow the rigurous quantitative methods set by the International Union for Conservation of Nature [(IUCN)](http://www.iucnredlist.org/). Red Lists are authoritative and objective systems for assessing large-scale, species-level extinction risk. 

As we learn more about the threat status for more animal and plant groups through comprehensive Red List assessments,  we can start  identifying the biological factors and/or human pressures that explain why some species are more threatened than others. This usually involves using multivariate models to relate a species’ level of threat (e.g. Red List data) with information on its distribution, biology, and the threats it faces. These comparative analyses implement various statistical methods to overcome the fact that evolutionary relatedness can introduce apparent correlations between species' traits. 

### Ordinal response

To date, most studies have treated Red List values of extinction risk as a continuous variable (i.e there are five main threat categories for living species, going from _Least Concern -> Near Threatened -> Vulnerable -> Endangered -> Critically Endangered_ and they can be treated as a coarse continous index from 1 to 5). This approach assumes that the categories are continuously varying and evenly spaced. Instead, the Red List is an ordinal, categorical estimate of threat that represents an underlying continuous latent variable (the unknown true extinction risk). For example, the true difference in extinction risk may vary between categories of Least Concern and Near Threatened when compared with Critically Endangered and extinct. The coarse continuous index approach can produce elevated type I error rates because it loses the variance structure of the original ordinal ranks. Problems arise when the ordinal ranks are separated by unequal distances along the underlying continuous variable that they measure, and we can't know this beforehand. The coarse continous approach isn't necessarily wrong or misleading, but the sensitivity of models to different treatments of Red List response data is not always acknowledged. A growing number of papers have compared the results from ordinal vs continous models, and a simulation test by Matthews et al. (2011) have found that the results can be consistent, but not always... 


### Phylogenetic generalized linear mixed models


For my PhD research I studied extinction risk in mammals, and I used IUCN Red List data as the response variable. My co-supervisor and PCM guru [Simon Blomberg](http://researchers.uq.edu.au/researcher/428) convinced me to try and model the response as an ordinal index. At the time, only two studies had modeled Red List data as an ordered multinomial response, but both had potential non-indpendece issues. Liow et al. (2009) used nonphylogenetic proportional odds models; and González-Suárez & Revilla (2013) used taxonomically informed Generalised Linear Mixed Models. Initially, we tried to code ordinal logit models in JAGS - and while I struggled with the phylogenetic comparative aspect and the JAGS and Linux learning curves, a helpful Reddit user pointed me to the _MCMCglmm_ package by Jarrod Hadfield.  

_MCMCglmm_ is an R package for fitting Generalised Linear Mixed Models using Markov chain Monte Carlo techniques. It draws on quantitative genetics methods, and I was very interested in how the it could incorporate phylogenetic information (as a covariance matrix representing the amount of shared evolutionary history between species), and use a probit link function to model ordinal responses. The package is widely-used and well-documented in mailing lists and discussion groups (and Jarrod was always helpful and patient whenever I pestered him on mailing lists or at conferences).

### 2013 paper

For my first thesis chapter, I investigated the relationship between extinction risk and  quantitative properties of the mammalian phylogeny. I used _MCMCglmm_ to fit Phylogenetic Generalised Linear Mixed Models (PGLMM; or the cooler-sounding Bayesian Phylogenetic Mixed Models, BPMM). This research was published in 2013 [[OA link]](http://rspb.royalsocietypublishing.org/content/280/1765/20131092.short) and since then I've seen ordinal extinction risk modeling used to address some interesting questions for amphibians and beetles, using SAS and Mesquite routines that I haven't looked into yet.

I'm still proud of having published the "first" ordinal/phylogenetic mammal extinction risk  paper. I shared all my data and described the methods as thoroughly as I could, but I did not make my analysis and visualisation code available. On top of that I flaked when someone emailed me and requested the R code (sorry Jörg). I admit that at the time I was:
- very sloppy at R and keeping track of scripts and data
- ashamed of my non-optimised code, annotated mostly in Spanish
- scared of blatant errors that I might have somehow missed, which would make the paper wrong and useless (despite having being checked by my supervisors)
- away on extended field work and conference travel

I ended up perpetuating the annoying trend of not supplying materials ["upon request"](http://www.tandfonline.com/doi/abs/10.1080/08989621.2012.678688?url_ver=Z39.88-2003&rfr_id=ori%3Arid%3Acrossref.org&rfr_dat=cr_pub%3Dpubmed&) and I'd like to make it right. Below is a fully reproducible example for running and plotting a multivariate model of extinction risk in terrestrial carnivores (cliché/well-studied group) that takes into account phylogenetic relatedness between species, and the ordinal nature of Red List Data. It outlines what I did in the 2013 paper. 

## #Rstats example code

This code is not very elegant, but it should be fully reproducible as long as you have an internet connection. Make sure you install the latest version of all the required packages and please let me know of any serious mistakes or cool data wrangling tips that I could incorporate. The full script is here. 



{% highlight r %}

# Load dplyr for data manipulation
require(dplyr)

# For reproducibility, read the table directly from the publication's URL 
PantheriaWebAddress <- "http://esapubs.org/archive/ecol/e090/184/PanTHERIA_1-0_WR05_Aug2008.txt"
pantheria <- read.table(file=PantheriaWebAddress,header=TRUE,sep="\t",na.strings=c("-999","-999.00"),stringsAsFactors = FALSE)

# In this example we'll work with terrestrial carnivores 
carnivora <- filter(pantheria, 
                    MSW05_Order == "Carnivora"&
                    MSW05_Family!="Phocidae"&
                    MSW05_Family!="Otariidae"&
                    MSW05_Family!="Odobenidae")


# we'll use adult body mass (body size) and litter size for this exercise
# dplyr select can already be used to rename
carnivora <- select(carnivora,
                    Species = MSW05_Binomial,
                    BodySize = X5.1_AdultBodyMass_g,
                    LitterSize = X15.1_LitterSize)


# keep only complete cases
carnivora <- carnivora %>% filter(complete.cases(.)) 

# get the extinction risk values from the IUCN Red List API
# the letsR package can also query the Red List website but I've had http issues lately
require(taxize)
# get IUCN data summary
carnivoraIUCNSummary <- iucn_summary(carnivora$Species)
# extract threat status values
carnivoraIUCNdata <- iucn_status(carnivoraIUCNSummary)
# manipulate into dataframe of complete cases
carnivoraIUCNdata <- data.frame(carnivoraIUCNdata)
carnivoraIUCNdata$Species <- row.names(carnivoraIUCNdata)
carnivoraIUCNdata <- rename(carnivoraIUCNdata,Status = carnivoraIUCNdata)
carnivoraIUCNdata <- carnivoraIUCNdata %>% filter(complete.cases(.),Status!="DD") 

# change Red List status to numerical index
require(letsR)
carnivoraIUCNdata$Status <- lets.iucncont(carnivoraIUCNdata$Status)+1

# merge tables
carnivoraFinal <- merge(carnivoraIUCNdata,carnivora,by="Species")
# logTransform body size
carnivoraFinal$lBodySize <- log(carnivoraFinal$BodySize)

# get a phylogeny
require(geiger)
# This resolved tree comes from Rolland et al (2014)
treeURL <- "http://journals.plos.org/plosbiology/article/asset?unique&id=info:doi/10.1371/journal.pbio.1001775.s001"
mammalPhylo <- read.tree(file=treeURL)

# trim tree to species in dataset
# but first, replace spaces to underscores to match tree tip formatting
carnivoraFinal$Species <- gsub(" ","_",carnivoraFinal$Species)
row.names(carnivoraFinal) <- carnivoraFinal$Species

# trim the phylogeny to match the data
carnPhylo <- treedata(mammalPhylo,carnivoraFinal)$phy

# drop the species not found in the tree
# treedata changes numeric to factor when dropping rows, so we drop them manually
toDrop <- setdiff(carnivoraFinal$Species,carnPhylo$tip.label)
carnivoraData <- carnivoraFinal[!rownames(carnivoraFinal) %in% toDrop, ]


}
{% endhighlight %}

For this example I ignore any issues with missing data, taxonomy and synonyms, and phylogenetic uncertainty. All these can and should be addressed in a proper extinction risk study, especially one that aims to inform conservation. 
Missing data can be completed with throrough searches of recent or grey literature, or imputation techniques can fill in the gaps.  Phylogenetic uncertainty can be addressed by performing MCMCglmm across multiple trees using the mulTree functions by the TCD . 


{% highlight r %}

# Now to run the multivariate model
require(MCMCglmm)

# create phylogenetic covariance matrix
Ainv <- inverseA(carnPhylo,nodes = "TIPS")$Ainv

# Define priors
# V prior follows suggested Gelman prior for ordinal regression by Gelman (2008), modified by J. Hadfield see function documentation
# R is fixed for an ordinal probit model. See function documentation
prior <- list (B=list(mu=rep(0,3), V=gelman.prior(~ lBodySize+LitterSize, data=carnivoraData, scale=1+pi^2/3)),
               R = list(V = 1, fix= 1), 
               G = list(G1= list(V=1e-6, nu=-1)))        
 
# run model 
 
ERiskModel <- MCMCglmm(Status ~ lBodySize+LitterSize,
              data=carnivoraData, random=~Species,
              ginverse=list(Species=Ainv), family = "ordinal",
              prior= prior, nitt=600000, burnin=100000, thin=500)

# evaluate convergence
heidel.diag (ERiskModel$Sol) # Heidelberg and Welch (1983) diagnostic test
autocorr (ERiskModel$Sol) # autocorrelation of succesive samples (should be near 0)
plot (ERiskModel) # visual inspection of mixing properties of the MCMC chain


# explore results
summary (ERiskModel)
# summarize model for plotting
summModel <- summary(ERiskModel)

}
{% endhighlight %}

The number of iterations can be changed 
parallel chains, pooling chains that have different starting values, just by looking at the summary and trace plots (fuzzy caterpillars) we see a positive relationship between body size and extinction risk. 

Next block of code is for plotting the effect of body size on extinction risk 

{% highlight r %}

# new data for prediction
# vectors for each predictor variable, based on the data

logBSize = seq(min(carnivoraData$lBodySize),max(carnivoraData$lBodySize), length.out=nrow(carnivoraData))
LitterSize = seq(min(carnivoraData$LitterSize),max(carnivoraData$LitterSize), length.out=nrow(carnivoraData))


# to plot the body size~threat relationship keeping the effect of gest. length constant

newdat2 <- as.matrix(data.frame("(Intercept)"=1,
                      bodySize = logBSize,
                      LitterSize = median(LitterSize))) 
            


# probabilities of falling into categories
# this follows ...http://doingbayesiandataanalysis.blogspot.mx/2014/11/ordinal-probit-regression-transforming.html
# https://stat.ethz.ch/pipermail/r-sig-mixed-models/2010q2/003673.html



require(devtools)
install_github ("postMCMCglmm", "JWiley")
require (postMCMCglmm)

## calculate predicted values

predCarn <- predict2(ERiskModel, X=newdat2, use = "all", Z=NULL, type = "response", varepsilon = 1)
summPredCarn <- summary (predCarn,level=0.99)

## combine predicted probs + HPD intervals with prediction data
predProbsCarn <- as.data.frame (cbind(do.call(rbind, rep(list(newdat2),5)), do.call(rbind,summPredCarn)))

## indicator for which level of the outcome
predProbsCarn$outcome <- factor (rep(c("LC","NT","VU","EN","CR"), each = nrow(summPredCarn[[1]])), 
                                 levels=c("LC", "NT", "VU", "EN", "CR"))



predProbsCarnLC <-  predProbsCarn %>%
  filter(outcome=="LC") %>%
  dplyr::select(M,LL,UL)%>%  
  cbind(newdat2[,2])

predProbsCarnNT <-  predProbsCarn %>%
  filter(outcome=="NT") %>%
  dplyr::select(M,LL,UL)%>%  
  mutate_each(funs(addProb = .+1)) %>%
  cbind(newdat2[,2])

predProbsCarnVU <-  predProbsCarn %>%
  filter(outcome=="VU") %>%
  dplyr::select(M,LL,UL)%>%  
  mutate_each(funs(addProb = .+2)) %>%
  cbind(newdat2[,2])

predProbsCarnEN <-  predProbsCarn %>%
  filter(outcome=="EN") %>%
  dplyr::select(M,LL,UL)%>%  
  mutate_each(funs(addProb = .+3)) %>%
  cbind(newdat2[,2])

predProbsCarnCR <-  predProbsCarn %>%
  filter(outcome=="EN") %>%
  dplyr::select(M,LL,UL)%>%  
  mutate_each(funs(addProb = .+4)) %>%
  cbind(newdat2[,2])

predProbPlot <- rbind.data.frame(predProbsCarnLC,
                                 predProbsCarnNT,
                                 predProbsCarnVU,
                                 predProbsCarnEN,
                                 predProbsCarnCR)


predProbPlot <- rename(predProbPlot,bodySize=`newdat2[, 2]`)
predProbPlot$outcome <- factor (rep(c("LC","NT","VU","EN","CR"), each = nrow(summPredCarn[[1]])), 
                                levels=c("LC", "NT", "VU", "EN", "CR"))



require(ggplot2)


 ggplot (predProbPlot, aes(x = bodySize, y = M, colour = outcome)) +
  geom_ribbon(aes(ymin = LL, ymax = UL, fill = outcome), alpha = .25) +
  geom_line(size=2)+
  scale_y_continuous(breaks=seq(0.5,4.5,by=1),
                     labels=c("LC", "NT", "VU", "EN", "CR"),expand=c(0,0))+
  scale_x_continuous(expand=c(0,0))+
  ylab("threat category")+xlab("log(body size)")+
  scale_color_manual(values=c("#fed976","#feb24c","#fd8d3c","#f03b20","#bd0026"),name="Red List Status")+
  scale_fill_manual(values=c("#fed976","#feb24c","#fd8d3c","#f03b20","#bd0026"), guide=FALSE)+
  theme_classic()+theme(legend.position = "none",axis.ticks.y = element_blank())+
   geom_hline(yintercept=seq(0:4),by=1)
 
 
}
{% endhighlight %}

De Lisle, S. P., & Rowe, L. (2015) Independent evolution of the sexes promotes amphibian diversification. 282. doi:10.1098/rspb.2014.2213.

Seibold, S., Brandl, R., Buse, J., Hothorn, T., Schmidl, J., Thorn, S., et al. (2015) Association of extinction risk of saproxylic beetles with ecological degradation of forests in Europe. Conservation Biology.
