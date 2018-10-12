import java.util.ArrayDeque;

// Maintains a buffer of raw sensor values and computes and 
// stores running statistics for the raw data.  
class ValuesBuffer {
  public ValuesBuffer(int sample_size) {
    sample_size_ = sample_size;
  }
  
  public void setSampleSize(int new_sample_size) {
    if (new_sample_size > 0) {
      sample_size_ = new_sample_size;
      this.clear();
    }
  }

  public int getSampleSize() {
    return sample_size_;
  }

  public void setFilter(ValueFilter filter) {
    value_filter_ = filter;
  }

  public void setFilterEnabled(boolean state) {
    value_filter_enabled_ = state;
  }

  public void calibrateFilter() {
    ArrayDeque<Float> raw_buffer_a = getAxisVals(Axis.A);
    ArrayDeque<Float> raw_buffer_b = getAxisVals(Axis.B);
    ArrayDeque<Float> raw_buffer_c = getAxisVals(Axis.C);
    ArrayDeque<SetStats> stats_buffer_a = getAxisStats(Axis.A);
    ArrayDeque<SetStats> stats_buffer_b = getAxisStats(Axis.B);
    ArrayDeque<SetStats> stats_buffer_c = getAxisStats(Axis.C);
    Float[] raw_a = raw_buffer_a.toArray(new Float[raw_buffer_a.size()]);
    Float[] raw_b = raw_buffer_b.toArray(new Float[raw_buffer_b.size()]);
    Float[] raw_c = raw_buffer_c.toArray(new Float[raw_buffer_c.size()]);
    SetStats[] stats_a =
        stats_buffer_a.toArray(new SetStats[stats_buffer_a.size()]);
    SetStats[] stats_b =
        stats_buffer_b.toArray(new SetStats[stats_buffer_b.size()]);
    SetStats[] stats_c =
        stats_buffer_c.toArray(new SetStats[stats_buffer_c.size()]);

    value_filter_.addCalibrationPoint(raw_a, raw_b, raw_c, 
                                     stats_a, stats_b, stats_c);
  }
  
  // Adds new raw values for all axes.
  public void addValues(Float a, Float b, Float c) {
    if (value_filter_ != null && value_filter_enabled_) {
      a = value_filter_.filterA(a);
      b = value_filter_.filterB(b);
      c = value_filter_.filterC(c);
    }

    // Store the current raw value.
    vals_a_.addFirst(a);
    vals_b_.addFirst(b);
    vals_c_.addFirst(c);
    
    // Get the arrays of the current sample set of raw values.
    Float[] array_a = vals_a_.toArray(new Float[vals_a_.size()]);
    Float[] array_b = vals_b_.toArray(new Float[vals_b_.size()]);
    Float[] array_c = vals_c_.toArray(new Float[vals_c_.size()]);
    
    // Compute the stats for each array.
    SetStats stat_a = new SetStats(array_a);
    SetStats stat_b = new SetStats(array_b);
    SetStats stat_c = new SetStats(array_c);
    
    // Store the stats for the current sample set.
    stats_a_.addFirst(stat_a);
    stats_b_.addFirst(stat_b);
    stats_c_.addFirst(stat_c);
  
    // All buffers should have the same size at all times.
    while (vals_a_.size() > sample_size_) { 
      vals_a_.removeLast();
      vals_b_.removeLast();
      vals_c_.removeLast();
      stats_a_.removeLast();
      stats_b_.removeLast();
      stats_c_.removeLast();
    }
  }
  
  public boolean isFull() {
    return vals_a_.size() >= sample_size_;
  }
  
  public Float getCurrentValue(Axis axis, ValueType type) {
    if (type == ValueType.RAW) return getAxisVals(axis).peekFirst();
    else return (float) getAxisStats(axis).peekFirst().getStat(type);
  }
  
  public SetStats getCurrentStats(Axis axis) {
    return getAxisStats(axis).peekFirst();    
  }
  
  public Float[] getCurrentSampleSetValues(Axis axis, ValueType type) {
    if (type == ValueType.RAW) {
      ArrayDeque<Float> buffer = getAxisVals(axis);
      return buffer.toArray(new Float[buffer.size()]);
    } else {
      ArrayDeque<SetStats> buffer = getAxisStats(axis);
      return getStatArray(
          buffer.toArray(new SetStats[buffer.size()]), type);
    }
  }
  
  private ArrayDeque<Float> getAxisVals(Axis axis) {
    switch(axis) {
      case A: return vals_a_;
      case B: return vals_b_;
      case C: return vals_c_;
      default: return null;
    }
  }
  
  private ArrayDeque<SetStats> getAxisStats(Axis axis) {
    switch(axis) {
      case A: return stats_a_;
      case B: return stats_b_;
      case C: return stats_c_;
      default: return null;
    }
  }
  
  private void clear() {
    vals_a_.clear();
    vals_b_.clear();
    vals_c_.clear();
    stats_a_.clear();
    stats_b_.clear();
    stats_c_.clear();
  }
  
  private Float[] getStatArray(SetStats[] stats, ValueType type) {
    Float[] res = new Float[stats.length];
    for(int i = 0; i < stats.length; i++) {
      res[i] = (float) stats[i].getStat(type);
    }
    return res;
  }
  
  private int sample_size_;
  
  // The buffers for raw values.
  private ArrayDeque<Float> vals_a_ = new ArrayDeque<Float>();
  private ArrayDeque<Float> vals_b_ = new ArrayDeque<Float>();
  private ArrayDeque<Float> vals_c_ = new ArrayDeque<Float>();
  
  // The buffers for computed rolling statistics over the raw values.
  private ArrayDeque<SetStats> stats_a_ = new ArrayDeque<SetStats>();
  private ArrayDeque<SetStats> stats_b_ = new ArrayDeque<SetStats>();
  private ArrayDeque<SetStats> stats_c_ = new ArrayDeque<SetStats>();

  private ValueFilter value_filter_ = null;
  private boolean value_filter_enabled_ = false;
}
