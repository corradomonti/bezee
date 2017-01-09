// Bezee by Corrado Monti - released under GPL - see corradomonti.com
class InversePoint extends Point {
  Point p1, p2;
  
  InversePoint(Point a, Point b) { p1 = a; p2 = b; }
  
  /*PVector inversePoint(PVector p1, PVector p2) {
    return PVector.add(p1, PVector.sub(p1, p2 ) );
  }*/
  
  float x() { return p1.x() + (p1.x() - p2.x()); }
    
  float y() { return p1.y() + (p1.y() - p2.y()); }
  
}
