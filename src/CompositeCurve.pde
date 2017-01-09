// Bezee by Corrado Monti - released under GPL - see corradomonti.com
class CompositeCurve extends Curve {
  Curve c1;
  SimpleCurve c2;
  
  private int depth = -1;
  
  CompositeCurve(Curve c, Point p1, Point p2) {
    this.c1 = c;
    this.c2 = new SimpleCurve(c.getLastPoint(),
                        new InversePoint(c.getLastPoint(), c.getLastControlPoint()),
                        p1, p2);
  }
  
  Point getFirstPoint()          { return c1.getFirstPoint();        }
  Point getFirstControlPoint()   { return c1.getFirstControlPoint(); }
  Point getLastPoint()           { return c2.getLastPoint();         }
  Point getLastControlPoint()    { return c2.getLastControlPoint();  }
  Curve getLastCurve()           { return c2; }
  Curve getPreviousCurve()       { return c1; }
  
  int getDepth() {
    if (depth == -1)
      depth = (c1.getDepth() + 1);
    return depth;
  }
  
  void draw() {
    c1.draw();
    c2.draw();
  }
  
  PVector getPoint(float t)   {
    float t2;
    float lastPart = 1.0 / (float) getDepth();
    float threshold = (1.0 - lastPart);
    
    if (t < threshold)
      return c1.getPoint(t/threshold);
      else
      return c2.getPoint(t*getDepth());
  }
  
  boolean checkPointsIfGrabbed() {
    return c2.checkPointsIfGrabbed() || c1.checkPointsIfGrabbed();
  }
  
  void editPointsIfGrabbed(float x, float y) {
    c1.editPointsIfGrabbed(x,y);
    c2.editPointsIfGrabbed(x,y);
  }
  
  void editPointsBy(float dx, float dy) {
    c1.editPointsBy(dx,dy);
    c2.getLastControlPoint().editBy(dx, dy);
    if (c2.getLastPoint() != c1.getFirstPoint())
        c2.getLastPoint().editBy(dx,dy);
  }
  
  void ungrabPoints() {
    c1.ungrabPoints();
    c2.ungrabPoints();
  }
      
  
}
