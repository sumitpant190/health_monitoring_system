#include <ESP8266WiFi.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <FirebaseESP8266.h>

#define FIREBASE_HOST "dummytesting-11f29-default-rtdb.asia-southeast1.firebasedatabase.app"
#define FIREBASE_AUTH "8vwDsEyOGivhanvnjIvZo1S7qMcrcfFYXOfJa5LI"
#define ONE_WIRE_BUS 4

const char* ssid = "nodemcu_fpkhr";
const char* password = "basaula12345";

FirebaseData firebaseData;
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

int DEV_NUM = 0;
int h = 0;
float tempC = 0.0;
int realBPM = 0;

const int pulsePin = A0;      // Pin connected to the PulseSensor
const int threshold = 550;    // Threshold value for peak detection
const int minInterval = 300;  // Minimum interval between consecutive peaks (in milliseconds)
int prevPeakTime = 0;         // Previous peak time
int bpm = 0;

const int chipID = ESP.getChipId();
const String HEART_VAL = String(chipID) + "/HEART_VALUE";
const String TEMP_VAL = String(chipID) + "/TEMP_VALUE";
const String NUM = String(chipID) + "/NUM";

void setup() {
  Serial.begin(9600);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  Serial.println("WiFi connected");
  Serial.println("IP address: " + WiFi.localIP().toString());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.setString(firebaseData, HEART_VAL, "60");
  Firebase.setString(firebaseData, TEMP_VAL, "25");
  Firebase.setInt(firebaseData, NUM, 0);
}

void loop() {
  Firebase.getInt(firebaseData, "/" + NUM, &DEV_NUM);
  Serial.println(DEV_NUM);
  if (DEV_NUM == 0) {
    Serial.println(".");
  } else {
    if (DEV_NUM == 1) {
      measureTemp();
    } else {
      if (DEV_NUM == 2) {
        //  ESP.wdtDisable();
        measureHeart();
        //  ESP.wdtEnable(WDTO_8S);

      } else if (DEV_NUM == 3) {
        measureHeart();
        measureTemp();
      }
    }
  }
  delay(500);
}

void measureHeart(void) {
  int count = 10;
  while (count > 0) {
    ESP.wdtDisable();
    int sensorValue = analogRead(pulsePin);

    // Check if a peak is detected
    if (sensorValue > threshold && millis() - prevPeakTime > minInterval) {
      // Calculate time duration between peaks
      int peakTime = millis();
      int interval = peakTime - prevPeakTime;

      // Update previous peak time
      prevPeakTime = peakTime;
      // Calculate BPM
      bpm = int(60.0 / (interval / 1000.0));
      Serial.println("Bpm is: ");
      Serial.println(bpm);
      if (bpm > 40 && bpm < 130) {
        Firebase.setString(firebaseData, HEART_VAL, String(bpm));
      }
      count--;
      ESP.wdtFeed();
    }
    //   delay(100);


  }  // Reset the watchdog timer

  //delay(3000);
}

void measureTemp() {
  sensors.requestTemperatures();  // read temperature data from temperature sensor
  tempC = sensors.getTempCByIndex(0);
  Serial.print("Temperature: ");
  Serial.print(tempC);
  Serial.println(" C");
  Firebase.setString(firebaseData, TEMP_VAL, String(tempC));
  //ESP.wdtFeed();  // Reset the watchdog timer
}
