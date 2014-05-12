#include <OctoWS2811.h>

const int ledsPerStrip = 34;

DMAMEM int displayMemory[ledsPerStrip*6];
int drawingMemory[ledsPerStrip*6];


const int config = WS2811_GRB | WS2811_800kHz;

OctoWS2811 leds(ledsPerStrip, displayMemory, drawingMemory, config);

void setup() {
  Serial.begin(115200);
  leds.begin();
  leds.show();

}


void loop() {
  while (Serial.available() > 0) {
  
   int pos = Serial.parseInt(); 
   int red = Serial.parseInt(); 
   int green = Serial.parseInt(); 
   int blue = Serial.parseInt(); 
   if (Serial.read() == '\n') {
     Serial.println(pos);
     if (pos == -1){
       lightupdate();
     }
   leds.setPixel(pos, blue+256*(red+256*green));
   }
  }
}



void lightupdate() {
    leds.show();
    for (int i=0; i < leds.numPixels(); i++) {
     //leds.setPixel(i, 0);
    }
}
