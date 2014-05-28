#
# Project paint, paint
#

TARGET = paint

CONFIG += sailfishapp

DEFINES += "APPVERSION=\\\"$${SPECVERSION}\\\""

message($${DEFINES})

QT += dbus

SOURCES += src/paint.cpp \
	src/myclass.cpp
	
HEADERS += src/myclass.h

OTHER_FILES += qml/paint.qml \
    qml/cover/CoverPage.qml \
    qml/pages/Paint.qml \
    qml/pages/AboutPage.qml \
    rpm/paint.spec \
	paint.png \
    paint.desktop \
    qml/pages/penSettingsDialog.qml \
    qml/pages/bgSettingsDialog.qml

