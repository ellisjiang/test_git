PRODUCT_COPY_FILES += \
    device/ingenic/watch/tencent/apps/Labyrinth/lib/mips/libcocos2dcpp.so:/system/lib/libcocos2dcpp.so \
    device/ingenic/watch/tencent/Library/gif/mips/libgif_drawable.so:/system/lib/libgif_drawable.so \
    device/ingenic/watch/tencent/Library/gif/mips/libgif_drawable_surface.so:/system/lib/libgif_drawable_surface.so \
    vendor/ingenic/watchcommon/qrom/lib/mips/libvad.so:system/lib/libvad.so \
    vendor/ingenic/watchcommon/qrom/lib/mips/libwxvoiceembed.so:system/lib/libwxvoiceembed.so

    
PRODUCT_PACKAGES += \
    qqagent \
    launcher \
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
    libWXVoice \
    libmatch \
    libsecure_proc.so \
    qwearsystemui \
    powerkey

#
# qrom.mk
#

QROM_BUILD_PROP_FILE := \
    device/ingenic/watch/build.prop

# QROM_NOTICE is important, use it to override product pacakges.
PRODUCT_PACKAGES += QROM_NOTICE

QROM_PRODUCT_PACKAGE_OVERRIDES := \
    QuickSearchBox \
    VideoEditor \
    VoiceDialer

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.timezone=Asia/Shanghai \
    ro.product.locale.language=zh \
    ro.product.locale.region=CN

