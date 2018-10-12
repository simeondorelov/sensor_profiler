public class Visualizer {
  public Visualizer(VisualizerConfig config, DrawingUtil drawer) {
    config_ = config;
    drawer_ = drawer;
    frame_rate_ = new Rate(1000);
    poll_rate_ = new Rate(1000);
    buffer_ = new ValuesBuffer(config.SampleSize());
  }
  
  public void drawVisualizerFrame() {
    frame_rate_.count();

    int frame_width = drawer_.frameWidth();
    int frame_height = drawer_.frameHeight();
    int header_height = 50;
    int graphs_width = (int)(config.GraphScreenRatio() * frame_width);
    int stats_width = frame_width - graphs_width;
  
    if (!config_.DisplayPauseOn()) drawer_.clear();
    drawer_.drawHeader(
        0, 0, frame_width, header_height, 
        config.DisplayPauseOn(), frame_rate_.get(), poll_rate_.get(), 
        config_.SampleSize(), config_.CurrentSensor().name(), 
        config.CurrentFilter().name(), config.FilterEnabled()
    );

    if (config_.DisplayPauseOn()) return;
    if (!buffer_.isFull()) return;

    try {
      int drawable_height = frame_height - header_height;
      drawTables(0, header_height, stats_width, drawable_height);
      drawGaphs(stats_width, header_height, graphs_width,  drawable_height);
    } catch (Exception e) {}

    if (config.ShowHelpMenu()) drawer_.drawMenu(1000, 700, help_text_);
  }

  public void periodicUpdate() {
    poll_rate_.compute();
    frame_rate_.compute();

    if (buffer_.getSampleSize() != config.SampleSize()) {
      buffer_.setSampleSize(config.SampleSize());
    }

    updateFilter();
    buffer_.setFilterEnabled(config.FilterEnabled());
  }

  public void serialDataReceived(String input) {
    Float[] vals;
    String[] raw_vals = input.split(",");
    vals = new Float[raw_vals.length];
    for (int i = 0; i < raw_vals.length; i++) {
      vals[i] = Float.parseFloat(raw_vals[i]);
    }
    
    if (vals.length < 3) return;
    float curr_a = vals[0];
    float curr_b = vals[1];
    float curr_c = vals[2];
    
    buffer_.addValues(curr_a, curr_b, curr_c);
    poll_rate_.count();
  }

  public void calibrateFilter() {
    if (!config.FilterEnabled()) buffer_.calibrateFilter();
  }

  public void resetFilter() {
    curr_filter_.reset();
  }

  private void updateFilter() {
    Filter last_filter_type = Filter.NONE;
    if (curr_filter_ != null) last_filter_type = curr_filter_.type();
    if (config.CurrentFilter() == last_filter_type) return;

    switch(config.CurrentFilter()) {
      case CONST_OFF: {
        curr_filter_ = new ConstOffsetCalibration();
        break;
      }
      case ACCEL_CAL: {
        curr_filter_ = new AccelCalibration();
        break;
      }
      default: {
        curr_filter_ = null;
        break;
      }
    }

    buffer_.setFilter(curr_filter_);
  }

  private void drawTables(int x, int y, int w, int h) {
    int current_vals_height = 100;
    int tables_width = Math.min(900, (w - 20));

    SetStats stats_a = buffer_.getCurrentStats(Axis.A);
    SetStats stats_b = buffer_.getCurrentStats(Axis.B);
    SetStats stats_c = buffer_.getCurrentStats(Axis.C);
    float curr_a = buffer_.getCurrentValue(Axis.A, ValueType.RAW);
    float curr_b = buffer_.getCurrentValue(Axis.B, ValueType.RAW);
    float curr_c = buffer_.getCurrentValue(Axis.C, ValueType.RAW);

    int vals_height = Math.min(650, (h - current_vals_height - 40));
    drawer_.drawCurrentValues(
        config_.CurrentSensor(), 
        (x + 10), (y + 10), tables_width, current_vals_height, 
        curr_a, curr_b, curr_c
    );

    
    int stats_height = Math.min(650, (h - current_vals_height - 40));
    drawer_.drawStatInfo(
        config_.CurrentSensor(), 
        (x + 10), (y + current_vals_height + 30), 
        tables_width, stats_height, 
        stats_a, stats_b, stats_c
    );
  }

  private void drawGaphs(int x, int y, int w, int h) {
    int bar_graph_width = 90;

    float curr_a = buffer_.getCurrentValue(Axis.A, ValueType.RAW);
    float curr_b = buffer_.getCurrentValue(Axis.B, ValueType.RAW);
    float curr_c = buffer_.getCurrentValue(Axis.C, ValueType.RAW);

    drawer_.drawBarGraph(
        config_.CurrentSensor(), 
        (x + 10), (y + 10), bar_graph_width, (h - 20),
        curr_a, curr_b, curr_c
    );
        
    drawer_.drawPlot(
        config_, 
        (x + bar_graph_width + 20), (y + 10), 
        (w - bar_graph_width - 30), (h - 20), 
        buffer_
    );
  }
  
  private VisualizerConfig config_;
  DrawingUtil drawer_;
  
  private Rate frame_rate_;
  private Rate poll_rate_;
  
  private ValuesBuffer buffer_;

  private ValueFilter curr_filter_ = null;

  private String help_text_ =
      "  Help Menu\n\n" + 
      "  h   - Show / hide the help menu.\n" +
      "  p   - Pause the visualization.\n" + 
      "  z   - Capture a screenshot.\n" +
      "  l   - Togge the frame rate limiter.\n" + 
      "  s   - Toggle between available sensors.\n" +
      "  f   - Toggle between available filtering modes.\n" +
      "  e   - Enable / disable the current filter.\n" +
      "  c   - Add a calibration point for the current filter.\n" +
      "  r   - Resets the calibration of the current filter.\n" +
      "  m   - Toggle between scaling modes of the graph plotter.\n" + 
      "  a   - Toggle between auto scaling each axis individually or together.\n" + 
      "  v   - Change the type of value being plotted.\n" +
      " [ ]  - Decrease / increase the sample size.\n" + 
      " - =  - Decrease / increase the graph plotter's width on screen.\n" + 
      " ; '  - Decrease / increase the point size on the plotter.";
}
