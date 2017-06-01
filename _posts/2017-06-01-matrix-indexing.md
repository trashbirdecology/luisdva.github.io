---
published: false
---
Matrix indexing
I recently received a file from a collaborator in which some categorical variables describing various primate species had been recoded into binary columns. I later learned that this is known as a design or model matix, in which categories (factors) are expanded into a set of dummy variables.

For example, I was looking at something like this:

| species | arboreal | terrestrial |
|---------|----------|-------------|
| sp a    | 0        | 1           |
| sp b    | 1        | 0           |
| sp c    | 1        | 0           |

Instead of something like this:

| species | locomotion  |
|---------|-------------|
| sp a    | terrestrial |
| sp b    | arboreal    |
| sp c    | arboreal    |

About ten of the variables that I needed were coded as binary columns and I found myself unsure of how I could change them back without too much work. I didn’t know what to call this or what terms to search for, so I took to twitter and asked.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/hashtag/rstats?src=hash">#rstats</a> people: <br>what&#39;s the dplyr or <a href="https://twitter.com/hashtag/tidyr?src=hash">#tidyr</a> way to do this? <br>help pls I&#39;m stuck :( <a href="https://t.co/OAt5jGed8L">pic.twitter.com/OAt5jGed8L</a></p>&mdash; Luis D. Verde (@LuisDVerde) <a href="https://twitter.com/LuisDVerde/status/867869003246706690">May 25, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I’m a tidyverse type of person so I specifically asked for a dplyr or tidyr approach. By then I had already written a loop that more or less worked, but I knew I was missing something.
Almost immediately the Twitter #rstats community came through and both [Naupaka Zimmerman](https://twitter.com/naupakaz) and [Giulio Valentino Dalla Riva](https://twitter.com/ipnosimmia) suggested that I ‘melt’ the data into long format; filter only the rows with value 1, and then select out the column with the values.

Essentialy:

{% highlighttext %}
gather() %>% filter() %>% select()
{% endhighlight %}

My mistake was not leaving a species/ID column in the rough screenshot that I posted and in the toy dataset that I was using, without which I couldn’t get the above approach to work. Once I realized that I needed row IDs I replied in the Twitter thread and [T.J. Mahr]( https://twitter.com/tjmahr) pointed out that the tibble package has a new function to add row IDs to columns (rowid_to_column). 
That was the last piece missing and I got everything working. Let’s have a look at how to recode dummy binary columns into a single variable (also known as matrix indexing).
First, the dplyr approach:
With row ids

With a loop (thanks to [Daijiang Li]( https://twitter.com/_djli) for this suggestion)

baseR approach using the apply family of functions (thanks to [Damien R. Farine]( https://twitter.com/DamienFarine) for this one)

When this indexing has to be done many times for different variables, I came across a nifty way of putting the new tbls together using Reduce() to perform multiple left joins.

