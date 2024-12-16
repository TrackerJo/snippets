package com.kazoom.snippets

import io.flutter.embedding.android.FlutterActivity
import android.content.ComponentName
import android.content.pm.PackageManager
 import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.NonNull

class MainActivity: FlutterActivity() {

    fun changeAppIcon(newIcon: String, previousIcon: String) {
        val pm = packageManager

        
        // Enable new alias (newIcon)
        pm.setComponentEnabledSetting(
            ComponentName(this, "$packageName.$newIcon"),
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )

        // Disable current alias
        pm.setComponentEnabledSetting(
            ComponentName(this, "$packageName.$previousIcon"),
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        )
    }
   

override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app.icon")
        .setMethodCallHandler { call, result ->
            when (call.method) {
                "changeAppIcon" -> {
                    val iconName: String? = call.argument("iconName")
                    val previousIcon: String? = call.argument("previousIcon")
                    if (iconName != null && previousIcon != null) {
                        changeAppIcon(iconName, previousIcon)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "Icon name is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
}
}