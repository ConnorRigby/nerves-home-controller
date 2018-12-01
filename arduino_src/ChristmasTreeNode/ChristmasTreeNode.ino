// Enable debug prints to serial monitor
#define MY_DEBUG 

// Enable and select radio type attached
#define MY_RADIO_NRF24
//#define MY_RADIO_RFM69

// Enabled repeater feature for this node
#define MY_REPEATER_FEATURE

#include <Adafruit_NeoPixel.h>
#include <SPI.h>
#include <MySensors.h>

#define PIXEL_PIN    6    // Digital IO pin connected to the NeoPixels.
#define PIXEL_COUNT (16 + 35) * 2

Adafruit_NeoPixel strip = Adafruit_NeoPixel(PIXEL_COUNT, PIXEL_PIN, NEO_GRB + NEO_KHZ800);

void setup()  
{  
  strip.begin();
  strip.show();
}

void presentation()  {
  // Send the sketch version information to the gateway and Controller
  sendSketchInfo("Christmas Tree", "1.0");
  for(int i = 0; i<PIXEL_COUNT; i++)
    present(i, S_RGB_LIGHT);
}

/*
*  Example on how to asynchronously check for new messages from gw
*/
void loop() 
{
} 
 
void receive(const MyMessage &message) {
  if(message.type == V_RGB) {
    int32_t color = message.getLong();
    strip.setPixelColor(message.sensor, color);
    strip.show();
    Serial.print("got color change for sensor=");
    Serial.print(message.sensor);
    Serial.print(" color=");
    Serial.println(color);
  }
}
