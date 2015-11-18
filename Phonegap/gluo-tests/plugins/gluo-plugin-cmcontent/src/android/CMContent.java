import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaInterface;
import android.util.Log;
import android.provider.Settings;
import android.widget.Toast;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CMContent extends CordovaPlugin {
    
    public static final String TAG = "CMContent";
    
    private TempConvert tempService;
    
    public CMContent() {}
    
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        Log.v(TAG, "Init CMContent");
        tempService = new TempConvert();
        tempService.setUrl("http://www.w3schools.com/webservices/tempconvert.asmx");
    }
    
    public boolean execute(final String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        
        // Action recieved
        Log.v(TAG,"Action received:"+ action);
        String message = args.getString(0);
        
        if(action.equals("getContenido")) {
            this.getContenido(message, callbackContext);
            return true;
        } else if (action.equals("convertirGradosC")) {
            this.convertirGradosC(message, callbackContext);
            return true;
        } else if (action.equals("convertirGradosF")) {
            this.convertirGradosF(message, callbackContext);
            return true;
        }
        return false;
    }
    
    private void getContenido(String input, CallbackContext callbackContext) {
        Log.d(TAG,"Input:"+ input);
    }
    
    private void convertirGradosC(String grados, CallbackContext callbackContext) {
        Log.d(TAG, "Grados celsius:" + grados);
        String result = tempService.CelsiusToFahrenheit(grados);
        callbackContext.success(result);
    }
    
    private void convertirGradosF(String grados, CallbackContext callbackContext) {
        Log.d(TAG,"Grados fahrenheit:"+ grados);
        String result = tempService.FahrenheitToCelsius(grados);
        callbackContext.success(result);
    }
    
}