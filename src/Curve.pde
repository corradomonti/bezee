// Bezee by Corrado Monti - released under GPL - see corradomonti.com
abstract class Curve {
  abstract void draw();
  
  abstract PVector getPoint(float t);
  
  abstract Point getFirstPoint();
  abstract Point getFirstControlPoint();
  abstract Point getLastPoint();
  abstract Point getLastControlPoint();
  
  abstract int getDepth();
  boolean isNotEmpty() { return true; }
  
  Curve getLastCurve() {return this; }
  Curve getPreviousCurve() {return new EmptyCurve(); }
  
  Curve add(Point p1, Point p2) {
    return new CompositeCurve(this, p1, p2);
  }
  
  Curve close() {
    return new CompositeCurve(this,
          new InversePoint(getFirstPoint(), getFirstControlPoint()),
          getFirstPoint());
  }
  
  abstract boolean checkPointsIfGrabbed();
  abstract void editPointsIfGrabbed(float x, float y);
  abstract void editPointsBy(float dx, float dy);
  abstract void ungrabPoints();
    
}
