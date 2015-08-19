PRODUCT_COPY_FILES += \
    packages/tencent/lib/libWXVoice.so:system/lib/libWXVoice.so \
    packages/tencent/lib/libmatch.so:system/lib/libmatch.so \
    packages/tencent/lib/libcocos2dcpp.so:system/lib/libcocos2dcpp.so \
    packages/tencent/lib/libImgProcessScan.so:system/lib/libImgProcessScan.so \
    packages/tencent/lib/libQrMod.so:system/lib/libQrMod.so \
    packages/tencent/lib/libsecure_proc.so:system/lib/libsecure_proc.so \
    packages/tencent/lib/libstlport_shared.so:system/lib/libstlport_shared.so \
    packages/tencent/lib/libgif_drawable.so:system/lib/libgif_drawable.so \
    packages/tencent/lib/libgif_drawable_surface.so:system/lib/libgif_drawable_surface.so \
    packages/tencent/animations/bootanimation.zip:system/media/bootanimation-tencent.zip \
    packages/tencent/animations/shutdownanimation.zip:system/media/shutdownanimation.zip
    
PRODUCT_PACKAGES += \
    devicemanageragent \
    pedometer \
    watchlauncher \
    watchsetting \
    yiya.watch \
    wechatagent \
    findphone \
    heartrate \
    watchmusicplayer \
    chargingui \
    Labyrinth \
    qwearsystemui \
    twsbluetoothphone \
    qqagent \
    powerkey

define month_convert
$(if $(filter Jan,$(1)),$(shell echo 01))
$(if $(filter Feb,$(1)),$(shell echo 02))
$(if $(filter Mar,$(1)),$(shell echo 03))
$(if $(filter Apr,$(1)),$(shell echo 04))
$(if $(filter May,$(1)),$(shell echo 05))
$(if $(filter Jun,$(1)),$(shell echo 06))
$(if $(filter Jul,$(1)),$(shell echo 07))
$(if $(filter Aug,$(1)),$(shell echo 08))
$(if $(filter Sep,$(1)),$(shell echo 09))
$(if $(filter Oct,$(1)),$(shell echo 10))
$(if $(filter Nov,$(1)),$(shell echo 11))
$(if $(filter Dec,$(1)),$(shell echo 12))
endef

define day_format
$(shell printf "%02d" $(1))
endef

GET_COMMIT_DATE=$(shell cd ./packages/tencent;git log -n1|grep Date)
COMMIT_DATE_YEAR=$(strip $(shell echo $(word 6,$(GET_COMMIT_DATE))|cut -c 3-4))
COMMIT_DATE_MONTH=$(strip $(call month_convert,$(word 3,$(GET_COMMIT_DATE))))
COMMIT_DATE_DAY=$(strip $(call day_format,$(shell echo $(word 4,$(GET_COMMIT_DATE)))))

ifeq ($(strip $(QROM_BUILD_TENCENT)),)
ADDITIONAL_BUILD_PROPERTIES += \
     persist.sys.timezone=Asia/Shanghai \
     ro.qrom.beaconkey = 0M000V5PH01B6QQD \
     ro.qrom.product.device = P802W10 \
     ro.qrom.product.device.brand = ZTE \
     ro.qrom.build.version.number = 01$(COMMIT_DATE_YEAR)$(COMMIT_DATE_MONTH)$(COMMIT_DATE_DAY) \
     ro.qrom.build.version.name = ADRQRTWS01_GA \
     ro.qrom.build.version.snver = 01 \
     ro.qrom.build.version.snflag = ADRQRTWS \
     ro.qrom.build.version.day = $(COMMIT_DATE_YEAR)$(COMMIT_DATE_MONTH)$(COMMIT_DATE_DAY) \
     ro.qrom.build.version.type = GA \
     ro.qrom.build.number = $(strip $(shell echo $(BUILD_VERSION_ZTE)|cut -c 13-15)) \
     ro.qrom.build.lc = A1B2C3000D4E5F6 \
     ro.qrom.build.lcid = 99 \
     ro.qrom.build.brand = tws \
     ro.qrom.build.date = $(shell date +%y%m%d) \
     ro.qrom.build.date.utc = $(shell date +%s) \
     ro.qrom.build.os = android5.1.1 \
     ro.qrom.build.channel = 10100
endif