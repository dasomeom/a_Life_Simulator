import controlP5.*;
import processing.core.PImage;
import java.util.Timer;
import java.util.TimerTask;

ControlP5 p5;
PImage bg;
int[][] arr = new int[100][100];
boolean mode = false, single = false, random = false, space = false, togg = false;
ArrayList<Integer> arri, arrj;
Toggle modes;
float lastcheck;
float timeinterval;

void setup() {
  size(1050, 850);
  //background(200, 200, 200);
  smooth();
  bg = loadImage("cells.jpg");
  p5 = new ControlP5(this); 
  //fill(0, 102, 153, 51);
  //rect(225, 25, 600, 600);
  //clear = p5.addToggle("clear")
  //  .setPosition(20, 100).setSize(50, 20);
  p5.addButton("clear")
    .setPosition(30, 100).setSize(150, 80)
    .setColorForeground(#acacea)
    .setColorBackground(#8080cd)
    .setColorActive(#484894)
    .activateBy((ControlP5.RELEASE));
  p5.addButton("randomize")
    .setPosition(30, 250).setSize(150, 80)
    .setColorForeground(#acacea)
    .setColorBackground(#8080cd)
    .setColorActive(#484894)
    .activateBy((ControlP5.RELEASE));
  modes = p5.addToggle("mode")
    .setPosition(30, 400).setSize(150, 80)
    .setColorForeground(#ebebfa)
    .setColorBackground(#8080cd)
    .setColorActive(#ebebfa)
    .setValue(false)
    .setMode(Toggle.SWITCH);
    
  for (int i=0; i<arr.length; i++){
    for (int j=0; j<arr.length; j++){
      arr[i][j] = 0;
    }
  }
  lastcheck = millis();
  timeinterval = 100;
}  

void draw() {
  image(bg, 0, 0);
  textSize(27);
  fill(0, 102, 153);
  text("A Life Simulator", 17, 50);
  text("Dasom Eom", 20, 750);
  text("CS 7492", 20, 800); 
  textSize(16);
  text("Single    Continuous", 28, 390);  
  for (int i=0; i<arr.length; i++){
    for (int j=0; j<arr.length; j++){
      fill(arr[i][j]);
      stroke(arr[i][j]);
      rect(230 + 8*j, 20 + 8*i, 6.9, 6.9);
    }
  }
  state();
  //println(modes.getValue());
  if (keyPressed) {
    if (key == 'c' || key == 'C') {
      clear();
    } else if ((key == 'r' || key == 'R') && !random) {
      randomize();
      random = true;
    } else if (key == ' ' && !space && modes.getValue() == 0.0) {
      println("Single step");
      space = true;
      mode();
    } else if ((key == 'g' || key == 'G') && !togg) {
      togg = true;
      if (modes.getValue() == 0.0) {
        modes.setValue(true);
      } else {
        modes.setValue(false);
      }
      
    }
  }
}

void state() {
  if (millis() > timeinterval + lastcheck) {
    lastcheck = millis();
    if (modes.getValue() == 1.0) {
      mode();
    }  
    random = false;
    space = false;
    togg = false;
    
  }
}

public void clear() {
  for (int i=0; i<arr.length; i++){
    for (int j=0; j<arr.length; j++){
      arr[i][j] = 0;
    }
  }
} 

public void randomize() {
  for (int i=0; i<arr.length; i++){
    for (int j=0; j<arr.length; j++){
      arr[i][j] = Math.random() < 0.5 ? 255 : 0;
    }
  }
} 


void mode() {
  int[][] temparr = new int[100][100];
  int[][] temparr2 = new int[100][100];
  arrayCopy(arr, temparr);
  for (int i=0; i<arr.length; i++){
    for (int j=0; j<arr.length; j++){  
      int count = 0;
      if(temparr[mod((i-1),100)][mod((j-1),100)] == 255){
        count++;
      }
      if(temparr[mod((i-1),100)][j] == 255){
        count++;
      }
      if(temparr[mod((i-1),100)][(j+1)%100] == 255){
        count++;
      }
      if(temparr[i][mod((j-1),100)] == 255){
        count++;
      }
      if(temparr[i][(j+1)%100] == 255){
        count++;
      }
      if(temparr[(i+1)%100][mod((j-1),100)] == 255){
        count++;
      }
      if(temparr[(i+1)%100][j] == 255){
        count++;
      }
      if(temparr[(i+1)%100][(j+1)%100] == 255){
        count++;
      } 
      
      
      if (temparr[i][j] == 255) {
        println(count);
        if (!(count == 2 || count == 3)) {
          temparr2[i][j] = 0;
        } else {
          temparr2[i][j] = 255;
        }
      } else {
        if (count == 3) {
          temparr2[i][j] = 255;
        } else {
          temparr2[i][j] = 0;
        }           
      }
      
    }
  }
  arr = temparr2;
  
}


private static int mod(int index, int modulo) {
  if (modulo <= 0) {
      throw new IllegalArgumentException("The modulo must be positive.");
  } else {
      int newIndex = index % modulo;
      return newIndex >= 0 ? newIndex : newIndex + modulo;
  }
}

void mousePressed() {
  if (mouseX > 230 && (mouseX-230)/8 < 100 && mouseY >22 && (mouseY-23)/8 < 100) {
    int x = (mouseX - 231)/8;
    int y = (mouseY - 23)/8;
    if ((x == 0 && (mouseX-231) <= 6.9) || (x > 0 && (mouseX-231) <=(x) * 8 + 6.9  ) ) {
      if ((y == 0 && (mouseY-23) <= 6.9) || (y > 0 && (mouseY-23) <=(y) * 8 + 6.9  ) ) {
        arr[y][x] = (arr[y][x] == 0 ? 255 : 0);    
      }
    }
  }
}
