public static class ProfilerUtils {
  public static float mapValues(
      float value, 
      float source_min, float source_max, 
      float target_min, float target_max) {
    float slope = (target_max - target_min) / (source_max - source_min);
    float output = target_min + slope * (value - source_min);
    return output;
  }
}
