class Ritual {
  //Functions
  //Constructor
  Ritual(PImage deSel, PImage sel, SoundFile s) {
    deselected = deSel;
    selected = sel;
    sound = s;
    active = false;
    text = "";
  }

  // toggles the active property and plays the rituals sound
  void toggle() {
    active = !active;
    if (active && sound != null)
      sound.play();
  }

  //draws the ritual
  void draw(int x, int y, float scale) {
    pushMatrix();
    translate(x, y);
    scale(scale);
    imageMode(CENTER);
    int offset;
    //choose the correct image
    if (active) {
      image(selected, 0, 0);
      offset = selected.height / 2;
    } else {
      image(deselected, 0, 0);
      offset = selected.height / 2;
    } 
    popMatrix();
    textAlign(CENTER, TOP);
    // write ritual text
    textSize(20);
    text(text, x, y + (offset*scale));
  }


  // Members
  boolean active;
  float luck;
  PImage deselected;
  PImage selected;
  SoundFile sound;
  String text;
}
