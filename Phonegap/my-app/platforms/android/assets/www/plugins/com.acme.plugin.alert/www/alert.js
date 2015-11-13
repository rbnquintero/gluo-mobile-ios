cordova.define("com.acme.plugin.alert.Alert", function(require, exports, module) { var exec = require('cordova/exec');

function Alert() { 
 console.log("alert.js: is created");
}

Alert.prototype.alert = function(title, message, buttonLabel, successCallback){
 console.log("alert.js: alert");

 exec(successCallback,
  function(result){
    /*alert("Error" + reply);*/
   },"Alert","alert",[title, message, buttonLabel]);
}

 var Alert = new Alert();
 module.exports = Alert;
});
