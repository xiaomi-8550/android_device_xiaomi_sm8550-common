/*
 * Copyright (C) 2023-2024 Paranoid Android
 *
 * SPDX-License-Identifier: Apache-2.0
 */

package com.xiaomi.settings.touch;

import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.ContentObserver;
import android.net.Uri;
import android.os.Handler;
import android.os.IBinder;
import android.os.UserHandle;
import android.provider.Settings;
import android.util.Log;
import android.view.Display;

import com.xiaomi.settings.utils.FileUtils;

public class TapToWakeService extends Service {

    private static final String TAG = "XiaomiPartsTapToWakeService";
    private static final boolean DEBUG = true;

    private static final String SECURE_KEY_TAP = "doze_tap_gesture";

    private boolean mEnabled;

    private ContentResolver mContentResolver;
    private ScreenStateReceiver mScreenStateReceiver;
    private SettingsObserver mSettingsObserver;
    private final Handler mHandler = new Handler();

    @Override
    public void onCreate() {
        super.onCreate();
        if (DEBUG) Log.d(TAG, "Creating service");
        mContentResolver = getContentResolver();
        mScreenStateReceiver = new ScreenStateReceiver();
        mSettingsObserver = new SettingsObserver(mHandler);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startid) {
        if (DEBUG) Log.d(TAG, "Starting service");
        mScreenStateReceiver.register();
        mSettingsObserver.register();
        mSettingsObserver.update();
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        if (DEBUG) Log.d(TAG, "Destroying service");
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private final class ScreenStateReceiver extends BroadcastReceiver {
        public void register() {
            if (DEBUG) Log.d(TAG, "ScreenStateReceiver: register");
            registerReceiver(mScreenStateReceiver, new IntentFilter(Intent.ACTION_SCREEN_ON));
            registerReceiver(mScreenStateReceiver, new IntentFilter(Intent.ACTION_SCREEN_OFF));
        }

        @Override
        public void onReceive(Context context, Intent intent) {
            if (DEBUG) Log.d(TAG, "onReceive: " + intent.getAction());
            int displayState = getDisplay().getState();
            boolean displayStateOff = displayState != Display.STATE_ON;
            TfWrapper.setTouchFeature(
                    new TfWrapper.TfParams(/*TOUCH_AOD_ENABLE*/ 11, displayStateOff && mEnabled ? 1 : 0));
        }
    }

    private final class SettingsObserver extends ContentObserver {
        SettingsObserver(Handler handler) {
            super(handler);
        }

        public void register() {
            if (DEBUG) Log.d(TAG, "SettingsObserver: register");
            mContentResolver.registerContentObserver(
                    Settings.Secure.getUriFor(SECURE_KEY_TAP), false, this);
        }

        void update() {
            mEnabled = Settings.Secure.getInt(mContentResolver, SECURE_KEY_TAP, 1) != 0;
            if (DEBUG) Log.d(TAG, "SettingsObserver: SECURE_KEY_TAP: " + mEnabled);
        }

        @Override
        public void onChange(boolean selfChange, Uri uri) {
            if (DEBUG) Log.d(TAG, "SettingsObserver: onChange: " + uri.toString());
            if (uri.equals(Settings.Secure.getUriFor(SECURE_KEY_TAP))) {
                update();
            }
        }
    }
}