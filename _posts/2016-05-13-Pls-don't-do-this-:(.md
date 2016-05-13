---
layout: post
title: pls don't do this :(
excerpt: "Easy changes to make before sharing tablular data with others. "
tags: 
  - Excel
  - reshape2
  - merge and center
image: 
  feature: featurepls.png
  credit: null
  creditlink: null
published: true
---


Three common bad practices in sharing tables and spreadsheets and how to avoid them.

In the past month I’ve been busy with collaborations, and by coincidence all the projects that I’m involved with reached the stage of actually having completed datasets. This has involved me receiving data via email or shared web folders. So far all these data has come in Excel spreadsheets. Personally, I don’t have anything against xls files and I won’t start judging others. However, with this post I want to share three common spreadsheet practices that we should all avoid when preparing and sharing data in a tabular format. These are all things I’ve done in the past, but they add complication and slow things down at the time of analysis and data manipulation.

Obviously there are workarounds and fancy ways to solve the complications programmatically but I won’t get into that here. It’s easier if those with the original data avoid messy spreadsheet practices from the very start. I go through the three spreadsheet practices that I see most often, with examples and suggestions.

# 1 Color-coding and other formatting

Spreadsheet programs let us format cells and their content with different colors, borders, font types, etc. Highlighted cells are a good visual aid, and sometimes I use them but never when I plan on sharing the files with anyone else.
By doing this, whatever the color represents is stacked with the actual data in the cell, with no easy way to separate these two (or more) values. 

<figure>
    <a href="/images/xlsEx1.png"><img src="/images/xlsEx1.png"></a>
        <figcaption>with a helpful legend underneath the cells</figcaption>
</figure>


Suggestion: add additional columns with the information that was being conferred by the formatting. It might look redundant but it’s an incredible time saver and very convenient within scripting languages.

<figure>
    <a href="/images/xlsEx1.2.png"><img src="/images/xlsEx1.2.png"></a>
        <figcaption>much better</figcaption>
</figure>

# 2. Merged cells

Merged cells will look good in the final version of a table, but they can lead to strange behaviours when trying to read and manipulate the data with other programs. 

<figure>
    <a href="/images/xlsEx2.1.png"><img src="/images/xlsEx2.1.png"></a>
        <figcaption>everything is better melted</figcaption>
</figure>

Suggestion: suck it up and repeat the content that was merged in the first place. R, Python and Julia can deal just fine with this kind of melted presentation of the data.

# 3. Weird header rows

This is a very common practice for data that follows some hierarchy. I see this often in papers from my field because this arrangement can convey geographic or taxonomic membership of different rows to whatever is referred to in the header row.

<figure>
    <a href="/images/xlsEx3.png"><img src="/images/xlsEx3.png"></a>
        <figcaption>very common in appendices</figcaption>
</figure>

Suggestion: Same as before, add a new column specifying the membership of each row.

<figure>
    <a href="/images/xlsEx3.1.png"><img src="/images/xlsEx3.1.png"></a>
        <figcaption>very common in appendices</figcaption>
</figure>


That's it. All the suggested changes might make the tables less appealing visually, but they structure the data in a way that saves everyone time. No more sunny afternoons wasted fixing tables by hand. 
