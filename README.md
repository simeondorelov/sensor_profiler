## Sensors Profiler ##

This project aims to provide an easy way of visualizing, analyzing and understanding sensor data from robots. A profiler is developed which allows for the visualization, in real time, of sensor data from robotic platforms. The current version is targeted for the Sparki robot, but is easily adaptable to any platform.

### Profiler ###

The profiler application is a Processing app which listens for sensor data sent over a serial interface, stores data in a buffer, computes statistics and plots the data to the screen.

#### Sensors & Motion ####

The profiler currently supports three dimensional sensors by default and is tuned to the sensors onboard the Sparki. An abstract class is used to define sensors, allowing for easy extensibility of the profiler. The definition of a sensor includes axis names, axis ranges, and a serial identifier.

The profiler sends single characters (identifier) over serial in order to request a change of the type of sensor data sent by the target device (e.g. "A" is sent to switch over to Accelerometer data). The profiler can also send "G" or "S" to instruct the target device to move forward or stop while profiling.

#### Samples Buffer & Statistics ####

Samples from the currently selected sensor are buffered in the profiler until the current sample size is filled before the data is plotted.

Moving statistics are computed for the entire sample size at any given time point. These include minimum and maximum values, mean and median, basic standard deviation, as well as maximum deviation. The profiler supports plotting raw values, as all as any of the statistics values over time. For every new raw value received, statistics for the entire buffer at that time point are computed and stored in the statistics buffer, which is then used for plotting.

### Sparki Sensors Dump ###

A sample Arduino sketch for the Sparki robot is included. The sketch implements listening for the serial commands sent by the profiler and sending sensor data.

### Virtual Sparki ###

A test Processing application with limited functionality is included to allow for mocking a target device. This is intended to serve for the purposes of testing the profiler itself. It requires that a serial loopback interface is available on the machine.

A well-established implementation of a loopback COM port is available at [com0com](http://com0com.sourceforge.net/).

### Usage ###
Download, open, and run the source code in Processing or download and launch one of the published release binaries.
1. After launching the profiler, a COM port selection menu appears. Use the number buttons to select the COM port to use
2. Once the profiler is running all the keyboard shortcuts can be viewed inside the help menu available by pressing "h".