package com.deathblade666.mdeditor

//import io.flutter.embedding.android.FlutterActivity

//class MainActivity: FlutterActivity()

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "markdown editor";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                if (call.method.equals("getFileUri")) {
                    Intent intent = getIntent();
                    String action = intent.getAction();
                    Uri data = intent.getData();

                    if (Intent.ACTION_VIEW.equals(action) && data != null) {
                        result.success(data.toString());
                    } else {
                        result.error("UNAVAILABLE", "File URI not available.", null);
                    }
                } else {
                    result.notImplemented();
                }
            });
    }
}

