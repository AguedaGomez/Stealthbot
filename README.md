# Stealthbot
Stealthbot (también BeepFit) es un proyecto académico que fue desarrollado en 24 horas. Es un juego para PC, Kinect y Arduino de dos jugadores. 

## Descripción
El objetivo del juego consiste en completar un recorrido lo antes posible manejando un robot que tiene integrada una placa Arduino.
Cada una de las ruedas es controlada por un jugador y se activan cuando éste se agacha. 
La energía del robot está fragmentada en cuatro partes que se van consumiendo cada vez que éste está sobre las líneas que delimitan del recorrido. 
Para recargar la energía los jugadores pueden levantar la mano derecha cuando escuchen sonidos que emite el ordenador. 
Hay tres tipos de sonidos; uno recarga la energía un cuarto, otro la recarga dos cuartos y un tercero consume un cuarto de energía. 
Si los jugadores levantan la mano cuando se emite el tercer sonido y habían consumido la energía completa , acaba el juego teniendo que reanudar la partida.

En los vídeos [Stealthbot](https://www.youtube.com/watch?v=5w83Eg9dmz8&t=10s) y [¡Levántate y juega con BeepFit!](https://www.youtube.com/watch?v=6wIDf4YJWPM) se muestra el resultado de este proyecto.


## Aspectos técnicos y requisitos
-	Los robots que se han utilizado en este proyecto son [Miniskybots 2](http://www.iearobotics.com/wiki/index.php?title=Miniskybot_2).
-	Estos robots también tienen integrados un sensor infrarrojo blanco y negro, un módulo bluetooth que se conecta con el PC, cuatro leds que muestran el estado de la energía y un buzzer que suena cuando el robot está sobre negro.
-	Se necesita una Kinect (Xbox 360).
-	Los límites del recorrido deben ser negros sobre un fondo blanco.
-	El proyecto está programado en Arduino y Processing utilizando la librería [SimpleOpenNI](http://openni.ru/files/simpleopenni/index.html).


