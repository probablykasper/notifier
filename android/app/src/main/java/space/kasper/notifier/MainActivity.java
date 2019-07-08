package space.kasper.notifier;

import android.content.pm.PackageManager;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.content.pm.PackageInfo;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "space.kasper.notifier/get_install_date";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
      new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
          if (methodCall.method.equals("get_install_date")) {
            PackageInfo packageInfo = null;
            try {
              packageInfo = getPackageManager().getPackageInfo(getPackageName(), 0);
              long firstInstallTime = packageInfo.firstInstallTime;
              result.success(String.valueOf(firstInstallTime));
            } catch (PackageManager.NameNotFoundException e) {
              e.printStackTrace();
              result.error("PACKAGE NAME NOT FOUND", "Package name was not found", null);
            }
          }
        }
      }
    );
  }
}
