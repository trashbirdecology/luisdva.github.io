---
published: false
---

At some point we all end up working with large(ish) sets of for example, morphological measurements for museum specimens, occurrence records from bird surveys, average values for many species.  
Here are some 

Admit that probably a year into my PhD, and with an R expert like Simon Blomberg as a supervisor I still wasted a lot of time getting my data ready manually. I took a long time transitioning from xls spreadsheets, doing and a lot of copying and pasting, writing things down on paper, and retyping data.

Hopefully people can find this post with web searches, but this also a reference for myself. I often have to  go through my old scripts to remember how to do these basic operations.


# Separators

Many 
Sometimes the different parts of a scientific name are separated by non-whitespace characters. (many phylogenetic programs don’t like spaces) We can replace them all using pattern matching + replacement with gsub 


{% highlight r %}


{% endhighlight %}

# combining columns

Sometimes, we find that a scientific name has been split into columns when we open a table
In excel, I used to do this with the & operator, then copy and paste the values into a new column before removing the one with the formula and saving as a csv for R

# change var order

# fill w existing colum

# how many of each






The data structure is ready for plotting, and this can all be done with _ggplot()_ to initialize a ggplot object and _geom\_bar()_ to draw the bars.
{% highlight r %}
#if you don't have the packages you can install them all from CRAN using install.packages()
library(ggplot) 
library(ggthemes)
library(palettetown)
# plot the data
ggplot(newDataFr)+
  geom_bar(aes(y=individuals,x=critter,fill=trapped),position="dodge",stat="identity")
{% endhighlight %}

<figure>
    <a href="/images/bars1.png"><img src="/images/bars1.png"></a>
        <figcaption>starting out</figcaption>
</figure>