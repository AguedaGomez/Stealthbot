import SimpleOpenNI.*;
import processing.serial.*;
import ddf.minim.*;

SimpleOpenNI  context;
Minim minim;
AudioPlayer bueno;
AudioPlayer muyBueno;
AudioPlayer malo;


Serial myPort;

float altura_user_1;
float altura_user_2;
float tiempo;
float r;
int tiempoSonidos = 0;
boolean detectado_user_1=false;
boolean detectado_user_2=false;
boolean haBajado1 =false;
boolean haBajado2 = false;
boolean sonidoCogido=false;

PVector joint;
PVector joint2;
PVector jointH;
PVector jointH2;

PVector convertedJoint;
PVector convertedJoint2;
PVector convertedJointH;
PVector convertedJointH2;

void setup() {
  context = new SimpleOpenNI(this);
  context.enableDepth();
  
  // turn on user tracking
  context.enableUser();

  size(640,480);
  String portName = Serial.list()[7];
  myPort = new Serial(this,portName,9600);
  
  fill(255, 0, 0);
  //play 
  minim=new Minim(this);
  bueno = minim.loadFile( "Bueno.mp3"); // 1
  muyBueno = minim.loadFile( "MuyBueno.mp3"); //2
  malo = minim.loadFile( "Malo.mp3"); //3

}

void draw() {
  context.update();
  PImage depth = context.depthImage();
  image(depth, 0, 0);
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();

  
  for (int i=0; i<userList.length; i++)
  {
    if(i>1)break;
    int userId = userList[i];

    if (context.isTrackingSkeleton(userId))
    {
      drawSkeleton(userId);
      
    }
    
  }
 // print("tiempo : \n\n",int(round(millis()/1000)));
  if(keyCode==UP) {
    tiempo=millis()/1000;
    println("Has superado la prueba en " ,Float.toString(tiempo));
    exit();
  }
  
   if (int(round((millis()/1000)))-tiempoSonidos == 7){
     r = random(1,3);
     println("random es ",Float.toString(r));
     switch(int(round(r))){
       case 1:
         tiempoSonidos = int(round((millis()/1000)));
         sonidoCogido=false;
         bueno.rewind();
         bueno.play();
         println("suena el bueno");
         break;
       case 2:
         tiempoSonidos = int(round((millis()/1000)));
         sonidoCogido=false;
         muyBueno.rewind();
         muyBueno.play();
         println("suena el muy bueno");
         break;
       case 3:
         tiempoSonidos = int(round((millis()/1000)));
         sonidoCogido=false;
         malo.rewind();
         malo.play();
         println("suena el malo");
         break;
     }
   }
  
}

void drawSkeleton(int userId) {
  stroke(0);
  strokeWeight(5);
  noStroke();

  fill(255,0,0);

 drawJoint(userId, SimpleOpenNI.SKEL_HEAD);




  drawJoint(userId,SimpleOpenNI.SKEL_RIGHT_HAND);

}

void drawJoint(int userId, int jointID) {
   float confidence =0;
   if (jointID ==SimpleOpenNI.SKEL_HEAD){
      if(userId ==1){
        joint = new PVector();
        confidence = context.getJointPositionSkeleton(userId, jointID, joint);
        convertedJoint = new PVector();
        context.convertRealWorldToProjective(joint, convertedJoint);
        ellipse(convertedJoint.x, convertedJoint.y, 20,20);  
      }
      else if (userId==2){
        joint2 = new PVector();
        confidence = context.getJointPositionSkeleton(userId, jointID, joint2);
        convertedJoint2 = new PVector();
        context.convertRealWorldToProjective(joint2, convertedJoint2);
        ellipse(convertedJoint2.x, convertedJoint2.y, 20,20);  
      }
      if(confidence < 0.5){
        return;
      }
    
     
      if(userId==1 && !detectado_user_1 && millis()/100>6){
        detectado_user_1 = true;
        altura_user_1 = convertedJoint.y;
      }
      else if(userId==2 && !detectado_user_2 && millis()/100>6){
        detectado_user_2 = true;
        altura_user_2 = convertedJoint2.y;
      }
      
      if  (detectado_user_2 && convertedJoint2.y>altura_user_2+75  && detectado_user_1 && convertedJoint.y>altura_user_1+75){
        myPort.write('w');
      }
      else if(userId ==1 && convertedJoint.y<=altura_user_1+75){
        myPort.write('o');
      }
      
      else if  (detectado_user_2 && convertedJoint2.y>altura_user_2+75 && userId ==2 ){
        myPort.write('d');
      }
      else if(userId ==2 && convertedJoint2.y<=altura_user_2+75){
        myPort.write('f');
      }
      else if  ( detectado_user_1 && convertedJoint.y>altura_user_1+75 && userId ==1){
         haBajado1 =true;
         myPort.write('a');
       }
   }
  else if (jointID ==SimpleOpenNI.SKEL_RIGHT_HAND){
      if(userId ==1){
        jointH = new PVector();
        confidence = context.getJointPositionSkeleton(userId, jointID, jointH);
        convertedJointH = new PVector();
        context.convertRealWorldToProjective(jointH, convertedJointH);
        ellipse(convertedJointH.x, convertedJointH.y, 20,20);  
      }
      else if (userId==2){
        jointH2 = new PVector();
        confidence = context.getJointPositionSkeleton(userId, jointID, jointH2);
        convertedJointH2 = new PVector();
        context.convertRealWorldToProjective(jointH2, convertedJointH2);
        ellipse(convertedJointH2.x, convertedJointH2.y, 20,20);  
        
      }
      
      if (((detectado_user_1 && convertedJointH.y<convertedJoint.y-20)|| (detectado_user_2 && convertedJointH2.y<convertedJoint2.y-20)) && !sonidoCogido){
        switch(int(round(r))){
           case 1:
             myPort.write('2');
             println("Cogido el bueno");
             break;
           case 2:
              myPort.write('1');
             println("Cogido el muy bueno");
             break;
           case 3:
             myPort.write('3');
             println("Cogido el malo");
             break;
        }
        sonidoCogido = true;
      }
      else{
        //println("no cogido");
      } 
         
   }
   

}

// user-tracking callbacks!
void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
  if(userId==1) detectado_user_1=false;
  if(userId==2) detectado_user_2=false;
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
 /*println("onVisibleUser - userId: " + userId);
  println("posicion actual= ",Float.toString(convertedJoint.y));
  println("posicion intermedia= ",Float.toString(convertedJoint.y +altura_user_1/2));*/

  
}
