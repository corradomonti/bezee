// Bezee by Corrado Monti - released under GPL - see corradomonti.com
class Box {
  PVector p1, p2, delta;
  float opacity = 20;
  
  Box(PVector a, PVector b) {
    p1 = new PVector(min(a.x, b.x), min(a.y, b.y));
    p2 = new PVector(max(a.x, b.x), max(a.y, b.y));
    delta = PVector.sub(p2, p1);
  }
  
  void draw(color col) {
    if (deleteBoxes) //changes opacity if it is active for the mouse
      this.isActive(new PVector(mouseX, mouseY));
      
    fill(col, opacity);
    noStroke();
    rect(p1.x, p1.y, delta.x, delta.y);
  }
  
  boolean isActive(PVector p) {
    boolean result = (p.x > p1.x && p.x < p2.x && p.y > p1.y && p.y < p2.y);
    opacity = result ? 128 : 20;
    return result;
  }
  
  void editBy(PVector move) {
    p1.add(move);
    p2.add(move);
  }
  
  
  
  
}
