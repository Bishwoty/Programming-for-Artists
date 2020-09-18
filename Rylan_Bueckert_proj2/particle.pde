// A simple Particle class
// Modified version of particle class found here:
// https://processing.org/examples/simpleparticlesystem.html

class particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

// Constructor
  particle(PVector l) {
    float angle = random(0, 2*PI);
    float speed = random(0, 50);
    velocity = new PVector(speed*cos(angle), speed*sin(angle));
    acceleration = velocity.copy();
    acceleration.mult(-0.001);
    position = l.copy();
    lifespan = 255.0;
  }

// draw and update
  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    fill(255, lifespan);
    circle(position.x, position.y, 20);
  }
}
