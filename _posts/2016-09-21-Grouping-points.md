---
published: false
---
##Drawing polygons around groups of points in ggplot

For various kinds of analyses, we often end up plotting point data in two dimensions for two or groups. This includes Principal Component Analyses, bioclimatic profiles, or any other combination of values on two axes. In some of my recent projects I’ve encountered three alternatives for drawing polygons around groups of points and I want to share code and examples for all three in this post.  

These methods are for ggplot, but I assume there are ways to do the same things using base or other plotting engines. I wanted to use real data, so the following examples use data from this paper on the physiology of the Japanese quail. After loading (or installing if necessary) the required packages and downloading the data directly from Dryad, we can wrangle the data so we can plot length and mass data from several individual birds at 30 vs 40 days of age. 

Codeblokc

Convex hulls are one of the most common methods for grouping points. Convex hulls have a formal geometric definition, but basically they are like stretching a rubber band around the outermost points in the group. We can calculate the convex hulls for many groups using grDevices::chull and an apply function (see this exchange for a worked example). 

codeblock
img

Another common alternative is to group points using ellipses. Ggplot has a flexbile geometry for drawing these elipses. It can inherit all the arguments and parameters so colors and legends are taken care of. 

Codeblock

Img

This third option is what I ended up using for my own figures. It uses geom_encircle, a new geometry provided in the ggalt package. This geom uses polynomial splines to draw nice smoothed polygons around the groups of points. It has flexible options for color, fill, and the smoothness of the polygons that it draws. I feel that this method is mostly for highlighting groups visually and indicate cohesion, and not for performing any further analyses on the polygons themselves (e.g. using the areas or the amount of overlap for other subsequent tests).   

Codeblock

Img

Although I left them hollow, we can change the transparency and fill values of the different polygons for all three methods. This can be useful to highlight overlap between groups.
