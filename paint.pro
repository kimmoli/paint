#
# Project paint, paint
#

TARGET = harbour-paint

CONFIG += sailfishapp
QT += dbus

DEFINES += "APPVERSION=\\\"$${SPECVERSION}\\\""

message($${DEFINES})

#system(lupdate qml -ts $$PWD/i18n/translations_fi.ts)
#system(lupdate qml -ts $$PWD/i18n/translations_sv.ts)
#system(lupdate qml -ts $$PWD/i18n/translations_de.ts)
system(lrelease $$PWD/i18n/*.ts)

i18n.path = /usr/share/harbour-paint/i18n
i18n.files = i18n/translations_fi.qm \
    i18n/translations_sv.qm \
    i18n/translations_de.qm

INSTALLS += i18n

SOURCES += src/paint.cpp \
    src/PainterClass.cpp \
    src/recursivesearch.cpp \
    src/filemodel.cpp \
    src/nemoimagemetadata.cpp \
    src/nemothumbnailprovider.cpp \
    src/nemothumbnailitem.cpp
	
HEADERS += \
    src/PainterClass.h \
    src/IconProvider.h \
    src/recursivesearch.h \
    src/filemodel.h \
    src/nemoimagemetadata.h \
    src/nemothumbnailprovider.h \
    src/nemothumbnailitem.h \
    src/linkedlist.h

OTHER_FILES += qml/paint.qml \
    qml/cover/CoverPage.qml \
    qml/pages/Paint.qml \
    qml/pages/AboutPage.qml \
    rpm/paint.spec \
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
    qml/icons/icon-m-eraser.png \
    qml/pages/penSettingsDialog.qml \
    qml/icons/icon-m-toolsettings.png \
    qml/icons/icon-m-geometrics.png \
    qml/components/GeometryPopup.qml \
    qml/icons/icon-m-geom-rectangle.png \
    qml/icons/icon-m-geom-line.png \
    qml/icons/icon-m-geom-circle.png \
    qml/icons/icon-m-geom-rectangle-filled.png \
    qml/icons/icon-m-geom-circle-filled.png \
    i18n/translations_sv.ts \
    qml/pages/eraserSettingsDialog.qml \
    qml/pages/spraySettingsDialog.qml \
    qml/icons/icon-m-save.png \
    qml/pages/MediaSelector.qml \
    qml/components/Toolbar3.qml \
    qml/pages/textSettingsDialog.qml \
    qml/pages/textEntryDialog.qml \
    qml/icons/icon-m-toolsettings.png \
    qml/icons/icon-m-texttool.png \
    qml/icons/icon-m-textsettings.png \
    qml/icons/icon-m-spray.png \
    qml/icons/icon-m-save.png \
    qml/icons/icon-m-geom-rectangle-filled.png \
    qml/icons/icon-m-geom-rectangle.png \
    qml/icons/icon-m-geom-line.png \
    qml/icons/icon-m-geometrics.png \
    qml/icons/icon-m-geom-circle-filled.png \
    qml/icons/icon-m-geom-circle.png \
    qml/icons/icon-m-erasersettings.png \
    qml/icons/icon-m-eraser.png \
    qml/icons/icon-m-dimensiontool.png \
    i18n/translations_de.ts \
    qml/pages/dimensionDialog.qml \
    qml/components/DimensionPopup.qml \
    qml/icons/icon-m-move.png \
    qml/icons/icon-m-grid.png \
    qml/icons/icon-m-geom-ellipse.png \
    qml/icons/icon-m-geom-ellipse-filled.png \
    qml/icons/icon-m-geom-fill.png \
    qml/components/ColorSelector.qml

TRANSLATIONS += i18n/translations_fi.ts \
    i18n/translations_sv.ts \
    i18n/translations_de.ts

RESOURCES +=

