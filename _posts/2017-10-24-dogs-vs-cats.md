---
published: false
---
Here is yet another post about dogs and the [@dog_rates](https://twitter.com/dog_rates) Twitter account. I’m writing this as a way to try out the [rtweet](http://rtweet.info/) package (and to document some plotting code that I had to leave out of an unrelated paper).
In this post, I’ll compare scores for two independent samples, represented here by ratings for around 200 dogs and 200 cats, sourced from two popular Twitter accounts that share user-provided photos with funny captions and a rating out of 10 for a different dog or cat. Cat ratings come from the [We Rate Cats](https://twitter.com/CatsRates) account, which has a big following, a good number of posts, and variation in the ratings for the various cats.

Here are some examples:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Meet Frida. She&#39;s in the search &amp; rescue division of the Mexican Navy along with two German shepherds. Sadly, she&#39;s been busy lately. 14/10 <a href="https://t.co/82nlfkvodW">pic.twitter.com/82nlfkvodW</a></p>&mdash; SpookyWeRateDogs™ (@dog_rates) <a href="https://twitter.com/dog_rates/status/910580043381923840?ref_src=twsrc%5Etfw">September 20, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Elsie is always hungry &amp; waiting for food. 12/10 for being a lil fatty <a href="https://t.co/KFIMhlblU1">pic.twitter.com/KFIMhlblU1</a></p>&mdash; We Rate Cats 🐈 (@CatsRates) <a href="https://twitter.com/CatsRates/status/913916433175805952?ref_src=twsrc%5Etfw">September 30, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

These are the main steps in the workflow:

-Get the tweets
-Extract the ratings
-Plot the data
-Test for differences

Downloading the tweets was super easy thanks to _rtweet_. Once you setup your app and authentication keys with this handy guide, you should be able to reproduce everything in this post. 

CODEBLOK

First, we download the tweets and clean up the resulting data frames. I specified different numbers of tweets to retrieve because the @dog_rates account is more active in retweeting and replying, and we only want ratings. 

After stripping replies and retweets, some minor data wrangling will get us to a more or less even sample for each screen name. I used str_detect() to only keep rows with tweet text that contained a rating (e.g. the string “/10”). 

CODEBLOK

To extract the ratings into a new column, we can use stringr again with some hacky regex to pull out digits preceding the string /10 (positive lookahead). After converting the column to numeric, this data is ready for visualization.

CODEBLOK

To show the difference in ratings, I used a sina plot, implemented in the [ggforce](https://github.com/thomasp85/ggforce) package. It is like a strip chart but with the points jittered according to their local density. I feel that this type of plot shows the distribution of the points well. Most dogs received a 13/10, while cats got mainly 12/10 with more variation around this value. 

CODEBLOK

FIGUrE

We might typically use a two-sample t-test to compare the means of the two groups. This is assuming that both samples are random, independent, and come from normally distributed population with unknown but equal variances. However, the t-test has some problems. By assuming equal variances and normally distributed data, any F tests are sensitive to outliers and not that easy to interpret, because the best-fitting normal distributions do not describe the data well.  

Rather than testing whether two groups are different, we could aim to estimate how different they are, which is more informative. To do this, we can use a Bayesian approach: BEST (Bayesian estimation supersedes the t-test), proposed by John K. Kruschke. BEST estimates the difference in means between two groups (expressed as the mean differences of the marginal posterior distributions) and provides a probability distribution over the difference. From this distribution of credible values we consider the mean value as our best guess of the actual difference and a Highest Density Interval (HDI) as the range where the actual difference is, with X% credibility (e.g. 95 or 99%). If the HDI does not include zero, then zero is not a credible value for the difference of means between groups. Although I didn’t go into it, BEST also provides complete distributions of credible values for the effect size, standard deviations and their difference, and the normality of the data. Read more about BEST [here](http://www.dataminingapps.com/2016/03/update-your-beliefs-a-bayesian-approach-to-two-sample-comparison/ "BEST overview"), [here](http://docs.pymc.io/notebooks/BEST.html "python implementation"), and in this puppy-themed [book](https://sites.google.com/site/doingbayesiandataanalysis/) by J.K. Kruschke himself.  


CODEBLOK

Setting up and running the model (with default settings and arguments) is pretty straightforward, and once it’s done we can look at the model summary. Basically, the difference of means being different from cero is a credible value given the data.

CODEBLOK

Let’s look at it graphically. BEST has a built in plotting function that generates this figure.

FIGUre

Because I get uncomfortable when I can’t change things in _ggplot_, the following code reuses values and elements from the output and summary of the BEST model to recode a similar plot, using a density plot instead of a histogram. 

CODEBLOK

figure

Now we know that the mean rating differs between dogs and cats. I’m a dog person so you can probably guess how I would interpret this result. 



