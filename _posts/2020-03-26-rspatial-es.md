---
layout: post
excerpt: Extraer valores de uno o más raster a partir de coordenadas xy usando R.
tags:
  - rstats
  - sig
  - capas raster
  - stars
  - sf
image:
  feature: featureSig.png
  credit: null
  creditlink: null
published: true
---
# Extraer valores de uno o más raster a partir de coordenadas xy usando R. 

> ### Esta es una versión nueva de esta [guía](https://luisdva.github.io/R-para-tareas-espaciales/){:target="_blank"}, escrita en 2016 y que ya está bastante desactualizada.   

En temas de biodiversidad, es común trabajar con registros puntuales de la distribución de una o más especies, generalmente representadas en coordenadas geográficas xy (longitud/latitud). A veces necesitamos datos sobre las condiciones ambientales en cada registro. Estos datos de clima, vegetación, uso de suelo, etc. generalmente existen como capas raster (una representación del área de estudio en formato de matriz dividida en celdas con valores únicos).

Extraer el valor de las celdas en donde ocurren nuestros registros puntuales es fácil usando sistemas de información geográfica (SIG) con interfaces gráficas, que casi siempre tienen algun botón o herramienta dedicada a esta tarea. A continuación comparto una forma de extraer los valores de varios raster para registros puntuales (longitud/latitud) desde R.

