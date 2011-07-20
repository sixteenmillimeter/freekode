//version 0.6alpha
import proxml.*;

XMLInOut xmlIO;

String[] rN, rSt, rSt1;
int[] dL, fIR, fOR, fL;
float[] cor;
int[] dI, dO, fI, fO;
String[] pname, pI, pO, brI, brO;
int TB;
boolean scroll = false;
String inshow;
String outshow;

int Y, Ystore, YstoreL = 0;

int clips = 0;

int li = 15;
PFont font = createFont("Courier", 11);
void xmlEvent(proxml.XMLElement element) {
  clips =  element.getChild(6).getChild(0).getChild(1).getDepth() - 1;
  rN = new String[clips];
  rSt = new String[clips];
  rSt1 = new String[clips];
  dL = new int[clips];
  fIR = new int[clips];
  fOR = new int[clips];
  fL = new int[clips];
  cor = new float[clips];
  dI = new int[clips];
  dO = new int[clips];
  fI = new int[clips];
  fO = new int[clips];
  pname = new String[clips];
  pI = new String[clips];
  pO = new String[clips];
  brI = new String[clips];
  brO = new String[clips];


  for(int i = 0; i < clips;i++) {
    //ROLL NAME:
    rN[i] = element.getChild(6).getChild(0).getChild(1).getChild(i).getChild(15).getAttribute("id");
    //DIGITAL LENGTH
    dL[i] = Integer.parseInt(element.getChild(6).getChild(0).getChild(1).getChild(i).getChild(1).getChild(0).getElement());
    //DIGITAL IN
    dI[i] = Integer.parseInt(element.getChild(6).getChild(0).getChild(1).getChild(i).getChild(3).getChild(0).getElement());
    //DIGITAL OUT
    dO[i] = Integer.parseInt(element.getChild(6).getChild(0).getChild(1).getChild(i).getChild(4).getChild(0).getElement());
    //FULL KEYCODE IN+OUT
    rSt[i] = element.getChild(6).getChild(0).getChild(1).getChild(i).getChild(0).getChild(0).getElement();
    fullKey(rSt[i],i);
    brI[i] = "[ ]";
    brO[i] = "[ ]";
  }
  //TIMEBASE !! NEW FEATURE !!
  TB = Integer.parseInt(element.getChild(2).getChild(1).getChild(0).getElement());
}

void setup() {
  xmlIO = new XMLInOut(this);
  xmlIO.loadElement("fcp.xml");
  size(720,800);
  smooth();
}

void draw() {
  background(25);
  fill(40);
  stroke(75);
  rect(-1,-1,30,802);
  fill(75);
  textFont(font);

  translate(0,Y);
  for(int n=0;n<clips*5+1;n++) {
    int cha = 19;
    if(n+1>9) {
      cha = 12;
    }
    text(n+1,cha,(n*li)+li);
  }
  fill(250);
  text("                                  freeCode XML Cut List v0.6 alpha",35,li);
  text("                          CUT      FEET>0       LENGTH                  Final Cut Pro",35,3 * li);
  int l = 0;
  while(l<clips) {
    if(l%2==0) {
      pname[l] = "A ROLL : '"+rN[l]+"'";
    }
    else {
      pname[l] = "B ROLL : '"+rN[l]+"'";
    }
    text(pname[l], 35, (5*l*li) + 4*li);
    int DIuse;
    int DOuse;
    if(TB==30) {
      DIuse = pulldown(dI[l]);
      DOuse = pulldown(dO[l]);
    }
    else {
      DIuse = dI[l];
      DOuse = dO[l];
    }
    //println(fI[l]+" - "+fO[l]);

    String corcor;
    String corcor2;
    if(round(DIuse * cor[l])>=0) {
      corcor ="+"+round(DIuse * cor[l]);
    }
    else {
      corcor =Integer.toString(round(DIuse * cor[l]));
    }
    if(round(pulldown(dO[l]) * cor[l])>=0) {
      corcor2 ="+"+round(DOuse * cor[l]);
    }
    else {
      corcor2 =Integer.toString(round(DOuse * cor[l]));
    }


    inshow = rSt1[l];
    if(floor(fIR[l]/20)>int(keys(fIR[l]+fI[l]).substring(0,4))) {
      int inner =int(rSt1[l].substring(5,9))+1;
      inshow = rSt1[l].substring(0,4)+" "+inner;
    }
    pI[l] = "  IN : "+inshow+" "+keys(fIR[l]+fI[l])+"   "+feet(fI[l])+
      "'                "+" Din "+dZero(dI[l],5)+"    "+timecode(dI[l])+
      "    "+corcor+"  "+brI[l];
    text(pI[l], 35, (5*l*li) + 5*li);

    outshow = rSt1[l];    
    if(floor(fIR[l]/20)>int(keys(fIR[l]+fO[l]).substring(0,4))) {
      int inner =int(rSt1[l].substring(5,9))+1;
      outshow = rSt1[l].substring(0,4)+" "+inner;
    }
    pO[l] = "  OUT: "+outshow+" "+keys(fIR[l]+fO[l])+"   "+feet(fO[l])+
      "'    "+feet(fO[l] -fI[l])+"'    "+"Dout "+dZero(dO[l],5)+"    "+
      timecode(dO[l])+"    "+corcor2+"  "+brO[l];
    text(pO[l], 35, (5*l*li) + 6*li);
    l++;
  }
}

