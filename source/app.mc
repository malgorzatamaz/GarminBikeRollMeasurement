import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Sensor;

class App extends Application.AppBase {
  var controller;

  function initialize() {
    AppBase.initialize();
    controller = new Controller();
  }

  function getInitialView() as Array<Views or InputDelegates>? {
    return (
      [new mainView(), new MainInputDelegate()] as
      Array<Views or InputDelegates>
    );
  }
}

function getApp() as App {
  return Application.getApp() as App;
}
