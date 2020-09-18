import processing.sound.*;

// Stores rituals
Ritual[] rituals;

// Keeps track of current stage of the game
// 0 - Ritual selection
// 1 - Ready to flip coin
// 2 - Flipping coin
// 3 - Result of coin flip
// 4 - Determine how many guesses are correct
// 5 - Show user their performance and ask to play again

int stage;
boolean result;

// Counter for correct guesses
int correctCount;

// Enables fade
boolean fade = false;

// Frame timer for a couple acions
int timer;

// Current spin of the coin
float spin = PI/2;

// Sounds
SoundFile coinFlip;
SoundFile coinDrop;

void setup() {
  // 3D render
  size(1280, 720, P3D);

  // set starting stage
  stage = 0;

  // Initalize rituals
  rituals = new Ritual[4];
  rituals[0] = new Ritual(loadImage("catRed.png"), loadImage("catGreen.png"), new SoundFile(this, "meow.wav"));
  rituals[0].text = "Pet Black Cat";
  rituals[1] = new Ritual(loadImage("umbrellaRed.png"), loadImage("umbrellaGreen.png"), new SoundFile(this, "umbrella.wav"));
  rituals[1].text = "Open Umbrella Indoors";
  rituals[2] = new Ritual(loadImage("logRed.png"), loadImage("logGreen.png"), new SoundFile(this, "knock.wav"));
  rituals[2].text = "Knock on Wood";
  rituals[3] = new Ritual(loadImage("fingersRed.png"), loadImage("fingersGreen.png"), null);
  rituals[3].text = "Cross Your Fingers";

  // determine luck
  assignLuck();

  // coin sounds
  coinFlip = new SoundFile(this, "coin flip.wav");
  coinDrop = new SoundFile(this, "coin drop.wav");
}


void draw() {
  // if fade is enabled, do fade
  if (fade) {
    fill(0, 0, 0, 20);
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, height);
    timer++;
    if (timer >= 60) {
      fade = false;
      timer = 0;
    }
    // otherwise, proccess stage
  } else {
    switch(stage) {
    case 0:
      // draw rituals and buttons
      background(0);
      textAlign(CENTER, TOP);
      textSize(50);
      text("Choose your Rituals", width/2, 5);
      rituals[0].draw(width/4, height/4, 0.5);
      rituals[1].draw(3*width/4, height/4, 0.3);
      rituals[3].draw(width/4, 3*height/4, 0.3);
      rituals[2].draw(3*width/4, 3*height/4, 0.5);
      playButton();
      //grid();
      break;
    case 1:
      background(0);

      // draw back button
      pushMatrix();
      stroke(255);
      fill(0);
      strokeWeight(5);
      translate(50, 40);
      triangle(-20, 0, 10, 17, 10, -17);
      popMatrix();

      // draw coin
      lights();
      pushMatrix();
      translate(width/2, 2*height/3);
      rotateX(spin);
      strokeWeight(1);
      stroke(0);
      fill(#F0AA29);
      drawCoin(50, 50, 10);
      popMatrix();
      noLights();

      // slowly spin coin
      spin += 0.05;
      break;
    case 2:
      background(0);
      strokeWeight(1);
      stroke(0);

      // draw coin
      lights();
      pushMatrix();
      // move coin in arc
      translate(width/2, 2*height/3 - map(sin(radians(timer*2)), 0, 1, 0, height/3));
      rotateX(spin);
      fill(#F0AA29);
      drawCoin(50, 50, 10);
      popMatrix();
      noLights();

      // spin coin fast
      spin += 0.4;
      timer++;
      // after animation, fade to result
      if (timer > 90) {
        result = determineOutcome();
        stage = 3;
        timer = 0;
        coinDrop.play();
      }
      break;
    case 3:
      background(0);

      //draw back arrow
      pushMatrix();
      stroke(255);
      fill(0);
      strokeWeight(5);
      translate(50, 40);
      triangle(-20, 0, 10, 17, 10, -17);
      popMatrix();

      // spin the coin to show the correct result of the flip
      strokeWeight(1);
      stroke(0);
      if (result)
        spin = 1 + PI;
      else
        spin = 1;
      lights();

      // draw coin
      pushMatrix();
      translate(width/2, 2*height/3);
      rotateX(spin);
      fill(#F0AA29);
      drawCoin(50, 50, 10);
      popMatrix();

      noLights();
      break;
    case 4:
      //count correct guesses
      correctCount = 0;
      for (int i = 0; i < 4; i++) {
        if ((rituals[i].luck > 1 && rituals[i].active) || (rituals[i].luck < 1 && !rituals[i].active))
          correctCount++;
      }
      fade();
      stage = 5;
      break;
    case 5:
      background(0);
      textAlign(CENTER, BOTTOM);
      textSize(50);
      fill(255);
      // Tell user hw many were correct
      if (correctCount ==4) {
        text("You got them all correct.", width/2, height/2);
      } else {
        text("You got " + correctCount + " correct.", width/2, height/2);
      }

      // draw play again button
      stroke(255);
      strokeWeight(10);
      fill(0);
      rectMode(CENTER);
      rect(width/2, height/2 + 2*height/20, width/7, height/10, 20);
      textAlign(CENTER, CENTER);
      textSize(30);
      fill(255);
      text("Play Again?", width/2, height/2 + 2*height/20);
      break;
    }
  }
}

void mousePressed() {
  // disable input while fading
  if (!fade) {
    switch(stage) {
    case 0:
      // detect what object is pressed
      if (mouseX >= 6*width/32 && mouseX <= 10*width/32 && mouseY >= 2*height/18 && mouseY <= 8*height/18) // cat
        rituals[0].toggle();
      else if (mouseX >= 21*width/32 && mouseX <= 27*width/32 && mouseY >= 2*height/18 && mouseY <= 8*height/18) { // umbrella
        rituals[1].toggle();
      } else if (mouseX >= 6*width/32 && mouseX <= 10*width/32 && mouseY >= 11*height/18 && mouseY <= 17*height/18) { // fingers
        rituals[3].toggle();
      } else if (mouseX >= 21*width/32 && mouseX <= 27*width/32 && mouseY >= 11*height/18 && mouseY <= 17*height/18) { // wood
        rituals[2].toggle();
      } else if (mouseX >= width/2 - width/14 && mouseX <= width/2 + width/14 && mouseY >= height/2 - 3*height/20 && mouseY <= height/2 - height/20) { //play button
        fade();
        stage = 1;
      } else if (mouseX >= width/2 - width/14 && mouseX <= width/2 + width/14 && mouseY >= height/2 + height/20 && mouseY <= height/2 + 3*height/20) { // guess button
        stage = 4;
      }
      break;
    case 1:
      //check if back button is clicked, otherwise flip coin
      if (mouseX <= 70 && mouseY <= 70) {
        stage = 0;
        fade();
      } else {
        stage = 2;
        coinFlip.play();
      }
      break;
    case 3:
      //check if back button is clicked, otherwise flip coin again
      if (mouseX <= 70 && mouseY <= 70) {
        fade();
        stage = 0;
      } else {
        stage = 2;
        coinFlip.play();
      }
      break;
    case 5:
      //if  user clicks play again, reset game
      if (mouseX >= width/2 - width/14 && mouseX <= width/2 + width/14 && mouseY >= height/2 + height/20 && mouseY <= height/2 + 3*height/20) {
        stage = 0;
        assignLuck();
        fade();
        for (int i = 0; i < 4; i++) {
          rituals[i].active = false;
        }
      }
      break;
    }
  }
}
