import Toybox.Lang;
class Controller {
  const activity = new Activity();
  const timer = new Timer.Timer();
  var time = 0;

  function onStartStop() {
    activity.onStartStop();
    if (isRunning()) {
      timer.start(method(:sendMessage), 1000, true);
    } else {
      timer.stop();
      time = 0;
    }
  }

  function isRunning() {
    return activity.isRunning();
  }

  function getAngle() as Array {
    return activity.getAngle();
  }

  function getMaxAngle() {
    return activity.getMaxAngle();
  }

  function getCurrentMaxAngle() {
    return activity.getCurrentMaxAngle();
  }

  function getSpeed() {
    return activity.getSpeed();
  }

  function getPosition() {
    return activity.getPosition();
  }

  function sendMessage() as Void {
    var angle = getAngle().toString();
    var currentMaxAngle = getCurrentMaxAngle().abs().toString();
    var speed = getSpeed().toString();
    var position = getPosition();

    var message = {
      Constants.MESSAGE_PAYLOAD_TIME => time,
      Constants.MESSAGE_PAYLOAD_MAX_ANGLE => currentMaxAngle,
      Constants.MESSAGE_PAYLOAD_ANGLE => angle,
      Constants.MESSAGE_PAYLOAD_SPEED => speed,
      Constants.MESSAGE_PAYLOAD_POSITION_LAT => position[0],
      Constants.MESSAGE_PAYLOAD_POSITION_LNG => position[1],
    };

    time = time + 1;
    Messaging.sendMessage(Constants.MESSAGE_TYPE_ALL, message);
  }
}
