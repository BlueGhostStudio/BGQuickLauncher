#-------------------------------------------------
#
# Project created by QtCreator 2017-03-23T15:13:34
#
#-------------------------------------------------

QT       += core gui quick
CONFIG += qscintilla2

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = BGQLCreator
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


SOURCES += main.cpp\
        mainwindow.cpp \
    openprojectdialog.cpp \
    prjlistview.cpp \
    filelistview.cpp \
    project.cpp \
    sourceeditorarea.cpp \
    sourceeditor.cpp \
    addprjfiledlg.cpp \
    newprojectdialog.cpp \
    projectpropertygroupbox.cpp \
    prjpropdlg.cpp \
    uploadtodevicewizard.cpp

HEADERS  += mainwindow.h \
    openprojectdialog.h \
    prjlistview.h \
    filelistview.h \
    project.h \
    sourceeditorarea.h \
    sourceeditor.h \
    addprjfiledlg.h \
    newprojectdialog.h \
    projectpropertygroupbox.h \
    prjpropdlg.h \
    uploadtodevicewizard.h

FORMS    += mainwindow.ui \
    openprojectdialog.ui \
    addprjfiledlg.ui \
    newprojectdialog.ui \
    projectpropertygroupbox.ui \
    prjpropdlg.ui \
    uploadtodevicewizard.ui


RESOURCES += \
    bgqlcreator.qrc

DISTFILES +=

unix:!macx: LIBS += -L$$OUT_PWD/../BGQLCommon/ -lBGQLCommon

INCLUDEPATH += $$PWD/../BGQLCommon
DEPENDPATH += $$PWD/../BGQLCommon

unix:!macx: PRE_TARGETDEPS += $$OUT_PWD/../BGQLCommon/libBGQLCommon.a
