---
layout: post
title: "La Santísima Trinidad Parte 1 - Inseguro por negligencia"
tags: rant opinion
---

## .::0xFF::Contexto::.

Llevo harto tiempo queriendo escribir sobre este tema, porque me lo sigo
topando una y otra vez en mi vida diaria (y porque soy medio obsesivo). En
foros, videos y en mil otros lugares más me he encontrado con gente que -por
algún motivo u otro- difunde malas prácticas de seguridad, sin ser conscientes
de ello la mayoría de las veces. Mi ejemplo favorito de este fenómeno es la
cantidad preocupante de usuarios en Stack Overflow que recomiendan correr
`chmod 777` para resolver cualquier problema de permisos que alguien tenga,
independiente del contexto de la pregunta original.

![caddy-security](/assets/images/2024-trinidad-p1-so1.png){:class="imgcenter" width="60%"}

![caddy-security](/assets/images/2024-trinidad-p1-so2.png){:class="imgcenter" width="60%"}

![caddy-security](/assets/images/2024-trinidad-p1-so3.png){:class="imgcenter" width="60%"}

**[*] TIP: No hagan eso!!1! :)** En sistemas *nix, 777 indica permisos de
lectura, escritura y ejecución para cualquiera, aka. porfa no, gracias.

A estos comportamientos los llamo _"muletillas"_ y pueden parecer
insignificantes en la mayoría de los casos. Si bien esto es verdad casi siempre,
yo soy medio purista (extremista) para mis cosas y son estos detalles los que me
sacan de quicio realmente.

Dada esta distribución masiva de contenido inseguro (NSFW literalmente jaja
saludos) con la que me vi enfrentado, decidí plasmar mi opinión en lo que
terminó siendo un archivo eliminado, porque la verdad es que estaba muy malo.
Sin embargo, durante este proceso mi crítica dejó de ser solo sobre las
_"muletillas"_ y fue mutando hasta reducirse en 3 ideas clave, que terminé
llamando **La Santísima Trinidad** porque soy edgy y suena bacán.
{% asciiart center %}
.~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~.
(  '.  _  .'      ¿Sabías que elegí el nombre "La Santísima Trinidad"     )
( -=  (~)  =-     porque decidí resumir estas ideas en 3 conceptos        )
(  .'  #  '.      clave? Qué cool!!                                       )
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
{% endasciiart %}

## .::0x00::_La Santísima Trinidad™_::.

_La Santísima Trinidad™_ hace referencia a lo que yo creo que son las
explicaciones más comunes para la existencia de código inseguro/vulnerable.
Estas "explicaciones" tienen la cualidad de englobar una serie de problemas
comunes y recurrentes, como el ejemplo con `chmod 777` más arriba. No me refiero
a BOFs, inyecciones SQL ni a ninguna otra vulnerabilidad en particular, sino más
bien a los comportamientos y malas prácticas que sus desarrolladores tuvieron
para que estas siquiera existieran en primer lugar.

Omito algunos casos específicos, como por ejemplo la inserción deliberada de
código malicioso (liblzma siono), ya que son problemas que no se pueden abordar
a esta escala y porque haría que fueran 4 conceptos y no 3; y no se me ocurre
ningún nombre bueno para esa cantidad de cosas.

En general, estos posts van a ser bien cortos y todos con la misma estructura;
primero voy a explicar un poco la idea en cuestión y luego mostraré casos reales
que he encontrado en los que siento que esta aplica. Espero ir añadiendo cosas a
medida que me las tope, pero probablemente se me olvide.

Mucha paja mental... Música tito!

## .::0x01::Inseguro por Negligencia::.

Esta es el último concepto que se me ocurrió, pero el primero que muestro porque
ohhh puta qué rabia.

Bajo mi definición:
{% asciiart center %}
Un programa es "Inseguro por Negligencia" cuando sus
desarrolladores/mantenedores han sido informados sobre la existencia de un
problema de seguridad en este, pero toman la decisión deliberada de no
abordarlo.
{% endasciiart %}

Este es -sin discusión- uno de los peores casos que hay, porque desvela las
verdaderas prioridades detrás del proyecto y expone el absoluto desinterés de
sus desarrolladores por el bienestar de sus usaurios. eww.

Veamos algunos ejemplos.

## .::0x2::Ejemplo 1 - caddy-security::.

![caddy-security](/assets/images/2024-trinidad-p1-caddy-security.png){:class="imgcenter" width="60%"}

- Nombre: caddy-security 
- Descripción: Plugin de AAA [0] no oficial para el servidor web Caddy.
- URL: https://github.com/greenpau/caddy-security

A primera vista, es un plugin bien completo para implementar seguridad en un
servidor web Caddy. Me parece fantástico, y en particular se cruza con dos cosas
que me gustan mucho: Caddy y ciberseguridad.

Sin embargo, los problemas comenzaron el 18/09/2023, cuando un grupo de
investigadores de _Trail of Bits_ [1] publicaron un artículo [2] exponiendo
múltiples vulnerabilidades que encontraron en el plugin. Entre estas destacan
una redirección abierta y 2 XSS. Estos problemas fueron reportados
responsablemente a los mantenedores del plugin, quienes respondieron afirmando
que **no estaba entre sus planes a corto plazo trabajar en ellos**. Aquí me
caliento un poco la cabeza, pero no sin antes reconocer algunas cosas:

