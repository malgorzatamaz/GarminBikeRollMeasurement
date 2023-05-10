import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

using Toybox.Communications as Comm;

class mainView extends WatchUi.View {
  var controller;
  var angleLabel;
  var maxAngleLabel;
  var activityStateLabel;
  var timer;

  function initialize() {
    View.initialize();
    controller = Application.getApp().controller;
    timer = new Timer.Timer();
  }

  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.MainLayout(dc));

    angleLabel = View.findDrawableById("Angle");
    maxAngleLabel = View.findDrawableById("MaxAngle");
    activityStateLabel = View.findDrawableById("Activity");
  }

  function onUpdate(dc as Dc) as Void {
    View.onUpdate(dc);
    if (controller.isRunning()) {
      var angleValues = controller.getAngle();
      try {
        if (angleValues.size() > 0) {
          var angle = angleValues[0].abs().toLong();
          angleLabel.setText(angle.toString() + " °");
        } else {
          angleLabel.setText("-");
        }

        var max = controller.getMaxAngle().toLong();
        maxAngleLabel.setText(max != 0 ? max.toString() + "°" : "-");
      } catch (e) {
        System.println(e);
      }
      activityStateLabel.setText("Started");
    } else {
      activityStateLabel.setText("Paused");
    }
  }

  function onShow() {
    if (timer) {
      timer.start(method(:onTimer), 500, true);
    }
  }

  function onHide() {
    if (timer) {
      timer.stop();
    }
  }

  function onTimer() {
    WatchUi.requestUpdate();
  }
}
