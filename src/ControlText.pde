// Bezee by Corrado Monti - released under GPL - see corradomonti.com
abstract class ControlText {
  String txt;
  int y;

  ControlText(String txt, int y) {
    this.txt = txt;
    this.y = y;
  }
  
  void draw() {
    text(txt + " = " + value(), areaWidth + 20, y);
  }
  
  abstract String value();
  
  
  
}
