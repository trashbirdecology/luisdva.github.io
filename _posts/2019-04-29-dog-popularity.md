---
title: "Dog breed popularity chart"
layout: post
excerpt: Plotting how popularity rankings for dog breeds change through time, (p)updated for 2019. 
category: rstats
tags:
  - ggplot2
  - bump chart
  - retriever
  - akc 2019
  - pupper
image:
  feature: featureDoggs.png
  credit: Pixabay CC0 image
  creditlink: 
published: true
---

The American Kennel Club just announced the 2018 rankings of dog breed [popularity](https://www.akc.org/expert-advice/news/most-popular-dog-breeds-of-2018/){:target="_blank"}, collected from registration data in the USA. 

Last year, I followed this [post](https://dominikkoch.github.io/Bump-Chart/){:target="_blank"} by Dominik Koch about creating bump charts in R using _ggplot2_ to show changes in rank over time, and applied it to dog breed popularity rankings from 2013-2017. The resulting chart is below, and the code is detailed in this [entry](https://luisdva.github.io/rstats/dog-bump-chart/){:target="_blank"}.  


<figure>
    <a href="/images/akcranks.png"><img src="/images/akcranks.png"></a>
        <figcaption>click to enlarge</figcaption>
</figure>
<br><br>

With the new rankings out, here's a quick update to last year's post. I drew more dogs for use as custom image labels with [ggimage](https://github.com/GuangchuangYu/ggimage){:target="_blank"}, and this time they are full-size pngs with transparent backgrounds, available [here](https://github.com/luisDVA/luisdva.github.io/tree/master/images/pups/){:target="_blank"}. 

The new dog drawings look like this. I assembled the little collage using Maëlle Salmon's _magick_ [resources](https://masalmon.eu/tags/collage/){:target="_blank"}.

<figure>
    <a href="/images/doggos.png"><img src="/images/doggos.png"></a>
        <figcaption>click to enlarge</figcaption>
</figure>
<br><br>

...and here's the updated plot:  

<figure>
    <a href="/images/akcranks2019.png"><img src="/images/akcranks2019.png"></a>
        <figcaption>click to enlarge</figcaption>
</figure>
<br><br>

The code for the updated chart is in the gist at the end of this post. The plotting code is less fiddly and I was more careful with paths when working with the images. 


Thanks for reading. Let me know if anything isn't working and feel free to reuse the dog drawings (with attribution). 



The code:
{% gist luisDVA/1678e030a3c33cb18f4e53a1a83357be %}


