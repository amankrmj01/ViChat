package com.example.messenger_app

import android.content.Context
import androidx.multidex.MultiDex
import androidx.multidex.MultiDexApplication
import io.flutter.embedding.android.FlutterActivity

class MainApplication : MultiDexApplication() {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}

class MainActivity: FlutterActivity()
