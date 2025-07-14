// SWiM: Lab01
const int ledPins[] = {8, 9, 10};
const int buttonPins[] = {2, 3, 4};
const unsigned long debounceDelay = 50;    // the debounce time; increase if the output flickers
const int ledCount = sizeof(ledPins)/sizeof(ledPins[0]);
const int buttonCount = sizeof(buttonPins)/sizeof(buttonPins[0]);

int ledStates[ledCount];
int buttonStates[buttonCount];
int lastButtonStates[buttonCount];
unsigned long lastDebounceTimes[buttonCount] = {0};

void onPress(int buttonPin) {
  switch (buttonPin) {
  case 2:
    ledStates[0] = !ledStates[0];
    break;
  case 3:
    ledStates[1] = !ledStates[1];
    break;
  case 4:
    ledStates[2] = !ledStates[2];
    break;
  }
}

void setup() {
  for (int i = 0; i < ledCount; ++i) {
    pinMode(ledPins[i], OUTPUT);
    ledStates[i] = LOW;
    digitalWrite(ledPins[i], ledStates[i]);
  }

  for (int i = 0; i < buttonCount; ++i) {
    pinMode(buttonPins[i], INPUT_PULLUP);
    buttonStates[i] = LOW;
    lastButtonStates[i] = LOW;
  }
}

void loop() {
  for (int i = 0; i < buttonCount; ++i) {
    int reading = digitalRead(buttonPins[i]);

    if (reading != lastButtonStates[i]) {
      lastDebounceTimes[i] = millis();
    }

    // Debounce based on https://docs.arduino.cc/built-in-examples/digital/Debounce/
    if ((millis() - lastDebounceTimes[i]) > debounceDelay) {
      if (reading != buttonStates[i]) {
        buttonStates[i] = reading;

        if (buttonStates[i] == LOW) {
          onPress(buttonPins[i]);
        }
      }
    }

    digitalWrite(ledPins[i], ledStates[i]);

    lastButtonStates[i] = reading;
  }
}
