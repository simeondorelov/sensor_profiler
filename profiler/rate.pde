// Keeps track of the rate of occurence of an event over a given timespan.
class Rate {
  public Rate(int timespan_ms) {
    timespan_ms_ = timespan_ms;
    last_timestamp_ = millis();
  }
  
  public void count() { count_++; }
  
  public void compute() {
    if ((millis() - last_timestamp_) > timespan_ms_) {
      last_rate_ = count_;
      last_timestamp_ = millis();
      count_ = 0;
    }
  }
  
  public int get() {
    return last_rate_;
  }
  
  private int count_ = 0;
  private int timespan_ms_;
  private int last_timestamp_;
  private int last_rate_ = 0;
}
