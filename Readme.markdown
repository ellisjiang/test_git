# APP合入QROM

--------

> * apps.git目前分为两个分支(dev和master)，请确认当前分支

> * 提交前最好先测试验证

> * 参考一下步骤

# 合入步骤

## 1. 参考sample创建同级的目录，将需要合入的放到该目录下

```
.
├── Android.mk
├── Readme.markdown
└── sample
    ├── Android.mk
    ├── libqsample.so
    └── qsample.apk
```

## 2. 参考sample下的Android.mk写自己的Android.mk

> 创建了Android.mk仅仅是声明了定义了模块，需要在qrom.mk中声明合入到具体机型。

```
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE       := qsample
LOCAL_REQUIRED_MODULES := qromsample samplebin libqrom_sample libqrom_sample_misc_0.1
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
ifeq ($(QROM_INTEGRATE_DEBUG_APP),true)
LOCAL_SRC_FILES    := qsample_0.1.140808_1_debug.apk
else
LOCAL_SRC_FILES    := qsample_0.1.140808_1_release.apk
endif
LOCAL_MODULE_PATH  := $(TARGET_OUT_APPS)
#LOCAL_OVERRIDES_PACKAGES := MODULE_TO_BE_OVERRIDED
LOCAL_CERTIFICATE  := PRESIGNED
LOCAL_MODULE_OWNER := tencent
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := qromsample
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
LOCAL_MODULE_SUFFIX := .jar
LOCAL_SRC_FILES    := qromsample_0.1.jar
LOCAL_MODULE_PATH  := $(TARGET_OUT_JAVA_LIBRARIES)
LOCAL_MODULE_OWNER := tencent
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE       := samplebin
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES    := samplebin_0.1
LOCAL_MODULE_PATH  := $(TARGET_OUT_EXECUTABLES)
LOCAL_MODULE_OWNER := tencent
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := libqrom_sample
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_SRC_FILES := libqrom_sample_0.1.so
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_MODULE_OWNER := tencent
include $(BUILD_PREBUILT)
```

### 2.1 apk签名

```
使用LOCAL_CERTIFICATE来指定使用的签名类型，如果保留原有签名则将LOCAL_CERTIFICATE设置为PRESIGNED
对于QROM的apk通常设置为：platform、media、shared
```

## 3. 合入到具体机型的PRODUCT_PACKAGES中，统一在qrom.mk下

### 3.1 只希望debug版本有，release版本没有

```
参考“更多”中的LOCAL_MODULE_TAGS小节

```

### 3.2 替换

```
参考“更多”中的LOCAL_REQUIRED_MODULES小节

```

### 3.3 合入到具体机型

具体`机型`对应的`qrom.mk`中追加`模块名`到变量`PRODUCT_PACKAGES`

* 机型目录下的qrom.mk (对apps.git所有分支有效)

* apps.git device下对应机型的qrom.mk (只对当前分支的apps.git有效)

```
PRODUCT_PACKAGES += \
   qsample \
   ……
```

### 3.4 反编译机型qrom.mk分布到apps.git

> 在机型目录下必须保留qrom.mk文件，仅将`PRODUCT_PACKAGES`部分放到apps.git

    $ tree device/
    device/
    ├── lg
    │   └── hammerhead
    │       └── qrom
    │           └── android4.4.4
    │               └── qrom.mk
    └── samsung
        └── GT-I9500
            └── qrom
                └── android4.4.2
                    └── qrom.mk

在apps.git的device目录之下，目录层次分别是机型目录下的build.prop中的值，如:

    $ cat build.prop
    ro.qrom.product.device=GT-I9500
    ro.qrom.product.device.brand=samsung
    ro.qrom.build.brand=qrom
    ro.qrom.build.os=android4.4.2

在机型目录下的`config.sh`中添加

    USE_APPS_QROM_MK=true

## 4. changelog

```
各模块提交需要包含changelog，具体规范参照规范文档。
```

# 更多

## 1 LOCAL_MODULE_PATH

