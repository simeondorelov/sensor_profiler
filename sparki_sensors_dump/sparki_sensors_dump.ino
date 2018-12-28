#include <Sparki.h> // include the sparki library

int sensor_select = 1;

void DumpSensorData(Stream&, int); 

void setup() {
  sparki.RGB(RGB_OFF);
  Serial1.begin(9600);
  
  sparki.onIR();
}

void loop() {
  if (Serial1.available()) {
    char input = (char) Serial1.read();
    if (input == 'L') sensor_select = 1;
    else if (input == 'A') sensor_select = 2;
    else if (input == 'M') sensor_select = 3;
    else if (input == 'U') sensor_select = 4;
    else if (input == 'R') sensor_select = 5;
    else if (input == 'F') sensor_select = 7;
    else if (input == 'G') {
      sparki.moveForward();
    }
    else if (input == 'S') {
      sparki.moveStop();
    }
    else sensor_select = 0;
  }

  DumpSensorData(Serial1, sensor_select);
}

void DumpSensorData(Stream& output, int  sensor) {
    switch(sensor) {
    case 1: {
      int left   = sparki.lightLeft();
      int center = sparki.lightCenter();
      int right  = sparki.lightRight();
      output.print(left);
      output.print(",");
      output.print(center);
      output.print(",");
      output.println(right);
      break;
    }
    #ifndef NO_ACCEL
    case 2: {
      float x = sparki.accelX();
      float y = sparki.accelY();
      float z  = sparki.accelZ();
      output.print(x);
      output.print(",");
      output.print(y);
      output.print(",");
      output.println(z);
      break;
    }
    #endif
    #ifndef NO_MAG
    case 3: {
      float x = sparki.magX();
      float y = sparki.magY();
      float z  = sparki.magZ();
      output.print(x);
      output.print(",");
      output.print(y);
      output.print(",");
      output.println(z);
      break;
    }
    #endif
    case 4: {
      int cm = sparki.ping_single();
      delay(5);
      output.print(cm);
      output.print(",");
      output.print(cm);
      output.print(",");
      output.println(cm);
      break;
    }
    case 5: {
      int lineLeft = sparki.lineLeft();
      int lineCenter = sparki.lineCenter();
      int lineRight = sparki.lineRight();
      output.print(lineLeft);
      output.print(",");
      output.print(lineCenter);
      output.print(",");
      output.println(lineRight);
      break;
    }
    case 6: {
      int edgeLeft = sparki.edgeLeft();
      int edgeRight = sparki.edgeRight();
      delay(5);
      output.print(edgeLeft);
      output.print(",-1,");
      output.println(edgeRight);
      break;
    }
    case 7: {
      int lineLeft = sparki.lineLeft();
      int lineCenter = sparki.lineCenter();
      int lineRight = sparki.lineRight();
      int center = (lineLeft + lineCenter + lineRight) / 3;
      int edgeLeft = sparki.edgeLeft();
      int edgeRight = sparki.edgeRight();
      //delay(5);
      output.print(edgeLeft);
      output.print(",");
      output.print(center);
      output.print(",");
      output.println(edgeRight);
      break;
    }
    default:
      break;
  }
}

