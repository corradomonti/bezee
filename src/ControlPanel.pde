// Bezee by Corrado Monti - released under GPL - see corradomonti.com
class ControlPanel {
  ControlP5 controlP5;
  List<ControlText> txts = new ArrayList<ControlText>();
  List<ControlRadio> radios = new ArrayList<ControlRadio>();
  List<ControlSlider> sliders = new ArrayList<ControlSlider>();
  final int panelWidth = width - areaWidth;
  final int beatIndicatorYPosition;
  PFont font;
  
  String help =
  "> KEYS.\r\n\r\n" +
  "\'O\'/\'S\' open/save\r\n" + 
  "\'B\' draw boxes\r\n"+
  "\'C\' draw curves\r\n"+
  "\'I\' invert box effect\r\n"+
  "\'D\' delete a box\r\n"+
  "\'Z\' delete last curve\r\n" +
  "ARROWS move curves \r\n"+
  "Space pause/play\r\n"+
  "0-9 move play point";
  
  ControlPanel(ControlP5 c) {
    //spacing
    final int maxidy = 89, mediumdy = 74, dy = 20, minidy = 6;
    
    int y = 0;
    font = loadFont("SFIntermosaicB-32.vlw");
    controlP5 = c;
    
    txts.add( new ControlText("BEAT", y+=dy) {
                  String value() {
                    int gcd = greatestCommonDivisor(player.getCurvesNumber(), curvePerBar);
                    return ( player.getCurvesNumber() / gcd) + 
                              ( (curvePerBar / gcd == 1) ?
                                " bars"
                              :
                                ("/" + (curvePerBar / gcd) + " bars") );
                  }
    } );
    
    beatIndicatorYPosition=(y+=minidy);
    y+=minidy;
    
    txts.add( new ControlText("BPM", y+=dy) {
                  String value() { return BPM + ""; }
    } );
    
    sliders.add( new ControlSlider(controlP5, "BPM", "", 60, 200, BPM, y+=minidy, 1) {
          void click(float value) { updateFrameRate(); }
    } );
    y+=dy;
    
    Integer[] beats = {1, 2, 3, 4, 6, 8, 16, 32};
    radios.add( new ControlRadio<Integer>(controlP5, "NOTES PER BAR", y+=dy, 2, beats, "notes", 6) { 
          void click(Integer i) { notePerBar = i; player.updateNoteInterval(); }
    } );
    
    radios.add( new ControlRadio<Integer>(controlP5, "CURVES PER BAR", y+=maxidy, 2, beats, "curves", 3) { 
          void click(Integer i) { curvePerBar = i;  player.updateAllTimes(); }
    } );
    
    radios.add( new ControlRadio<Scala>(controlP5, "SCALA", y+=maxidy, 2, scales, "", 0) { 
          void click(Scala s) { grid.changeScale(s); }
    } );
    
    String[] notes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
    radios.add( new ControlRadio<String>(controlP5, "BASE NOTE", y+=mediumdy, 4, notes, "", 0) { 
          void click(String noteName) {
              int newToneDelta = toneDeltaFromNoteName(noteName);
              grid.changeTone(newToneDelta);
          }
    } );
    
    sliders.add( new ControlSlider(controlP5, "PHASE", "phase", 0, 1, 0, y+=mediumdy, 140) {
          void click(float value) { player.setPhase(value); }
    } );
    
    
  }
  
  void draw() {
    stroke(128);
    fill(8);
    rect(areaWidth, 0, panelWidth, height);
    
    textFont(font, 16);
    
    fill(255);
    for (ControlText c : txts)
      c.draw();
    for (ControlRadio c : radios)
      c.draw();
    for (ControlSlider s: sliders)
      s.draw();
      
    text("by CH3M", areaWidth+20, height-8);
      
    textFont(font, 12);
    text(help, areaWidth+20, height-128);
    
    
    //beatIndicator
    noStroke();
    fill(9, 54, 82);
    rect(areaWidth+18, beatIndicatorYPosition, 140, 5);
    fill(20, 105, 140);
    rect(areaWidth+18 + player.getCurrentPosition() * (player.hasNoCurves() ? 0 : 140), beatIndicatorYPosition, 5, 5);
    
  }
  
void controlEvent(ControlEvent theEvent) {
   if (theEvent.isController()) {
      for (ControlSlider s : sliders)
        if (s.isResponsibleFor(theEvent))
          s.controlEvent(theEvent);
          
    } else if (theEvent.isGroup()) {
      for (ControlRadio c : radios)
        if (c.isResponsibleFor(theEvent)) {
          c.controlEvent(theEvent);
          return;
        }
    }
  }
  
List<SavableControl> getAllSavableControls() {
    List<SavableControl> s = new ArrayList<SavableControl>(sliders);
    s.addAll(radios);
    return s;
  }
  
}
