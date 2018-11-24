#define MY_DEBUG
#define MY_RADIO_RFM69
#define MY_RFM69_NEW_DRIVER
#define MY_OTA_FIRMWARE_FEATURE
#define MY_REPEATER_FEATURE
#include <MySensors.h>
#include <DHT.h>

// Set this to the pin you connected the DHT's data pin to
#define DHT_DATA_PIN 4
#define LHT_DATA_PIN A0

// Set this offset if the sensor has a permanent small offset to the real temperatures.
// In Celsius degrees (as measured by the device)
#define SENSOR_TEMP_OFFSET 0

// Sleep time between sensor updates (in milliseconds)
// Must be >1000ms for DHT22 and >2000ms for DHT11
static const uint64_t UPDATE_INTERVAL = 15000;

// Force sending an update of the temperature after n sensor reads, so a controller showing the
// timestamp of the last update doesn't show something like 3 hours in the unlikely case, that
// the value didn't change since;
// i.e. the sensor would force sending an update every UPDATE_INTERVAL*FORCE_UPDATE_N_READS [ms]
static const uint8_t FORCE_UPDATE_N_READS = 10;

int   lastLht;
float lastTemp;
float lastHum;

uint8_t nNoUpdatesLht;
uint8_t nNoUpdatesTemp;
uint8_t nNoUpdatesHum;
bool metric = true;

#define CHILD_ID_LIGHT_INTENSITY 0
#define CHILD_ID_HUM 1
#define CHILD_ID_TEMP 2

MyMessage msgLight(CHILD_ID_LIGHT_INTENSITY, V_LIGHT_LEVEL);
MyMessage msgHum(CHILD_ID_HUM, V_HUM);
MyMessage msgTemp(CHILD_ID_TEMP, V_TEMP);

DHT dht;

void before()
{
}

void presentation()
{
  // Send the sketch version information to the gateway and Controller
  sendSketchInfo("TurtleLightTempHum", "1.0");
  present(CHILD_ID_LIGHT_INTENSITY, S_LIGHT_LEVEL);
  present(CHILD_ID_HUM, S_HUM);
  present(CHILD_ID_TEMP, S_TEMP);
  metric = getControllerConfig().isMetric;
}

void setup()
{
  dht.setup(DHT_DATA_PIN, DHT::DHT11); // set data pin of DHT sensor
  if (UPDATE_INTERVAL <= dht.getMinimumSamplingPeriod()) {
    Serial.println("Warning: UPDATE_INTERVAL is smaller than supported by the sensor!");
  }
  // Sleep for the time of the minimum sampling period to give the sensor time to power up
  // (otherwise, timeout errors might occure for the first reading)
  sleep(dht.getMinimumSamplingPeriod());
}

void loop()
{
  int lht = analogRead(LHT_DATA_PIN);
  if(outsideThreshold(lht, lastLht, 10) || nNoUpdatesLht == FORCE_UPDATE_N_READS) {
    nNoUpdatesLht = 0;
    send(msgLight.set(lht, 1));
    #ifdef MY_DEBUG
    Serial.print("L: ");
    Serial.println(lht);
    #endif
  } else {
    nNoUpdatesLht++;
  }
  lastLht = lht;
  
  // Force reading sensor, so it works also after sleep()
  dht.readSensor(true);
  
  // Get temperature from DHT library
  float temperature = dht.getTemperature();
  if (isnan(temperature)) {
    Serial.println("Failed reading temperature from DHT!");
  } else if (temperature != lastTemp || nNoUpdatesTemp == FORCE_UPDATE_N_READS) {
    // Only send temperature if it changed since the last measurement or if we didn't send an update for n times
    lastTemp = temperature;

    // apply the offset before converting to something different than Celsius degrees
    temperature += SENSOR_TEMP_OFFSET;

    if (!metric) {
      temperature = dht.toFahrenheit(temperature);
    }
    // Reset no updates counter
    nNoUpdatesTemp = 0;
    send(msgTemp.set(temperature, 1));

    #ifdef MY_DEBUG
    Serial.print("T: ");
    Serial.println(temperature);
    #endif
  } else {
    // Increase no update counter if the temperature stayed the same
    nNoUpdatesTemp++;
  }

  // Get humidity from DHT library
  float humidity = dht.getHumidity();
  if (isnan(humidity)) {
    Serial.println("Failed reading humidity from DHT");
  } else if (humidity != lastHum || nNoUpdatesHum == FORCE_UPDATE_N_READS) {
    // Only send humidity if it changed since the last measurement or if we didn't send an update for n times
    lastHum = humidity;
    // Reset no updates counter
    nNoUpdatesHum = 0;
    send(msgHum.set(humidity, 1));
    
    #ifdef MY_DEBUG
    Serial.print("H: ");
    Serial.println(humidity);
    #endif
  } else {
    // Increase no update counter if the humidity stayed the same
    nNoUpdatesHum++;
  }

  // Sleep for a while to save energy
  sleep(UPDATE_INTERVAL); 
}

void receive(const MyMessage &message)
{
}

bool outsideThreshold(int current, int old, int thresh)
{
  return abs(old - current) > thresh;
}

