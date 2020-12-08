---
title: "Dog breed popularity bump chart"
layout: post
excerpt: Plotting how popularity rankings for dog breeds change through time, (p)updated for 2020. 
category: rstats
tags:
  - ggplot2
  - ggbump
  - retriever
  - kennel club
  - pupper
image:
  feature: featureDoggs.png
  credit: Pixabay CC0 image
  creditlink: 
published: true
---

The American Kennel Club recently published the 2019 rankings of dog breed [popularity](https://www.akc.org/expert-advice/dog-breeds/2020-popular-breeds-2019/){:target="_blank"}, collected from registration data in the USA. 

For the 2017 and 2018 rankings, I created bump charts in R using `ggplot2` to show changes in rank over time, following the work of [Dominik Koch](https://dominikkoch.github.io/Bump-Chart/){:target="_blank"}.  

The code for the 2017 and 2018 versions (below) is detailed in these posts:
- [2017 rankings](https://luisdva.github.io/rstats/dog-bump-chart/){:target="_blank"}  
- [2018 rankings](https://luisdva.github.io/rstats/dog-popularity/){:target="_blank"}  

  
  
<figure>
    <a href="/images/akcranks.png"><img src="/images/akcranks.png" style="width:50%"></a>
        <figcaption>click to enlarge</figcaption>
</figure>
<figure>
    <a href="/images/akcranks2019.png"><img src="/images/akcranks2019.png" style="width:50%"></a>
        <figcaption>click to enlarge</figcaption>
</figure>
<br>

With the new rankings out, here's another (p)update. By now there is a specific `geom` for bump charts thanks to the [`ggbump`](https://github.com/davidsjoberg/ggbump){:target="_blank"} package by David Sjoberg. The code for the updated chart is in the gist at the end of this post and should be fully reproducible. This approach uses both the wide and long formats of the data, a darker theme, and makes use of `scale_y_reverse()`, which I was previously unfamiliar with. 

...and here's the updated plot:  

<figure>
    <a href="/images/akc2020.png"><img src="/images/akc2020.png"></a>
        <figcaption>click to enlarge</figcaption>
</figure>
<br><br>

Thanks for reading. Let me know if anything isn't working and be nice to dogs. 


The code:
{% gist 18ebd0617ef8892b9569052306003931 %}


