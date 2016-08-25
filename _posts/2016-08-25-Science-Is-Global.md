---
layout: post
excerpt: 'Emoji flags, international research, and tweet analyses in R.'
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

This is my first attempt at working with Twitter data and strings, and I want to share the process and some of the things I learned about working with strings, dates, encodings, and emojis. To replicate my version of the analysis, I suggest downloading the Google sheet and filtering everything up to “8/8/2016 9:01:04” using lubridate.

{% highlight r %}
#load libraries (install if needed)
library(stringi)
library(dplyr)

# read file for Archiver from your own working directory
alltweets <- read.csv("tweetArchiverData.csv",stringsAsFactors = F,header = T)

# strip retweets
norts <- filter(alltweets, !grepl("RT @",Tweet.Text))
norts <- filter(norts, !grepl("Retweeted",Tweet.Text))

# percentage of RTs in dataset
1-nrow(norts)/nrow(alltweets)

# strip urls
norts$Tweet.Text <- stri_replace_all_regex(norts$Tweet.Text," ?(f|ht)(tp)(s?)(://)(.*)[.|/](.*)","")
# remove duplicates
norts <- norts%>%  filter(!stri_duplicated(norts$Tweet.Text))
# remove spambot tweets
norts <- filter(norts,!grepl("VOTE for me in",Tweet.Text))
{% end highlight %}

I started by cleaning up the data. To avoid duplication, I removed all the retweets, the twitteR package has a function for this, but with the flat data frame we can use dplyr::filter and some basic pattern matching to remove retweets, which made up a good portion of the dataset (about 75%). Looking at the original entries, I realized that it would be a good idea to strip all URLS, then remove other duplicates and spam (e.g. dozens of tweets with spam links or requesting votes in spammy websites).


Now we can plot how many tweets were posted each day, and we see that #scienceisglobal peaked the day after the joint statement was published and then tapered off. 
{% highlight r %}
norts %>%  count(posted  = date(mdy_hms(norts[,1]))) %>% 
  ggplot(aes(posted,n)) +
  geom_line() + 
  scale_x_date(labels = date_format("%m/%d"),breaks = date_breaks("days"))+
    labs(x = "date posted",
       y = "no. of tweets")
{% end highlight %}

<figure>
    <a href="/images/twtdates.png"><img src="/images/twtdates.png"></a>
        <figcaption>tweets/day</figcaption>
</figure>

Now for the interesting part, I had to translate the flag emojis into something sensible. I don’t know if this applies to everyone, but on my Windows PC I always struggle with special characters in R. I was interested in the flag emojis people were using, and in my case I was unsure of how to deal with file encoding and fonts so all the emojis and special characters were getting “garbaged” into things like this  ðŸ‡¬ðŸ‡§

I realized that there is no loss of information with this character garbling, and that other people also work with it (see here), so they were something I could work with.  Now I could use these characters and filter our rows that won’t contain emojis.

{% highlight r %}
# keep tweets with probably flags 
sciFlags <- filter(norts, grepl("ð",Tweet.Text))
{% end highlight %}

Emoji flags are combinations of two regional indicator letters, based on ISO 3166-1: a list of internationally recognized two-letter country codes. There are now hundreds of working flag emojis, and their indicator letters have unique encodings. Fortunately, [this page](http://emojipedia.org/flags/)  has the full list, and after scraping it and doing some minor edits, I had a csv file that was getting garbaged the same way when I read it into R, making it a good translation table. 

If we know what the gibberish stands for, we can use the powerful stringi package to do vectorized pattern replacements. It also helps that a similar translation table for emojis has already been put together by another team doing Twitter analytics. 

I used a hacky, multi-stage process to replace flags and other emojis until all the weird characters were accounted for. The biggest issue was that there can be overlap in the character strings representing combinations of regional indicators, and because the replacements are vectorized without lookahead overlap detection, it becomes messy because countries can be both incorrectly replaced or excluded.
For example, if someone mentioned Ascencion Island and Canada together (ACCA) and the vector of two-letter combinations is not ordered just right, the CC for Cocos Islands can get ‘incorrectly’ replaced instead of the two countries that were actually mentioned. 

My solution for the overlapping patterns was to strip away all alphanumeric characters and punctuation, and to then split the remaining strings into 8-character chunks (because I realized that each regional indicator gets garbaged into four character sequences) and then translate again. 


After that, I used stringi to extract the occurrences of different country names in each tweet and some more list manipulation to end up with a matrix of the presence of each country in each tweet.

Quick summary statistics

On average, about nine different countries were mentioned per tweet, with the minimum of 1 and a maximum of 50 for some people having way too much fun with emoji flags.

Bastian G. noted that the usual Western, rich industrialized countries are the most frequently mentioned. We can make a lollipop plot of the top n countries with the highest number of mentions. In this case it’s 30.


<figure>
    <a href="/images/lolipop.png"><img src="/images/lolipop.png"></a>
        <figcaption>useful ggalt geometry</figcaption>
</figure>

Finally, using code from a previous post I joined the country list to a worldmap to visualize the countries being mentioned.


{% highlight r %}

{% end highlight %}

<figure>
    <a href="/images/mapW.png"><img src="/images/mapW.png"></a>
        <figcaption>starting out</figcaption>
</figure>

