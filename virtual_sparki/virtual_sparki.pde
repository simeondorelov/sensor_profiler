import processing.serial.*;
Serial myPort;

char mode = 'L';

void setup() {
  myPort = new Serial(this, "COM13", 11520);
}

void draw() {
  if (myPort.available() > 0) {
    mode = (char) myPort.read();
  }
  
  if (mode == 'L') {
     float a = 400 + random(50);
    float b = 500 + random(50);
    float c = 700 + random(50);
    myPort.write(String.format("%f,%f,%f\n", a, b, c));
  } else if (mode == 'A') {
     float a = random(48) - 24.0;
    float b = random(48) - 24.0;
    float c = random(48) - 24.0;
    myPort.write(String.format("%f,%f,%f\n", a, b, c));
  } else {
    myPort.write("400,500,600\n");
  }
  delay(4);
}
