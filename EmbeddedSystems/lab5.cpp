// SWiM: Lab05
#include <LiquidCrystal.h>
#include <TimerOne.h>

LiquidCrystal LCD(12, 11, 7, 6, 5, 4);
const int LCD_WIDTH = 16;
const int LCD_HEIGHT = 2;

const int SW1_PIN = 8;
const int SW2_PIN = 2;

void setup() {
  pinMode(SW1_PIN, INPUT_PULLUP);
  pinMode(SW2_PIN, INPUT_PULLUP);

  Timer1.initialize(500000);  // 0.5s in microseconds

  LCD.begin(LCD_WIDTH, LCD_HEIGHT);
  LCD.clear();
  LCD.setCursor(0, 0);

  readValue();
  setTimer();
}

volatile bool dataChanged = true;
volatile double value;
volatile bool usesTimer = false;

void updateLCD() {
  if(!dataChanged) return;
  dataChanged = false;

  LCD.setCursor(0, 0);
  LCD.print("A5 [V]: ");
  LCD.print(value);
  LCD.setCursor(0, 1);
  if(usesTimer) {
    LCD.print("Timer mode ");
  } else {
    LCD.print("Button mode");
  }
}

void readValue() {
  value = analogRead(A5)/1024.0 * 5;
  dataChanged = true;
}

void setManual() {
  usesTimer = false;
  Timer1.detachInterrupt();
  attachInterrupt(digitalPinToInterrupt(SW2_PIN), readValue, FALLING);
  dataChanged = true;
}

void setTimer() {
  usesTimer = true;
  detachInterrupt(digitalPinToInterrupt(SW2_PIN));
  Timer1.attachInterrupt(readValue);
  dataChanged = true;
}

int buttonState;
int lastButtonState;
unsigned long lastDebounceTime = 0;
const unsigned long debounceDelay = 50;

void onPress() {
  if(usesTimer) {
    setManual();
  } else {
    setTimer();
  }
}

void readButton() {
  int reading = digitalRead(SW1_PIN);
 
  if (reading != lastButtonState) {
    lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (reading != buttonState) {
      buttonState = reading;

      if (buttonState == LOW) {
        onPress();
      }
    }
  }

  lastButtonState = reading;
}

void loop() {
  readButton();
  updateLCD();
}
