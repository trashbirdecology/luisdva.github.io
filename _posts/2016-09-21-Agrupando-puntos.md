---
published: false
---
## Agrupando puntos en dos dimensiones con ggplot

Para varios tipos de análisis, es común terminar con gráficas que muestran puntos de dos o más grupos en dos dimensiones. Por ejemplo: análisis de componentes principales, perfiles bioclimáticos, o cualquier combinación de valores en dos ejes. Colaborando en diferentes proyectos, me he encontrado con tres alternativas para agrupar puntos y las quiero compartir en una misma publicación.

Todos estos métodos son para graficar con ggplot2, y estos ejemplos son con datos reales, obtenidos de la información en línea de este artículo sobre fisiología de codornices. Después de cargar los paquetes requeridos y descargar los datos directamente de Dryad, podemos separar los datos para comparar el peso y el largo de varias aves a los 30 y 40 días de edad. 

codeblokc

Uno de los métodos más comunes para agrupar puntos es la envoltura convexa (convex hull), que tiene una definición geométrica formal pero que prácticamente es como si rodeáramos al grupo de puntos con una liga elástica.  Podemos calcular las envolturas para varios grupos usando grDevices::chull y una función de la familia apply (este método lo aprendí en esta discusión).

codeblock

img

Otra opción muy común es la de agrupar puntos usando elipses. Ggplot cuenta con una opción bastante flexible para trazar elipses, que además hereda los parámetros gráficos necesarios para dibujar los colores y la leyenda sin necesidad de especificarlos por separado.

Codeblock
Img

Esta tercera opción es la que yo terminé utilizando en mis figuras es con geom_encircle, una geometría adicional que es parte del paquete ggalt. Este método utiliza splines, o curvas diferenciables definida en porciones mediante polinomios y termina dibujando polígonos redondeados que se ven bastante bien. Este método es más que nada para agrupar puntos y destacarlos visualmente, y no necesariamente para hacer otros análisis basados en el área del polígono (como ocurre en el caso de las envolturas convexas). 

Codeblock
Img

Para estas tres opciones es posible cambiar los parámetros de relleno y transparencia, estos ajustes sirven para destacar la sobreposición entre grupos. 
