import processing.serial.*;
import java.awt.*;
import java.util.*;
HashMap<String, TextField>fields=new HashMap<String, TextField>();
int unitX;
int unitY;
int scrollY=0;
int [] sensors=new int [8];
Score score;
Serial serial;
boolean isSerial=false;
void setup() {
  size(800, 600);
  unitX=width/40;
  unitY=height/40;

  setLayout(null);
  
  //Text File
  score=new Score("data/score.tja");

  //Text Fields
  fields.put("bpm", new TextField(score.getBpm()));
  fields.put("title", new TextField(score.getTitle()));
  fields.put("offset", new TextField(score.getOffset()));
  fields.get("title").setBounds(unitX*1, unitY*2, unitX*18, unitY*2);
  fields.get("bpm").setBounds(unitX*21, unitY*2, unitX*8, unitY*2);
  fields.get("offset").setBounds(unitX*31, unitY*2, unitX*8, unitY*2);
  for (Map.Entry field : fields.entrySet ()) {
    fields.get(field.getKey()).setFont(new Font("Century", Font.PLAIN, 24));
    add(fields.get(field.getKey()));
  }

  try {
    serial=new Serial(this, Serial.list()[1], 9600);
    serial.bufferUntil('\n');
    isSerial=true;
  }
  catch(Exception e) {
    println(e);
  }
} 



void draw() {
  score.updateHead();
  background(255);

  score.display();

  //Text Box
  noStroke();
  fill(0);
  rect(unitX*0, unitY*0, unitX*40, unitY*5);

  //Text
  fill(255);
  text("TITLE", unitX*1, unitY*2);
  text("BPM", unitX*21, unitY*2);
  text("OFFSET", unitX*31, unitY*2);

  //Arrow Buttons
  fill(200);
  if (mousePressed && mouseX>0 && mouseX<unitX*40 && mouseY>unitY*5 && mouseY<unitY*8) {
    strokeWeight(3);
    stroke(255, 255, 0);
    score.scrollY(1);
  } else {
    noStroke();
  }
  rect(unitX*0, unitY*5, unitX*40, unitY*2);
  fill(200);
  if (mousePressed && mouseX>0 && mouseX<unitX*40 && mouseY>unitY*38 && mouseY<unitY*40) {
    strokeWeight(3);
    stroke(255, 255, 0);
    score.scrollY(-1);
  } else {
    noStroke();
  }
  rect(unitX*0, unitY*38, unitX*40, unitY*2);
}
void mousePressed() {
  score.checkEditingPart(mouseX, mouseY);
  score.edit(mouseX,mouseY);
  score.updateHead();
}
void keyPressed() {
  if (keyCode==UP)score.scrollY(1);
  if (keyCode==DOWN)score.scrollY(-1);
  if (keyCode==ENTER)score.turnEditing();
}
void serialEvent(Serial port) {
  if (port.read()=='H') {
    String portString=port.readStringUntil('\n');
    portString=trim(portString);
    println(portString);
    sensors=int(split(portString, ","));
    score.edit(sensors);
  }
}

