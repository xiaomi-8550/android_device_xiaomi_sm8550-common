/*
 * Copyright (C) 2023-2024 Paranoid Android
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package com.xiaomi.settings;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.hardware.display.DisplayManager;
import android.os.IBinder;
import android.os.UserHandle;
import android.util.Log;
import android.view.Display;
import android.view.Display.HdrCapabilities;

import com.xiaomi.settings.display.ColorModeService;
import com.xiaomi.settings.display.DcDimmingService;
import com.xiaomi.settings.doze.AodBrightnessService;
import com.xiaomi.settings.edgesuppression.EdgeSuppressionService;
import com.xiaomi.settings.touch.TouchOrientationService;

public class BootCompletedReceiver extends BroadcastReceiver {

    private static final String TAG = "XiaomiParts";
    private static final boolean DEBUG = Log.isLoggable(TAG, Log.DEBUG);

    @Override
    public void onReceive(final Context context, Intent intent) {
        if (DEBUG) Log.d(TAG, "Received boot completed intent: " + intent.getAction());
        switch (intent.getAction()) {
            case Intent.ACTION_LOCKED_BOOT_COMPLETED:
                onLockedBootCompleted(context);
                break;
            case Intent.ACTION_BOOT_COMPLETED:
                onBootCompleted(context);
                break;
        }
    }

    private static void onLockedBootCompleted(Context context) {
        // AOD
        context.startServiceAsUser(new Intent(context, AodBrightnessService.class),
                UserHandle.CURRENT);

        // Display
        context.startServiceAsUser(new Intent(context, ColorModeService.class),
                UserHandle.CURRENT);
        context.startServiceAsUser(new Intent(context, DcDimmingService.class),
                UserHandle.CURRENT);

        // Touchscreen
        context.startServiceAsUser(new Intent(context, EdgeSuppressionService.class),
                UserHandle.CURRENT);
        context.startServiceAsUser(new Intent(context, TouchOrientationService.class),
                UserHandle.CURRENT);
        
        // Override HDR types to enable Dolby Vision
        final DisplayManager displayManager = context.getSystemService(DisplayManager.class);
        displayManager.overrideHdrTypes(Display.DEFAULT_DISPLAY, new int[]{
                HdrCapabilities.HDR_TYPE_DOLBY_VISION, HdrCapabilities.HDR_TYPE_HDR10,
                HdrCapabilities.HDR_TYPE_HLG, HdrCapabilities.HDR_TYPE_HDR10_PLUS});
    }

    private static void onBootCompleted(Context context) {
    }
}
