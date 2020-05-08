---
layout: post
title: Mapas de altas latitudes en R
excerpt: Ilustrando la distribución de dos especies de focas antárticas con R y ggplot2.
tags:
  - rstats
  - gis
  - seals
  - mapping
  - sf
image:
  feature: featureSeals.png
  credit: Andrew Shiva - Wikimedia Commons
  creditlink: null
published: true
---

Esta es una guía bastante breve para hacer mapas con R, a través de `ggplot2` y `sf`, orientado a regiones de alta latitud. El ejemplo en esta guía es con datos puntuales que muestran la distribución de dos especies de foca cerca de la Península Antártica.

Vamos a descargar registros de foca de Wedell y de elefante marino del portal de biodiversidad [gbif](https://www.gbif.org/){:target="_blank"} con `rgbif`, así como polígonos de costas con `rnaturalearth`. El mapa lleva una proyección geográfica azimutal para mostrar adecuadamente estas regiones tan australes. Los parámetrosde la proyección provienen de la aplicación  [Projection Wizard web app](https://projectionwizard.org/){:target="_blank"} de Oregon State University.

Veamos.

* Cargamos las librerías necesarias y descargamos los datos sobre observaciones para elefantes marinos y focas de Wedell en Chile, Argentina, y la Antártida.  

{% highlight r %}
# cargar librerías 
library(sf) # CRAN v0.9-1
library(rnaturalearth) # CRAN v0.1.0
library(ggplot2) # CRAN v3.3.0
library(dplyr) # [github::tidyverse/dplyr] v0.8.99.9002
library(rgbif) # CRAN v2.2.0
library(ggimage) # CRAN v0.2.8

# descargar datos
mlseals <- occ_data(scientificName = "Mirounga leonina",country = "AR;CL;AQ")
wseals <- occ_data(scientificName = "Leptonychotes weddellii",country = "AR;CL;AQ")
mlsealsdat <- mlseals$data
wsealsdat <-wseals$data
{% endhighlight %}

Pasamos estos datos a objectos "sf". Solo hay que especificar cuales son las variables con las coordenadas y cual es su proyección. Decidí filtar los datos por longitud y latitud antes de proyectarlos y antes de crear un objeto con los límites espaciales del mapa que vamos a dibujar.

{% highlight r %}

# pasar a sf y filtrar por ubicación
mlsealssf <- 
  mlsealsdat %>% select(scientificName,decimalLongitude,decimalLatitude) %>% 
  distinct() %>% dplyr::filter(decimalLatitude < -40) %>% 
  dplyr::filter(decimalLongitude> -150 & decimalLongitude < -30 )
wsealssf <- 
  wsealsdat %>% select(scientificName,decimalLongitude,decimalLatitude) %>% 
  distinct() %>% dplyr::filter(decimalLatitude < -40) %>% 
  dplyr::filter(decimalLongitude> -150 & decimalLongitude < -30 )

# combinar
sealsdf <- bind_rows(mlsealssf,wsealssf) 

# proyectar
seals_spat <- st_as_sf(sealsdf,coords = c("decimalLongitude","decimalLatitude"),crs=4326)               
# proj from Projection Wizard website
sealsproj <- st_transform(seals_spat,"+proj=aea +lat_1=-67.64292238209752 +lat_2=-43.70345673689002 +lon_0=-60.46875")
# límites geográficos
boundss <- st_bbox(st_buffer(sealsproj,500000))
xydatbuffer <- st_as_sf(st_as_sfc(boundss))
{% endhighlight %}

Ahora cargamos la división política de [Natural Earth](https://www.naturalearthdata.com/){:target="_blank"} (un juego de datos espaciales abiertos) y la proyectamos.

{% highlight r %}

# división política 
divpol <- ne_countries(scale = "large",country = c("Chile","Argentina","Antarctica"),returnclass = "sf") %>% 
  st_transform("+proj=aea +lat_1=-67.64292238209752 +lat_2=-43.70345673689002 +lon_0=-60.46875")
regs <- ne_states(country = "Chile",returnclass = "sf") %>% 
  st_transform("+proj=aea +lat_1=-67.64292238209752 +lat_2=-43.70345673689002 +lon_0=-60.46875")
regsAr <- ne_states(country = "Argentina",returnclass = "sf") %>% 
  st_transform("+proj=aea +lat_1=-67.64292238209752 +lat_2=-43.70345673689002 +lon_0=-60.46875")
{% endhighlight %}

Ya podemos apilar todas estas capas en `ggplot`. Para mostrar un posible uso de `ggimage` y para decorar un poco el mapa, podemos armar una tabla con la ubicación geográfica y las rutas de algunas imágenes que podemos sobreponer en la figura. Vamos a agregar dibujos de las dos especies de foca, ilustrados por [Julia Saravia](https://twitter.com/JujuSaravia){:target="_blank"}, genetista austral y divulgadora.

{% highlight r %}

# dibujos de focas
sealimgs <- tibble(x=c(-2023533 ,1725000),y=c(-8200000,-8200000),imgurl=c("https://raw.githubusercontent.com/luisDVA/luisdva.github.io/master/images/pup/mirounga.png",
                                  "https://raw.githubusercontent.com/luisDVA/luisdva.github.io/master/images/pup/wedd.png"))
{% endhighlight %}

Para graficar todos los datos, `sf` se encarga de todo y es posible cambiar tamaños y colores con la gramática de `ggpplot`.

{% highlight r %}
ggplot()+  
  geom_sf(data=divpol,size=0.2,color="black",fill="#e7d8c9")+
  geom_sf(data=regs,size=0.3,color="black",fill="transparent",lty=2)+
  geom_sf(data=regsAr,size=0.3,color="black",fill="transparent",lty=2)+
  geom_sf(data=sealsproj,pch=21,color="black",aes(fill=scientificName),size=3,stroke=1)+
  geom_image(data=sealimgs[1,],aes(x=x,y=y,image=imgurl),size=0.12)+
  geom_image(data=sealimgs[2,],aes(x=x,y=y,image=imgurl),size=0.14)+
    coord_sf(
    xlim = c(boundss["xmin"]-900000, boundss["xmax"]+900000),
    ylim = c(boundss["ymin"]-800000, boundss["ymax"]))+
  scale_x_continuous(expand = c(0,0))+
  scale_y_continuous(expand = c(0,0))+
  scale_fill_manual(values = c("blue","orange"),name="",labels=c("Southern elephant seal","Weddell seal"))+
  labs(x="",y="")+
  theme(panel.background = element_rect(fill="#c6def1"),
        text = element_text(family = "Loma",size = 18),
        legend.position = "bottom",legend.text = element_text(size = 24))
{% endhighlight %}

a ver:

<figure>
    <a href="/images/seals.png"><img src="/images/seals.png"></a>
        <figcaption>photobomb!</figcaption>
</figure>
  
    
Quedó bastante bien.
Si hay dudas, no duden en contactarme.
