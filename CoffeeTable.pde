 import ddf.minim.analysis.*;
import ddf.minim.*;
import processing.serial.*;
Minim minim;
FFT fft;
AudioInput in;
float[] angle;
float[] y, x;
int frameheight = 8; // set to height of frame (y)
int framewidth = 34; // set to width of frame (x)
Serial port;

void setup() {
  size(framewidth,frameheight,P3D);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 2048, 192000.0);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  y = new float[fft.specSize()];
  x = new float[fft.specSize()];
  angle = new float[fft.specSize()];
  
  frameRate(30);
  port = new Serial(this,"/dev/cu.usbmodem35131", 115200);
  
}
 
void draw() {
  background(0);
  fft.forward(in.mix);
  //doubleAtomicSprocket();
  spectrumanal();
   
  for (int i=0;i<framewidth;i++) {
    for (int j=0;j<frameheight;j++) {
      color c=get(i,j);
      if (red(c)+blue(c)+green(c)>0) {
          writeToSerialPort((i*frameheight+j), int(red(c)), int(blue(c)), int(green(c))); //if the color is
      }                                                                                   //not black
      else{
        if (random(1000)>900) {
            writeToSerialPort((i*frameheight+j),0,0,0); // Fades out LEDs
        }
      }
    }
  }  
  writeToSerialPort(-1,0,0,0); // Send command to update leds
}

void writeToSerialPort(int pos, int red, int green, int blue) {   // function for sending pixels to Teensy
        port.write(str(pos));
        port.write(",");
        port.write(str(red));
        port.write(",");
        port.write(str(green));
        port.write(",");
        port.write(str(blue));
        port.write("\n");
}

void doubleAtomicSprocket() {  // This section written by Benjamin Farahmand http://www.benfarahmand.com/
  noStroke();
  pushMatrix();
  translate(width/2, height/2);
  for (int i = 0; i < fft.specSize() ; i++) {
    y[i] = y[i] + fft.getBand(i)/100;
    x[i] = x[i] + fft.getFreq(i)/20;
    angle[i] = angle[i] + fft.getFreq(i)/2000;
    rotateX(sin(angle[i]/2));
    rotateY(cos(angle[i]/2));
    //    stroke(fft.getFreq(i)*2,0,fft.getBand(i)*2);
    fill(fft.getFreq(i)*1.5, 0, fft.getBand(i)*1);
    pushMatrix();
    translate((x[i]+50)%width/3, (y[i]+50)%height/3);
    box(fft.getBand(i)/20+fft.getFreq(i)/15);
    popMatrix();
  }
  popMatrix();
  pushMatrix();
  translate(width/2, height/2, 0);
  for (int i = 0; i < fft.specSize() ; i++) {
    y[i] = y[i] + fft.getBand(i)/200;
    x[i] = x[i] + fft.getFreq(i)/10;
    angle[i] = angle[i] + fft.getFreq(i)/100000;
    rotateX(sin(angle[i]/2));
    rotateY(cos(angle[i]/2));
    //    stroke(fft.getFreq(i)*2,0,fft.getBand(i)*2);
    fill(0, 255-fft.getFreq(i)*1, 255-fft.getBand(i)*1);
    pushMatrix();
    translate((x[i]+250)%width, (y[i]+250)%height);
    box(fft.getBand(i)/20+fft.getFreq(i)/15);
    popMatrix();
  }
  popMatrix();
  
    pushMatrix();
  translate(width/2, height/2, 0);
  for (int i = 0; i < fft.specSize() ; i++) {
    y[i] = y[i] + fft.getBand(i)/80;
    x[i] = x[i] + fft.getFreq(i)/40;
    angle[i] = angle[i] + fft.getFreq(i)/100000;
    rotateX(sin(angle[i]/2));
    rotateY(cos(angle[i]/2));
    //    stroke(fft.getFreq(i)*2,0,fft.getBand(i)*2);
    fill(fft.getFreq(i)*3, fft.getBand(i)*1.5,0);
    pushMatrix();
    translate((x[i]+100)%width, (y[i]+100)%height);
    box(fft.getBand(i)/20+fft.getFreq(i)/15);
    popMatrix();
  }
  popMatrix();
}

void spectrumanal()
{
  int band = fft.specSize()/34;
  for(int i = 0; i < 34; i++)
  {
    if (fft.getBand(band * i) <= 3){
      stroke(0,0,255);
    }
    else if (fft.getBand(band * i) <=6 && fft.getBand(band * i) > 3){
      stroke(255,0,255);
    }
    else if (fft.getBand(band * i) > 6){
      stroke(255,0,0);
    } 
    line( i + 1, height, i + 1, height - fft.getBand(band * i));
  }
}
 //<>//

void stop(){
  // always close Minim audio classes when you finish with them
  minim.stop();
 
  super.stop();
}
