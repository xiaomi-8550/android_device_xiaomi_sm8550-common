/*
 * SPDX-FileCopyrightText: 2023-2025 Paranoid Android
 * SPDX-License-Identifier: Apache-2.0
 */

package com.xiaomi.settings.touch

import android.app.Service
import android.content.Intent
import android.content.res.Configuration
import android.os.IBinder
import android.util.Log
import com.xiaomi.settings.utils.writeLine

class TouchOrientationService : Service() {

    companion object {
        private const val TAG = "TouchOrientationService"
        private val DEBUG = Log.isLoggable(TAG, Log.DEBUG)

        private const val TOUCH_PANEL_ORIENTATION_PATH = "/sys/class/touch/touch_dev/panel_orientation"
    }

    private var rotation: Int = 0
        set(value) {
            if (field == value) return
            field = value
            if (DEBUG) Log.d(TAG, "rotation=$value")
            runCatching {
                    // Lucky for us, Surface.ROTATION_* directly translates into touchpanel values
                    writeLine(TOUCH_PANEL_ORIENTATION_PATH, rotation)
                }
                .onFailure { e -> Log.e(TAG, "Failed to set touch panel orientation", e) }
        }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (DEBUG) Log.d(TAG, "onStartCommand")
        updateOrientation()
        return START_STICKY
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        if (DEBUG) Log.d(TAG, "onConfigurationChanged")
        updateOrientation()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun updateOrientation() {
        rotation = display.rotation
    }
}
