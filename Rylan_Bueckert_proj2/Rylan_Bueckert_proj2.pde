import processing.sound.*;

// Rylan Bueckert


// Timings
float titleEnd = 5000; // 5000
float PlanetEnd = 18700; //13700
float fadeEnd = 20400; // 1700
float explodeEnd = 24900; // 4500
float SmearEnd = 42700; // 17800
float RippleEnd = 49700; // 7000


// sun
Planet sun = new Planet(150, 0, 1, color(230, 25, 25));

// smear
Planet smearCentre = new Planet(1, 0, 1, color(0));

// ripple
ripple rip1 = new ripple(10, 255);
ripple rip2 = new ripple(11, 0);
ripple rip3 = new ripple(10, 255);
ripple rip4 = new ripple(11, 0);
ripple rip5 = new ripple(10, 255);
ripple rip6 = new ripple(11, 0);

// explode
explode ex;

//Credits
float creditsPos = 0;

float planetZoom = 0.05;
float smearZoom = 8.0;
float time;
float offset;
PFont font;

// Sounds
SoundFile drip;
SoundFile explosion;
SoundFile pulse;
SoundFile ambient;

boolean playedDrip = false;
boolean playedExplosion = false;
boolean playedPulse = false;
boolean playedAmbient = false;


void setup() {
  size(1920, 1080);

  // Font
  font = createFont("Times New Roman", 300);

  // Sounds
  drip = new SoundFile(this, "drip.wav");
  drip.cue(0.7);

  explosion = new SoundFile(this, "distant-explosion.mp3");

  pulse = new SoundFile(this, "pulse.wav");

  ambient = new SoundFile(this, "ambient.wav");
  ambient.amp(0.5);

  createPlanets();
  setupSmear();
  // explosion has 1000 particles
  ex = new explode(1000);
  background(0);
  //time it takes to setup
  offset = millis();
}

void draw() {
  // subtract offset so timings arn't messed up
  time = millis() - offset;

  //Make the correct scenes play at different times
  if (time < titleEnd) {
    title();
  } else if (time < PlanetEnd)
    planetScene();
  else if (time < PlanetEnd + 1700)
    fade();
  else if (time < explodeEnd)
    explodeScene();
  else if (time < SmearEnd)
    smearScene();
  else if (time < RippleEnd)
    rippleScene();
  else if (time > RippleEnd + 1500)
    credits();

  if (time > 58000)
    resetAnimation();
}

// Title Scene
void title() {
  textAlign(CENTER);
  textFont(font);
  fill(255);
  textSize(300);
  text("Orbits", width/2, height/2);
}

void planetScene() {
  if (!playedAmbient) {
    ambient.play();
    playedAmbient = true;
  }


  // Zoom in
  planetZoom/=0.99;
  noStroke();
  background(0);
  pushMatrix();
  // Move to centre of screen
  translate(width/2, height/2);
  // Set the zoom
  scale(planetZoom);
  // Center in on the position of "Earth"
  translate(-sun.moons.get(2).distance * cos(sun.moons.get(2).angle), -sun.moons.get(2).distance * sin(sun.moons.get(2).angle));
  // Draw the system
  sun.draw(false);
  popMatrix();
}

void explodeScene() {
  background(0);
  noStroke();
  if (!playedExplosion) {
    explosion.play();
    playedExplosion = true;
  }
  ex.draw();
}

void smearScene() {

  if (!playedPulse) {
    pulse.play();
    playedPulse = true;
  }

  // Zoom out
  smearZoom*=0.994;
  noStroke();
  fill(0, 0, 0, 7);
  // Leave fading trails
  rect(0, 0, width, height);
  pushMatrix();
  // Move to centre of screen
  translate(width/2, height/2);
  // set zoom
  scale(smearZoom);
  // draw
  smearCentre.draw(true);
  popMatrix();
}


