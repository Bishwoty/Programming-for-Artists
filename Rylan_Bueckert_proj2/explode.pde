class explode {
  // Constructor
  explode(int particles) {
    for (int i = 0; i < particles; i++) {
      bits.add(new particle(new PVector(width/2,height/2)));
    }
  }
  // draw and proccess all the particles
  void draw() {
    for (int i = 0; i < bits.size(); i++) {
      bits.get(i).run();
    }
  }
  
  // Holds the paricles
   ArrayList<particle> bits = new ArrayList<particle>();
}
