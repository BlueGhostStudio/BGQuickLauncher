TEMPLATE = lib
TARGET = BGCanvas
QT += qml quick
CONFIG += plugin c++11

TARGET = $$qtLibraryTarget($$TARGET)
uri = BGCanvas

# Input
SOURCES += \
    bgcanvas_plugin.cpp \
    bgcanvas.cpp

HEADERS += \
    bgcanvas_plugin.h \
    bgcanvas.h


specTest = $$basename(QMAKESPEC)
equals(specTest, "android-g++") {
    message("android")
    TARGET = $$PWD/../BGQuickLauncher-Quick/Initial/plugins/android/$$TARGET
} else {
    message("desktop")
    TARGET = $$PWD/../BGQuickLauncher-Quick/Initial/plugins/desktop/$$TARGET
}

DISTFILES = qmldir
!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/qmldir
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
    copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
    QMAKE_EXTRA_TARGETS += copy_qmldir
    PRE_TARGETDEPS += $$copy_qmldir.target
}

qmldir.files = qmldir
unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir
}
