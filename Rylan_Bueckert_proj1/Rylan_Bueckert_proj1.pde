////////////////////////////////////////////////////////////////////////
//
// Project #1
// Drawing Program
// Created by Rylan Bueckert
//
///////////////////////////////////////////////////////////////////////

void setup() {
  // Window is standard 16:9 720p
  size(1280, 720);
  // Sets color mode to HSB (Hue, Shade, Black)
  colorMode(HSB);
  // White Background
  background(255);
  // Set toolbar width to be 250 pixels
  toolWidth = 250;
}

// Flag to enable drawing
boolean draw = false;
// Keeps track of the drawing brush position
float posX, posY, pposX, pposY;
//movment speed of the brush
float speed = 100;
// Thickness of the brush
int brushSize = 1;
// Flag to enable bouncing off the edges
boolean bounce = false;
// hold the width of the toolbar
int toolWidth;
// direction of brush movment
float angle = 0;

void draw() {
  // redraw the toolbar
  drawToolbar();

  // Draw
  if (draw) {

    // if bounce mode is on, bounce on edges
    if (bounce) {
      if (posX < toolWidth || posX >width) {
        angle = -angle + PI;
      }    
      if (posY < 0 || posY > height)
        angle= -angle;
    } 
    //if bounce mode is off, stop drawing on edges
    else { 
      if (posX < toolWidth || posX >width || posY < 0 || posY > height)
        draw =false;
    }

    // sets the color hue relative to the speed
    stroke(map(speed, 1, 200, 170, 0), 255, 255);
    // sets the brush thickness
    strokeWeight(brushSize);
    // draw line
    line(posX, posY, pposX, pposY);
    //set ppos varibles to old pos values
    pposX=posX;
    pposY=posY;

    // Calculate new brush position from ange and speed using some trig
    posX=posX+cos(angle)*speed/2;
    posY=posY+sin(angle)*speed/2;
  }
}

// draws the toolbar
void drawToolbar() {
  // Create the toolbar
  //toolbar is black
  fill(0);
  //toolbar has no edges
  noStroke();
  // toolbar is rectangle on side of the screen
  rect(0, 0, toolWidth, height);

  // Brush preview

  // set color to white
  fill(255);
  noStroke();
  // backround for preview
  rect(10, 10, 110, 110);
  // sets the color hue relative to the speed
  stroke(map(speed, 1, 200, 170, 0), 255, 255);
  // set preview 
  strokeWeight(brushSize);
  //draw preview
  point(65, 65);

  // Direction

  // set color to white
  fill(255);
  noStroke();
  // backround for preview
  rect(130, 10, 110, 110);
  // sets the color hue relative to the speed
  fill(map(speed, 1, 200, 170, 0), 255, 255);

  //rotates an positions triangle for direction
  pushMatrix();
  translate(185, 65);
  rotate(angle);
  triangle(-20, -20, -20, 20, 35, 0);
  popMatrix();

  // background for bounce option
  fill(255);
  noStroke();
  rect(10, 130, 230, 110);

  // shows if bounce mode is on
  if (bounce) {
    noStroke();
    strokeWeight(2);
    fill(map(speed, 1, 200, 170, 0), 55, 255);
    ellipse(toolWidth/2 - 20, 185 - 20, 50, 50);
    fill(map(speed, 1, 200, 170, 0), 155, 255);
    ellipse(toolWidth/2, 185, 50, 50);
    fill(map(speed, 1, 200, 170, 0), 255, 255);
    stroke(0);
    ellipse(toolWidth/2 + 20, 185 + 20, 50, 50);
  }
}

void keyPressed() {
  switch(key) {
    // spacebar start or stop drawing
  case ' ':
    draw = !draw;
    break;
  case '+':
    // press + to increase thickness
    if (brushSize < 100)
      brushSize++;
    break;
    //press - to decrease thickness
  case '-':
    if (brushSize > 1)
      brushSize--;
    break;
    // press c to clear
  case 'c':
  case 'C':
    noStroke();
    fill(255);
    rect(toolWidth, 0, width-toolWidth, height);
    draw =false;
    break;
    // press b to toggle bounce
  case 'b':
  case 'B':
    bounce = !bounce;
    break;
    // press s to save
  case 's':
  case 'S':
    saveFrame();
    break;
  case CODED:
    switch(keyCode) {
      // press right arrow to turn right
    case RIGHT:
      angle = (angle + 0.1);
      if (angle >= 2*PI)
        angle-=2*PI;
      break;
      // press left arrow to turn left
    case LEFT:
      angle = (angle - 0.1);
      if (angle < 0)
        angle+=2*PI;
      break;
      // press up arrow to increase speed
    case UP:
      if (speed < 200)
        speed++;
      break;
      // press down arrow to decrease speed
    case DOWN:
      if (speed > 1)
        speed--;
      break;
    }
    break;
  }
}

void mousePressed() {
  //if mouse press on canvas
  if (mouseX > toolWidth) {
    // make pos the mose position to statr drawing from
    posX = pposX = mouseX;
    posY = pposY = mouseY;
    // enable drawing
    draw = true;
  } else {
  }
}
