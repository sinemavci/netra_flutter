package com.example.netra_flutter

import com.example.netra_flutter.NetraControllerPigeon.NetraHostApi
import com.example.netra_flutter.controller.NetraServiceController
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** NetraFlutterPlugin */
class NetraFlutterPlugin :
    FlutterPlugin,
    MethodCallHandler {
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val netraServiceHostApi: NetraHostApi =
            NetraServiceController(flutterPluginBinding.applicationContext)
        NetraHostApi.setUp(flutterPluginBinding.binaryMessenger, netraServiceHostApi)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        NetraHostApi.setUp(binding.binaryMessenger, null)
    }
}
