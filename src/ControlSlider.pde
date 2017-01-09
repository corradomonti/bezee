// Bezee by Corrado Monti - released under GPL - see corradomonti.com
abstract class ControlSlider implements SavableControl {
  final int X = areaWidth + 18, HEI = 15;
  int y;
  Slider s;
  String label;
  
  //"bpmValue", 60, 200, 0, areaWidth+18, y+=10, 100, 15)
  ControlSlider(ControlP5 controlP5, String name, String label, float minV, float maxV, float initialV, int y, float xPerValue) {
    s = controlP5.addSlider(name, minV, maxV, initialV, X, y + (label.length() > 0 ? 10 : 0), (int) (xPerValue * (maxV - minV)), HEI);
    s.setCaptionLabel("");
    this.y = y;
    this.label = label;
  }
  
  void draw() {
    if (label.length() > 0)
      text("> " + label, areaWidth + 20, y);
  }
  
  boolean isResponsibleFor(ControlEvent theEvent)  {
    return (theEvent.controller() == s);
  }
  
  void controlEvent(ControlEvent theEvent) {
    click(s.value());
  }
  
  abstract void click(float value);
  
  String getName() { return s.name(); }
  String getValue() { return  ""+s.value(); }
  void setValue(String string) { s.setValue(Float.parseFloat(string)); }
  
}
