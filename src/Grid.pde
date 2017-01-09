// Bezee by Corrado Monti - released under GPL - see corradomonti.com
class Grid {
  final int OTTAVE = 4;
  int tono;
  int[] notes;
  Scala scala;
  float[] row;
  float deltaRow, lastPlayed = -1;
  
  final int BASE_NOTE = 60 - 24;
  
  Grid() {
    scales = new Scala[6];
    int[]     MINORE = {0, 2, 1, 2, 2, 1, 2},
              MAGGIORE = {0, 2, 2, 1, 2, 2, 2},
              BLUES = {0, 3, 2, 1, 1, 3},
              CROMA = {0,1,1,1,1,1,1,1,1,1,1,1},
              ARABIC = {0, 1, 3, 1, 2, 1, 3},
              PHRYGIAN = {0, 1, 3, 1, 2, 1, 2};
    
    scales[0] = new Scala(MINORE, "Minore");       
    scales[1] = new Scala(MAGGIORE, "Maggiore");
    scales[2] = new Scala(BLUES, "Blues");
    scales[3] = new Scala(ARABIC, "Arabic");
    scales[4] = new Scala(PHRYGIAN, "Phrygian");
    scales[5] = new Scala(CROMA, "Chromatic");
    
    
    
    updateNotes(BASE_NOTE, scales[0], OTTAVE);
  }
  
  void draw() {
    stroke(128);
    noFill();
    
    for (int i = 0; i < row.length; i++) {
      line(0,row[i],areaWidth,row[i]);
      if (i % scala.get().length == 0)
        ellipse(10, row[i] - (deltaRow/2.0), 15, 15);
    }
    
    if (lastPlayed > 0) {
      noStroke();
      fill(255);
      ellipse(10, lastPlayed, 15, 15);
      lastPlayed = -1;
    }
  }
  
  int getNote(PVector p) {
    int i;
    for (i = 0; (i+1) < row.length && p.y < row[i+1]; i++);
    lastPlayed = row[i] - (deltaRow/2);
    return notes[i];
  }
  
  int getPan(PVector p) {
    return max(0, min(127, (int) (127.0 * (float) p.x / (float) areaWidth)));
  }
  
  void updateNotes(int tono, Scala s, int OTTAVE) {
    this.tono = tono;
    this.scala = s;
    
    notes = new int[scala.get().length * OTTAVE + 1];
    row = new float[notes.length];
    
    deltaRow = (float) height / (notes.length);
    
    for (int i = 0; i < OTTAVE; i++) { 
      notes[i*scala.get().length] = tono + i*12;
      
      for (int j = 1; j < scala.get().length; j++) {
        int t = i*scala.get().length + j;
        notes[t] = notes[t - 1] + scala.get()[j];
      }
    }
    
    notes[notes.length-1] = tono+OTTAVE*12;
    
    row[0] = height;
    for (int i = 1; i < notes.length; i++)
      row[i] = row[i-1] - deltaRow;
    
    /* //DEBUG OUTPUT 
    for (int i = 0; i < notes.length; i++)
      System.out.println("notes[" + i + "] = " + notes[i]);
    for (int i = 0; i < row.length; i++)
      System.out.println("row[" + i + "] = " + row[i]);
    */
    
    
  } 
  
  void changeScale(Scala newScala) {
    updateNotes(tono, newScala, OTTAVE);
  }
  
  void changeTone(int toneDelta) {
    updateNotes(BASE_NOTE + toneDelta, scala, OTTAVE);
  }
  
  
}
