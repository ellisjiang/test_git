LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE       := qwearsystemui
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_SRC_FILES    := qwearsystemui_150812.15_release_internal.apk
LOCAL_MODULE_PATH  := $(TARGET_OUT_APPS_PRIVILEGED)
LOCAL_CERTIFICATE  := platform
LOCAL_MODULE_OWNER := tencent
include $(BUILD_PREBUILT)