```
TARGET_OUT_EXECUTABLES                  /system/bin
TARGET_OUT_SHARED_LIBRARIES             /system/lib
TARGET_OUT_JAVA_LIBRARIES               /system/framework
TARGET_OUT_APPS                         /system/app
TARGET_OUT_APPS_PRIVILEGED              /system/priv-app
TARGET_OUT_KEYLAYOUT                    /system/usr/keylayout
TARGET_OUT_KEYCHARS                     /system/usr/keychars
TARGET_OUT_ETC                          /system/etc
TARGET_OUT_FAKE                         /system/fake_packages
TARGET_OUT_VENDOR                       /system/vendor
TARGET_OUT_VENDOR_EXECUTABLES           /system/vendor/bin
TARGET_OUT_VENDOR_OPTIONAL_EXECUTABLES  /system/vendor/xbin
TARGET_OUT_VENDOR_SHARED_LIBRARIES      /system/vendor/lib
TARGET_OUT_VENDOR_JAVA_LIBRARIES        /system/vendor/framework
TARGET_OUT_VENDOR_APPS                  /system/vendor/app
TARGET_OUT_VENDOR_ETC                   /system/vendor/etc

ref to build/core/envsetup.mk
```

## 2 替换模块

### 2.1 QROM源码

> 只支替换LOCAL_MODULE_CLASS := APPS的模块

```
例如QLauncher要替换原生Launcher2，那么需要再QLauncher对应的脚本加入：
LOCAL_OVERRIDES_PACKAGES := Launcher2
```

### 2.2 反编译

```
在反编译继续中修改removed_file_list
```

## 3 需要Root权限

> 此项修改需要通知baodingzhou同步到反编译集成，否则反编译集成不生效

```
有些特殊的可执行文件需要支持root权限,所以需要额外修改
QROM源码:
参考
system/core/include/private/android_filesystem_config.h
```

## 4 LOCAL_REQUIRED_MODULES

```
使用LOCAL_REQUIRED_MODULES来指定本模块依赖的模块，例如otaupdater需要用到rootstub和libtcm
所以可以用
LOCAL_REQUIRED_MODULES := rootstub libtcm
来指定这种关系，这样PRODUCT_PACKAGES就可以不指定rootstub和libtcm，编译会根据依赖关系自动添加。
```

## 5 LOCAL_MODULE_TAGS

```
通常将LOCAL_MODULE_TAGS设置为optional即可，然后需要到具体机型PRODUCT_PACKAGES中添加模块名，例如：
LOCAL_MODULE_TAGS := optional
但是对于有些模块希望在debug版时集成，但在release版时不集成，就需要设置LOCAL_MODULE_TAGS为debug，例如：
LOCAL_MODULE_TAGS := debug
```

## 6 QROM_INTEGRATE_DEBUG_APP

```
如果本次编译希望集成debug版本的apk，则QROM_INTEGRATE_DEBUG_APP会设置为true，当发布类型为DD或SD是，会设置为true
即当QROM_INTEGRATE_DEBUG_APP的值为true时，LOCAL_SRC_FILES需要指向debug版本的apk，其它情况必须为release版本的apk：
ifeq ($(QROM_INTEGRATE_DEBUG_APP),true)
LOCAL_SRC_FILES    := qsample_0.1.140808_1_debug.apk
else
LOCAL_SRC_FILES    := qsample_0.1.140808_1_release.apk
endif
```

## 7 公共模块

