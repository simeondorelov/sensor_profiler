#include <Sparki.h> // include the sparki library

int mode = 0;

void setup() {
  sparki.RGB(RGB_OFF);
  Serial.begin(11520);
}

void loop() {
  if (Serial.available()) {
    char input = (char) Serial.read();
    if (input == 'L') mode = 1;
    else if (input == 'A') mode = 2;
    else if (input == 'M') mode = 3;
    else if (input == 'U') mode = 4;
    else if (input == 'R') mode = 5;
    else if (input == 'F') mode = 6;
    else mode = 0;
  }
  switch(mode) {
    case 1: {
      int left   = sparki.lightLeft();
      int center = sparki.lightCenter();
      int right  = sparki.lightRight();
      Serial.print(left);
      Serial.print(",");
      Serial.print(center);
      Serial.print(",");
      Serial.println(right);
      break;
    }
    case 2: {
      float x = sparki.accelX();
      float y = sparki.accelY();
      float z  = sparki.accelZ();
      Serial.print(x);
      Serial.print(",");
      Serial.print(y);
      Serial.print(",");
      Serial.println(z);
      break;
    }
    case 3: {
      float x = sparki.magX();
      float y = sparki.magY();
      float z  = sparki.magZ();
      Serial.print(x);
      Serial.print(",");
      Serial.print(y);
      Serial.print(",");
      Serial.println(z);
      break;
    }
    case 4: {
      int cm = sparki.ping_single();
      delay(5);
      Serial.print(cm);
      Serial.print(",");
      Serial.print(cm);
      Serial.print(",");
      Serial.println(cm);
      break;
    }
    case 5: {
      int lineLeft = sparki.lineLeft();
      int lineCenter = sparki.lineCenter();
      int lineRight = sparki.lineRight();
      Serial.print(lineLeft);
      Serial.print(",");
      Serial.print(lineCenter);
      Serial.print(",");
      Serial.println(lineRight);
      break;
    }
    case 6: {
      int edgeLeft = sparki.edgeLeft();
      int edgeRight = sparki.edgeRight();
      delay(5);
      Serial.print(edgeLeft);
      Serial.print(",-1,");
      Serial.println(edgeRight);
      break;
    }
    default:
      break;
  }
}
