// Bezee by Corrado Monti - released under GPL - see corradomonti.com
class SimplePoint extends Point {
  float x;
  float y;
  
  boolean grabbed = false;
  
  SimplePoint(PVector p)        {this.x = p.x; this.y = p.y; }
  SimplePoint(float x, float y) {this.x = x;   this.y = y;   }
  
  float x() {return x;}
  float y() {return y;}
  
  void draw() {
    ellipse(x, y, 5, 5);
  }
  
  boolean isGrabbed() {
    if (mouseX <= x+5 && mouseX >= x-5 && mouseY <= y+5 && mouseY >= y-5)
        grabbed = true;
    return grabbed;
  }
  
  void ungrab() { grabbed = false; }
  
  void editIfGrabbed(float newX, float newY) {
    if (grabbed) {
      x = newX;
      y = newY;
    }
  }
  
  void editBy(float dx, float dy) {
    x+=dx;
    y+=dy;
  }
  
  
}
