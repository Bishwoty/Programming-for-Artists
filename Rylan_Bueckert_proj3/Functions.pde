// sets up varables for fading
void fade() {
  fade = true;
  timer = 0;
}

//draws buttons for stage 0
void playButton() {
  stroke(255);
  strokeWeight(10);
  fill(0);
  rectMode(CENTER);
  rect(width/2, height/2 - 2*height/20, width/7, height/10, 20);
  textAlign(CENTER, CENTER);
  textSize(35);
  fill(255);
  text("Play", width/2, height/2 - 2*height/20);

  stroke(255);
  strokeWeight(10);
  fill(0);
  rectMode(CENTER);
  rect(width/2, height/2 + 2*height/20, width/7, height/10, 20);
  textAlign(CENTER, CENTER);
  textSize(35);
  fill(255);
  text("Guess", width/2, height/2 + 2*height/20);
}

// gives random luck values for all the rituals
void assignLuck() {
  for (int i = 0; i < 4; i++) {
    if (random(0, 1) < 0.5) {
      //Unlucky
      rituals[i].luck = 0.85;
      print(0);
    } else {
      print(1);
      //Lucky
      rituals[i].luck = 1.15;
    }
  }
  print('\n');
}

// debugging grid (disabled)
void grid() {
  stroke(255);
  for (int i = 0; i < width; i += width/32) {
    line(i, 0, i, height);
  }
  for (int i = 0; i < height; i += height/18) {
    line(0, i, width, i);
  }
}

// does a coin flip
boolean determineOutcome() {
  float combinedLuck = 1;
  for (int i = 0; i < 4; i++) {
    //apply luck if acive
    if (rituals[i].active)
      combinedLuck = combinedLuck * rituals[i].luck;
  }
  float coinResult = random(1);
  print(coinResult);
  print('\n');
  // make luck influence result
  return coinResult > 0.5/combinedLuck;
}

// creates a coin
void drawCoin( int sides, float r, float h)
{
  float angle = 2*PI / sides;
  float halfHeight = h / 2;

  // draw top of the tube
  fill(#F0AA29);
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos(i * angle) * r;
    float y = sin(i * angle) * r;
    vertex( x, y, -halfHeight);
  }
  endShape(CLOSE);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(30);
  pushMatrix();
  rotate(PI);
  text("W", 0, 0, -halfHeight-1);
  popMatrix();

  // draw bottom of the tube
  fill(#F0AA29);
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos(i * angle) * r;
    float y = sin(i * angle) * r;
    vertex( x, y, halfHeight);
  }
  endShape(CLOSE);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(30);
  text("L", 0, 0, halfHeight+1);

  // draw sides
  fill(#F0AA29);
  beginShape(QUAD_STRIP);
  for (int i = 0; i < sides + 1; i++) {
    float x = cos(i * angle) * r;
    float y = sin(i * angle) * r;
    vertex( x, y, halfHeight);
    vertex( x, y, -halfHeight);
  }
  endShape(CLOSE);
}
