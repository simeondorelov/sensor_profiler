public class AccelCalibration implements ValueFilter {
  public float filterA(float raw_a) {
    return raw_a + getOffset(offset_sum_a_);
  }
  public float filterB(float raw_b) {
    return raw_b + getOffset(offset_sum_b_);
  }
  public float filterC(float raw_c) {
    return raw_c + getOffset(offset_sum_c_);
  }

  public void addCalibrationPoint(
      Float[] raw_a, Float[] raw_b, Float[] raw_c, 
      SetStats[] stats_a, SetStats[] stats_b, SetStats[] stats_c) {
    double mean_a = stats_a[stats_a.length - 1].getStat(ValueType.MEAN);
    double mean_b = stats_b[stats_b.length - 1].getStat(ValueType.MEAN);
    double mean_c = stats_c[stats_c.length - 1].getStat(ValueType.MEAN);
    offset_sum_a_ += (float) determineOffset(mean_a);
    offset_sum_b_ += (float) determineOffset(mean_b);
    offset_sum_c_ += (float) determineOffset(mean_c);
    calibration_points_count_++;

    System.out.println(offset_sum_a_);
    System.out.println(offset_sum_b_);
    System.out.println(offset_sum_c_);
    System.out.println(calibration_points_count_);
  }

  public void reset() {
    calibration_points_count_ = 0;
    offset_sum_a_ = 0.0;
    offset_sum_b_ = 0.0;
    offset_sum_c_ = 0.0;
  }

  public Filter type() { return Filter.ACCEL_CAL; }

  private double determineOffset(double mean) {
    double abs_mean = Math.abs(mean);

    if (abs_mean >= 0 && abs_mean <= 1.5) {
      if (mean < 0) return abs_mean;
      else return abs_mean * -1.0;
    }
    if (abs_mean >= 8.3 && abs_mean <= 11.2) {
      double offset = abs_mean - 9.8;
      if (mean < 0) return offset;
      else return offset * -1.0;
    }
    return 0.0;
  }

  private float getOffset(float offset_sum) {
    if (calibration_points_count_ == 0) return 0.0;
    return offset_sum / calibration_points_count_;
  }
  
  private int calibration_points_count_ = 0;
  private float offset_sum_a_ = 0.0;
  private float offset_sum_b_ = 0.0;
  private float offset_sum_c_ = 0.0;
}
