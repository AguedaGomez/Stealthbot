char blueToothVal;           //value sent over via bluetooth
int pinBuzzer = 9;
int sensorBN = 14;
int valorBN;
int leds_encendidos = 3;
bool baja_bateria = true;
int ledBN = 7;
bool calculado = false;
unsigned long tiempo_pasado = 0;
unsigned long TiempoSonido;

 
void setup()
{
 Serial.begin(9600); 
 for (int led=10; led<=13; led++){
  pinMode(led,OUTPUT);
  digitalWrite(led,HIGH);
 }
 pinMode(pinBuzzer,OUTPUT);
 pinMode(sensorBN,INPUT);
 pinMode(ledBN, OUTPUT);
 //tone(pinBuzzer,442,500);
 digitalWrite(pinBuzzer, HIGH);
}
 
 
void loop()
{ 
  digitalWrite(pinBuzzer, HIGH);
  digitalWrite(ledBN,HIGH);
  if(Serial.available())
  {//if there is data being recieved
    blueToothVal=Serial.read(); //read it
  }
  /* MOVER RUEDAS */
  switch (blueToothVal)
  {
    case 'a':
       if(leds_encendidos>-1)
       {
          digitalWrite(4,HIGH);            //gira rueda izquierda
          digitalWrite(3,LOW);
          calculado = false;
       }
       break;
       
    case 'd':
      if(leds_encendidos>-1)
      {
        digitalWrite(3,HIGH);            //gira rueda derecha
        digitalWrite(4,LOW);
        calculado = false;
      }
      break;
      
    case 'o':
      digitalWrite(4,LOW);
      break;
    case 'f':
      digitalWrite(3,LOW);
      break;
    case 's':
      digitalWrite(3,LOW);
      digitalWrite(4,LOW);
      break;
    case 'w':
      if(leds_encendidos>-1)
      {
        digitalWrite(3,HIGH);
        digitalWrite(4,HIGH);
        calculado = false;
      }
      else
        blueToothVal = 's';
      break;
    case '1':                           //coge sonido muy bueno
      if (leds_encendidos<2 && !calculado)
      {
        leds_encendidos++;
        digitalWrite(10+leds_encendidos, HIGH);
        leds_encendidos++;
        digitalWrite(10+leds_encendidos, HIGH);
        calculado = true;
        //println("case 1 leds_encendidos<2");
      }
      else if (leds_encendidos==2 && !calculado)
      {
        leds_encendidos++;
        digitalWrite(10+leds_encendidos, HIGH);
        calculado = true;
        //println("case 1 leds_encendidos==2");
      }
      break;
    case '2':                           //coge sonido bueno
      if (leds_encendidos<3 && !calculado)
      {
        leds_encendidos++;
        digitalWrite(10+leds_encendidos, HIGH);
        calculado = true;
       // Serial.println("case 2 leds_encendidos<3");
      }
      break;
    case '3':                           //coge sonido malo 
      if (leds_encendidos>=0 && !calculado)
      {
        digitalWrite(10+leds_encendidos, LOW);
        leds_encendidos--;
        calculado = true;
        //println("case 3 leds_encendidos>=0");
      }
        
      break;
  }
  
  /* LEER SI TE SALES DE LA LÍNEA Y GASTO DE BATERÍA */
  valorBN = digitalRead(sensorBN);
  if(valorBN == 1){
    if ((int(millis()/1000)-tiempo_pasado>2 || tiempo_pasado==0)&& baja_bateria && leds_encendidos>=0){
      digitalWrite(10+leds_encendidos, LOW);
      leds_encendidos--;
      baja_bateria = false;
      //tone(pinBuzzer,1500,1000);
      digitalWrite(pinBuzzer, LOW);
      delay(200);
      digitalWrite(pinBuzzer, HIGH);

      tiempo_pasado = int(round(millis()/1000));
    }
  }
  if(valorBN==0) {
     baja_bateria = true;

  }

  
  
}
