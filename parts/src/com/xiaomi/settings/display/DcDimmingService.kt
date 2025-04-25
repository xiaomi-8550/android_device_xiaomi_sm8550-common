/*
 * SPDX-FileCopyrightText: 2023-2025 Paranoid Android
 * SPDX-License-Identifier: Apache-2.0
 */

package com.xiaomi.settings.display

import android.app.Service
import android.content.Intent
import android.database.ContentObserver
import android.os.Handler
import android.os.IBinder
import android.os.UserHandle
import android.provider.Settings
import android.util.Log

class DcDimmingService : Service() {

    companion object {
        private const val TAG = "DcDimmingService"
        private val DEBUG = Log.isLoggable(TAG, Log.DEBUG)

        private const val DC_DIMMING_MODE = 20
    }

    private val handler = Handler()

    private val settingObserver =
        object : ContentObserver(handler) {
            override fun onChange(selfChange: Boolean) {
                if (DEBUG) Log.d(TAG, "SettingObserver: onChange")
                updateDcDimming()
            }
        }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (DEBUG) Log.d(TAG, "Starting service")
        contentResolver.registerContentObserver(
            Settings.System.getUriFor(Settings.System.DC_DIMMING_STATE),
            false,
            settingObserver,
            UserHandle.USER_CURRENT,
        )
        updateDcDimming()
        return START_STICKY
    }

    override fun onDestroy() {
        if (DEBUG) Log.d(TAG, "Destroying service")
        contentResolver.unregisterContentObserver(settingObserver)
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun updateDcDimming() {
        val enabled = Settings.System.getInt(contentResolver, Settings.System.DC_DIMMING_STATE, 0)
        if (DEBUG) Log.d(TAG, "updateDcDimming: enabled=$enabled")
        try {
            DisplayFeatureWrapper.setFeature(DC_DIMMING_MODE, enabled, 0)
        } catch (e: Exception) {
            Log.e(TAG, "updateDcDimming failed!", e)
        }
    }
}
