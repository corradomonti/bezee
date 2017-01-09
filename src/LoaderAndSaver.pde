// Bezee by Corrado Monti - released under GPL - see corradomonti.com
static class LoaderAndSaver {
  static final String COUPLE_SEPARATOR = "\n", POINT_SEPARATOR = " : ";
  static void save(BezeePlayer player, ControlPanel panel, String filePath) {
    println("Saving the score to " + filePath + "...");
    
    Properties data = new Properties();
    data.setProperty("Curves", savePointsOfCurves(player.curves));
    data.setProperty("Boxes", savePointsOfBoxes(player.boxes));
    data.setProperty("Play within boxes", ""+!player.boxesArePauses);
    
    println("Curves and boxes evaluated, evaluating controls...");
    for (SavableControl c : panel.getAllSavableControls())
      data.setProperty(c.getName(), c.getValue());
    
    println("Saving to disk...");
    try {
      data.storeToXML(new FileOutputStream(filePath), "Created in Bezee by Corrado Monti - http://www.corradomonti.com");
    } catch (Exception e) { throw new RuntimeException(e); }
    
    println("Saved.");
  }
  
  static void load(BezeePlayer player, ControlPanel panel, String filePath) {
    println("Loading score from " + filePath + "...");
    Properties data = new Properties();
    try {
      data.loadFromXML(new FileInputStream(filePath));
    } catch (Exception e) { throw new RuntimeException(e); }
    
    println("File correctly read...");
    player.deleteAllBoxesAndCurves();
    loadPointsOfCurves(data.getProperty("Curves"), player);
    loadPointsOfBoxes(data.getProperty("Boxes"), player);
    player.boxesArePauses = !Boolean.parseBoolean(data.getProperty("Play within boxes"));
    
    println("Curves and boxes parsed, parsing controls...");
    for (SavableControl c : panel.getAllSavableControls())
      c.setValue(data.getProperty(c.getName()));
      
    println("Loaded.");
  }
  
  static String savePointsOfCurves(Curve curve) {
    String s = "";
    if (curve.isNotEmpty()) {
        Point[] p = new Point[2 + curve.getDepth()*2];
        p[0] = curve.getFirstPoint();
        p[1] = curve.getFirstControlPoint();
        
        int i = p.length;
        while (curve.isNotEmpty()) {
          i--;
          p[i] = curve.getLastPoint();
          i--;
          p[i] = curve.getLastControlPoint();
          curve = curve.getPreviousCurve();
        }
        
        if (i != 2) throw new RuntimeException("Value " + i + " not expected");
        
        for (i = 0; i < p.length; i+=2)
          s+=savePoint(p[i]) + POINT_SEPARATOR + savePoint(p[i+1]) + COUPLE_SEPARATOR;
    }
    return s;
  }
  
  static String savePointsOfBoxes(List<Box> boxes) {
    String s = "";
    for (Box b : boxes)
      s+= savePoint(b.p1) + POINT_SEPARATOR + savePoint(b.p2) + COUPLE_SEPARATOR;
      
    return s;
  }
  
  static void loadPointsOfCurves(String allPoints, BezeePlayer player) {
    if (allPoints.length() > 0) {
      String[] couples = allPoints.split(COUPLE_SEPARATOR);
      String[] pointsInCouple;
      
      for (int i = 0; i < couples.length; i++) {
          pointsInCouple = couples[i].split(POINT_SEPARATOR);
          player.addCurve(loadPoint(pointsInCouple[0]), loadPoint(pointsInCouple[1]));
      }
    }
  }
  
  static void loadPointsOfBoxes(String allPoints, BezeePlayer player) {
    if (allPoints.length() > 0) {
      String[] couples = allPoints.split(COUPLE_SEPARATOR);
      String[] pointsInCouple;
      
      for (int i = 0; i < couples.length; i++) {
          pointsInCouple = couples[i].split(POINT_SEPARATOR);
          player.addBox(loadPoint(pointsInCouple[0]), loadPoint(pointsInCouple[1]));
      }
    }
  }
  
  static String savePoint(Point p)     { return p.x() + "," + p.y(); }
  static String savePoint(PVector p)   { return p.x   + "," + p.y;   }
  
  static PVector loadPoint(String s)   {
    String[] p = s.split(",");
    return new PVector(Float.parseFloat(p[0]), Float.parseFloat(p[1]));
  }
  
  
}
