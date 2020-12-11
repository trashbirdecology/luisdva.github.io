---
title: Formatted spreadsheets in R
excerpt: "Import and work with formatted spreadsheet data"
category: rstats
tags: 
  - bolded
  - formatting
  - xlsx
  - Excel
header: 
  image: /assets/images/featurepls.png
---

At some point, we all have had to deal with spreadsheets in which group membership was color coded (see the replies to this [tweet](https://twitter.com/JennyBryan/status/722954354198597632){:target="_blank"}):

<blockquote class="twitter-tweet" data-dnt="true"><p lang="en" dir="ltr">I&#39;m seeking TRUE, crazy spreadsheet stories. Happy to get the actual sheet or just a description of the crazy. Also: I can keep a secret.</p>&mdash; Jenny Bryan (@JennyBryan) <a href="https://twitter.com/JennyBryan/status/722954354198597632?ref_src=twsrc%5Etfw">April 21, 2016</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>   


Here’s a quick workflow that uses a new function in [`unheadr`](https://github.com/luisDVA/unheadr){:target="_blank"}  to annotate meaningful formatting (cell coloring and font formatting) used to designate group membership.

📎 This example spreadsheet (packaged with `unheadr`) shows some tasks and behaviors that characterize a well-behaved dog, along with their respective scores. These rows belong in three different task types (shown in yellow cells and bold font), and the average score for each task type appears next to each one. 

 <figure>
    <a href="/assets/images/dogtest.png"><img src="/assets/images/dogtest.png"></a>
        <figcaption>cell and font formatting</figcaption>
</figure>
<br><br>

To work with this in R, we need to translate the colors and font faces into something flatter, and then we can pull out these ‘embedded subheaders’ and put them in their own indicator column if we want a tidy data structure.

For educational purposes, this example uses the `RverbalExpressions` package by [Tyler Littlefield](https://rverbalexpressions.netlify.com/index.html){:target="_blank"}  to build regular expressions, and I loaded `tidylog` by [Benjamin Elbers](https://github.com/elbersb/tidylog){:target="_blank"}  to print some feedback about the `dplyr` operations happening. This is optional.

Once we load (install first if necessary) the required packages, the `dog_test` spreadsheet is bundled in `unheadr` and can be loaded with `system.file()`. We then tell `annotate_mf()` which variable has the meaningful formatting we want to annotate, and the name of the new annotated variable. This new function calls various useful tools from the `tidyxl` package (available on CRAN) by [Duncan Garmonsway](https://twitter.com/nacnudus){:target="_blank"}. 

{% highlight r %}
# remotes::install_github("luisDVA/unheadr")
# remotes::install_github("VerbalExpressions/RVerbalExpressions")
# install.packages("tidylog")
library(unheadr)
library(tidylog)
library(RVerbalExpressions)
library(stringr)

# prepackaged data
example_spreadsheet <- system.file("extdata/dog_test.xlsx", package = "unheadr")
# annotate the meaningful formatting
dogtest_tibble <- annotate_mf(example_spreadsheet,orig = Task, new=Task_annotated)
{% endhighlight %}

This is the resulting tibble:

{% highlight text %}
> dogtest_tibble
# A tibble: 11 x 3
   Task                                       Task_annotated                                    Score
   <chr>                                      <chr>                                             <dbl>
 1 Outdoor activities                         (bolded, highlighted) Outdoor activities           7.67
 2 Walks on a loose leash without pulling     Walks on a loose leash without pulling             7   
 3 Walks without chasing bicycles, animals, … Walks without chasing bicycles, animals, etc.      6   
 4 Greets friends and strangers without jump… Greets friends and strangers without jumping      10   
 5 Home behavior                              (bolded, highlighted) Home behavior                8.5 
 6 Moves location when directed without grow… Moves location when directed without growling      9   
 7 Does not rush through doorways             Does not rush through doorways                     8   
 8 General social skills and obedience        (bolded, highlighted) General social skills and …  7   
 9 Can play or interact appropriately with o… Can play or interact appropriately with other do…  7   
10 Can be groomed or handled without squirmi… Can be groomed or handled without squirming        8   
11 Stops barking on command                   Stops barking on command                           6   
{% endhighlight %}

To match the values that hold annotations, we use a regular expression built using `RverbalExpressions` as an argument for `untangle2()`. We also define the variable that has the subheaders and the name of the new variable that now explicitly indicates group membership.

{% highlight r %}
# untangling annotated rows
# build regular expression
reg_expression_br <- rx_start_of_line() %>% 
  rx_find("(")
reg_expression_br
# untagle embedded subheaders
dog_test_ut <- untangle2(dogtest_tibble,reg_expression_br,Task_annotated,task_type)
{% endhighlight %}

Let’s see:

{% highlight text %}
> dog_test_ut
# A tibble: 8 x 4
  Task                        Task_annotated                   Score task_type                       
  <chr>                       <chr>                            <dbl> <chr>                           
1 Walks on a loose leash wit… Walks on a loose leash without …     7 (bolded, highlighted) Outdoor a…
2 Walks without chasing bicy… Walks without chasing bicycles,…     6 (bolded, highlighted) Outdoor a…
3 Greets friends and strange… Greets friends and strangers wi…    10 (bolded, highlighted) Outdoor a…
4 Moves location when direct… Moves location when directed wi…     9 (bolded, highlighted) Home beha…
5 Does not rush through door… Does not rush through doorways       8 (bolded, highlighted) Home beha…
6 Can play or interact appro… Can play or interact appropriat…     7 (bolded, highlighted) General s…
7 Can be groomed or handled … Can be groomed or handled witho…     8 (bolded, highlighted) General s…
8 Stops barking on command    Stops barking on command             6 (bolded, highlighted) General s…
{% endhighlight %}

Now let’s clean up the new variable using more regex to remove everything inside brackets (and the brackets too).

{% highlight r %}
# build regex for everything inside brackets and a trailing space
 regexp_annotation <- 
  rx_start_of_line() %>% 
    rx_find("(") %>% 
    rx_anything() %>% 
    rx_find(")") %>% 
    rx_space()
regexp_annotation  
  
# cleaning
dog_test <- dog_test_ut %>% select(-Task_annotated) %>% 
  mutate(task_type=str_remove(task_type,regexp_annotation))
{% endhighlight %}
>select: dropped one variable (Task_annotated)  
>mutate: changed 8 values (100%) of 'task_type' (0 new NA)

The data in a tidy structure:

{% highlight text %}
> dog_test
# A tibble: 8 x 3
  Task                                               Score task_type                          
  <chr>                                              <dbl> <chr>                              
1 Walks on a loose leash without pulling                 7 Outdoor activities                 
2 Walks without chasing bicycles, animals, etc.          6 Outdoor activities                 
3 Greets friends and strangers without jumping          10 Outdoor activities                 
4 Moves location when directed without growling          9 Home behavior                      
5 Does not rush through doorways                         8 Home behavior                      
6 Can play or interact appropriately with other dogs     7 General social skills and obedience
7 Can be groomed or handled without squirming            8 General social skills and obedience
8 Stops barking on command                               6 General social skills and obedience
{% endhighlight%}


Now we can summarize the scores for each task type, and they should match the calculated value present in the first place. 
{% highlight r %}
dog_test %>% group_by(task_type) %>% summarize(mean_score=mean(Score))
{% endhighlight %}
> group_by: one grouping variable (task_type)  
>summarize: now 3 rows and 2 columns, ungrouped

{% highlight text %}
# A tibble: 3 x 2
  task_type                           mean_score
  <chr>                                    <dbl>
1 General social skills and obedience       7   
2 Home behavior                             8.5 
3 Outdoor activities                        7.67
{% endhighlight%}


🐶 Feel free to contact me with any feedback 🐶


Further reading:  

[meaningful formatting](https://nacnudus.github.io/spreadsheet-munging-strategies/tidy-formatted-rows.html){:target="_blank"}     

[embedded subheaders](https://doi.org/10.4404/hystrix-00133-2018){:target="_blank"}   

[data organization in spreadsheets](https://github.com/jennybc/2016-06_spreadsheets){:target="_blank"}   

