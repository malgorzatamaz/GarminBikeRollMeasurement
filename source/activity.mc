using Toybox.Sensor;
using Toybox.SensorLogging;
using Toybox.ActivityRecording;
using Toybox.Activity;
using Toybox.Math;
using Toybox.Lang;
using Toybox.Position;

class Activity {
  var isRecording = false;
  var allValues as Lang.Array = [];
  var values as Lang.Array = [];
  var SAMPLE_RATE = 10;
  var speed = 0;
  var position = {};

  function getMaxValue(array as Lang.Array<Lang.Float>) {
    var max = 0;
    for (
      var i = array.size() > 200 ? array.size() - 150 : 0;
      i < array.size();
      i++
    ) {
      var newMax = array[i].abs();
      if (newMax > max) {
        max = newMax;
      }
    }

    return max;
  }

  function getAngle() as Lang.Array<Lang.Number> {
    return values;
  }

  function getMaxAngle() {
    return getMaxValue(allValues);
  }

  function getCurrentMaxAngle() {
    return getMaxValue(values);
  }

  function getSpeed() {
    return speed;
  }

  function getPosition() {
    return position;
  }

  function startActivity() {
    var options = {
      :period => 1, // 1 second sample time
      :accelerometer => {
        :includeRoll => true, // Include roll values
        :enabled => true, // Enable the accelerometer
        :sampleRate => SAMPLE_RATE, // samples
      },
    };

    Position.enableLocationEvents(
      Position.LOCATION_CONTINUOUS,
      method(:onPosition)
    );
    Sensor.registerSensorDataListener(method(:onAccelCallback), options);
    isRecording = true;
  }

  function onAccelCallback(sensorData as Sensor.SensorData) as Void {
    var sensorValues = sensorData.accelerometerData.roll;

    var speedInMetersPerSecond = Sensor.getInfo().speed;
    if (speedInMetersPerSecond != null) {
      speed = speedInMetersPerSecond * 3.6;
    }

    var tempValues = [];

    var sum = 0;
    var sumValues = [].addAll(sensorValues);
    if (values.size() > 10) {
      sumValues.addAll(values.slice(values.size() - 10, values.size()));
    }
    for (var i = 0; i < sensorValues.size(); i++) {
      sum += sumValues[i];
    }
    var average = sum / sumValues.size();

    for (var i = 0; i < sensorValues.size(); i++) {
      if (180 - sensorValues[i].abs() > 60 || sensorValues[i] - average > 20) {
        continue;
      }

      if (sensorValues[i] > 0) {
        tempValues.add(180 - sensorValues[i]);
      } else {
        tempValues.add(-180 + sensorValues[i].abs());
      }
    }
    values = tempValues;
    allValues.addAll(tempValues);
  }

  function onPosition(info as Position.Info) as Void {
    position = info.position.toDegrees();
  }

  function stopActivity() {
    Sensor.unregisterSensorDataListener();
    Position.enableLocationEvents(
      Position.LOCATION_DISABLE,
      method(:onPosition)
    );
    isRecording = false;
    values = [];
    allValues = [];
  }

  function isRunning() {
    return isRecording;
  }

  function onStartStop() {
    if (isRecording) {
      stopActivity();
    } else {
      startActivity();
    }
  }
}
