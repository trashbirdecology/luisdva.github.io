---
layout: post
excerpt: Graficando dos variables independientes sin usar ejes duales.
tags:
  - el gerente
  - ggplot2
  - elerre
image:
  feature: featureDual.jpg
  credit:
  creditlink:
published: true
---

Supongamos que el personal administrativo de un negocio quiere visualizar las cifras anuales sobre el número de transacciones registradas y el total de ventas para cada uno de sus 15 empleados.  
En este caso no hay razón para esperar que el total de ventas ($MXN) se relacione estrechamente con el número de transacciones (puede que los precios de los productos en venta varíen mucho).  

| vendedor | transacciones | total_ventas |
|----------|---------------|--------------|
| A        | 34            | 2807         |
| B        | 21            | 200          |
| C        | 6             | 10954        |

Una de las opciones más simples es mostrar las gráficas para cada variable independiente lado a lado, y para ayudarnos visualmente podemos acomodar la variable dependiente (en este caso un factor) según sus valores en el eje Y para alguna de las dos variables independientes. Ni sé cómo usar dos ejes y simultáneamente y hay [varias](http://www.storytellingwithdata.com/blog/2016/2/1/be-gone-dual-y-axis) [razones](http://www.storytellingwithdata.com/blog/2011/05/secondary-y-axis) para no hacerlo.

<figure>
    <a href="/images/lollp1.png"><img src="/images/lollp1.png"></a>
        <figcaption></figcaption>
</figure>

Si el objetivo es condensar información sobre las dos variables independientes en una misma gráfica, podemos crear una nueva variable que combina las dos anteriores, o bien combinar diferentes representaciones visuales para valores continuas en una misma figura. 

> Total vendido / número de transacciones

| vendedor | transacciones | total_ventas | montoXtransaccion |
|----------|---------------|--------------|-------------------|
| A        | 34            | 2807         | 82.55             |
| B        | 21            | 200          | 9.5               |
| C        | 6             | 10954        | 1825.6            |

En el primer caso, la gráfica sigue los mismos principios visuales que las dos anteriores.

<figure>
    <a href="/images/lollp2.png"><img src="/images/lollp2.png"></a>
        <figcaption></figcaption>
</figure>

En este último caso, usé (de manera bastante redundante) colores, tamaños, y etiquetas para mostrar los valores de ventas totales mientras que el número de transacciones sólo se demuestra con la posición de los puntos en el eje Y. 

<figure>
    <a href="/images/lollp3.png"><img src="/images/lollp3.png"></a>
        <figcaption></figcaption>
</figure>

El script de R para reproducir este tipo de gráficas está disponible en el siguiente Gist. La apariencia nítida y minimalista es gracias a los paquetes _ggalt_ y _hrbrthemes_ desarrollados por [Bob Rudis](https://github.com/hrbrmstr). En el script primero generamos datos aleatorios para 15 vendedores (rotulados “A”,”B”,”C”,etc.) y luego generamos las figuras con ggplot2. Personalmente prefiero usar ‘paletas’ en lugar de barras y girar los ejes 90 grados (coord_flip) para que sean más fáciles de interpretar. Por lo general yo uso el paquete _gridExtra_ para acomodar dos o más objetos gráficos lado a lado.

{% gist luisDVA/3e45462f654e9717e37dffbc86ded4aa %}
