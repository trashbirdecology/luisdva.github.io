---
title: "Dog breeds bump chart"
layout: post
excerpt: Showing how popularity rankings for dog breeds change through time. 
category: rstats
tags:
  - ggplot2
  - bump chart
  - labradors
  - akc
  - pup
image:
  feature: featureDoggs.png
  credit: 
  creditlink: 
published: false
---

Last week, the American Kennel Club announced the 2017 rankings of dog breed popularity in the USA (news story here)http://people.com/pets/akc-most-popular-dog-breed-2017/. A few days later, Dominik Koch blogged https://dominikkoch.github.io/Bump-Chart/ about creating bump charts in ggplot2 to show changes in rank over time. 

The ACK also released an update to the full list of breed rankings from 2013 to 2017 
http://www.akc.org/expert-advice/news/most-popular-dog-breeds-full-ranking-list/ , and it looked like a good dataset to try out the code for making bump charts. 

For this example, I was only interested in the top ten breeds of 2017 and how they’ve changed in ranking since 2013. 

In the original bump chart example with Olympic medal rankings, countries are labeled using little flags and the ggflags package. I wanted to use custom images as labels, and the ggimage package worked out great for that. I’ve written code to scrape and download dog photos by breed in the past, but for this post I drew each dog by hand. 

Side note: I used this nifty function by Maelle Salmon for batch resizing images using purrr and magick. I uploaded all the drawings here. 


Get the data

To import the rankings into R, I used Miles McBain’s datapasta to smoothly copy and paste the first ten entries directly from a web browser to my source script in RStudio. The variable names for the different years needed some editing, but everything else stays as is. 

Code

To annotate the plots with my own dog drawings, I simply needed to add a variable containing the filenames that correspond to each breed. After that, wrangling the data into a long form suitable for making the bump chart was pretty easy thanks to various functions from dplyr and tidyr.

code

I used the same custom theme as Dominik, and just had to change the labels and margins so that I could have breed names and breed drawings as annotations on either side of the chart. 

Final plot
