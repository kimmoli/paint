#
# Project paint, paint
#

TARGET = harbour-paint

CONFIG += sailfishapp

DEFINES += "APPVERSION=\\\"$${SPECVERSION}\\\""

message($${DEFINES})

system(lupdate qml -ts $$PWD/i18n/translations_fi.ts)
system(lrelease $$PWD/i18n/*.ts)

i18n.path = /usr/share/harbour-paint/i18n
i18n.files = i18n/translations_fi.qm

INSTALLS += i18n

QT += dbus

SOURCES += src/paint.cpp \
    src/PainterClass.cpp
	
HEADERS += \
    src/PainterClass.h \
    src/IconProvider.h

OTHER_FILES += qml/paint.qml \
    qml/cover/CoverPage.qml \
    qml/pages/Paint.qml \
    qml/pages/AboutPage.qml \
    rpm/paint.spec \
    qml/pages/penSettingsDialog.qml \
    qml/pages/bgSettingsDialog.qml \
    harbour-paint.desktop \
    harbour-paint.png \
    i18n/translations_fi.ts \
    qml/components/Messagebox.qml \
    qml/components/Toolbox.qml \
    qml/pages/genSettings.qml \
    qml/components/Toolbar1.qml \
    qml/components/Toolbar2.qml \
    qml/icons/icon-m-spray.png \
    qml/icons/icon-m-eraser.png

TRANSLATIONS += i18n/translations_fi.ts

RESOURCES +=

