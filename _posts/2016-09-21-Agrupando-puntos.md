---
layout: post
excerpt: Tres maneras de agrupar puntos en dos dimensiones con ggplot.
tags:
  - rstats
  - ggplot
  - en tu idioma
  - graficas
image:
  feature: featureGroups.png
  credit: null
  creditlink: null
published: true
---
## Agrupando puntos en dos dimensiones con ggplot

> This post is available in English [here](http://luisdva.github.io/rstats/Grouping-points/ "Anglais")

Para varios tipos de análisis, es común terminar con gráficas que muestran puntos de dos o más grupos en dos dimensiones. Por ejemplo: análisis de componentes principales, perfiles bioclimáticos, o cualquier combinación de valores en dos ejes. Colaborando en diferentes proyectos, me he encontrado con tres alternativas para agrupar puntos y las quiero compartir en una misma publicación.

Todos estos métodos son para graficar con _ggplot2,_ y estos ejemplos son con datos reales, obtenidos de la información en línea de [este](http://www.journals.uchicago.edu/doi/10.1086/688383 "codorniz") artículo sobre fisiología de codornices. Después de cargar los paquetes requeridos y descargar los datos directamente de Dryad, podemos separar los datos para comparar el peso y el largo de varias aves a los 30 y 40 días de edad. 

{% highlight r %}

#cargar paquetes (instalar si es necesario)
library(dplyr)
library(ggplot2)
library(plyr)
library(ggalt)
# descargar datos de Dryad
birdData <- read.csv("http://www.datadryad.org/bitstream/handle/10255/dryad.124441/Morphology%20data.csv?sequence=1",stringsAsFactors = FALSE)
# separar en dos tablas para 30 y 40 dias de edad
birds40 <- birdData %>% select(mass=Day.40.mass..g.,length=Day.40.head.bill.length..mm.) %>% mutate(age="day40")
birds30 <- birdData %>% select(mass=Day.30.mass..g.,length=Day.30.head.bill.length..mm.) %>% mutate(age="day30")
# juntar en una misma tabla y quitar filas incompletas
birdsAll <- bind_rows(birds30,birds40) %>% na.omit()

# graficar solo los puntos
  ggplot(birdsAll,aes(x=mass,y=length,color=age))+geom_point()+theme_bw()
  
{% endhighlight %}

<figure>
    <a href="/images/pointsonly.png"><img src="/images/pointsonly.png"></a>
        <figcaption>puntos en 2d</figcaption>
</figure>

Uno de los métodos más comunes para agrupar puntos es la **envoltura convexa** (_convex hull_), que tiene una definición geométrica formal pero que prácticamente es como si rodeáramos al grupo de puntos con una liga elástica.  Podemos calcular las envolturas para varios grupos usando grDevices::chull y una función de la familia apply (este método lo aprendí en [esta](http://stats.stackexchange.com/questions/22805/how-to-draw-neat-polygons-around-scatterplot-regions-in-ggplot2 "foro") discusión).

{% highlight r %}

# calculando envolturas
find_hull <- function(birdsAll) birdsAll[chull(birdsAll$mass, birdsAll$length), ]
hulls <- ddply(birdsAll, "age", find_hull)

# graficar con envolturas
  ggplot(birdsAll,aes(x=mass,y=length,color=age))+geom_point()+
  geom_polygon(data=hulls,fill=NA)+ theme_bw()

{% endhighlight %}

<figure>
    <a href="/images/chullsimg.png"><img src="/images/chullsimg.png"></a>
        <figcaption>con envoltura</figcaption>
</figure>

Otra opción muy común es la de agrupar puntos usando **elipses**. _ggplot_ cuenta con una opción bastante flexible para trazar elipses, que además hereda los parámetros gráficos necesarios para dibujar los colores y la leyenda sin necesidad de especificarlos por separado.

{% highlight r %}
# graficar con elipse
  ggplot(birdsAll,aes(x=mass,y=length,color=age))+geom_point()+
  stat_ellipse()+ theme_bw()
  
{% endhighlight %}

<figure>
    <a href="/images/elips.png"><img src="/images/elips.png"></a>
        <figcaption>elipse sin cambios a los argumentos de color or relleno</figcaption>
</figure>


Esta tercera opción es la que yo terminé utilizando en mis figuras es con _geomencircle_, una geometría adicional que es parte del paquete [ggalt](https://github.com/hrbrmstr/ggalt). Este método utiliza **splines**, o curvas diferenciables definidas en porciones mediante polinomios, y termina dibujando polígonos redondeados que se ven bastante bien. Este método es más que nada para agrupar puntos y destacarlos visualmente, y no necesariamente para hacer otros análisis basados en el área del polígono (como ocurre en el caso de las envolturas convexas). 

{% highlight r %}
# graficar con poligonos redondeados
  ggplot(birdsAll,aes(x=mass,y=length,color=age))+geom_point()+
  geom_encircle(expand=0)+ theme_bw()

{% endhighlight %}

<figure>
    <a href="/images/encircle.png"><img src="/images/encircle.png"></a>
        <figcaption>con spline</figcaption>
</figure>


Para estas tres opciones es posible cambiar los parámetros de relleno y transparencia, estos ajustes sirven para destacar la sobreposición entre grupos.
