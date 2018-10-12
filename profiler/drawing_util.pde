public class DrawingUtil {
  public DrawingUtil(PApplet applet) {
    applet_ = applet;
  }

  public void clear() {
    applet_.background(0);
  }

  public int frameWidth() { 
    return applet_.width;
  }

  public int frameHeight() { 
    return applet_.height; 
  }

  public void drawMenu(int w, int h, String text) {

    int x = (frameWidth() - w) / 2;
    int y = (frameHeight() - h) / 2;

    applet_.fill(0);
    applet_.stroke(150);
    applet_.rect(x, y, w, h);

    applet_.textSize(24);
    applet_.fill(255);
    applet_.noStroke();
    text(text, x + 20, y + 60);
  }

  public void drawMessage(String text) {
    int w = frameWidth() - 100;
    int h = 60;
    int x = (frameWidth() - w) / 2;
    int y = (int)((frameHeight() - h) * 0.9);

    applet_.fill(0);
    applet_.stroke(255, 0, 0);
    applet_.rect(x, y, w, h);

    applet_.textSize(24);
    applet_.fill(255, 0, 0);
    applet_.noStroke();
    text(text, x + 20, y + 40);
    fill(0);
  }

  public void drawHeader(
      int x, int y, int w, int h, 
      boolean paused, int frame_rate, int poll_rate, int sample_size, 
      String sensor, String filter, boolean filter_enabled) {
    int baseline = y + h / 2 + 13;
    
    applet_.textSize(30);
    applet_.fill(255);
    applet_.rect(x, y, w, h);
    applet_.fill(0);
    
    // Print left aligned info.
    applet_.text(
        String.format("Polls:  %d", poll_rate), 
        (x + 20), baseline
    );
    applet_.text(
        String.format("Samples:  %d", sample_size), 
        (x + 200), baseline
    );
    
    // Print center aligned info.
    applet_.text(
        sensor, 
        (x + w / 2 - applet_.textWidth(sensor) / 2), baseline
    );
    
    // Print right aligned info.
    applet_.fill((filter_enabled ? 0 : 170));
    applet_.text(
        String.format("Filter:  %s", filter), 
        (x + w - 450), baseline
    );
    applet_.fill(0);
    String fps_str = 
        (paused ? "PAUSED" : String.format("FPS:  %d", frame_rate));
    applet_.text(fps_str, (x + w - 150), baseline);
  }
  
  public void drawCurrentValues(
      Sensor sensor,
      int x, int y, int w, int h,
      Float curr_a, Float curr_b, Float curr_c) {
    int font_size = determineFontSize(w, h, 2, 3);
    int row_height = h / 2;
    
    // Draw header row.
    drawRow(
        200, 0, font_size,
        x, y, w, row_height,
        sensor.axisNames()
    );
    // Draw raw values.
    
    drawRow(
        0, 255, font_size,
        x, (y + row_height), w, row_height, 
        new String[]{
            String.format("%.2f", curr_a),
            String.format("%.2f", curr_b),
            String.format("%.2f", curr_c)
        }
    );
    
    drawOuterStroke(x, y, w, h);
  }
  
  public void drawStatInfo(
      Sensor sensor, int x, int y, int w, int h, 
      SetStats stats_a, SetStats stats_b, SetStats stats_c) {
    int row_count = (ValueType.count() - 1) + 1;
    int row_height = h / row_count;
    int row = 1;
    
    int font_size = determineFontSize(w, h, row_count, 4);
    
    try {
      // Draw header row.
      drawRow(
          200, 0, font_size,
          x, y, w, row_height, 
          new String[]{ 
              "Value", 
              sensor.axisNames()[0], 
              sensor.axisNames()[1], 
              sensor.axisNames()[2]}
      );
      // Draw data rows.
      for (ValueType type = ValueType.RAW.next(); 
            type != ValueType.RAW; 
            type = type.next()) {
        // Color the row for every other row.
        if (row % 2 == 0) applet_.fill(20);
        else applet_.fill(0);
        drawRow(
            (row % 2 == 0 ? 0 : 20), 255, font_size,
            x, (y + row_height * row), w, row_height, 
            new String[]{
                type.HumanReadableName(),
                String.format("%.2f", stats_a.getStat(type)),
                String.format("%.2f", stats_b.getStat(type)),
                String.format("%.2f", stats_c.getStat(type))
            }
        );
        row++;
      }
      
      drawOuterStroke(x, y, w, h);
    } catch (Exception e) {}
  }

  public void drawBarGraph(
      Sensor sensor,
      int x, int y, int w, int h,
      Float curr_a, Float curr_b, Float curr_c) {
    int footer_height = 30;
    int track_width = w / 3;
    int track_height = h - footer_height;
    
    // Draw the bars.
    applet_.fill(200,200,0);
    drawBar(
        sensor.barType(), 
        x, y, track_width, track_height, 
        sensor.axisMin(), sensor.axisMax(), curr_a
    );
    drawBar(
        sensor.barType(), 
        (x + track_width), y, track_width, track_height, 
        sensor.axisMin(), sensor.axisMax(), curr_b
    );
    drawBar(
        sensor.barType(), 
        (x + 2 * track_width), y, track_width, track_height,
        sensor.axisMin(), sensor.axisMax(), curr_c
    );
    
    drawBarFooter(sensor, x, (y + track_height), w, footer_height);
    
    drawOuterStroke(x, y, w, h);
  }
  
  public void drawPlot(
      VisualizerConfig config, 
      int x, int y, int w, int h,
      ValuesBuffer buffer) {

    int plotter_info_height = 50;
    int range_margin = 15;
    drawPloterInfo(
        config, x, (y + h - plotter_info_height), w, plotter_info_height);

    SetStats stats_a = buffer.getCurrentStats(Axis.A);
    SetStats stats_b = buffer.getCurrentStats(Axis.B);
    SetStats stats_c = buffer.getCurrentStats(Axis.C);

    Range range_a = determineValueRange(config, stats_a, stats_b, stats_c);
    Range range_b = determineValueRange(config, stats_b, stats_a, stats_c);
    Range range_c = determineValueRange(config, stats_c, stats_a, stats_b);

    Float[] vals_a = 
        buffer.getCurrentSampleSetValues(Axis.A, config.PlotValueType());
    Float[] vals_b = 
        buffer.getCurrentSampleSetValues(Axis.B, config.PlotValueType());
    Float[] vals_c = 
        buffer.getCurrentSampleSetValues(Axis.C, config.PlotValueType());
    
    // Draw plot background.
    applet_.fill(0);
    applet_.rect(x, y, w, (h - plotter_info_height));

    int plot_y = (y + range_margin);
    int plot_h = (h - plotter_info_height - (2 * range_margin));
    applet_.textSize(15);
    applet_.noStroke();
    applet_.fill(255, 0, 0);
    drawBuffer(
        config.PlotPointSize(), 
        x, plot_y, w, plot_h,
        vals_a,  range_a.min_val, range_a.max_val
    );
    text(
        String.format("%.2f", range_a.max_val), 
        (x + 10) , (y + range_margin)
    );
    text(
        String.format("%.2f", range_a.min_val), 
        (x + 10) , (plot_y + plot_h + range_margin)
    );

    applet_.fill(0, 255, 0);
    drawBuffer(
        config.PlotPointSize(), 
        x, plot_y, w, plot_h,
        vals_b,  range_b.min_val, range_b.max_val
    );
    text(
        String.format("%.2f", range_b.max_val), 
        (x + 100) , (y + range_margin)
    );
    text(
        String.format("%.2f", range_b.min_val), 
        (x + 100) , (plot_y + plot_h + range_margin)
    );

    applet_.fill(0, 0, 255);
    drawBuffer(
        config.PlotPointSize(), 
        x, plot_y, w, plot_h,
        vals_c,  range_c.min_val, range_c.max_val
    );
    text(
        String.format("%.2f", range_c.max_val), 
        (x + 190) , (y + range_margin)
    );
    text(
        String.format("%.2f", range_c.min_val), 
        (x + 190) , (plot_y + plot_h + range_margin)
    );
    
    drawOuterStroke(x, y, w, h);
  }

  // PRIVATE 

  private int determineFontSize(
      int w, int h, int rows, int cols) {
    float cell_height = h / rows;
    float cell_width = w / cols;
    float size_from_width = 
        (cell_width / cell_target_max_chars_) * (1 / font_width_adjust_);
    float size_from_height = ((float) cell_height * 0.6);
    
    return (int) Math.min(size_from_width, size_from_height);
  }
    
  private void drawRow(
      int row_color, int text_color, int font_size,
      int x, int y, int w, int h, 
      String[] values) {
    applet_.noStroke();
    applet_.fill(row_color);
    applet_.rect(x, y, w, h);
    
    int cell_width = w / values.length;
    
    // Print each cell of the row.
    applet_.fill(text_color);
    for (int i = 0; i < values.length; i++) {
      drawCell(
          font_size, 
          (x + cell_width * i), y, cell_width, h, 
          values[i]
      );
    }
  }
    
  private void drawCell(
      int font_size,
      int x, int y, int w, int h, 
      String value) {
    applet_.textSize(font_size);
    int baseline = y + h / 2 + font_size / 2;
    int x_offset = (int) (x + w / 2 - applet_.textWidth(value) / 2);
    applet_.text(value, x_offset, baseline);
  }
    
  private void drawOuterStroke(
      int x, int y, int w, int h) {
    applet_.stroke(150);
    applet_.noFill();
    applet_.rect(x, y, w, h);
    applet_.stroke(0);
  }
  
  private void drawBarFooter(
      Sensor sensor,
      int x, int y, int w, int h) {
    int axis_width = w / 3;
    int baseline = y + h / 2 + 13;
    int x_offset = (axis_width - 20) / 2;
    
    // Draw footer box.
    applet_.textSize(30);
    applet_.fill(255);
    applet_.rect(x, y, w, h);
    
    // Draw the bar initials beneath the bars.
    applet_.fill(0);
    applet_.text(
        sensor.axisNames()[0].charAt(0), 
        (x + x_offset), baseline
    );
    applet_.text(
        sensor.axisNames()[1].charAt(0), 
        (x + axis_width + x_offset), baseline
    );
    applet_.text(
        sensor.axisNames()[2].charAt(0), 
        (x + 2 * axis_width + x_offset), baseline
    );
    
    // Draw the color codes.
    applet_.noStroke();
    applet_.fill(255,0,0);
    applet_.rect((x + axis_width - 5), (y + h - 5), 5, 5);
    applet_.fill(0,255,0);
    applet_.rect((x + axis_width * 2 - 5), (y + h - 5), 5, 5);
    applet_.fill(0,0,255);
    applet_.rect((x + axis_width * 3 - 5), (y + h - 5), 5, 5);
  }
  
  private void drawBar(
      BarType type, 
      int x, int y, int w, int h, 
      float min, float max, float value) {
    float bar_height = 0;
    float top_offset = h / 2;
    
    switch (type) {
      default:
      case BASELINE: {
        bar_height = map(value, min, max, 0.0, h);
        top_offset = h - bar_height;
        break;
      }
      case MIDPOINT: {
        float abs_max_value = Math.max(Math.abs(min), Math.abs(max));
        bar_height = map(Math.abs(value), 0.0, abs_max_value, 0.0, (h / 2));
        if (value > 0) top_offset -= bar_height;
        break;
      }
    }
    applet_.rect(x, y + top_offset, w, bar_height);
  }

  private void drawPloterInfo(
      VisualizerConfig config, 
      int x, int y, int w, int h) {
    int baseline = y + h / 2 + 13;
    applet_.textSize(30);
    applet_.fill(255);
    applet_.text(
        config.PlotValueType().name(), 
        (x + 30), 
        baseline
    );
    applet_.text(
        config.AutoScalingOn() ? "auto-scale" : "full-range", 
        (x + w - 300), 
        baseline
    );

    if (config.ScalingAggregationOn() && config.AutoScalingOn()) {
      applet_.text("(agg)", x + w - 100, baseline);
    }

    drawOuterStroke(x, y, w, h);
  }

  private void drawBuffer(
      float point_size, 
      int x, int y, int w, int h,
      Float[] vals,  double min, double max) {
    try {
      int size = vals.length;
      for (int i = 0; i < size; i++) {
        int y_ax = (int) ProfilerUtils.mapValues(
            vals[i], (float) min, (float) max, (float) (y + h), (float) y);
        int x_ax = (int) ProfilerUtils.mapValues(
            (float) i, 0.0, (float) size, (float) x, (float) (x + w));
        applet_.rect(x_ax, y_ax , point_size, point_size);
      }  
    } catch (Exception e) {}
  }

  private Range determineValueRange(
      VisualizerConfig config,
      SetStats stats_curr, SetStats stats_oth1, SetStats stats_oth2) {
    if (!config.AutoScalingOn()) {
      return new Range(
          config.CurrentSensor().axisMin(),
          config.CurrentSensor().axisMax()
      );
    }
    
    double curr_min = stats_curr.getStat(ValueType.MIN);
    double curr_max = stats_curr.getStat(ValueType.MAX);
    double abs_min = Math.min(
      Math.min(
          stats_oth1.getStat(ValueType.MIN), 
          stats_oth2.getStat(ValueType.MIN)
      ), 
      curr_min
    );
    double abs_max = Math.max(
        Math.max(
            stats_oth1.getStat(ValueType.MAX),
            stats_oth2.getStat(ValueType.MAX)
        ), 
        curr_max
    );
    
    if (config.ScalingAggregationOn()) {
      return new Range(abs_min, abs_max);
    }

    double range = curr_max - curr_min;
    curr_min -= range * 0.1;
    curr_max += range * 0.1;

    return new Range(curr_min, curr_max);
  }
    
  private float font_width_adjust_ = 0.5;
  private int cell_target_max_chars_ = 10;

  private PApplet applet_;
}
