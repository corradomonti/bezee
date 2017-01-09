// Bezee by Corrado Monti - released under GPL - see corradomonti.com
class EmptyCurve extends Curve {
  List<Point> p = new ArrayList<Point>();
  
  EmptyCurve() { }
  
  Point getFirstControlPoint() { throw new NoSuchElementException("Not defined yet."); }
  Point getFirstPoint()        { throw new NoSuchElementException("Not defined yet."); }
  Point getLastControlPoint()  { throw new NoSuchElementException("Not defined yet."); }
  Point getLastPoint()         { throw new NoSuchElementException("Not defined yet."); }
  
  PVector getPoint(float t)    { throw new NoSuchElementException("Not defined yet."); }
  
  int getDepth() {return 0;}
  boolean isNotEmpty() { return false; }
  
  void draw() {
    for (Point ppoint : p)
      ellipse(ppoint.x(), ppoint.y(), 15, 15);
  }
  
  Curve add(Point newP) {
    p.add(newP);
    if (p.size() > 3)
      return new SimpleCurve(p.get(0), p.get(1), p.get(2), p.get(3));
    else
      return this;
  }
  
  Curve add(Point p1, Point p2) {
    p.add(p1);
    return add(p2);
  }
  
  boolean checkPointsIfGrabbed() {
    for (Point ppoint : p)
      if (ppoint.isGrabbed())
        return true;
    return false;
  }
  
  void editPointsIfGrabbed(float x, float y) {
    for (Point ppoint : p)
      ppoint.editIfGrabbed(x,y);
  }
  
  void editPointsBy(float dx, float dy) {
    for (Point ppoint : p)
      ppoint.editBy(dx,dy);
  }
  
  void ungrabPoints() {
    for (Point ppoint : p)
      ppoint.ungrab();
  }
  
  
}
