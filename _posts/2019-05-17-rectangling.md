---
title: "Data Rectangling Resource Roundup"
layout: post
excerpt: Links to material on Data Rectangling. 
tags:
  - Jenny
  - tidy
  - spreadsheets
  - data organization
  - unheadr
image:
  feature: featureRectangle.png
  credit: 
  creditlink: 
published: false
---

From the tidyr package vignette:
https://tidyr.tidyverse.org/dev/articles/rectangle.html

Rectangling is the art and craft of taking a deeply nested list (often sourced from wild caught JSON or XML) and taming it into a tidy data set of rows and columns. 

“Data rectangling” was coined by [Jenny Bryan](https://twitter.com/JennyBryan) around 2016 and has been making the rounds ever since.

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">“Rectangling” should be in the running for the merriam webster word of the year.</p>&mdash; Martin Frigaard (@mjfrigaard) <a href="https://twitter.com/mjfrigaard/status/990307358596259840?ref_src=twsrc%5Etfw">April 28, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>  

<script async class="speakerdeck-embed" data-id="907f3dc0cdb5496c8d35efca70e5f6bd" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>  

Data rectangling originally meant taking nested data and lists of lists, and ultimately getting a nice rectangular data frame thanks to the flexibility of list-columns.

Lego example

In parallel, this great guide on [data organization in spreadsheets](https://doi.org/10.1080/00031305.2017.1375989) 
by Karl Broman and Kara Woo also suggests making data rectangular, with rows corresponding to subjects and columns corresponding to variables. This recommendation addresses flat tables and their layouts without necessarily mentioning nested arrays, lists or JSON/XML formats.

In a recent [guide](https://doi.org/10.4404/hystrix-00133-2018) for sharing human and machine-readable biodiversity data, we (myself, Natalie Cooper and Guillermo D’Elía) kept the same focus on layouts when referring explicitly to data rectangling, but I made sure to mention nested data and JSON files.

The focus on layouts in these two publications is somewhat in conflict with the original definition of data rectangling, which focuses on the nested data.

When I asked for clarification, and [Hadley Wickham](https://twitter.com/hadleywickham) rightfully noted that in the examples of ‘non-rectangular’ data from both of these publications, the data are already in a single rectangle with rows and columns and that ‘data tidying’ would be more suitable for the process of making such data usable. 

examples

However, Jenny said of the same examples that those data are ‘rectangular’ in the same way that this cat is bowl-shaped.

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr">but sometimes such data is “rectangular” in the same sense that this cat is “bowl-shaped” 😂 <a href="https://t.co/ZmxvgcV57d">pic.twitter.com/ZmxvgcV57d</a></p>&mdash; Jenny Bryan (@JennyBryan) <a href="https://twitter.com/JennyBryan/status/1126582138344595456?ref_src=twsrc%5Etfw">May 9, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>



Other common examples of non-rectangular data include unstructured text, spreadsheets holding
multiple disparate tables, nested lists, or more complex data structures such as JavaScript Object Notation (JSON) files.

in a spectrum of untidy data, to deeply nested lists and 

Principles and definitions
Data rectangling . JB Rstudio talk. And slides


Rectangling layout and untidy 

Data organization in spreadsheets
https://doi.org/10.1080/00031305.2017.1375989

Good practices for sharing ….
https://doi.org/10.4404/hystrix-00133-2018

Get good data out of bad spreadsheets
[Duncan Garmonsway](https://twitter.com/nacnudus) beheads and unpivots messy spreadsheet data, a c

[slides](https://docs.google.com/presentation/d/1tVwn_-QVGZTflnF9APiPACNvyAKqujdl6JmxmrdDjok/edit?usp=sharing) and [video](https://www.youtube.com/watch?v=PYAxTuPk1mc)

Nested objects

Shaw Bros 
https://vallandingham.me/shaw_bros_analysis.html

tidyr

tidyjson

Relevant packages

R  
[tidyr](https://tidyr.tidyverse.org/dev/index.html) - 
[tidyxl](https://github.com/nacnudus/tidyxl) - 
[tidyjson](https://github.com/sailthru/tidyjson) - A pipe and _dplyr_-friendy way to parse JSON files.
[unpivotr](https://github.com/nacnudus/unpivotr) - 
[unheadr](https://github.com/luisDVA/unheadr) - 


Python  
[Databaker](https://databaker.sensiblecode.io/)




