public class ConstOffsetCalibration implements ValueFilter {
  public float filterA(float raw_a) {
    return raw_a + offset_a_;
  }
  public float filterB(float raw_b) {
    return raw_b + offset_b_;
  }
  public float filterC(float raw_c) {
    return raw_c + offset_c_;
  }

  public void addCalibrationPoint(
      Float[] raw_a, Float[] raw_b, Float[] raw_c, 
      SetStats[] stats_a, SetStats[] stats_b, SetStats[] stats_c) {
    double mean_a = stats_a[stats_a.length - 1].getStat(ValueType.MEAN);
    double mean_b = stats_b[stats_b.length - 1].getStat(ValueType.MEAN);
    double mean_c = stats_c[stats_c.length - 1].getStat(ValueType.MEAN);
    double abs_mean = (mean_a + mean_b + mean_c) / 3;
    offset_a_ = (float) (abs_mean - mean_a);
    offset_b_ = (float) (abs_mean - mean_b);
    offset_c_ = (float) (abs_mean - mean_c);
  }

  public void reset() {
    offset_a_ = 0.0;
    offset_c_ = 0.0;
    offset_c_ = 0.0;
  }

  public Filter type() { return Filter.CONST_OFF; }
  
  private float offset_a_ = 0.0;
  private float offset_b_ = 0.0;
  private float offset_c_ = 0.0;
}
