class ripple {
  // constructor
  ripple(float spreadRate, color ripCol) {
  radius = 0;
  rate = spreadRate;
  rippleColor = ripCol;
  }
  
  // draw and tick the ripple
  void draw() {
    // set color
    fill(rippleColor);
    // create circle
    circle(0,0,radius);
    // increse the radius by rate
    radius+=rate;
  }
  
  // color of ripple
  color rippleColor;
  // current size of ripple
  float radius;
  // size increase rate
  float rate;
}
