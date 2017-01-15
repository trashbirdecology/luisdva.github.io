---
layout: post
excerpt: Using R and dplyr to extract minimum or maximum (or both) variable values within groups.
tags:
  - rstats
  - dplyr
  - minmax
  - mammals
image:
  feature: featureMinMax.jpg
  credit: null
  creditlink: null
published: true
---
> Esta publicación está disponible en español [aqui](http://luisdva.github.io/Valores-m%C3%A1ximos-y-m%C3%ADnimos-para-datos-agrupados/)

In tables that contain data for many different groups, getting the maximum and minimum values (or the top _n_ or bottom _n_ values) of a continuous variable within each group is (I think) a common enough task. These are some simple examples:

- largest and smallest species in an order or family
-  best represented taxonomic groups in a collection, grouped by geographic unit

Despite the prevalence of this task in data wrangling for biodiversity research, I couldn’t find any documentation online so I thought I should contribute. 
The following is an approach that I saw someone else do using a spreadsheet program, and it inspired this post. There’s nothing particularly wrong with doing it this way, it just takes more time, is harder to document, and has to be repeated manually in case the original table is modified.

1. Make a new copy of the original spreadsheet. 
2. Separate each group into a new sheet within the workbook (copying and pasting after arranging the rows so the groups appear together).
3. Use conditional formatting to highlight the top and bottom values in a column.
4. Delete the rows that aren’t highlighted.
5. Copy and paste everything into a single table.

An alternative is to use R and the capability of the _dplyr_ package to work on groups, as well as the _top\_n_ function (a convenient wrapper that uses _filter_ and _min\_rank_ to select the top or bottom entries in each group). 

In this example, we can use brain mass data for hundreds of mammals from [this](http://onlinelibrary.wiley.com/doi/10.1111/evo.12943/abstract) paper by Gonzalez Voyer et al. and extract the maximum and minimum values for brain mass within each taxonomic group (orders in this case).

First, we download the data directly from Dryad and have a look at its structure and properties. Because we want maximum and minimum values, we can filter out orders that are either monotypic or have only one entry in this database.

{% highlight r %}
# load the required packages (install first if needed)
library(dplyr)
library(ggplot2)

# download the table directly from Dryad
brains <- read.csv("http://datadryad.org/bitstream/handle/10255/dryad.114692/Gonzalez-Voyer_et_al_Evolution_Brain_Data.csv?sequence=1")

# check it out
glimpse(brains)

# count how many entries per order
brains %>% count(Taxonomic_order)
# new DF with only orders that have 2 or more species
brains2 <- brains %>% group_by(Taxonomic_order) %>% filter(n()>1)
{% endhighlight %}

Now we can use pipes, the _group\_by_ function and _top\_n_ to get the top and bottom values within each group. In this case, I get the top and bottom values separately and then bind the rows using _bind\_rows_.

{% highlight r %}
# create data frame with top values of each group
brtop <-   brains2 %>% group_by(Taxonomic_order) %>% top_n(1,Brain_mass_g)
# create data frame with bottom values of each group
## note that we use a minus sign rather than a different function
brbottom <-   brains2 %>% group_by(Taxonomic_order) %>% top_n(-1,Brain_mass_g)
# bind and arrange
minmaxBr <- bind_rows(brtop,brbottom) 
minmaxBr <- arrange(minmaxBr,Taxonomic_Order)
# look at the result for bats
minmaxBr %>% filter(Taxonomic_order=="Chiroptera")
{% endhighlight %}

| Taxonomic_order | Species_name           | Brain_mass_g |
|-----------------|------------------------|--------------|
| Chiroptera      | Pteropus_giganteus     | 7.605096     |
| Chiroptera      | Pipistrellus_subflavus | 0.125000     |

In this new data frame we see that the bat (Order Chiroptera) with the highest brain mass is _Pteropus giganteus_ and the bat with the lowest brain mass is the tiny _Pipistrellus subflavus_. 
We can even plot the resulting maximum and minimum brain mass values for a few orders (on a log scale, using a hacky approach to _geom\_path_) to see some of the variation.

{% highlight r %}
# plot the min and max values for a few random orders
minmaxBr %>% filter(Taxonomic_order %in% sample(levels(minmaxBr$Taxonomic_order),5)) %>% 
ggplot(aes(x=Taxonomic_order,y=log(Brain_mass_g)))+geom_path()+theme_minimal()
{% endhighlight %}

<figure>
    <a href="/images/bothslopes.png"><img src="/images/brainMasses.png"></a>
        <figcaption>click to enlarge</figcaption>
</figure>


Note that in case of ties, the documentation states that _top\_n()_ either takes all rows with a value, or none.

If you found this helpful or if anything isn't working properly, please get in touch.
Happy 2017,
LD.
