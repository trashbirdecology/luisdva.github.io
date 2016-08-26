---
layout: post
excerpt: Emoji flags, international research, and tweet analysis in R.
tags:
  - rstats
  - Twitter
  - stringi
  - encoding
image:
  feature: featureflags.png
  credit: null
  creditlink: null
published: true
---
## Tweet data and emoji flags in R

On the occasion of the ESOF (EuroScience Open Forum) conference in Manchester, The Royal Society published a [joint statement](https://royalsociety.org/topics-policy/publications/2016/european-academies-statement-science-is-global/) from various scientific societies across Europe about the importance of International science and research collaborations, and how “unnecessary barriers to mobility will weaken science and be to the cost of all nations”. This statement included a call for people to use the social media hashtag #ScienceIsGlobal to recognize the international nature of research teams.  

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Our joint academies’ statement on the importance of international research <a href="https://twitter.com/hashtag/ScienceIsGlobal?src=hash">#ScienceIsGlobal</a> (1/4) <a href="https://t.co/LFsSotfeW7">pic.twitter.com/LFsSotfeW7</a></p>&mdash; The Royal Society (@royalsociety) <a href="https://twitter.com/royalsociety/status/757537126649065472">July 25, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

The hashtag really took off, and in a Tweet from August 1st the Royal Society posted that #ScienceIsGlobal had reached over 10 million people across the world. Lots of people started sharing the different countries of the people in their labs or collaborative networks, mainly by using emoji flags or photos of the research teams actually holding their national flags. 

A few days later, Bastian Greshake published [this](http://ruleofthirds.de/scienceisglobal/) really cool blog post in which he analysed tweet data relating to the hashtag. To make a network chart and a chord diagram of the connections between different countries, he set up an archiver add-on to collect tweets onto a Google sheet. Then he parsed the emoji flags with a Python script to create adjacency lists for visualization. 

I’ve always wanted to play with Twitter data and do something similar, but in my case I wanted to do everything in R. Using the [Twitter Archiver spreadsheet](https://docs.google.com/spreadsheets/d/1NRxvV0JP_eF98WUfbkpj1iMBlFEe25JGKGhblM6U3KQ/) he organized, I downloaded a copy of the Google sheet on 8/8/2016, which included 11655 tweets that included the hashtag (I’ve been very slow with writing this post).

This is my first attempt at working with Twitter data and strings, and I want to share the process and some of the things I learned about working with strings, dates, encodings, and emojis. To replicate my version of the analysis, I suggest downloading the Google sheet and filtering everything up to “8/8/2016 9:01:04” using _lubridate_.
