// Bezee by Corrado Monti - released under GPL - see corradomonti.com
abstract class ControlRadio<T> implements SavableControl {
  ControlP5 controlP5;
  RadioButton r;
  int y, itemPerRow;
  String title, suffix;
  T[] options;
  int value;
  
  private boolean firstActivation = false;
  
  ControlRadio (ControlP5 controlP5, String t, int y, int ipr, T[] o, String s, int v) {
    this.controlP5 = controlP5; this.y = y; itemPerRow = ipr; title = t; options = o; suffix = s; value = v;
    setup();
  }
  
  private void setup() {
    r = controlP5.addRadioButton(title, areaWidth + 20, y + 10);
    r.setColorActive(color(255));
    r.setItemsPerRow(itemPerRow);
    r.setSpacingColumn((panelWidth - 60) / itemPerRow);
    r.setNoneSelectedAllowed(false);
    
    for (int i = 0; i < options.length; i++)
      r.addItem(options[i].toString() + " " + suffix, i);
    
  } 
  
  void draw() {
    if (!firstActivation) {
      r.activate(value);
      firstActivation = true;
    }
    text("> " + title, areaWidth + 20, y);
  }
  
  boolean isResponsibleFor(ControlEvent theEvent) {
    return (theEvent.group().name().equals(this.title));
  }
  
  void controlEvent(ControlEvent theEvent) {
    value = (int) theEvent.group().value();
    click(options[value]);
  }
  
  abstract void click(T o);
  
  String getName() { return title; }
  String getValue() { return options[(int) r.value()].toString() + " " + suffix; }
  void setValue(String value) {
      r.activate(value);
  }
  
  
}