//KEYCODE ENCODE
String keys(int frames) {
  String K;
  String F;
  int footsK = floor(frames / 20);
  int footsF = frames % 20;
  if(footsF<10) {
    F = "0"+footsF;
  }
  else {
    F = Integer.toString(footsF);
  } 
  if(footsK>9999) {
    footsK-=10000;
  }
  K = Integer.toString(footsK);
  if(footsK<10) {
    K = "000"+K;
  }
  else if(footsK<100) {
    K = "00"+K;
  }
  else if(footsK<1000) {
    K = "0"+K;
  }
  return K + " + " + F;
}

//FEET ENCODE
String feet(int frames) {
  String K;
  String F;
  float forT = 40;
  float foots = frames / forT;
  int footsK = floor(foots);
  int footsF = frames % 40;
  if(footsF<10) {
    F = "0"+footsF;
  }
  else {
    F = Integer.toString(footsF);
  }
  if(footsK<1000) {
    K = "0"+footsK;
    if(footsK<100) {
      K = "00"+footsK;
      if(footsK<10)
        K = "000"+footsK;
    }
  }
  else {
    K = Integer.toString(footsK);
  }
  return K+"+"+F;
}

//timecode encode
String timecode(int tc) {
  int d = tc % TB;
  int c = (tc/TB) % 60;
  int b = ((tc/TB)/60) % 60;
  int a = (((tc/TB
    )/60)/60) % 60;
  String ab; 
  String bb;
  String cb;
  String db;
  if(a<10) {
    ab = "0"+a;
  }
  else {
    ab = Integer.toString(a);
  }
  if(b<10) {
    bb = "0"+b;
  }
  else {
    bb = Integer.toString(b);
  }
  if(c<10) {
    cb = "0"+c;
  }
  else {
    cb = Integer.toString(c);
  }
  if(d<10) {
    db = "0"+d;
  }
  else {
    db = Integer.toString(d);
  }
  return ab +":"+bb+":"+cb+";"+db;
}

int pulldown(int frames) {
  return floor((frames/29.97)*24);
}

float corrector(int dgen, int real) {
  return float(real - dgen) / float(real);
}

int correction(int d, float cor) {
  return ceil(d + (d * cor));
}

void fullKey(String ky, int tk) {
  String in1 = ky.substring(0,4);
  String in2 = ky.substring(4,8);
  String in3 = ky.substring(8,12);
  String in4 = ky.substring(13,15);

  String out1 = ky.substring(15,19);
  String out2 = ky.substring(19,23);
  String out3 = ky.substring(23,27);
  String out4 = ky.substring(28,30);

  rSt1[tk] = in1+" "+in2;
  fIR[tk] = (int(in3) * 20) + int(in4);
  fOR[tk] = (int(out3) * 20) + int(out4);

  if(fOR[tk]<fIR[tk]) {
    fOR[tk]+=200000;
  }

  fL[tk] = fOR[tk] - fIR[tk];
  cor[tk] = corrector(pulldown(dL[tk]),fL[tk]);
  fI[tk] = correction(pulldown(dI[tk]),cor[tk]);
  fO[tk] = correction(pulldown(dO[tk]),cor[tk]);
}

String dZero(int frames, int posta) {
  String checker = Integer.toString(frames);
  String pre = "";
  if(checker.length()<posta) {
    for(int c = checker.length();c<posta;c++) {
      pre += "0";
    }
  }
  return pre + checker;
}


void keyPressed() {

  if(key=='s') {
    filter(INVERT);
    String[] writer = new String[clips*4+5];
    writer[0] = "                             freeCode XML Cut List v0.6 alpha";
    writer[1] = " ";
    writer[2] = "                          CUT      FEET>0       LENGTH                  Final Cut Pro";
    for(int k = 0; k<clips; k++) {
      writer[k*4+3] = " ";
      writer[k*4+4] = pname[k];
      writer[k*4+5] = pI[k];
      writer[k*4+6] = pO[k];
    }
    writer[clips*4+3] = " ";
    writer[clips*4+4] = "          Generated using freeCode v0.6 alpha available from sixteenmillimeter.com";
    saveStrings("save.txt", writer);
    println("save");
  }
}

void mousePressed() {

  Ystore = mouseY;
  if(mouseX>670) {
    int Mstore = mouseY-YstoreL;
    //check mark maker
    int scheck = round((Mstore-3)/li)+1;
    int vcheck = round((scheck-5)/5);
    //println(scheck);
    if((scheck-5)%5==0) {
      if(brI[vcheck] =="[x]") {
        brI[vcheck] = "[ ]";
      }
      else {
        brI[vcheck] = "[x]";
      }
    }
    else if((scheck-6)%5==0) {
      if(brO[vcheck] =="[x]") {
        brO[vcheck] = "[ ]";
      }
      else {
        brO[vcheck] = "[x]";
      }
    }
  }
}

void mouseDragged() {
  if(clips*4+4>23) {
    scroll = true; 
    Y = YstoreL+(mouseY - Ystore);
    if(Y>17) {
      Y = 17;
    }
    if(Y<-((clips)*li)) {
      Y = -((clips)*li);
    }
  }
}

void mouseReleased() {
  YstoreL = Y;
}

//4place key decode
int keyFrom(String inner) {
  String[] keyer = split(inner, '+');
  return int(keyer[0]) * 20 + int(keyer[1]);
}
//feet decode
int feetFrom(String inner) {
  String[] footer = split(inner, '+');
  return int(footer[0]) * 40 + int(footer[1]);
}

