// Bezee by Corrado Monti - released under GPL - see corradomonti.com
import controlP5.*;

import arb.soundcipher.*;
import arb.soundcipher.constants.*;

int BPM = 120, notePerBar = 16, curvePerBar = 4;
int framePerBeat = 8, BACKGROUND_OPACITY = 32;

final boolean ACTIVE_PAN = true;

BezeePlayer player;
Grid grid;
Scala[] scales;
ControlPanel controlPanel;
SoundCipher sc;

final int areaWidth = 600, panelWidth = 200;

boolean curveMode = true, deleteBoxes = false, movingPoints = false, savingDialogIsNotOpen = true;
Point openPoint;

void playNote(int pan, int note) {
  if (ACTIVE_PAN)
     sc.pan(pan);
  sc.playNote(note, 100, 1);
}

void setup() {
  size(areaWidth + panelWidth, 600);
  updateFrameRate();
  smooth();
  
  println("Bezee by Corrado Monti - http://www.corradomonti.com");
  player = new BezeePlayer();
  grid = new Grid();
  controlPanel = new ControlPanel(new ControlP5(this));
  
  sc = new SoundCipher(this);
  sc.instrument(35);
}

void draw() {
  drawBackground();
  player.draw();
  grid.draw();
  
  if (openPoint != null)
    if (curveMode)
       player.drawPreviewOfNewCurve(openPoint);
    else
       player.drawPreviewOfNewBox(openPoint);
  
  if (movingPoints)
    player.editPointsIfGrabbed(mouseX,mouseY);
  
  player.drawPointAndPlay(grid);
  
  controlPanel.draw();
  
}

void mousePressed() {
  movingPoints = player.checkPointsIfGrabbed();   
}

void mouseReleased() {
  if (movingPoints) {
    player.ungrabPoints();
    movingPoints = false;
  }
}

void mouseClicked() {
  if (mouseX <= areaWidth) {
    if (deleteBoxes) {
      deleteBoxes = !player.deleteBox(mouseX, mouseY);
      cursor(deleteBoxes ? CROSS : ARROW);
    } else
        if (openPoint == null)
              if (mouseButton == RIGHT)
                  player.closeLastCurve();
              else
                  openPoint = new SimplePoint(mouseX, mouseY);
        else {
              if (curveMode)
                    player.addCurve(openPoint, new SimplePoint(mouseX, mouseY));
              else
                    player.addBox(openPoint.toVector(), new PVector(mouseX, mouseY));
                    
              openPoint = null;
        }
  }
    
}

void keyPressed() {
  if (savingDialogIsNotOpen)
    switch (key) {
      case 'O': case 'o':
        savingDialogIsNotOpen = false;
        String fileToOpen = selectInput();
        if (fileToOpen != null)
          LoaderAndSaver.load(player, controlPanel, fileToOpen);
        savingDialogIsNotOpen = true;
        break;
      case 'S': case 's':
        savingDialogIsNotOpen = false;
        println("Waiting for processing method selectOutput()... if it locks, please contact processing.org");
        String fileToSave = selectOutput("DO NOT PRESS ENTER, CLICK ON THE BUTTON PLEASE");
        if (fileToSave != null) {
          println("OK. Starting saving process...");
          if (!fileToSave.endsWith(".bezeescore"))
            fileToSave = fileToSave + ".bezeescore";
          LoaderAndSaver.save(player, controlPanel, fileToSave);
        }
        savingDialogIsNotOpen = true;
        break;
      case 'B': case 'b':
        curveMode = false;
        deleteBoxes = false;
        cursor(ARROW);
        break;
      case 'C': case 'c':
        curveMode = true;
        deleteBoxes = false;
        cursor(ARROW);
        break;
      case 'I': case 'i':
        player.switchBoxesMeaning(); break;
      case 'D': case 'd':
        deleteBoxes = !deleteBoxes;
        cursor(deleteBoxes ? CROSS : ARROW);
        break;
      case 'Z': case 'z':
        player.undoLastCurve();
        break;
      case ' ':
        player.invertPauseStatus(); break;
      case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8': case '9': case '0': 
        float t = Integer.parseInt(key + "");
        player.playFromPosition(t/10.0);
        break;
      case CODED:
        PVector movement = null;
        switch (keyCode) {
          case    UP: movement = new PVector(0, -grid.deltaRow); break;
          case  DOWN: movement = new PVector(0,  grid.deltaRow); break;
          case  LEFT: movement = new PVector(-grid.deltaRow, 0); break;
          case RIGHT: movement = new PVector(grid.deltaRow,  0); break;
        }
        if (movement != null)
          player.moveBy(movement);
        break;
    }
}

void controlEvent(ControlEvent theEvent) {
  controlPanel.controlEvent(theEvent);
}

void drawBackground() {
  noStroke();
  fill(0, BACKGROUND_OPACITY);
  rect(0, 0, areaWidth, height);
}

int greatestCommonDivisor (int m, int n){
	int x;
	int y;
	while (m % n != 0){
		x = n;
		y = m % n;
		m = x;
		n = y;
	}
	return n;
}		

int toneDeltaFromNoteName(String noteName) {
    char base = noteName.charAt(0);
    int d = 0;
    
    if (noteName.length() > 1)
      if (noteName.charAt(1) == 'b' || noteName.charAt(1) == '♭')
          d = -1;
          else if (noteName.charAt(1) == '#' || noteName.charAt(1) == '♯')
          d = 1;
          else
            throw new IllegalArgumentException(noteName + " is not a note.");
    
    switch (base) {
      case 'C': return 0 + d;
      case 'D': return 2 + d;
      case 'E': return 4 + d;
      case 'F': return 5 + d;
      case 'G': return 7 + d;
      case 'A': return 9 + d;
      case 'B': return 11 + d;
      default: throw new IllegalArgumentException(noteName + " is not a note.");
    }
  }
  
void updateFrameRate() {
  frameRate(BPM*framePerBeat / 60);
}
  
void setFramePerBeat(int value) {
  if (value != framePerBeat) {
    println("Switching to " + value + " frame per beat");
    framePerBeat = value;
    updateFrameRate();
    player.updateAllTimes();
  }
}

