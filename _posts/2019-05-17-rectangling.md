---
title: "Data Rectangling Resource Roundup"
excerpt: Links to material on Data Rectangling. 
tags:
  - Jenny
  - tidy
  - spreadsheets
  - data organization
  - unheadr
header:
  image: /assets/images/featureRectangle.png
---

Earlier this month, I spotted this definition in the _tidyr_ package [vignette](https://tidyr.tidyverse.org/dev/articles/rectangle.html){:target="_blank"}:

> Rectangling is the art and craft of taking a deeply nested list (often sourced from wild caught JSON or XML) and taming it into a tidy data set of rows and columns.   

“Data rectangling” was coined by [Jenny Bryan](https://twitter.com/JennyBryan){:target="_blank"} around 2016-2017 and has been making the rounds ever since.

<script async class="speakerdeck-embed" data-slide="2" data-id="b17d10a4f8d84b768caa82fdacfa2e05" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>  
<br>

Data rectangling originally meant taking nested data and lists of lists, and ultimately getting a nice rectangular data frame thanks to the flexibility of list-columns.

Here is a very suitable example ([from Jenny's Lego-Rstats gallery](https://github.com/jennybc/lego-rstats){:target="_blank"}) of how data can be nested and/or rectangled:

Data frames are not limited to atomic vectors.
<img src="https://raw.githubusercontent.com/jennybc/lego-rstats/master/lego-rstats_013-smaller.jpg" > 

In parallel, this great guide on [data organization in spreadsheets](https://doi.org/10.1080/00031305.2017.1375989){:target="_blank"} 
by [Karl Broman](https://twitter.com/kwbroman){:target="_blank"} and [Kara Woo](https://twitter.com/kara_woo){:target="_blank"} also suggests making data rectangular, with rows corresponding to subjects and columns corresponding to variables. This recommendation addresses flat tables and their layouts without necessarily mentioning nested arrays, lists or JSON/XML formats.

In a recent [guide](https://doi.org/10.4404/hystrix-00133-2018){:target="_blank"} for sharing human and machine-readable biodiversity data, we (myself, [Natalie Cooper](https://twitter.com/nhcooper123){:target="_blank"} and [Guillermo D’Elía](https://twitter.com/GuillermoDElia){:target="_blank"}) kept the same focus on layouts when referring explicitly to data rectangling. As examples of of non-rectangular data, we mentioned unstructured text, spreadsheets holding multiple disparate tables, nested lists, or more complex data structures such as JavaScript Object Notation (JSON) files.

The focus on layouts in these two publications is somewhat in conflict with the original definition of data rectangling, which focuses on the nested data.

When I asked for clarification, [Hadley Wickham](https://twitter.com/hadleywickham){:target="_blank"} rightfully noted that in the examples of ‘non-rectangular’ data from both of these publications, the data are already in a single rectangle with rows and columns and that ‘data tidying’ would be more suitable for the process of making such data usable. 

<figure>
    <a href="/assets/images/rectfigs.png"><img src="/assets/images/rectfigs.png"></a>
        <figcaption>click to enlarge</figcaption>
</figure>
<br>

However, Jenny said of the same examples that those data are ‘rectangular’ in the same way that this cat is bowl-shaped.

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">but sometimes such data is “rectangular” in the same sense that this cat is “bowl-shaped” 😂 <a href="https://t.co/ZmxvgcV57d">pic.twitter.com/ZmxvgcV57d</a></p>&mdash; Jenny Bryan (@JennyBryan) <a href="https://twitter.com/JennyBryan/status/1126582138344595456?ref_src=twsrc%5Etfw">May 9, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<br>
Wherever we decide to place 'data rectangling' on the spectrum of untidy data to deeply nested lists and complex objects, here are some relevant resources: 


## Principles
Presentation by Jenny Bryan at RStudio::conf  
-[video](https://www.rstudio.com/resources/videos/data-rectangling/){:target="_blank"}  
-[slides](https://speakerdeck.com/jennybc/data-rectangling-1){:target="_blank"}  


## Rectangling (non-nested data) 

[Data organization in spreadsheets](https://doi.org/10.1080/00031305.2017.1375989){:target="_blank"}  
Must-read guide for data entry and management. 

[Good practices for sharing biodiversity data](https://doi.org/10.4404/hystrix-00133-2018){:target="_blank"}  
Tips for creating and sharing human and machine-readable data.

*Get good data out of bad spreadsheets*  
[Duncan Garmonsway](https://twitter.com/nacnudus){:target="_blank"} beheads and unpivots messy and not very rectangular spreadsheet data in this recent talk.

- [slides](https://docs.google.com/presentation/d/1tVwn_-QVGZTflnF9APiPACNvyAKqujdl6JmxmrdDjok/edit?usp=sharing){:target="_blank"}  
- [video](https://www.youtube.com/watch?v=PYAxTuPk1mc){:target="_blank"}  

## Nested data

[tidyr vignette](https://tidyr.tidyverse.org/dev/articles/rectangle.html){:target="_blank"}  
Three worked examples with geocoding data, Game of Thrones, and discographic material

[Kung Fu films analysis](https://vallandingham.me/shaw_bros_analysis.html){:target="_blank"}  
Exploring martial arts film trends from a JSON data source, by [Jim Vallandingham](https://twitter.com/vlandham){:target="_blank"}.

[list-column tutorial](https://jennybc.github.io/purrr-tutorial/ls13_list-columns.html){:target="_blank"}  
Essential background reading, from a _purrr_ tutorial by Jenny Bryan.

## Relevant packages

_R_
---
[tidyr](https://tidyr.tidyverse.org/dev/index.html){:target="_blank"} - Reshaping and unnesting data, tidyverse style.  

[tidyxl](https://github.com/nacnudus/tidyxl){:target="_blank"} - Rectangling spreadsheets and dealing with meaningful formatting.

[tidyjson](https://github.com/sailthru/tidyjson){:target="_blank"} - A pipe and _dplyr_-friendy way to parse JSON files.

[unpivotr](https://github.com/nacnudus/unpivotr){:target="_blank"} - For complex and irregular data layouts. Especially useful for data with mutliple headers.

[unheadr](https://github.com/luisDVA/unheadr){:target="_blank"} - For subheaders embedded in the data rectangle.

_Python_
---
[Databaker](https://databaker.sensiblecode.io/){:target="_blank"} - Jupyter notebook tool for working with spreadsheets.




If I'm missing anything let me know and I'll add it.

