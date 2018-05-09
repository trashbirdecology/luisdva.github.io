---
title: "This is what happens when you encode data as cell formatting in Excel"
layout: post
excerpt: Extracting and wrangling data encoded as formatting in multi-sheet Excel files. 
category: rstats
tags:
  - clippy
  - spreadsheets
  - excel
  - readxl
  - tidyxl
image:
  feature: featureDoggs.png
  credit: Pixabay CC0 image
  creditlink: 
published: false
---

I recently offered to help create the game cards for a mammalogy-themed trivia board game that will be made available later in the year. The questions and answers had already been prepared and they were stored in an Excel file.  

When it was first described to me, the data structure seemed sensible:
- one worksheet per topic
- one row per question, followed by the possible answers on the same row

All I had to do was wrangle the questions and answers into little tables with one question from each topic and put them in MS Word documents that would then be given to a graphic designer at the print shop.

Everything seemed fine, until I opened the spreadsheet and realized that the correct answers were highlighted in bold, and the position of the correct answer for each question was already randomized. I’ve written about not using formatting this way (and so have many others before me) , but I personally hadn’t had to deal with this kind of dataset before. 
