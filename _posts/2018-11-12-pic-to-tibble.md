---
title: "From photo to tibble"
layout: post
excerpt: Digitizing and rectangling a restaurant menu. 
category: rstats
tags:
  - tesseract
  - unheadr
  - ocr
  - subheaders
image: 
  feature:  
  credit: 
  creditlink: 
published: false
---
When I first wrote about tidy evaluation and the untangle2 function, I used restaurant menus as an example of how embedded subheaders are used to create small multiples of data (by type of menu item). 

TABLE

After a recent [update](https://ropensci.org/technotes/2018/11/06/tesseract-40/) to the _tesseract_ optical character recognition (ocr) engine, I decided to try and digitize and parse a restaruant menu from a photo. I wanted to try with a real photo from a real menu, and I found this photo in my camera roll.  

PHOTO

The menu is from a nice taco place in Puerto Vallarta. I cropped the photo to beer selection, there are craft beers and commercial beers as little subsets of the menu and with their own heading. 


<figure>
    <a href="/images/graph3d.jpg"><img src="/images/graph3d.jpg"></a>
        <figcaption>CCO image</figcaption>
</figure>

Let's go through the code needed to ocr the text and then restructure the data.

To prepare the image for ocr, I followed some existing imagemagick tutorials, and the implementation in _magick_ lets us chain the different operations together, making for very readable code. 

{% highlight r %}

{% endhighlight %}

The resulting image looks like this (even though we don't need to write it to disk for the ocr process).

<figure>
    <a href="/images/graph3d.jpg"><img src="/images/graph3d.jpg"></a>
        <figcaption>CCO image</figcaption>
</figure>

Once we run the ocr, 


{% highlight r %}

{% endhighlight %}


After the text is clean we can structure into a tibble.

{% highlight r %}

{% endhighlight %}


There is some minor cleanup to be done. I like this real-world example because the original photo is not the best to begin, and the text itself is a mix of English, Spanish, and made up brand names. Even so, the ocr performed really well. Once the text is clean, we can put the prices into their own variable, and then use _unheadr_ to turn the subheaders into a tidy grouping variable 















