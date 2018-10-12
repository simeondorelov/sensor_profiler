// The types of bar graph displays supported.
enum BarType {
  BASELINE, MIDPOINT;
}

enum Axis {
  A, B, C;
}

// The types of values used in the system.
enum ValueType {
  RAW, MEAN, MEDIAN, MIN, MAX, STD_DEV, MAX_DEV;
   
  // Helper method for cycling through the enum values.
  public ValueType next() {
      return vals[(this.ordinal() + 1) % vals.length];
  }
  
  public String HumanReadableName() {
      return human_readable_names_[(this.ordinal())];
  }
  
  public static int count() {
    return vals.length;
  }
  
  private final static ValueType[] vals = values();
  private final static String[] human_readable_names_ = new String[] {
    "Raw", "Mean", "Median", "Min", "Max", "Std Dev", "Max Dev"
  };
}

// Definitions for all supported sensors.
enum Sensor {
  LIGHT, ACCEL, MAGNT, DIST, LINE_I, LINE_O;
  
  public Sensor next()
  {
      return vals[(this.ordinal() + 1) % vals.length];
  }
  
  public float axisMin() {
    return mins_[this.ordinal()];
  }
  
  public float axisMax() {
    return maxs_[this.ordinal()];
  }
  
  public String[] axisNames() {
    return axis_names_[this.ordinal()];
  }
  
  public char sensorCharId() {
    return char_ids_[this.ordinal()];
  }
  
  public BarType barType() {
    return bar_types_[this.ordinal()];
  }
  
  private static final Sensor[] vals = values();
  private static final float[] mins_ = 
      new float[]{0.0, -24.0, -1000.0, -2.0, 0.0, 0.0};
  private static final float[] maxs_ = 
      new float[]{1000.0, 24.0, 1000.0, 200, 1000.0, 1000.0};
  private static final String[][] axis_names_ = 
      new String[][]{
        {"Left", "Center", "Right"},
        {"X-Axis", "Y-Axis", "Z-Axis"},
        {"X-Axis", "Y-Axis", "Z-Axis"},
        {"Dist", "Dist", "Dist"},
        {"Left", "Center", "Right"},
        {"Left", "___", "Right"},
      };
  private static final char[] char_ids_ = 
      new char[] {'L', 'A', 'M', 'U', 'R', 'F'};
  private static final BarType[] bar_types_ = new BarType[] {
    BarType.BASELINE, BarType.MIDPOINT, BarType.MIDPOINT, BarType.BASELINE, 
    BarType.BASELINE, BarType.BASELINE
  };
}

enum Filter {
  NONE, CONST_OFF, ACCEL_CAL;

  // Helper method for cycling through the enum values.
  public Filter next() {
      return vals[(this.ordinal() + 1) % vals.length];
  }
  
  private final static Filter[] vals = values();
}
