public class VisualizerConfig {
  public void toggleDisplayPause() {
    display_paused_ = ! display_paused_;
  }

  public void toggleHelpMenu() {
    show_help_menu_ = !show_help_menu_;
  }

  public void toggleScaling() { 
    auto_scale_graph_ = !auto_scale_graph_; 
  }
  
  public void toggleScalingAggregation() { 
    auto_scale_aggregate_mode_ = !auto_scale_aggregate_mode_; 
  }
  
  public void changePlotValueType() {
    plot_value_type_ = plot_value_type_.next();
  }
  
  public void incrementPlotPointSize() {
    plot_point_size_ += 1.0;
  }
  
  public void decrementPlotPointSize() {
    if (plot_point_size_ - 1.0 > 0) {
      plot_point_size_ -= 1.0;
    }
  }

  public void incrementGraphScreenRatio() {
    if (graphs_screen_ratio_ + 0.05 < 0.9) {
      graphs_screen_ratio_ += 0.05;
    }
  }

  public void decrementGraphScreenRatio() {
    if (graphs_screen_ratio_ - 0.05 > 0.1) {
      graphs_screen_ratio_ -= 0.05;
    }
  }
  
  public void incrementSampleSize() {
    sample_size_ += 5;
  }
  
  public void decrementSampleSize() {
    if (sample_size_ - 5 > 0) {
      sample_size_ -= 5;
    }
  }
  
  public void changeSensor() {
    curr_sensor_ = curr_sensor_.next();
  }

  public void changeFilter() {
    curr_filter_ = curr_filter_.next();
  }

  public void toggleFilter() {
    filter_enabled_ = !filter_enabled_;
  }

  public boolean DisplayPauseOn() {
    return display_paused_;
  }

  public boolean ShowHelpMenu() {
    return show_help_menu_;
  }
  
  public boolean AutoScalingOn() { 
    return auto_scale_graph_; 
  }
  
  public boolean ScalingAggregationOn() { 
    return auto_scale_aggregate_mode_; 
  }
  
  public ValueType PlotValueType() {
    return plot_value_type_;
  }
  
  public float PlotPointSize() {  return plot_point_size_; }

  public float GraphScreenRatio() {
    return graphs_screen_ratio_;
  }
  
  public int SampleSize() { return sample_size_; }
  
  public Sensor CurrentSensor() { return curr_sensor_; }

  public Filter CurrentFilter() { return curr_filter_; }

  public boolean FilterEnabled() {return filter_enabled_; }

  private boolean display_paused_ = false;
  private boolean show_help_menu_ = false;
  private int sample_size_ = 80;
  private boolean auto_scale_graph_ = false;
  private boolean auto_scale_aggregate_mode_ = false;
  private ValueType plot_value_type_ = ValueType.RAW;
  private float plot_point_size_ = 3.0;
  private float graphs_screen_ratio_ = 0.6;
  private Sensor curr_sensor_ = Sensor.LIGHT;
  private Filter curr_filter_ = Filter.NONE;
  private boolean filter_enabled_ = false;
}
