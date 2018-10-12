import java.util.Arrays;

// Stores statistics for a single sample set.
// Provides methods for computing the stats for an array.
class SetStats {  
  public SetStats() {}
  
  public SetStats(Float[] arr_in) {
    this.ComputeFromArray(arr_in);
  }
  
  // Computes all the statistics for a given array of values.
  public void ComputeFromArray(Float[] arr_in) {
    if (arr_in.length < 3) return;
    // Clone and sort the input array.
    Float[] arr = arr_in.clone();
    Arrays.sort(arr);
    
    // Min, max and median can be computed directly from the sorted array.
    this.min_val = arr[0];
    this.max_val = arr[arr.length - 1];
    this.median = 0;
    // Median is computed as mean of two center elements of the array in 
    // the case of an even number of elements.
    if (arr.length % 2 == 0) {
      this.median = 
          (double)(arr[arr.length / 2] + arr[arr.length / 2 - 1]) / 2;
    } else {
      this.median = arr[arr.length / 2];
    }
    
    // Compute the mean of the array.
    double sum = 0;
    for(int i = 0; i < arr.length; i++) sum += arr[i];
    this.mean = (double) sum / (double) arr.length;
    
    this.max_dev = 0;
    this.std_dev = 0;
    double dev_sum = 0;
    for(int i = 0; i < arr.length; i++)  {
      // The deviation of a raw value is the delta of that value from
      // the mean of the whole set.
      double curr_dev = Math.abs((double)arr[i] - this.mean);
      // The maximum deviation is the greatest deviation value of a 
      // the set. 
      if (curr_dev > this.max_dev) this.max_dev = curr_dev;
      // Keep the sum of all deviations to compute their mean.
      dev_sum += curr_dev;
    }
    
    // The standard deviation is the mean of the deviation of each value.
    this.std_dev = dev_sum / (double) arr.length;
  }
  
  // Convenience method which retrieves a specific statistical value 
  // based on the type specified.
  public double getStat(ValueType type) {
    switch(type) {
      case MEAN: return this.mean;
      case MEDIAN: return this.median;
      case MIN: return this.min_val;
      case MAX: return this.max_val;
      case STD_DEV: return this.std_dev;
      case MAX_DEV: return this.max_dev;
      default: return (double) -1.0;
    }
  }
  
  // Prints the statistical data to a string in a human readable format.
  public String toString()
  {
    return "Mean: " + String.format("%.3f", mean)  + "\n" +
           "Median: " + String.format("%.3f", median) + "\n" +
           "Min: " + String.format("%.3f", min_val) + "\n" +
           "Max: " + String.format("%.3f", max_val) + "\n" +
           "StdDev: " + String.format("%.3f", std_dev) + "\n" +
           "MaxDev: " + String.format("%.3f", max_dev);
  }
  
  // TODO(simeondorelov): Rename with underscores.
  private double mean = 0;
  private double median = 0;
  private double std_dev = 0;
  private double max_dev = 0;
  private double min_val = 0;
  private double max_val = 0;
}
