// SWiM: Lab06
#include <LiquidCrystal.h>

LiquidCrystal LCD(12, 11, 5, 4, 3, 2);
const int LCD_WIDTH = 16;
const int LCD_HEIGHT = 2;

const int PIR_PIN = 10;
const int TRIG_PIN = 8;
const int ECHO_PIN = 9;

void setup() {
  pinMode(PIR_PIN, INPUT);
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  digitalWrite(TRIG_PIN, LOW);

  LCD.begin(LCD_WIDTH, LCD_HEIGHT);
  LCD.clear();
}

bool dataChanged = true;
bool sensedMovement = false;
int sensedDistance = 0;

void updateLCD() {
  if(!dataChanged) return;
  dataChanged = false;

  LCD.setCursor(0, 0);
  if(sensedMovement) {
    LCD.print("ruch      ");
  } else {
    LCD.print("brak ruchu");
  }

  LCD.setCursor(0, 1);
  LCD.print("dist: ");
  if(sensedDistance <= 0) {
    LCD.print("OoR    ");
  } else {
    LCD.print(sensedDistance);
    LCD.print("cm   ");
  }
}

unsigned long lastMovementTime = 0;
unsigned long moveMessageTimeout = 2000;

void readMovement() {
  int reading = digitalRead(PIR_PIN);
  if(reading == HIGH && millis() - lastMovementTime > moveMessageTimeout) {
    lastMovementTime = millis();
  }
  if(lastMovementTime == 0 || millis() - lastMovementTime > moveMessageTimeout) {
    if(sensedMovement) dataChanged = true;
    sensedMovement = false;
  } else {
    if(!sensedMovement) dataChanged = true;
    sensedMovement = true;
  }
}

const double microsToDistanceRatio = 29.1*2;
const unsigned int upperDistanceLimit = 200;
const unsigned long measureTimeoutMicros = ceil(upperDistanceLimit * microsToDistanceRatio);

void readDistance() {
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);

  int duration = pulseIn(ECHO_PIN, HIGH, measureTimeoutMicros);
  sensedDistance = duration / microsToDistanceRatio;
  dataChanged = true;
}

void loop() {
  readMovement();
  readDistance();
  updateLCD();
}