En este caso usé los raster de temperatura y precipitación anual del proyecto [CHELSA Climate](http://chelsa-climate.org/){:target="_blank"}. Estos datos tienen mejor exactitud en zonas montañosas que otras opciones existentes como WorldClim. Aquí se pueden descargar los datos de clima en formato _geotiff_. 

Son archivos grandes, pero gracias al paquete `stars` no hace falta cargarlos a la memoria para varias operaiones, y yo no tuve problema para manipularlos en una pc vieja. En este ejemplo, obtuve simultáneamente los valores de dos raster para 150 localidades: la temperatura media anual y la precicipitación anual. Para reproducirlo, hay que descargar los archivos de clima desde esta [página de descargas](http://chelsa-climate.org/downloads/){:target="_blank"} , y las coordenadas se pueden leer directamente de [este](https://raw.githubusercontent.com/luisDVA/codeluis/master/localidades.csv){:target="_blank"}  archivo csv. 

Los raster de clima los manejamos como objetos `stars`, y los datos puntuales como un objeto `simple feature` del paquete `sf`.

{% highlight r %}
# cargar paquetes, instalarlos si hace falta 
library(stars)
library(dplyr)
library(sf)
library(ggplot2)
library(scico)
library(patchwork)
remotes::install_github("michaeldorman/geobgu")
library(geobgu)

# leer el archivo con las localidades 
localidades <- read.csv("https://raw.githubusercontent.com/luisDVA/codeluis/master/localidades.csv")%>% select(long=2,lat=3)
# convertirlo a objeto sf, especificando cuales son las variables con las coordenadas x y
xydat <- st_as_sf(localidades, coords = c("long", "lat"))

# leer los raster de temperatura, en este caso los archivos estan en el directorio de trabajo
annTemp <- stars::read_stars("CHELSA_bio10_01.tif", proxy = TRUE) #temperatura media anual
annPrec <- stars::read_stars("CHELSA_bio10_12.tif", proxy = TRUE) # precipitación anual
# apilarlos como ingredientes en una hamburguesa
climStack <- c(annTemp, annPrec)
{% endhighlight %}

Utilizando el argumento _proxy_ de `read_stars()`, no se carga todo el archivo a la memoria y así evitamos que colapse la sesión de R por falta de RAM.

Para que sea más práctico el manejo de los raster, los podemos recortar a la extensión geográfica de nuestros datos puntuals (también podrían ser polígonos y el método es el mismo). En este caso, usé un _buffer_ de 3 grados alrededor de los cuatro valores que definen los valores máximos y mínimos de los puntos en ambos ejes. El 4326 es el código EPSG (European Petroleum Survey Group) de la proyección genérica WGS84.

La pila de rasters se recorta con `st_crop()`, y los raster recortados se pueden exportar/importar.

{% highlight r %}
# extension geografia para recortar y graficar
# definida por límites máximos y mínimos de long y lat 
xydatbuffer <- st_bbox(st_buffer(xydat, 3))
xydatbuffer <- st_as_sfc(xydatbuffer)
xydatbuffer <- st_as_sf(xydatbuffer, crs=4326)

# recortar rasters
climStack_cropped <- st_crop(climStack,xydatbuffer)
# exportar
write_stars(climStack_cropped[1], "annTempcr.tif")
write_stars(climStack_cropped[2], "annPreccr.tif")
# importar capas recortadas
annTempcr <- stars::read_stars("annTempcr.tif") #temperatura media anual
annPreccr <- stars::read_stars("annPreccr.tif") # precipitación anual
# apilarlos como ingredientes en una hamburguesa
climStackcr <- c(annTempcr, annPreccr)
{% endhighlight %}

Ahora podemos visualizar las capas recortadas y los datos puntuales directamente en `ggplot`. 

{% highlight r %}
 ggplot() +
  geom_stars(data = annTempcr, downsample = 2) +
  scale_fill_scico(palette = "lajolla", na.value = "transparent", name = "Temperatura media anual") +
  geom_sf(data = xydat, pch = 23, color = "white") +
  coord_sf() + ggthemes::theme_map() +
  theme(legend.position = "bottom") +
 ggplot() +
  geom_stars(data = annPreccr, downsample = 2) +
  scale_fill_scico(palette = "davos", na.value = "transparent", name = "Precipitación anual") +
  geom_sf(data = xydat, pch = 23, color = "white") +
  coord_sf() + ggthemes::theme_map() +
  theme(legend.position = "bottom")
{% endhighlight %}

El paquete `patchwork` nos ayuda a dibjuar las figuras lado a lado.

<figure>
    <a href="/images/capasbc.png"><img src="/images/capasbc.png"></a>
        <figcaption>paletas de color de scico</figcaption>
</figure>

La extracción es de los valores de los raster para cada punto es fácil, y se hace para todos los elementos de la pila al mismo tiempo. Aquí usé la función `geobgu::raster_extract()` (que a su vez llama a `raster::extract()`) dentro de `dplyr::mutate()` para poner los valores extraidos en cada punto en una nueva columna del objeto con los puntos.  

{% highlight r %}
# extraer valores
xydat <-
  xydat %>% mutate(
    precVals = raster_extract(annTempcr, xydat, fun = mean, na.rm = TRUE),
    tempVals = raster_extract(annPreccr, xydat, fun = max, na.rm = TRUE) / 100
  )
{% endhighlight %}

Así se ven los valores obtenidos para las primeras 15 líneas del objeto con los datos xy:

{% highlight r %}
xydat %>%
  slice(1:15) %>%
  st_set_geometry(NULL) %>%
  tibble::rowid_to_column() %>% 
  knitr::kable()
{% endhighlight %}

| rowid| precVals| tempVals|
|-----:|--------:|--------:|
|     1|      217|    24.94|
|     2|      194|    21.40|
|     3|      125|    14.16|
|     4|      194|    21.40|
|     5|      194|    21.40|
|     6|      135|    14.38|
|     7|      257|    14.14|
|     8|      233|    27.13|
|     9|      180|     9.45|
|    10|      167|    13.34|
|    11|      194|    21.40|
|    12|      194|    21.40|
|    13|      129|    10.30|
|    14|      246|     8.11|
|    15|      199|    13.46|

Como tenemos dos variables climáticas, las podemos graficar en dos dimensiones como un perfil bioclimático.


{% highlight r %}
ggplot(xydat, aes(tempVals, y = precVals)) +
  geom_point() + geom_density2d() +
  xlab("temperatura") + ylab("precipitación") +
  theme_minimal()
{% endhighlight %}


<figure>
    <a href="/images/biocxy.png"><img src="/images/biocxy.png"></a>
        <figcaption> envoltura bioclimática </figcaption>
</figure>

!Listo! Sabiendo extraer datos, los más tardado será la descarga de los raster.

No duden en contactarme si tienen cualquier duda o sugerencia.