1. Entiendo que este proyecto fue hecho, y actualmente está siendo mantenido por una sola persona.
2. El proyecto es Open Source y nada me impide hacer un PR y mitigar las vulnerabilidades.
3. Igual es un proyecto grande y honestamente está super bien hecho, es natural que aparezcan este tipo de problemas.

Por otro lado, si uno hace un plugin exclusivamente sobre ciberseguridad,
esperaría que esta también fuera una prioridad para el proyecto en sí.  Entiendo
el fenómeno Open Source y no me puedo ni imaginar lo que debe ser tener que
mantener un proyecto usado por miles de personas, eso se lo cedo.  Pero
incluso con todo eso, esperaría que por último no fuera tan secretiva la
existencia de estas vulnerabilidades, porque la única forma que tiene hoy un
usuario para saber de ellas es leyendo los issues en el repositorio o haciendo
una búsqueda específica del tema.
{% asciiart center %}
https://duckduckgo.com/?q=caddy-security | https://duckduckgo.com/?q=caddy-security+vulnerability
{% endasciiart %}
Trato de no ser tan duro con este caso particular, pero luego recuerdo que a la
fecha (26/04/24) más de 22k usuarios han descargado el plugin [3] y quizá
cuántos más lo estén usando activamente.

![Plugin Downloads](/assets/images/2024-trinidad-p1-downloads.png){:class="imgcenter"}

Para que se entienda un poco mejor mi enojo, investigué cuál es el título por
defecto que el portal de autenticación de caddy-security tiene configurado. Para
hacerla corta, solo me basé en el template genérico que ofrecen [4].

![Plugin Downloads](/assets/images/2024-trinidad-p1-caddy-title.png){:class="imgcenter" width="80%"}

Sumando las variables en el código {% raw %}[5][6]{% endraw %} sabemos que el
título por defecto es **"Authentication Portal - Sign In"**.

![Plugin Downloads](/assets/images/2024-trinidad-p1-caddy-title-1.png){:class="imgcenter"}
*https://github.com/greenpau/go-authcrunch/blob/12d1bf7/pkg/authn/portal.go#L593*

![Plugin Downloads](/assets/images/2024-trinidad-p1-caddy-title-2.png){:class="imgcenter"}
*https://github.com/greenpau/go-authcrunch/blob/12d1bf7/pkg/authn/portal.go#L543*

Ahora, si dorkeamos como los _1337 h4x0rs_ que somos, nos encontramos con muchos
sitios que aparentemente están usando _caddy-security_...

![Plugin Downloads](/assets/images/2024-trinidad-p1-caddy-dork.png){:class="imgcenter"}
*intitle:"Authentication Portal - Sign In"*

Para validar esto, podemos explotar alguna de las vulnerabilidades encontradas
por los investigadores. Acá estoy explotando uno de los XSS [7] porque
`alert(document.cookie + " kali linux hack")` y todo ese rollo.

Y sorpresa sorpresa, son vulnerables.

![Plugin Downloads](/assets/images/2024-trinidad-p1-caddy-xss.png){:class="imgcenter"}

## .::0x3::Takeaways::.

Casos como _caddy-security_ hay por montones, escribí sobre este solamente
porque uso mucho Caddy. Es complicado el diálogo Open Source, pero creo que si
uno publica una librería para implementar controles de seguridad, y además esta
se vuelve popular, lo siento mucho pero _"once you're in, you're in"_. Quiera
uno o no, este hecho viene con responsabilidades y deberes nuevos. No hablo de
mantener sagradamente el código o resolver todos los issues que aparezcan, sino
que de ser transparente con los usuarios y ser consciente del impacto que uno
está teniendo en el mundo digital.

Si bien encuentro pésimo que se haya descartado la idea de mitigar las
vulnerabilidades (considerando la naturaleza del programa), encuentro peor que
no se hayan tomado otro tipo de acciones para comunicar el problema al resto del
mundo. En mi caso ideal, se habría añadido un disclaimer en el README y en el
sitio web informando a los usuarios sobre los potenciales riesgos a los que se
se vería expuesta su aplicación, llegasen a usar el plugin. La ausencia de este
mensaje me da a entender que los autores valoran mucho más la popularidad del
proyecto que aquello que tanto defienden: la seguridad de sus usuarios.

Afortunadamente, la inseguridad por negligencia es lo que menos me he encontrado
en el mundo real (aunque puede que sea yo nomás), pero `|algo| > 0`, y eso es
suficiente para que me parezca relevante hablar del tema.

{% asciiart center %}
 _______________________________________ 
/ La seguridad no es una opción, es una \
\ necesidad.                            /
 --------------------------------------- 
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
{% endasciiart %}

Qué trillado igual usar cowsay siono, ya chao bye

## .::0x4::Referencias::.

{% asciiart left,4 %}
[0] Autenticación, Autorización y Contabilización (o Alianza Apostólica Anticomunista, como ustedes quieran)
[1] https://www.trailofbits.com/
[2] https://blog.trailofbits.com/2023/09/18/security-flaws-in-an-sso-plugin-for-caddy/
[3] https://caddyserver.com/download?package=github.com%2Fgreenpau%2Fcaddy-security
[4] https://github.com/greenpau/go-authcrunch/blob/8f2ec94/assets/portal/templates/basic/generic.template
[5] https://github.com/greenpau/go-authcrunch/blob/12d1bf7/pkg/authn/portal.go#L593
[6] https://github.com/greenpau/go-authcrunch/blob/12d1bf7/pkg/authn/portal.go#L543
[7] https://github.com/greenpau/caddy-security/issues/264
{% endasciiart %}
