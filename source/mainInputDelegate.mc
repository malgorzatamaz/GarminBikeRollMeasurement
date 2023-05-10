using Toybox.System;
using Toybox.WatchUi;

class MainInputDelegate extends WatchUi.InputDelegate {
  var controller;

  function initialize() {
    BehaviorDelegate.initialize();
    controller = Application.getApp().controller;
    InputDelegate.initialize();
  }

  function onKey(keyEvent) {
    if (keyEvent.getKey() == KEY_START || keyEvent.getKey() == KEY_ENTER) {
      controller.onStartStop();
    }
    if (
      keyEvent.getKey() == KEY_LAP ||
      keyEvent.getKey() == KEY_LIGHT ||
      keyEvent.getKey() == KEY_MENU ||
      keyEvent.getKey() == KEY_DOWN ||
      keyEvent.getKey() == KEY_UP
    ) {
      System.exit();
    }
    return true;
  }
}
