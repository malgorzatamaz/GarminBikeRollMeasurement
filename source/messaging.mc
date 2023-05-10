using Toybox.Communications;
using Toybox.System;
using Toybox.Lang;

class CommListener extends Communications.ConnectionListener {
  function initialize() {
    Communications.ConnectionListener.initialize();
  }

  function onComplete() {
    System.println("onTransmitComplete");
  }

  function onError() {
    System.println("onError");
  }
}

class Messaging {
  function sendMessage(type, payload) {
    var message = {
      Constants.KEY_MESSAGE_TYPE => type,
      Constants.KEY_MESSAGE_PAYLOAD => payload,
    };

    var listener = new $.CommListener();
    Communications.transmit(message, null, listener);
  }
}
