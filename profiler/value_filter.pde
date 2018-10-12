public interface ValueFilter {
  public float filterA(float raw_a);
  public float filterB(float raw_b);
  public float filterC(float raw_c);

  public void addCalibrationPoint(
      Float[] raw_a, Float[] raw_b, Float[] raw_c, 
      SetStats[] stats_a, SetStats[] stats_b, SetStats[] stats_c);

  public void reset();

  public Filter type();
}
