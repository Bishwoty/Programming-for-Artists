class Planet {
  // Constructor (set variables)
  Planet(float pRadius, float pDistance, float pPeriod, color pColor) {
    radius = pRadius;
    distance = pDistance;
    period = pPeriod;
    planetColor = pColor;
    //starting angle is random
    angle = random(6);
  }

  // Alternate Constructor for setting the starting angle
  Planet(float pRadius, float pDistance, float pPeriod, color pColor, float pAngle) {
    radius = pRadius;
    distance = pDistance;
    period = pPeriod;
    planetColor = pColor;
    angle = pAngle;
  }

  // change the angle
  void orbit(float changeInAngle) {
    angle += changeInAngle;
    // ensure angle is always between 0 and 2 Pi
    while (angle >= 2*PI)
      angle -= 2*PI;
    while (angle < 0) {
      angle += 2*PI;
    }
  }

  //add an orbiting object to the planet
  void addMoon(float mRadius, float mDistance, float mPeriod, color mColor) {
    moons.add(new Planet(mRadius, mDistance, mPeriod, mColor));
  }

  //add an orbiting object to the planet with a set starting angle
  void addMoon(float mRadius, float mDistance, float mPeriod, color mColor, float mAngle) {
    moons.add(new Planet(mRadius, mDistance, mPeriod, mColor, mAngle));
  }

  // draw planet, then recursivly draw all the things orbiting it
  void draw(boolean reverse) {
    // if you want it to orbit in reverse 
    if (reverse)
      this.orbit(-(1/(period*60))*2*PI);
    // normal orbit
    else
      this.orbit((1/(period*60))*2*PI);
    //select color
    fill(planetColor);
    //create circle
    circle(0, 0, radius);
    //for all moons of the planet
    for (int i = 0; i < moons.size(); i++) {
      pushMatrix();
      // rotate to correct position
      rotate(moons.get(i).angle);
      // move to orbital distance
      translate(moons.get(i).distance, 0);
      // draw moon
      moons.get(i).draw(reverse);
      popMatrix();
    }
  }
  
  // size of planet
  float radius;
  //distance of planet
  float distance;
  // time to do an orbit
  float period;
  // current orbit position
  float angle;
  // color of planet
  color planetColor;
  // list of moons
  ArrayList<Planet> moons = new ArrayList<Planet>();
}