void rippleScene() {
  pushMatrix();
  //move to centre of screen
  translate(width/2, height/2);

  // drip sound
  if (!playedDrip) {
    drip.play();
    playedDrip = true;
  }

  // fade the sound so you cant hear the cutoff
  if (time > RippleEnd - 2500 && drip.isPlaying())
    drip.amp(map(time, RippleEnd - 2500, RippleEnd - 1900, 1, 0));

  if (time > RippleEnd - 1900 && drip.isPlaying())
    drip.stop();

  // only draw ripples at specific times
  if (time > RippleEnd - 7000)
    rip1.draw();
  if (time > RippleEnd - 6750)
    rip2.draw();
  if (time > RippleEnd - 6000)
    rip3.draw();
  if (time > RippleEnd - 5750)
    rip4.draw();
  if (time > RippleEnd - 5000)
    rip5.draw();
  if (time > RippleEnd - 4750)
    rip6.draw();
  popMatrix();
}

// fade to black
void fade() {
  fill(0, 0, 0, 10);
  rect(0, 0, width, height);
}

// end credits
void credits() {
  background(0);
  textAlign(CENTER, TOP);
  textFont(font);
  fill(255);
  textSize(45);
  String endCredits = "Made by Rylan Bueckert\n\nNew Media 3380 - Programming for Artists\n\nSounds from freesound.org";
  pushMatrix();
  translate(0, -creditsPos);
  text(endCredits, width/2, height);
  popMatrix();
  creditsPos+=5;
}

void createPlanets() {
  // Planets
  // add Mercury
  sun.addMoon(10, 390/2, 2.4, color(175));
  // add Venus
  sun.addMoon(28, 723/2, 6.66, color(200, 200, 0));
  // add Earth
  sun.addMoon(30, 500, 10, color(0, 0, 255));
  // add green section to Earth
  sun.addMoon(15, 500, 10, color(0, 255, 0));
  // make sure green part is lined up with Earth
  sun.moons.get(3).angle = sun.moons.get(2).angle;
  // add Mars
  sun.addMoon(20, 1524/2, 18.82, color(255, 0, 0));
  //add Jupiter
  sun.addMoon(70, 5200/2, 120, color(#ED9E37));
  //add Saturn
  sun.addMoon(75, 9000/2, 290, color(#F2D3AB));

  // Moons
  // add the moon to orbit Earth
  sun.moons.get(2).addMoon(5, 35, 0.83, color(230));
}

void setupSmear() {
  // Primary
  smearCentre.addMoon(75, 250, 20, color(255, 0, 0), 0);
  smearCentre.addMoon(75, 250, 20, color(255, 255, 0), 2*PI /3);
  smearCentre.addMoon(75, 250, 20, color(0, 0, 255), 4*PI /3);


  // Secondary (orbit the primaries)
  smearCentre.moons.get(0).addMoon(10, 50, 1, color(255, 125, 0), 0);
  smearCentre.moons.get(0).addMoon(10, 50, 1, color(150, 0, 255), PI);

  smearCentre.moons.get(1).addMoon(10, 50, 1, color(255, 125, 0), 0);
  smearCentre.moons.get(1).addMoon(10, 50, 1, color(0, 255, 0), PI);

  smearCentre.moons.get(2).addMoon(10, 50, 1, color(0, 255, 0), 0);
  smearCentre.moons.get(2).addMoon(10, 50, 1, color(150, 0, 255), PI);
}

void resetAnimation() {
  // sun
  sun = new Planet(150, 0, 1, color(230, 25, 25));
  createPlanets();

  // smear
  smearCentre = new Planet(1, 0, 1, color(0));
  setupSmear();

  // ripple
  rip1 = new ripple(10, 255);
  rip2 = new ripple(11, 0);
  rip3 = new ripple(10, 255);
  rip4 = new ripple(11, 0);
  rip5 = new ripple(10, 255);
  rip6 = new ripple(11, 0);

  // explode
  ex = new explode(1000);

  //Credits
  creditsPos = 0;

  planetZoom = 0.05;
  smearZoom = 8.0;

  // Sounds
  playedDrip = false;
  drip.amp(1);
  playedExplosion = false;
  playedPulse = false;
  playedAmbient = false;

  background(0);
  offset = millis();
}
