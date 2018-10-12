import processing.serial.*;

Serial myPort;
int LINE_FEED = 10;
boolean frame_rate_limit = true;
boolean serial_port_selected = false;
boolean save_next_frame = false;
String error_message = null;

DrawingUtil drawer = new DrawingUtil(this);

VisualizerConfig config = new VisualizerConfig();
Visualizer visualizer = new Visualizer(config, drawer);

void setup() 
{
  size(1300, 800);
  frameRate(frame_rate_limit ? 60 : 240);
  surface.setResizable(true);
}

void draw() {
  if (!serial_port_selected) {
    drawer.clear();
    drawer.drawMenu(650, 400, getSerialPortsList());
    if (error_message != null) {
      drawer.drawMessage(error_message);
    }
    return;
  }
  visualizer.periodicUpdate();
  visualizer.drawVisualizerFrame();

  if (save_next_frame) {
    saveFrame("profiler-######.jpg");
    save_next_frame = false;
  }
}

void keyPressed() {
  if (key == 'h') config.toggleHelpMenu();
  // Scaling options.
  else if (key == 'm') config.toggleScaling();
  else if (key == 'a') config.toggleScalingAggregation();
  else if (key == 'v') config.changePlotValueType();
  // Sample size adjustment.
  else if (key == '[') config.decrementSampleSize();
  else if (key == ']') config.incrementSampleSize();
  // Sensor selection.
  else if (key == 's') {
    config.changeSensor();
    if (myPort != null) myPort.write(config.CurrentSensor().sensorCharId());
  }
  else if (key == 'f') config.changeFilter();
  else if (key == 'e') config.toggleFilter();
  else if (key == 'c') visualizer.calibrateFilter();
  else if (key == 'r') visualizer.resetFilter();
  // Pause or screenshot the data display.
  else if (key =='p') config.toggleDisplayPause();
  else if (key == 'z') save_next_frame = true;
  // Increase plot size.
  else if (key == '-') config.decrementGraphScreenRatio();
  else if (key == '=') config.incrementGraphScreenRatio();
  // Alter the size of the plotter's data points.
  else if (key == ';') config.decrementPlotPointSize();
  else if (key == '\'') config.incrementPlotPointSize();
  // Enables / disables the frame rate limiter.
  else if (key == 'l') {
    frame_rate_limit = !frame_rate_limit;
    frameRate(frame_rate_limit ? 60 : 240);
  }
  // Number inputs.
  else if(key >= '0' && key <= '9') {
    int key_val = ((int) key - (int) '0');
    if (!serial_port_selected) {
      if (initSerial(key_val)) {
        serial_port_selected = true;
      }
    }
  }
}

void serialEvent(Serial port) {
  try {
    String data = port.readString().trim();
    // TODO(simeondorelov): Remove snippet below once we fix the sparki itself.
    if (data.charAt(data.length() - 1) == ',') {
      data = data.substring(0, data.length() - 1);
    }
    visualizer.serialDataReceived(data);
  } catch (Exception e) {
    System.out.println(e.toString());
  }
}

String getSerialPortsList() {
  String[] ports = Serial.list();
  String output = "Use the number keys to select the serial port to use.\n"; 
  
  output += "Serial Ports Available:\n\n";

  for (int i = 0; i < ports.length; i++) {
    output += String.format(" [ %d ]:   %s\n", i, ports[i]);
  }
  if (ports.length == 0) output += "no ports found";

  return output;
}

boolean initSerial(int port_id) {
  String[] ports = Serial.list();
  
  if (port_id < 0 || port_id >= ports.length) {
    error_message = "Serial Init: Invalid port id.";
    return false;
  }
  
  try {
    myPort = new Serial(this, ports[port_id], 11520);
    myPort.bufferUntil(LINE_FEED);
    myPort.write(config.CurrentSensor().sensorCharId());
  }  catch (Exception e) {
    error_message = "Serial Init: " + e.getMessage();
    return false;
  }
  
  return true;
}
