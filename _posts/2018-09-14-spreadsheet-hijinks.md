---
title: "Spreadsheet tomfoolery"
layout: post
excerpt: The results from crowd-sourcing a suitable term for a common spreadsheet practice.
tags:
  - excel
  - munging
  - unheadr
  - clippy
image: 
  feature: featureExcel.png
  credit: 
  creditlink: 
published: false
---
Earlier in the week Jenny Bryan helped me ask the Twitter community what to call this widely used spreadsheet habit (see the image in my Tweet).

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Do you have a pithy name for this spreadsheet phenomenon? Do tell! <a href="https://t.co/XbqOOSmr4i">https://t.co/XbqOOSmr4i</a></p>&mdash; Jenny Bryan (@JennyBryan) <a href="https://twitter.com/JennyBryan/status/1039267761174732800?ref_src=twsrc%5Etfw">September 10, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

I kept track of the replies to my tweet and to Jenny's retweet, and here are _most_ of the suggested names... 


<figure>
    <a href="/images/factros.png"><img src="/images/factros.png"></a>
</figure>


and again as a proper table...

|term given                                                               |user hande       |
|:------------------------------------------------------------------------|:----------------|
|Replies to Luis                                                          |NA               |
|pain in the neck                                                         |@AnneMarie_DC    |
|interrupting subheaders                                                  |@pandapoop42     |
|Interstitial group labels                                                |@BrodieGaslam    |
|Nested relational model                                                  |@arnabdotorg     |
|subgroups                                                                |@Thoughtfulnz    |
|group titles, group names                                                |@benomial        |
|partial normalization for human/visual consumption                       |@jgraham909      |
|groups, grouping                                                         |@jgraham909      |
|demon rows                                                               |@NthChapter      |
|Meta-data                                                                |@IsabellaGhement |
|Embheaders (embedded headers)                                            |@tammylarmstrong |
|pivots                                                                   |@antonycourtney  |
|spreadsheet block groups, spreadsheet sub-table groups, sub-table groups |@cormac85        |
|Meta-data headers                                                        |@cbirunda        |
|group representatives, grouping criterion                                |@Teggy           |
|complete shit                                                            |@StevenNHart     |
|2D matrix in a column of a data frame                                    |@dnlakhotia      |
|subgroups                                                                |@enoches         |
|paragraph grouping                                                       |@gshotwell       |
|Highlighted Collapsed Factor                                             |@PragmaticDon    |
|small multiples                                                          |@nacnudus        |
|Replies to Jenny                                                         |NA               |
|Merged cells gone wild                                                   |@RikaGorn        |
|windowmakers, widowmakers                                                |@polesasunder    |
|rowgory, separators                                                      |@EmilyRiederer   |
|Factros (factor rows)                                                    |@EmilyRiederer   |
|Growps = row + groups                                                    |@thmscwlls       |
|20 minutes of uninterrupted screaming                                    |@tpoi            |
|premature tabulation                                                     |@pdalgd          |
|Read bumps                                                               |@MilesMcBain     |
|Row group headers                                                        |@dmik3           |
|factor interruptus                                                       |@zentree         |
|Beheaders                                                                |@djhocking       |
|Third Abnormal Form                                                      |@pitakakariki    |
|Hydra                                                                    |@JasonWilliamsNY |
|stubs                                                                    |@IanDennisMiller |
|nuisance categorical ( or subgroup) variables                            |@nspyrison       |
|Categorical nuisance formatting                                          |@nspyrison       |
|Business logic                                                           |@doomsuckle      |
|Data beheading! Factorless features, grouping gone wrong...              |@SamanthaSifleet |
|Adjacent attribution                                                     |@dagoodman1      |
|group names                                                              |@benomial        |
|facet but in tabular form                                                |@kdpsinghlab     |
|murder of rows                                                           |@RileenSinha     |
|GroupNotRow                                                              |@kevin_lanning   |

Overall, there seems to be no clear-cut consensus but a few themes kept popping up, 

In the end, this is what I'll 

mention **attribution by adjacency** (apparently a term from computer science used when defining clauses to parsisng text strings) , because these embedded subheaders are used to imply that the rows below them belong to a subgroup until a new subheader indicates otherwise. 

I like the name factros (factor rows), it has a cool tidyverse ring to it and I when I update the documentation for _unheadr_
