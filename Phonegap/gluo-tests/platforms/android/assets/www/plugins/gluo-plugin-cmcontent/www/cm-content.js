cordova.define("gluo-plugin-cmcontent.CMContent", function(require, exports, module) { var exec = require('cordova/exec');

function CMContent() { 
 console.log("cm-content.js: is created");
}

CMContent.prototype.getContenido = function(successCallback, errorCallback){
 console.log("cm-content.js: alert");

 exec(successCallback,errorCallback,"CMContent","getContenido",["this is the input"]);
}

CMContent.prototype.convertirGradosC = function(successCallback, errorCallback, grados){
 exec(successCallback,errorCallback,"CMContent","convertirGradosC",[grados]);
}

CMContent.prototype.convertirGradosF = function(successCallback, errorCallback, grados){
 exec(successCallback,errorCallback,"CMContent","convertirGradosF",[grados]);
}

var CMContent = new CMContent();
module.exports = CMContent;
});