```
公共模块需要独立出来，例如otaupdater需要用到rootstub和libtcm，但其他模块也需要修改或用到这两个模块，所以这两个模块为公共模块。
对于大的、好分类的公共模块可以直接创建一个目录，对于小的或不好分类的则推荐放到miscellany下:
$ tree miscellany/
miscellany/
├── Android.mk
├── changelog
├── libqrom_sample_miscellany_0.1.so
├── libtcm.so
├── rootstub
└── sample
    ├── Android.mk
    ├── changeLog
    ├── libqrom_sample_miscellany_sample1_0.1.so
    └── libqrom_sample_miscellany_sample2_0.1.so

$ cat miscellany/Android.mk 
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := libqrom_sample_miscellany_0.1
LOCAL_REQUIRED_MODULES := libqrom_sample_miscellany1_sample_0.1 libqrom_sample_miscellany_sample2_0.1
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_SRC_FILES := libqrom_sample_miscellany_0.1.so
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_MODULE_OWNER := tencent
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := rootstub
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_SUFFIX :=
LOCAL_SRC_FILES := rootstub
LOCAL_MODULE_PATH := $(TARGET_OUT_EXECUTABLES)
LOCAL_MODULE_OWNER := tencent
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := libtcm
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_SRC_FILES := libtcm.so
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)
LOCAL_MODULE_OWNER := tencent
include $(BUILD_PREBUILT)

include $(call all-makefiles-under,$(LOCAL_PATH))


$ cat otaupdater/Android.mk
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE        := otaupdater
LOCAL_REQUIRED_MODULES := rootstub libtcm
LOCAL_MODULE_TAGS   := optional
LOCAL_MODULE_CLASS  := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_SRC_FILES     := otaupdater_0.1.140808_8_release.apk
LOCAL_MODULE_PATH   := $(TARGET_OUT_APPS)
LOCAL_CERTIFICATE   := platform
LOCAL_MODULE_OWNER  := tencent
include $(BUILD_PREBUILT)
```

## 8 替换或添加/system/build.prop中的property

将要替换或者添加的property写在`机型目录`下的`build.prop`文件, 例如：

源码编译机型(http://git.oa.com/rom/build)

| 机型名称 | 修改文件位置 |
| -------- | ---------- |
| Nexus5 | device/tencent/hammerhead/build.prop |
| Nexus4 | device/tencent/mako/build.prop |

反编译机型(http://tc-svn.tencent.com/mqq/mqq_wsrdplat_rep/NANJI_ROM_proj/trunk/QROM)

| 机型名称 | 修改文件位置 |
| -------- | ---------- |
| I9500 | I9500-4.4.2/build.prop |
| N7100 | N7100-4.3/build.prop |

> 随着版本更新，实际机型目录可能会调整。

## 9 QROM模块与AOSP模块冲突

> 随着QROM模块的增加，在QROM源码编译集成中难免会有与AOSP模块冲突的情况(例如AOSP自带了su，我们在apps.git也加入了su)

> 提供了一种屏蔽AOSP模块的机制(但由于模块屏蔽可能会很复杂，所以只解决当前冲突的问题)

> 在屏蔽AOSP模块前需要确认该模块是否被其它模块依赖

在apps.git的根目录，`config.mk`提供了变量`QROM_OVERRIDE_AOSP_MODULES`以配置需要屏蔽的AOSP模块：

    #
    # QROM Modules override AOSP's
    #
    # Now, Some QROM modules(e.g. su) is in conflict with AOSP's.
    # And It can be predicted, it will be more general in the future, so
    # a method to override modules of AOSP should be implemented.
    #
    # Yet, it is hard to do it
    # So, only solve the current problem and implement it step by step
    #
    # baodingzhou (baodingzhou@tencent.com)
    #
    # Now support override:
    #   BUILD_EXECUTABLE
    #
    #


    QROM_OVERRIDE_AOSP_MODULES := \
        su

## 10 PRODUCT_COPY_FILES

`PRODUCT_COPY_FILES`是AOSP build system支持的一个拷贝功能，用于实现对除apk以外文件的拷贝，相对使用起来更灵活

反编译也实现此功能，用于应对随着机型增多，维护`preinstall`的重复和困难

语法格式:

    源文件:目的文件

例如:

    PRODUCT_COPY_FILES += \
        $(QROM_APPS_DIR)/sample/qromsample_0.1.jar:system/framework/qromsample.jar \
        $(QROM_APPS_DIR)/sample/libqrom_sample_0.1.so:system/lib/libqrom_sample.so \
        $(QROM_APPS_DIR)/sample/samplebin_0.1:system/bin/samplebin \
        $(QROM_APPS_DIR)/sample/changelog:system/etc/changelog

> `$(QROM_APPS_DIR)`指向apps.git根目录

> 将`PRODUCT_COPY_FILES`的追加统一放到`qrom.mk`中

> 建议有限使用`BUILD_PREBUILT`方式

> 注意依赖问题，例如更新了源文件，那么所有机型的目的文件也立刻更新

