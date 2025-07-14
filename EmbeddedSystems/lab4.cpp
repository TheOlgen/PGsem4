// SWiM: Lab04
#include <LiquidCrystal.h>
#include <i2c_BMP280.h>

LiquidCrystal LCD(12, 11, 5, 4, 3, 2);
BMP280 bmp280;

const int LCD_WIDTH = 16;
const int LCD_HEIGHT = 2;

const char DEGREE_SYM = 223;

bool initialized_bmp280 = false;

void setup() {
  LCD.begin(LCD_WIDTH, LCD_HEIGHT);
  LCD.clear();

  if(!bmp280.initialize()) {
    LCD.write("Failed to init!!");
    return;
  }
  initialized_bmp280 = true;

  LCD.setCursor(0, 0);
  LCD.write("Hello World!");

}

char buffer[LCD_HEIGHT][LCD_WIDTH+1];

void updateMeasures() {
  if(!initialized_bmp280) return;

  bmp280.awaitMeasurement();
  float pressure;
  float temperature;
  bmp280.getPressure(pressure);
  bmp280.getTemperature(temperature);

  char numbuff[10];
  dtostrf(pressure, 1, 2, numbuff);
  sprintf(buffer[0], "psi [Pa]: %-6s", numbuff);
  dtostrf(temperature, 1, 2, numbuff);
  sprintf(buffer[1], "tmp [%cC]: %-6s", DEGREE_SYM, numbuff);

  for(int i=0; i<LCD_HEIGHT; ++i) {
    LCD.setCursor(0, i);
    LCD.print(buffer[i]);
  }
}

const long measureUpdateInterval = 1000;
long lastMeasureUpdate = millis();

void loop() {
  if(millis() - lastMeasureUpdate > measureUpdateInterval) {
    lastMeasureUpdate = millis();
    updateMeasures();
  }
}

