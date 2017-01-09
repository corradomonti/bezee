// Bezee by Corrado Monti - released under GPL - see corradomonti.com
class BezeePlayer {
  Curve curves, tempCurve;
  List<Box> boxes;
  boolean boxesArePauses, isPlaying, playingOnThirds = false;
  int step, stepsPerCurve, framePerNote, totSteps;
  float phase = 0;


  BezeePlayer() {
    boxesArePauses = true;
    isPlaying = true;
    curves = new EmptyCurve();
    boxes = new ArrayList<Box>();
    updateAllTimes();
  }
  
  void deleteAllBoxesAndCurves() {
    curves = new EmptyCurve();
    boxes = new ArrayList<Box>();
  }
  
  void draw() {  
      //draw boxes 
      color boxColor =
          (deleteBoxes ?
              #FF0000
           :
              (boxesArePauses ? #888888 : #0000FF ) 
           );
      for (Box b : boxes)
        b.draw(boxColor);
      
      //draw curves
      noFill();
      if (boxesArePauses)
        stroke(0, 255, 255, 200);
      else
        stroke(255, 255, 255, 200);
      curves.draw();
  }
  
  void drawPreviewOfNewCurve(Point openPoint) {
      stroke(255, 0, 0);
      noFill();
      if (!curves.isNotEmpty())
          openPoint.draw();
      else {
        tempCurve = curves.add(openPoint, new SimplePoint(mouseX, mouseY));
        tempCurve.getLastCurve().draw();
      }
  }
  
  void drawPreviewOfNewBox(Point openPoint) {
      if (boxesArePauses)
          stroke(128,128,128);
        else
          stroke(0, 0, 255);
      noFill();
      rect(openPoint.x(), openPoint.y(), mouseX - openPoint.x(), mouseY - openPoint.y());
    }
    
    
  void drawPointAndPlay(Grid g)  {
    if (isPlaying)
        step = (step + 1) % totSteps;
        
    //println(step + " / " + totSteps + " >>> " + framePerNote);
    
    if (curves.isNotEmpty()) {    
        PVector p = curves.getPoint( (phase + ((float) step / (float) totSteps) ) % 1);
        boolean isTimeForPlaying = (step % framePerNote == 0);
        
        //draw point p
        stroke(255, 255, 255);
        if (isTimeForPlaying)
          fill(255, 255, 0, 255);
        else
          fill(0, 255, 0, 128);
        ellipse(p.x, p.y, 20, 20);
        
        if (isTimeForPlaying && isPlaying) {
          boolean aBoxIsActive = false;
          for (Box b : boxes)
            aBoxIsActive = aBoxIsActive || b.isActive(p);
              
          if ( (aBoxIsActive && !boxesArePauses) || (boxesArePauses && !aBoxIsActive) )
              playNote(g.getPan(p), g.getNote(p));
        }
    }
  }
  
  void editPointsIfGrabbed(float x, float y) { curves.editPointsIfGrabbed(x,y);        }
  boolean checkPointsIfGrabbed()             { return curves.checkPointsIfGrabbed();   }
  void ungrabPoints()                        { curves.ungrabPoints();                  }
  
  //return true if it has deleted the last box, false else
  boolean deleteBox(float x, float y) {
    PVector p = new PVector(x,y);
    for (Box b : boxes)
        if (b.isActive(p)) {
          boxes.remove(b);
          if (boxes.size() == 0) 
            return true;
          break;
        }
    return false;
  }
  
  void closeLastCurve() {
    if (curves.isNotEmpty()) {
      curves = curves.close();
      updateTotSteps();
    }
  }
  
  void addCurve(PVector p1, PVector p2) {
    addCurve(new SimplePoint(p1), new SimplePoint(p2));
  }
  
  void addCurve(Point p1, Point p2) {
    curves = curves.add(p1, p2);
    updateTotSteps();
  }
  
  boolean hasNoBoxes() { return boxes.size() == 0; }
  
  void addBox(PVector p1, PVector p2) {
    boxes.add( new Box(p1, p2) );
  }
  
  boolean hasNoCurves() { return !curves.isNotEmpty(); }
  
  void undoLastCurve() {
      curves = curves.getPreviousCurve();
      updateTotSteps();
  }
  
  void moveBy(PVector movement) {
        curves.editPointsBy(movement.x, movement.y);
        for (Box b : boxes)
            b.editBy(movement);
  }
  
  float getCurrentPosition() { return ((float) step/totSteps); }
  
  int getCurvesNumber() { return curves.getDepth(); }

  void updateTotSteps() { totSteps = stepsPerCurve * max(1, curves.getDepth()); }
  
  void updateNoteInterval() {
    setFramePerBeat( (notePerBar % 3 == 0) ? 24 : 8);
    framePerNote = 4 * framePerBeat / notePerBar;
  }
  
  void updateAllTimes() {
    stepsPerCurve = (framePerBeat*4) / curvePerBar;
    updateNoteInterval();
    updateTotSteps();
    step = 0;
  }
  
  void switchBoxesMeaning() {
    boxesArePauses = !boxesArePauses;
  }
  
  void invertPauseStatus() {
    isPlaying = !isPlaying;
  }
  
  void playFromPosition(float t) {
    step = (int) (t * totSteps);
    frameCount = 0;
    isPlaying = true;
  }
  
  void setPhase(float value) {
    phase = value;
  }
  
}
