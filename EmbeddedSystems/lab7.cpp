// SWiM: Lab07
#define _USE_MATH_DEFINES
#include <cmath>
#include <SPI.h>
#include "LCD.h"
#include "DEV_Config.h"
#include "ADXL345.h"

ADXL345 accelerometer;

void setup() {
  // lcd initialisation
  pinMode(LCD_CS, OUTPUT);
  pinMode(LCD_RST, OUTPUT);
  pinMode(LCD_DC, OUTPUT);

  SPI.begin();
  SPI.beginTransaction(SPISettings(8000000, MSBFIRST, SPI_MODE0));

  LCD_SCAN_DIR Lcd_ScanDir = SCAN_DIR_DFT;
  LCD.LCD_Init(Lcd_ScanDir);
  LCD.LCD_Clear(BLACK);
  LCD.LCD_DisplayString(0, 6, "SWiM", &Font12, BLACK, YELLOW);
  //LCD.LCD_Show();   // for testing

  // accelerometer initialisation
  accelerometer.begin();
  accelerometer.setRange(ADXL345_RANGE_4G);
  Serial.begin(9600);
}

float points[4][3] = {
  {-0.5, -0.5, 0},
  {-0.5,  0.5, 0},
  { 0.5,  0.5, 0},
  { 0.5, -0.5, 0},
};

float rotated[4][3] = {
  {0, 0, 0},
  {0, 0, 0},
  {0, 0, 0},
  {0, 0, 0},
};

const int POINTS_OFFSET_X = 40;
const int POINTS_OFFSET_Y = 40;
const float POINTS_SCALE = 60;

void drawPoints(COLOR c) {
  for(int i=0; i<4; ++i) {
    int next = i+1;
    if(next == 4) next = 0;
    LCD_DrawLine(rotated[i][0], rotated[i][1], rotated[next][0], rotated[next][1], c, LINE_SOLID, DOT_PIXEL_1X1);
  }
}

void rotatePoints(float pitch, float roll, float yaw) {
  // transform
  float cosPitch = cos(pitch);
  float cosRoll = cos(roll);
  float cosYaw = cos(yaw);
  float sinPitch = sin(pitch);
  float sinRoll = sin(roll);
  float sinYaw = sin(yaw);
  for(int i=0; i<4; ++i) {
    rotated[i][0] = points[i][0];
    rotated[i][1] = cosPitch*points[i][1] - sinPitch*points[i][2];
    rotated[i][2] = sinPitch*points[i][1] + cosPitch*points[i][2];

    float temp = cosRoll*rotated[i][0] + sinRoll*rotated[i][2];
    rotated[i][2] = -sinRoll*rotated[i][0] + cosRoll*rotated[i][2];
    rotated[i][0] = temp;

    temp = cosYaw*rotated[i][0] - sinYaw*rotated[i][1];
    rotated[i][1] = sinYaw*rotated[i][0] + cosYaw*rotated[i][1];
    rotated[i][0] = temp;

    // scale
    for(int j=0; j<3; ++j) {
        rotated[i][j] *= POINTS_SCALE;
    }

    // transform
    rotated[i][0] += POINTS_OFFSET_X;
    rotated[i][1] += POINTS_OFFSET_Y;
  }
}

void drawFrame(float pitch, float roll, float yaw) {
    drawPoints(BLACK);
    rotatePoints(pitch, roll, yaw);
    drawPoints(YELLOW);
}

const int LINE_COUNT = 3;
const int LINE_LENGTH = 22;
char buffer[LINE_COUNT][LINE_LENGTH];
const int LINE_HEIGHT = 16;
const int START_Y = 22;

void loop() {
  Vector norm = accelerometer.readNormalize();
  Vector filtered = accelerometer.lowPassFilter(norm, 0.15);

  Serial.print ("ax = ");
  Serial.print(filtered.XAxis);
  Serial.print (", ay = ");
  Serial.print(filtered.YAxis);
  Serial.print (", az = ");
  Serial.print(filtered.ZAxis);

  float pitch = atan(filtered.XAxis/sqrt(filtered.YAxis*filtered.YAxis + filtered.ZAxis*filtered.ZAxis))*180/M_PI;
  float roll =  atan(filtered.YAxis/sqrt(filtered.XAxis*filtered.XAxis + filtered.ZAxis*filtered.ZAxis))*180/M_PI;
  float yaw =   atan(filtered.ZAxis/sqrt(filtered.XAxis*filtered.XAxis + filtered.ZAxis*filtered.ZAxis))*180/M_PI;  // ZAxis might need to be changed

  Serial.print (", pitch = ");
  Serial.print(pitch);
  Serial.print (", roll = ");
  Serial.print(roll);
  Serial.print (", yaw = ");
  Serial.println(yaw);

  // drawFrame(pitch, roll, yaw);  // only when everything will be working

  int iPitch = pitch;
  int iRoll = roll;
  int iYaw = yaw;
  char numbuff[10];
  dtostrf(filtered.XAxis, 1, 2, numbuff);
  sprintf(buffer[0], "x: %d %-6s", iPitch, numbuff);
  dtostrf(filtered.YAxis, 1, 2, numbuff);
  sprintf(buffer[1], "y: %d %-6s", iRoll, numbuff);
  dtostrf(filtered.ZAxis, 1, 2, numbuff);
  sprintf(buffer[2], "z: %d %-6s", iYaw, numbuff);
  for(int i=0; i<LINE_COUNT; ++i) {
    LCD.LCD_DisplayString(0, START_Y + i*LINE_HEIGHT, buffer[i], &Font12, BLACK, YELLOW);
  }

  delay(100);   // might not be needed
}

