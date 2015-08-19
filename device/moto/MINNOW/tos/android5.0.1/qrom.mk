#
# qrom.mk @ apps.git
#

# TODO
# Set it for debug

PRODUCT_PACKAGES += \
    launcher \
    devicemanageragent \
    wechatagent \
    pedometer \
    yiya.watch \
    findphone \
    watchsetting 

PRODUCT_COPY_FILES += \
$(QROM_APPS_DIR)/misc/armeabi-v7a/libgif_drawable_surface.so:system/lib/libgif_drawable_surface.so \
$(QROM_APPS_DIR)/misc/armeabi-v7a/libgif_drawable.so:system/lib/libgif_drawable.so \
$(QROM_APPS_DIR)/lib/libvad.so:system/lib/libvad.so \
$(QROM_APPS_DIR)/lib/libwxvoiceembed.so:system/lib/libwxvoiceembed.so


	


