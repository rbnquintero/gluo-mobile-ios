cordova.define("com.acme.plugin.alert.Alert", function(require, exports, module) { module.exports {
	alert: function(title, message, buttonLabel, successCallback) {
		cordova.exec(successCallBack, null, "Alert", "alert", [title, message, buttonLabel]);
	}
};
});
