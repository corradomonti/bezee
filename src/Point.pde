// Bezee by Corrado Monti - released under GPL - see corradomonti.com
abstract class Point {
  abstract float x();
  abstract float y();
  
  void draw() { }
  
  boolean isGrabbed() { return false; }
  void ungrab() { }
  
  void editIfGrabbed(float newX, float newY) { }
  void editBy(float dx, float dy) { }
  
  String toString() {
    return "[" + x() + "," + y() + "]";
  }
  
  PVector toVector() {
    return new PVector(x(), y());
  }
}
