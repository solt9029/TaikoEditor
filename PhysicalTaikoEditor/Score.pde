class Score {
  String fileName;
  String [] file;
  String title;
  String bpm;
  String offset;
  int titlePos;
  int bpmPos;
  int offsetPos;
  int startPos=0;
  int endPos=1;
  String [] lines;
  int [][] notes;
  int NOTE_NUM=16;
  int EDIT_NOTE_NUM=8;
  int scrollY=0;
  int editingPart=0;
  boolean editing=false;
  int [] editingNotes=new int [this.EDIT_NOTE_NUM];

  Score(String fileName) {
    this.init(fileName);
  }

  void init(String fileName) {
    this.fileName=fileName;
    this.file=loadStrings(this.fileName);
    for (int i=0; i<this.file.length; i++) {
      if (this.file[i].indexOf("TITLE:")>=0) {
        this.titlePos=i;
        this.title=this.file[this.titlePos].substring(this.file[this.titlePos].indexOf("TITLE:")+6, this.file[this.titlePos].length());
      }
      if (this.file[i].indexOf("BPM:")>=0) {
        this.bpmPos=i;
        this.bpm=this.file[this.bpmPos].substring(this.file[this.bpmPos].indexOf("BPM:")+4, this.file[this.bpmPos].length());
      }
      if (this.file[i].indexOf("OFFSET:")>=0) {
        this.offsetPos=i;
        this.offset=this.file[this.offsetPos].substring(this.file[this.offsetPos].indexOf("OFFSET:")+7, this.file[this.offsetPos].length());
      }
      if (this.file[i].equals("#START"))this.startPos=i;
      if (this.file[i].equals("#END"))this.endPos=i;
    }
    this.lines=new String [this.endPos-this.startPos-1];
    for (int i=0; i<this.lines.length; i++) {
      this.lines[i]=this.file[i+this.startPos+1];
    }
    this.notes=new int [this.lines.length][this.NOTE_NUM];
    for (int i=0; i<this.notes.length; i++) {
      for (int j=0; j<this.notes[i].length; j++) {
        this.notes[i][j]=int(this.lines[i].substring(j, j+1));
      }
    }
  }
  
  String getTitle(){
    return this.title;
  }
  
  String getBpm(){
    return this.bpm;
  }
  
  String getOffset(){
    return this.offset;
  }
  
  void updateHead(){
    this.file[this.titlePos]="TITLE:"+fields.get("title").getText();
    this.title=fields.get("title").getText();
    this.file[this.bpmPos]="BPM:"+fields.get("bpm").getText();
    this.bpm=fields.get("bpm").getText();
    this.file[this.offsetPos]="OFFSET:"+fields.get("offset").getText();
    this.offset=fields.get("offset").getText();
    saveStrings(this.fileName,this.file);
  }

  void updateTitle() {
    this.file[this.titlePos]="TITLE:"+fields.get("title").getText();
    this.title=fields.get("title").getText();
    saveStrings(this.fileName, this.file);
  }

  void updateBpm() {
    this.file[this.bpmPos]="BPM:"+fields.get("bpm").getText();
    this.bpm=fields.get("bpm").getText();
    saveStrings(this.fileName, this.file);
  }

  void updateOffset() {
    this.file[this.offsetPos]="OFFSET:"+fields.get("offset").getText();
    this.offset=fields.get("offset").getText();
    saveStrings(this.fileName, this.file);
  }

  void display() {
    this.displayLines();
    this.displayNotes();
    this.displayEditingNotes();
    this.displayEditingPart();
  }

  void displayLines() {
    for (int i=0; i<this.notes.length+1; i++) {
      strokeWeight(3);
      stroke(0);
      line(unitX*4, unitY*(8+i*5+this.scrollY), unitX*36, unitY*(8+i*5+this.scrollY));
      line(unitX*4, unitY*(12+i*5+this.scrollY), unitX*36, unitY*(12+i*5+this.scrollY));
      noStroke();
      fill(127);
      rect(unitX*4, unitY*(8.5+i*5+this.scrollY), unitX*32, unitY*3);
      fill(0);
      text(i+1, unitX*3, unitY*(9+i*5+this.scrollY));
      for (int j=0; j<this.NOTE_NUM; j++) {
        stroke(255);
        strokeWeight(2);
        line(unitX*(5+j*2), unitY*(8.5+i*5+this.scrollY), unitX*(5+j*2), unitY*(11.5+i*5+this.scrollY));
      }
    }
  }

  void displayNotes() {
    for (int i=0; i<this.notes.length; i++) {
      for (int j=0; j<this.notes[i].length; j++) {
        switch(this.notes[i][j]) {
        case 0:
          break;
        case 1:
          stroke(255);
          strokeWeight(3);
          fill(255, 0, 0);
          ellipse(unitX*(5+j*2), unitY*(10+i*5+this.scrollY), unitX*2, unitX*2);
          break;
        case 2:
          stroke(255);
          strokeWeight(3);
          fill(0, 0, 255);
          ellipse(unitX*(5+j*2), unitY*(10+i*5+this.scrollY), unitX*2, unitX*2);
          break;
        default:
          break;
        }
      }
    }
  }

  void displayEditingPart() {
    strokeWeight(3);
    noFill();
    stroke(255, 255, 0);
    if (this.editing)stroke(255, 0, 255);//editing color.
    rect(unitX*(4+(this.editingPart%2)*16), unitY*(8.25+5*int(this.editingPart/2)+this.scrollY), unitX*16, unitY*3.5);
  }

  void displayEditingNotes() {
    if (!this.editing)return;
    strokeWeight(3);
    stroke(0);
    line(unitX*(4+(this.editingPart%2)*16), unitY*(8+5*int(this.editingPart/2)+this.scrollY), unitX*(20+(this.editingPart%2)*16), unitY*(8+5*int(this.editingPart/2)+this.scrollY));
    line(unitX*(4+(this.editingPart%2)*16), unitY*(12+5*int(this.editingPart/2)+this.scrollY), unitX*(20+(this.editingPart%2)*16), unitY*(12+5*int(this.editingPart/2)+this.scrollY));
    noStroke();
    fill(127);
    rect(unitX*(4+(this.editingPart%2)*16), unitY*(8.5+5*int(this.editingPart/2)+this.scrollY), unitX*16, unitY*3);
    for (int i=0; i<this.NOTE_NUM/2; i++) {
      stroke(255);
      strokeWeight(2);
      line(unitX*(5+(this.editingPart%2)*16+i*2), unitY*(8.5+5*int(this.editingPart/2)+this.scrollY), unitX*(5+(this.editingPart%2)*16+i*2), unitY*(11.5+5*int(this.editingPart/2)+this.scrollY));
      switch(this.editingNotes[i]) {
      case 0:
        break;
      case 1:
        stroke(255);
        strokeWeight(3);
        fill(255, 0, 0);
        ellipse(unitX*(5+(this.editingPart%2)*16+i*2), unitY*(10+5*int(this.editingPart/2)+this.scrollY), unitX*2, unitX*2);
        break;
      case 2:
        stroke(255);
        strokeWeight(3);
        fill(0, 0, 255);
        ellipse(unitX*(5+(this.editingPart%2)*16+i*2), unitY*(10+5*int(this.editingPart/2)+this.scrollY), unitX*2, unitX*2);
        break;
      default:
        break;
      }
    }
  }

  void scrollY(int scroll) {
    this.scrollY+=scroll;
    if (this.scrollY>0)this.scrollY=0;
    if (this.notes.length>5) {
      if (this.scrollY<-(this.notes.length-5)*5)this.scrollY=-(this.notes.length-5)*5;
    } else {
      if (this.scrollY<0)this.scrollY=0;
    }
  }

  void checkEditingPart(int x, int y) {
    //out of bounds return
    if (!(x>unitX*4) || !(x<unitX*36) || !(y>unitY*7) || !(y<unitY*38))return;
    if (this.editing)return;
    for (int i=0; i<this.notes.length+1; i++) {
      this.editing=false;
      if (y>unitY*(8+i*5+this.scrollY) && y<unitY*(12+i*5+this.scrollY) && x>unitX*4 && x<unitX*20)this.editingPart=i*2;
      if (y>unitY*(8+i*5+this.scrollY) && y<unitY*(12+i*5+this.scrollY) && x>unitX*20 && x<unitX*36)this.editingPart=i*2+1;
    }
  }

  void turnEditing() {
    if (!this.editing) {
      //編集モードに移行するとき編集テンポラリデータを初期化
      for (int i=0; i<this.editingNotes.length; i++)this.editingNotes[i]=0;
    } else {
      //ーーーーー編集したデータを保存する処理を記述するーーーーー
      //実際にファイルにある行よりも多いとき、要するに一番下の行を編集していたとき
      if (this.editingPart/2+1>this.notes.length) {
        int [][] newNotes=new int [this.notes.length+1][this.NOTE_NUM];
        for (int i=0; i<this.notes.length; i++) {
          for (int j=0; j<this.notes[i].length; j++) {
            newNotes[i][j]=this.notes[i][j];
          }
        }
        for (int i=0; i<this.EDIT_NOTE_NUM; i++)newNotes[newNotes.length-1][i+(this.editingPart%2)*8]=this.editingNotes[i];
        for (int i=0; i<this.EDIT_NOTE_NUM; i++)newNotes[newNotes.length-1][this.NOTE_NUM-1-(i+(this.editingPart%2)*8)]=0;
        String [] newLines=new String [this.lines.length+1];
        for (int i=0; i<newNotes.length; i++) {
          newLines[i]="";
          for (int j=0; j<newNotes[i].length; j++) {
            newLines[i]+=str(newNotes[i][j]);
            if (j==newNotes[i].length-1)newLines[i]+=",";
          }
        }
        String [] newFile=new String [this.file.length+1];
        for (int i=0; i<this.file.length; i++)newFile[i]=this.file[i];
        for (int i=0; i<newLines.length; i++) {
          newFile[this.startPos+1+i]=newLines[i];
        }
        newFile[this.endPos+1]="#END";
        saveStrings(this.fileName, newFile);
        this.init(this.fileName);
      } else {
        for (int i=0; i<this.EDIT_NOTE_NUM; i++)this.notes[this.editingPart/2][i+(this.editingPart%2)*8]=this.editingNotes[i];
        for (int i=0; i<this.notes.length; i++) {
          this.lines[i]="";
          for (int j=0; j<this.notes[i].length; j++) {
            this.lines[i]+=str(this.notes[i][j]);
            if (j==this.notes[i].length-1)this.lines[i]+=",";
          }
        }
        for (int i=0; i<this.lines.length; i++) {
          this.file[this.startPos+1+i]=this.lines[i];
        }
        saveStrings(this.fileName, this.file);
        this.init(this.fileName);
      }
    }
    this.editing=!this.editing;
  }

  void edit(int x, int y) {
    if (!this.editing)return;
    if (isSerial)return;
    //out of bounds return
    if (!(x>unitX*(4+(this.editingPart%2)*16)) || !(y>unitY*(8.25+5*int(this.editingPart/2)+this.scrollY)) || !(x<unitX*(20+(this.editingPart%2)*16)) || !(y<unitY*(11.75+5*int(this.editingPart/2)+this.scrollY)))return;
    for (int i=0; i<this.NOTE_NUM/2; i++) {
      if (dist(unitX*(5+(this.editingPart%2)*16+i*2), unitY*(10+5*int(this.editingPart/2)+this.scrollY), x, y)<unitX*1)this.editingNotes[i]=(this.editingNotes[i]+1)%3;
    }
  }

  void edit(int [] sensors) {
    if (!this.editing)return;
    if (!isSerial)return;
    for (int i=0; i<this.EDIT_NOTE_NUM; i++) {
      this.editingNotes[i]=0;
      if (sensors[i]<400)this.editingNotes[i]=1;
      if (sensors[i]>600)this.editingNotes[i]=2;
    }
  }
}

