/*
   Copyright (c) 2015, The Linux Foundation. All rights reserved.
                 2016 The CyanogenMod Project.
                 2019-2020 The LineageOS Project.
                 2021 The Android Open Source Project.
                 2022-2024 Paranoid Android.

   SPDX-License-Identifier: Apache-2.0

 */

#include <cstdlib>
#include <string.h>

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>
#include <android-base/properties.h>

#include "property_service.h"
#include "vendor_init.h"

using android::base::GetProperty;
using std::string;

// List of partitions to override props
static const string source_partitions[] = {
    "", "bootimage.", "odm.", "product.", "system.",
    "system_dlkm.", "system_ext.", "vendor.", "vendor_dlkm."
};

bool IsRecoveryMode() {
    return access("/system/bin/recovery", F_OK) == 0;
}

void property_override(char const prop[], char const value[]) {
    auto pi = (prop_info*) __system_property_find(prop);

    if (pi != nullptr)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void set_build_prop(const string &prop, const string &value) {
    property_override(prop.c_str(), value.c_str());
}

void set_ro_build_prop(const string &prop, const string &value) {
    string prop_name;
    for (const string &source : source_partitions) {
        prop_name = "ro.product." + source + prop;
        property_override(prop_name.c_str(), value.c_str());
    }
}

void vendor_load_properties() {
    // Detect variant and override properties
    string region = GetProperty("ro.boot.hwc", "");
    string sku = GetProperty("ro.boot.hardware.sku", "");

    // Override device specific props
    set_build_prop("ro.build.product", sku);
    set_ro_build_prop("device", sku);

    if (sku == "fuxi") { // Xiaomi 13
        if (region == "CN") { // China
            set_ro_build_prop("model", "2211133C");
            set_ro_build_prop("name", "fuxi");
        } else {              // Global
            set_ro_build_prop("model", "2211133G");
            set_ro_build_prop("name", "fuxi_global");
        }
    } else if (sku == "nuwa") { // Xiaomi 13 Pro
        if (region == "CN") { // China
            set_ro_build_prop("model", "2210132C");
            set_ro_build_prop("name", "nuwa");
        } else {              // Global
            set_ro_build_prop("model", "2210132G");
            set_ro_build_prop("name", "nuwa_global");
        }
    } else if (sku == "ishtar") { // Xiaomi 13 Ultra
        if (region == "CN") { // China
            set_ro_build_prop("model", "2304FPN6DC");
            set_ro_build_prop("name", "ishtar");
        } else {              // Global
            set_ro_build_prop("model", "2304FPN6DG");
            set_ro_build_prop("name", "ishtar_global");
        }
    } else if (sku == "vermeer") { // POCO F6 Pro / Redmi K70
        if (region == "CN") { // China - Redmi K70
            set_ro_build_prop("model", "23113RKC6C");
            set_ro_build_prop("name", "vermeer");
            set_ro_build_prop("brand", "Redmi");
        } else {              // Global - POCO F6 Pro
            set_ro_build_prop("model", "23113RKC6G");
            set_ro_build_prop("name", "vermeer_global");
        }
    } else if (sku == "sheng") { // Xiaomi Pad 6S Pro 12.4
        if (region == "CN") { // China
            set_ro_build_prop("model", "24018RPACC");
            set_ro_build_prop("name", "sheng");
        } else {              // Global
            set_ro_build_prop("model", "24018RPACG");
            set_ro_build_prop("name", "sheng_global");
        }
    }

    // Override hardware revision
    set_build_prop("ro.boot.hardware.revision", sku);
}