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
  feature: featurePV.png
  credit: LV
  creditlink: 
published: false
---
When I first wrote about tidy evaluation and the untangle2 function, I used restaurant menus as an example of how embedded subheaders are used to create small multiples of data (by type of menu item). 

After a recent [update](https://ropensci.org/technotes/2018/11/06/tesseract-40/) to the _tesseract_ optical character recognition (ocr) engine, I decided to try and digitize and parse a restaruant menu from a photo. I wanted to try with a real photo from a real menu, and I found this photo in my camera roll.  

<figure>
    <a href="/images/beer.jpg"><img src="/images/beer.jpg"></a>
        <figcaption></figcaption>
</figure>

The menu is from a nice taco place in Puerto Vallarta. I cropped the photo to beer selection, there are craft beers and commercial beers as little subsets of the menu and each with their own heading. 

## Code-through

Let's ocr the text and then restructure the data.

To prepare the image for ocr, I followed some existing imagemagick tutorials, and the implementation in _magick_ lets us chain the different operations together, making for very readable code. The code below will read the photo striaght from the web, so anyone can follow after installing all the required packages.

{% highlight r %}

{% endhighlight %}

The resulting image looks like this (even though we don't need to write it to disk for the ocr process).

<figure>
    <a href="/images/blcean.jpg"><img src="/images/bclean.jpeg"></a>
        <figcaption>CCO image</figcaption>
</figure>

The 'image_ocr' function runs the optical character recognition on the image and returns a character vector, which we can structure into a tibble.

{% highlight r %}

{% endhighlight %}

There is some minor cleanup to be done. I like this real-world example because the original photo is not the best to begin, and the text itself is a mix of English, Spanish, and made up brand names. Even so, the ocr performed really well. Once the text is clean, we can put the prices into their own variable, and then use _unheadr_ to turn the subheaders into a tidy grouping variable 


{% highlight r %}

{% endhighlight %}

With the menu items in a tidy structure, we can now group by beer type and get summary data or find the most or least expensive options. 
















