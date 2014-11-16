window['__onGCastApiAvailable'] = function(loaded, errorInfo) {
  if (loaded) {
    initializeCastApi();
  } else {
    console.log(errorInfo);
  }
}

$(document).ready(function() {
  $("#cast_button").click(function() {
    chrome.cast.requestSession(onRequestSessionSuccess, onLaunchError);
  });
});

var session = null;
function onRequestSessionSuccess(e) {
  console.log("Got session");
  session = e;
}

function sessionListener(e) {
  console.log("Got existing session");
  session = e;
  if (session.media.length != 0) {
    onMediaDiscovered('onRequestSessionSuccess', session.media[0]);
  }
}

function receiverListener(e) {
  if( e === chrome.cast.ReceiverAvailability.AVAILABLE) {
      console.log("Got listener");
  }
}

function onInitSuccess() {
  console.log("Init succeeded");
}

function onInitError(e) {
  console.log("Init failed: " + e.description);
}

function onLaunchError(e) {
  console.log("Launch failed: " + e.description);
}

function initializeCastApi() {
  var sessionRequest = new chrome.cast.SessionRequest(chrome.cast.media.DEFAULT_MEDIA_RECEIVER_APP_ID);
  var apiConfig = new chrome.cast.ApiConfig(sessionRequest,
    sessionListener,
    receiverListener);
  chrome.cast.initialize(apiConfig, onInitSuccess, onInitError);
  console.log("Initialized cast API");
};


