---
title: "Limpiando datos en R"
layout: post
excerpt: Algunos pasos para reacomodar tablas con columnas repetidas, encabezados que no pertenecen, y notas al pie de página.
tags:
  - datos horrendos
  - iteraciones
  - purrr
  - adopción canina
image:
  feature: featureAwk.jpg
  credit: LD 
  creditlink: 
published: true
---

> read this post in English [here](http://luisdva.github.io/rstats/awkward-spreadsheet-formats/){:target="_blank"}

La siguente tabla es una muestra reducida de los datos contenidos en un directorio de centros de adopción canina en Canadá. Los datos son verdaderos y toda la información de contacto (correos, teléfonos, etc.) es reciente, y proviene de la página [Speaking of Dogs](https://www.speakingofdogs.com/){:target="_blank"}. 

Para este ejemplo, desacomodé el formato orgiginal de los datos para ponerlos en un formato medio complicado con el que he tenido que lidiar recientemente. Dejé el contenido de la tabla en inglés, el resto del texto en este ejemplo es en español. 

**Organization**|**Contact name**|**phone**|**website**|**Organization**|**Contact name**|**phone**|**website**
:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:
"Small Breed"| | | |"Bulldog (English)"| | | 
Happy Tails Rescue|Judy|905-357-5096|www.happytailsrescue.ca|Homeward Bound Rescue*|Kathy|905-987-1104|www.homewardboundrescue.ca
LOYAL Rescue Inc.|Anne|888-739-1221|www.loyalrescue.com|unknown|Joan†|416-738-6059 |unknown
Pomeranian and Small Breed Rescue|Shelley|416-225-6808|www.psbrescue.com|"Labrador Retriever "| | | 
Tiny Paws Rescue|Brenda|1-800-774-8315|www.tpdr.ca|Labrador Retriever Adoption Service|Laura or Karen |289-997-5227|www.lab-rescue.ca
"Senior Dogs"| | | |Dog Rescuers Inc|Joan|416-567-6249 ‡|www.thedogrescuersinc.ca
Speaking of Dogs Rescue|Lorraine|705-444-7637|www.speakingofdogs.com| | | |

La tabla tiene unos cuantos datos adicionales:
-  \* includes other Flat faced dogs: Bulldogs, Boxers, Bostons, Pugs etc
- † limited foster care available
- ‡ phone may not be up to date

En este formato, la tabla no está lista para ser analizada. Hay tres problemitas que hay que resolver primero. 

- Hay columnas repetidas en la tabla. Es como si alguien (yo) hubiera partido la tabla en dos (verticalmente) para después acomodas las dos mitades lado a lado en un formacho 'ancho'. No conviene tener columnas/variables repetidas porque esta manera de guardar datos es medio riesgosa e incómoda. 

- Hay encabezados metidos dentro de la columna _Organization_. Estas filas se usan para avisar que los datos en las filas que siguen pertenencen a un grupo, pero estas variables que agrupan observaciones no pertenenen en la misma variable. La práctica de usar encabezados de esta forma es muy común, y en realidad es fácil deseguir visualmente pero complica la manipulación automatizada de datos. Aquí hay una mejor [descripción](http://rpubs.com/jennybc/untangle-tidyeval){:target="_blank"}.

- Hay caracteres especiales en algunas celdas de la tabla, que se están usando para hacer referencia a algunos datos adicionales que están afuera de la misma (a manera de notas al pie de página).

# Reestructuración de datos

Aquí explico algunos pasos que se pueden hacer para reacomodar y reestructurar la tabla usando R. Sólo hace falta instalar algunos paquetes adicionales, y el resto del código se puede sequir copiando y pegando.

Para reproducir el ejemplo, lo primero que hay que hacer es pegar la tabla. Aquí viene como vector, con las columnas y filas delimitadas por tabulaciones y saltos de línea respectivamente.


{% highlight r %}
# cargar paquetes
library(dplyr)
library(magrittr)
library(tidyr)
library(rlang)
library(purrr)

# vector de datos 
resc <- 
c("Organization	Contact name	phone	website	Organization	Contact name	phone	website
'Small Breed'				'Bulldog (English)'			
Happy Tails Rescue	Judy	905-357-5096	www.happytailsrescue.ca	Homeward Bound Rescue*	Kathy	905-987-1104	www.homewardboundrescue.ca
LOYAL Rescue Inc.	Anne	888-739-1221	www.loyalrescue.com	unknown	Joan†	416-738-6059 	unknown
Pomeranian and Small Breed Rescue	Shelley	416-225-6808	www.psbrescue.com	'Labrador Retriever'			
Tiny Paws Rescue	Brenda	1-800-774-8315	www.tpdr.ca	Labrador Retriever Adoption Service	Laura or Karen 	289-997-5227	www.lab-rescue.ca
'Senior Dogs'				Dog Rescuers Inc	Joan	416-567-6249‡	www.thedogrescuersinc.ca
Speaking of Dogs Rescue	Lorraine	705-444-7637	www.speakingofdogs.com")				
{% endhighlight %}

Ahora podemos hacer que cada linea sea una fila dentro de una 'tibble', para después separar las columnas y de esta manera siguen habiendo variables repetidas.

{% highlight r %}
# pasar a filas
rescDF <- data_frame(unsep=unlist(strsplit(resc,"\n")))

# separar variables
rescDF %<>% separate(unsep,into=unlist(strsplit(rescDF$unsep[1],"\t")),sep ="\t")
{% endhighlight %}

Ahora toca apilar la tabla para que quede en formato 'largo' y no 'ancho'. En algún momento pregunté en Twitter cómo podía hacer ésto, y la recomendación general fue que usara la función _gather_ de _tidyr_. Esta solución sólo sirve si primero resolvemos el problema de las columnas repetidas o lo evitamos desde el principio.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/hashtag/rstats?src=hash">#rstats</a> crew: how can I use <a href="https://twitter.com/hashtag/purrr?src=hash">#purrr</a> to stack a &#39;wide&#39; df with duplicated variable names? <br>(I know I shouldn&#39;t have them in the first place) <a href="https://t.co/yxJoHMQ6N3">pic.twitter.com/yxJoHMQ6N3</a></p>&mdash; Luis D. Verde (@LuisDVerde) <a href="https://twitter.com/LuisDVerde/status/895439984966197249">August 10, 2017</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

No siempre vamos a tener datos limpios y columnas que no se repitan, y por eso aquí vamos a seguir la propuesta que encontré en esta [discusión](https://stackoverflow.com/questions/38839048/r-reshape-dataframe-from-duplicated-column-names-but-unique-values){:target="_blank"}. El usuario _akrun_ propone una solución bastante ingeniosa:

- extraer todas los observaciones para cada nombre de columna único iterativamente 
- desvincularlos (unlist)  
- acomodar todo en una tabla 

Le hice algunos cambios a la propuesta original. Más que nada cambié el  _lapply_ y en su lugar usé  _map_ porque estoy tratando de aprender  _purrr_.

{% highlight r %}
# apilar
rescDFstacked <- 
map(unique(names(rescDF)), ~
      unlist(rescDF[names(rescDF)==.x], use.names = FALSE)) %>% 
  as.data.frame(stringsAsFactors = FALSE) %>% 
  set_names(unique(names(rescDF)))
{% endhighlight %}

Los datos ya van tomando mejor forma pero aún falta sacar los encabezados que están metidos dentro de la columna _Organization_. La función _untangle2_ que está descrita [aquí](http://rpubs.com/jennybc/untangle-tidyeval){:target="_blank"} es justo lo que necesitamos. Muchas gracias a [Jenny Bryan](https://twitter.com/JennyBryan){:target="_blank"} por mejorar la versión original. 

En nuestro ejemplo los encabezados están entre comillas simples, y por eso es bastante fácil sacarlos y ponerlos en su lugar.

{% highlight r %}
# definir la función untangle2
untangle2 <- function(df, regex, orig, new) {
  orig <- enquo(orig)
  new <- sym(quo_name(enquo(new)))
  
  df %>%
    mutate(
      !!new := if_else(grepl(regex, !! orig), !! orig, NA_character_)
    ) %>%
    fill(!! new) %>%
    filter(!grepl(regex, !! orig))
}


# sacar los encabezados (cualquier cosa entre comillas en la variable Organization)
rescDFstacked %<>% untangle2("'",Organization,Category)
{% endhighlight %}

Ahora hay que limipar las filas, quitando las que están vacías or repetidas.

{% highlight r %}
# quitar filas repetidas, NA, o vacías
rescDFstacked %<>% filter(Organization != "Organization" & Organization != " ", !is.na(Organization))
{% endhighlight %}

Las notas al pie de página son el último problema. Para incorporar estos datos en la tabla, podemos usar 
_case\_when_ y _mutate_ y así meter las notas en las filas en las que corresponden. No me gustó tanto esta forma de definir manualmente las columnas en las que había que buscar los diferentes caracteres especiales, pero no sabía qué más hacer.

{% highlight r %}

# metar las notas a la tabla
rescDFstacked %<>% mutate(observation = case_when(
  grepl("\\*",Organization)~"includes other Flat faced dogs: Bulldogs, Boxers, Bostons, Pugs etc",
  grepl("\u0086",`Contact name`)~"limited foster care available",
  grepl("\u0087",phone)~"phone may not be up to date"
  ))

# para saber en qué columnas buscar con el regex
rescDFstacked %>% map(~grepl("\\*",.x)) %>% map(~.x[.x==TRUE]) %>% unlist() %>% names()
rescDFstacked %>% map(~grepl("\u0086",.x)) %>% map(~.x[.x==TRUE]) %>% unlist() %>% names()
rescDFstacked %>% map(~grepl("\u0087",.x)) %>% map(~.x[.x==TRUE]) %>% unlist() %>% names()

# no sirvió
# map2(rescDFstacked,c("\\*","\u0086","\u0087"),~ grepl(.y,.x))
{% endhighlight %}

Finalmente, sólo hay que borrar los caracteres especiales.

{% highlight r %}

# quitar símbolos raros
rescDFstacked %<>% mutate_all(funs(gsub("[†|‡|'|\\*]","",.)))
{% endhighlight %}

Así queda la tabla reestructurada:

**Organization**|**Contact name**|**phone**|**website**|**Category**|**observation**
:-----:|:-----:|:-----:|:-----:|:-----:|:-----:
Happy Tails Rescue|Judy|905-357-5096|www.happytailsrescue.ca|Small Breed|NA
LOYAL Rescue Inc.|Anne|888-739-1221|www.loyalrescue.com|Small Breed|NA
Pomeranian and Small Breed Rescue|Shelley|416-225-6808|www.psbrescue.com|Small Breed|NA
Tiny Paws Rescue|Brenda|1-800-774-8315|www.tpdr.ca|Small Breed|NA
Speaking of Dogs Rescue|Lorraine|705-444-7637|www.speakingofdogs.com|Senior Dogs|NA
Homeward Bound Rescue|Kathy|905-987-1104|www.homewardboundrescue.ca|Bulldog (English)|includes other Flat faced dogs: Bulldogs
unknown|Joan|416-738-6059 |unknown|Bulldog (English)|limited foster care available
Labrador Retriever Adoption Service|Laura or Karen |289-997-5227|www.lab-rescue.ca|Labrador Retriever|NA
Dog Rescuers Inc|Joan|416-567-6249|www.thedogrescuersinc.ca|Labrador Retriever|phone may not be up to date

Listo. Si hay alguna duda me pueden escribir.
