/*
 * You also need the arduino sketch for this to work, it´s fairly easy, just send the data as one string (S000E, S001E, S010E, S011E, S100E, S101E, S110E, S111E) 
 * this code here will then recognize and print out the rest and you can do the rest of your stuff
 *
 * 50cm Abstand: 0; dann in 1m Schritten weiter
 */

import processing.serial.*;

Serial myPort;
String portStream;

IntList graph = new IntList();
IntList graphToDraw = new IntList();
IntList accuracy = new IntList();

int b1 = 0;
int dist = 0;

boolean countdown = true;
boolean drawGraph = false;


void setup() {

  graph.clear();

  size(1880, 1040);
  background(255);
  noStroke();
  strokeWeight(2);
  fill(50);
  try {
    myPort = new Serial(this, Serial.list()[0], 115200);
    myPort.bufferUntil('\n');
  }
  catch(Exception e) {
    println("Wrong Serial Port");
  }
  printCoordinateSystem();
  drawStaticSineWave();

  println("Init done");
}

void draw() {
  startScreen();
  if(button() > 0){
    drawGraph = true;
    println("Lets go");
  }
  us();
}

void startScreen(){
  fill(255, 0, 0);
}

int button() {
  if(portStream != null){
    if (portStream.length() == 8 && portStream.charAt(0) == 'S' &&
      portStream.charAt(5) == 'E'){
        return int(portStream.substring(1, 2));
      }
  }
  return 0;
}

void us() {
  if (portStream != null && drawGraph) {
    if (portStream.length() == 8 && portStream.charAt(0) == 'S' &&
      portStream.charAt(5) == 'E') {
      dist = int(portStream.substring(2, 5));

      graph.append(dist);
      printArray(graph);
      
      if(countdown){
        drawCountdown();
      }
      
      if (graph.size() > 1679) {
        countdown = true;
        drawGraph = false;
        return;
      }
      printCoordinateSystem();
      drawStaticSineWave();
      beginShape();
      stroke(0);
      noFill();
      for (int i = 0; i < graph.size()-1; i++) {
        vertex(i + 80, 960 - graph.get(i)*1.747);
      }
      endShape();
    }
  }
}

void printCoordinateSystem() {
  fill(255);
  rect(0, 0, 1880, 1040);
  stroke(0);
  strokeWeight(4);
  line(80, 80, 80, 960);//y line
  line(80, 960, 1760, 960); //x line
  line(70, 90, 80, 80);//y line arrow left side
  line(90, 90, 80, 80);//y line arrow
  line(1750, 950, 1760, 960);//x line arrow top side
  line(1750, 970, 1760, 960);//x line arrow
  textSize(30);
  fill(0);
  text("Zeit", 1750, 1018);
  text("4 -", 35, 150);//Maximum
  text("3 -", 35, 355);
  text("2 -", 35, 560);
  text("1 -", 35, 755);
  text("0 -", 35, 970);//Ursprung
  
  //drawStaticSineWave();
}

void drawStaticSineWave() {
  noFill();
  beginShape();
  stroke(255, 0, 0);
  for (int i = 0; i < 1680; i++) {
    curveVertex(80 + i, f(i));
    graphToDraw.append(int(f(i)));
  }
  endShape();
}

void drawCountdown(){
  
}

float f(int x){
  return -410 * sin(x/(57* PI)) + 550;
}

void serialEvent(Serial myPort) {
  portStream = myPort.readString();
}
