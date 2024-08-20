#
# Copyright (C) 2023-2024 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

# Configure updatable_apex.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Get non-open-source specific aspects
$(call inherit-product, vendor/xiaomi/sm8550-common/sm8550-common-vendor.mk)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/xiaomi

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# A/B
ENABLE_AB := true
ENABLE_VIRTUAL_AB := true

$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/android_t_baseline.mk)

PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := gz

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

# Board
TARGET_BOARD_PLATFORM := kalama

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# QTI components
TARGET_COMMON_QTI_COMPONENTS := \
    adreno \
    alarm \
    audio \
    av \
    bt \
    display \
    gps \
    init \
    overlay \
    perf \
    telephony \
    usb \
    wfd \
    wlan

TARGET_USE_AIDL_QTI_BT_AUDIO := true
TARGET_USE_AIDL_QTI_HEALTH := true

# Shipping API level
BOARD_API_LEVEL := 33
BOARD_SHIPPING_API_LEVEL := 33
PRODUCT_SHIPPING_API_LEVEL := 33

# ANT+
PRODUCT_PACKAGES += \
    com.dsi.ant@1.0.vendor

# Atrace
PRODUCT_PACKAGES += \
    android.hardware.atrace@1.0-service

# Audio
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-V2-ndk.vendor

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kalama_qssi/audio_policy_configuration.xml

# Authsecret
PRODUCT_PACKAGES += \
    android.hardware.authsecret@1.0.vendor

# Boot Control
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl-qti \
    android.hardware.boot@1.2-impl-qti.recovery \
    android.hardware.boot@1.2-service

# Camera
$(call inherit-product-if-exists, vendor/xiaomi/camera/miuicamera.mk)

PRODUCT_PACKAGES += \
    android.hardware.camera.common-V1-ndk.vendor \
    android.hardware.camera.device-V1-ndk.vendor \
    android.hardware.camera.metadata-V1-ndk.vendor \
    android.hardware.camera.provider-V1-ndk.vendor \
    android.hardware.camera.provider@2.4-external \
    android.hardware.camera.provider@2.4-legacy \
    android.hardware.camera.provider@2.7.vendor \
    android.hardware.camera.common@1.0.vendor \
    camera.device@1.0-impl \
    libcamera2ndk_vendor \
    vendor.qti.hardware.camera.aon@1.3.vendor \
    vendor.qti.hardware.camera.device@1.0.vendor \
    vendor.qti.hardware.camera.postproc@1.0.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

# Characteristics
PRODUCT_CHARACTERISTICS := nosdcard

# Consumer IR
PRODUCT_PACKAGES += \
    android.hardware.ir-service.example

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml

# Display
TARGET_PANEL_DIMENSION_HAS_EXTRA_PRECISION := true
TARGET_USE_YCRCB_CAMERA_ENCODE := true

# Dolby
PRODUCT_PACKAGES += \
    XiaomiDolby

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.3.vendor \
    android.hardware.drm-service.clearkey \
    libdrm.vendor

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.3-service.xiaomi \
    libudfpshandler

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0.vendor

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.qti \
    android.hardware.health-service.qti_recovery \
    android.hardware.health@1.0.vendor \
    android.hardware.health@2.1.vendor

# Hotword Enrollement
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/permissions/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml

# Identity
PRODUCT_PACKAGES += \
    android.hardware.identity-V4-ndk.vendor

# Init
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.target.rc \
    init.mi_perf.rc \
    init.mi_service.rc \
    init.mi_udfps.rc \
    ueventd.xiaomi.rc

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/fstab.qcom:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.qcom

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1.vendor \
    libkeymaster_messages.vendor

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore.xml \
    android.hardware.security.keymint-V2-ndk.vendor \
    android.hardware.security.rkp-V3-ndk.vendor \
    android.hardware.security.secureclock-V1-ndk.vendor \
    android.hardware.security.sharedsecret-V1-ndk.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml

# Lineage Health
PRODUCT_PACKAGES += \
    vendor.lineage.health-service.default

# Logging
SPAMMY_LOG_TAGS := \
    MiStcImpl \
    SDM \
    SDM-histogram \
    SRE \
    WifiHAL \
    cnss-daemon \
    libcitsensorservice@2.0-impl \
    libsensor-displayalgo \
    libsensor-parseRGB \
    libsensor-ssccalapi \
    sensors \
    vendor.qti.hardware.display.composer-service \
    vendor.xiaomi.sensor.citsensorservice@2.0-service

ifneq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_VENDOR_PROPERTIES += \
    $(foreach tag,$(SPAMMY_LOG_TAGS),log.tag.$(tag)=E)
endif

# Media
PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.2.vendor \
    libavservices_minijail \
    libavservices_minijail.vendor \
    libcodec2_soft_common.vendor \
    libcodec2_hidl@1.2.vendor \
    libcodec2_vndk.vendor \
    libgui_vendor \
    libsfplugin_ccodec_utils.vendor \
    libstagefrighthw

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml

# Mlipay
PRODUCT_PACKAGES += \
    IFAAService

# Neural Networks
PRODUCT_PACKAGES += \
    android.hardware.neuralnetworks-V1-ndk.vendor

# NFC
$(call inherit-product, vendor/nxp/opensource/commonsys/packages/apps/Nfc/nfc_system_product.mk)
$(call inherit-product, vendor/st/opensource/commonsys/packages/apps/Nfc/nfc_system_product.mk)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.uicc.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml

# Overlays
PRODUCT_PACKAGES += \
    Xiaomi8550CarrierConfigRes \
    Xiaomi8550CarrierConfigResMiui \
    Xiaomi8550DeviceAsWebcamRes \
    Xiaomi8550Frameworks \
    Xiaomi8550FrameworksAOSPA \
    Xiaomi8550Nfc \
    Xiaomi8550NfcST \
    Xiaomi8550SecureElement \
    Xiaomi8550Settings \
    Xiaomi8550SystemUI \
    Xiaomi8550SystemUIAOSPA \
    Xiaomi8550WifiRes \
    Xiaomi8550WifiResMainline \

# Parts
PRODUCT_PACKAGES += \
    XiaomiParts

# RenderScript
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

# Powershare
PRODUCT_PACKAGES += \
    vendor.aospa.powershare-service

# QMI
PRODUCT_PACKAGES += \
    libjson

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors-service.xiaomi-multihal \
    libsensorndkbridge \
    sensor-notifier \
    sensors.xiaomi

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0 \
    android.hardware.thermal@2.0.vendor \
    android.hardware.thermal@2.0-service.qti-v2

# Touchscreen
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml

# Trusted User Interface
PRODUCT_PACKAGES += \
    android.hidl.memory.block@1.0.vendor \
    vendor.qti.hardware.systemhelper@1.0.vendor

# Update Engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

# USB
PRODUCT_HAS_GADGET_HAL := true

# Verified Boot
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# Vibrator
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service.xiaomi

PRODUCT_COPY_FILES += \
    hardware/xiaomi/aidl/vibrator/excluded-input-devices.xml:$(TARGET_COPY_OUT_VENDOR)/etc/excluded-input-devices.xml

# VNDK
PRODUCT_COPY_FILES += \
    prebuilts/vndk/v33/arm64/arch-arm64-armv8-a/shared/vndk-core/libcrypto.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libcrypto-v33.so \
    prebuilts/vndk/v33/arm64/arch-arm64-armv8-a/shared/vndk-core/libstagefright_foundation.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libstagefright_foundation-v33.so

# WiFi
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

# WiFi Display
PRODUCT_PACKAGES += \
    libnl \
    libwfdaac_vendor
