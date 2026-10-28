package com.rashidzada.pfapp.pf_app

import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.rashidzada.pfapp/native"
    private val PREFS_NAME = "pf_rashid_zada_prefs"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "launchUrl" -> {
                        val url = call.argument<String>("url")
                        if (url.isNullOrEmpty()) {
                            result.success(false)
                            return@setMethodCallHandler
                        }
                        try {
                            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.success(false)
                        }
                    }
                    "saveData" -> {
                        val key = call.argument<String>("key") ?: "student_state"
                        val value = call.argument<String>("value") ?: "{}"
                        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                        prefs.edit().putString(key, value).apply()
                        result.success(true)
                    }
                    "loadData" -> {
                        val key = call.argument<String>("key") ?: "student_state"
                        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                        val value = prefs.getString(key, null)
                        result.success(value)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
