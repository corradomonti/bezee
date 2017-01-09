// Bezee by Corrado Monti - released under GPL - see corradomonti.com
class SimpleCurve extends Curve {
  boolean DRAW_START = true, DRAW_POINTS = true;
  Point start, c1, c2, end;
  
  SimpleCurve(Point a, Point b, Point c, Point d) {
    start = a;
    c1 = b;
    c2 = c;
    end = d;
  }
  
  String toString() { return (start + " -> " + c1 + " -> " + c2 + " -> " + end); }
  
  Point getFirstPoint() { return start; }
  Point getFirstControlPoint() { return c1; }
  Point getLastPoint() { return end; }
  Point getLastControlPoint() { return c2; }
  
  int getDepth() { return 1; }
  
  void draw() {
    if (DRAW_START) {
      line(start.x()-5, start.y()-5, start.x()+5, start.y()+5);
      line(start.x()+5, start.y()-5, start.x()-5, start.y()+5);
    }
    if (DRAW_POINTS) {
      c1.draw();
      c2.draw();
    }
    bezier(start.x(), start.y(), c1.x(), c1.y(), c2.x(), c2.y(), end.x(), end.y());
  }
  
  PVector getPoint(float t) {
    t = t - floor(t);
    return new PVector(bezierPoint(start.x(), c1.x(), c2.x(), end.x(), t), 
                  bezierPoint(start.y(), c1.y(), c2.y(), end.y(), t));
  }
  
  PVector getTangent(float t) {
    PVector tangent = new PVector(bezierTangent(start.x(), c1.x(), c2.x(), end.x(), t), 
                  bezierTangent(start.y(), c1.y(), c2.y(), end.y(), t));
    
    float angle = atan2(tangent.y, tangent.x);
    angle += PI;
    
    return new PVector(cos(angle), sin(angle));
  }
  
  boolean checkPointsIfGrabbed() {
    return 
      start.isGrabbed() || c1.isGrabbed() || c2.isGrabbed() || end.isGrabbed();
  }
  
  void editPointsIfGrabbed(float x, float y) {
    start.editIfGrabbed(x,y);
    c1.editIfGrabbed(x,y);
    c2.editIfGrabbed(x,y);
    end.editIfGrabbed(x,y);
  }
  
  void editPointsBy(float dx, float dy) {
    start.editBy(dx,dy);
    c1.editBy(dx,dy);
    c2.editBy(dx,dy);
    end.editBy(dx,dy);
  }
  
  void ungrabPoints() {
    start.ungrab();
    c1.ungrab();
    c2.ungrab();
    end.ungrab();
  }
  
}
