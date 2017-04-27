#
# Project paint, paint
#

TARGET = harbour-paint

CONFIG += sailfishapp

DEFINES += "APPVERSION=\\\"$${SPECVERSION}\\\""

message($${DEFINES})

#system(lupdate qml -ts $$PWD/i18n/en.ts)
system(lrelease $$PWD/i18n/*.ts)

i18n.path = /usr/share/harbour-paint/i18n
i18n.files = i18n/*.qm

appicons.path = /usr/share/icons/hicolor
appicons.files = appicons/*

INSTALLS += i18n appicons

SOURCES += src/paint.cpp \
    src/PainterClass.cpp \
    src/helper.cpp \
    src/nemoimagemetadata.cpp \
    src/BrushModel.cpp \
    src/ShaderModel.cpp \
    src/ShaderItem.cpp \
    src/ShaderParameterModel.cpp \
    src/ShaderParameterItem.cpp \
    src/highlighter.cpp
	
HEADERS += \
    src/PainterClass.h \
    src/IconProvider.h \
    src/helper.h \
    src/nemoimagemetadata.h \
    src/ImageProvider.h \
    src/BrushProvider.h \
    src/BrushModel.h \
    src/ShaderModel.h \
    src/ShaderItem.h \
    src/ShaderParameterModel.h \
    src/ShaderParameterItem.h \
    src/highlighter.h

OTHER_FILES += qml/paint.qml \
    qml/cover/CoverPage.qml \
    qml/pages/Paint.qml \
    qml/pages/AboutPage.qml \
    rpm/paint.spec \
    qml/pages/bgSettingsDialog.qml \
    harbour-paint.desktop \
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
    qml/pages/eraserSettingsDialog.qml \
    qml/pages/spraySettingsDialog.qml \
    qml/icons/icon-m-save.png \
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
    qml/pages/dimensionDialog.qml \
    qml/components/DimensionPopup.qml \
    qml/icons/icon-m-move.png \
    qml/icons/icon-m-grid.png \
    qml/icons/icon-m-geom-ellipse.png \
    qml/icons/icon-m-geom-ellipse-filled.png \
    qml/icons/icon-m-geom-fill.png \
    qml/components/ColorSelector.qml \
    i18n/*.ts \
    qml/components/ToolbarButton.qml \
    qml/pages/askFilenameDialog.qml \
    qml/icons/icon-m-addimage.png \
    qml/components/GeometryButton.qml \
    qml/icons/icon-m-geom-square-filled.png \
    qml/icons/icon-m-geom-square.png \
    qml/code/drawinghelpers.js \
    qml/components/DimensionCanvas.qml \
    qml/components/GridCanvas.qml \
    qml/components/PreviewCanvas.qml \
    qml/components/DrawingCanvas.qml \
    qml/icons/icon-m-geom-etriangle.png \
    qml/icons/icon-m-geom-etriangle-filled.png \
    qml/icons/icon-m-geom-ritriangle.png \
    qml/icons/icon-m-geom-ritriangle-filled.png \
    qml/icons/icon-m-geom-polygon.png \
    qml/icons/icon-m-geom-polygon-filled.png \
    qml/icons/icon-m-geom-polygram.png \
    qml/icons/icon-m-geom-polygram-filled.png \
    qml/icons/icon-m-geom-arrow-filled.png \
    qml/icons/icon-m-geom-arrow.png \
    qml/components/LoupeCanvas.qml \
    appicons/86x86/apps/harbour-paint.png \
    appicons/108x108/apps/harbour-paint.png \
    appicons/128x128/apps/harbour-paint.png \
    appicons/256x256/apps/harbour-paint.png \
    qml/components/Toolbar4.qml \
    qml/pages/layersDialog.qml \
    qml/icons/icon-m-visible.png \
    qml/icons/icon-m-visible-not.png \
    qml/components/LayersNameLabel.qml \
    qml/brush/g4161.png \
    qml/brush/g4197.png \
    qml/brush/path4138.png \
    qml/brush/path4147.png \
    qml/brush/path4185.png \
    qml/brush/path4185-9.png \
    qml/brush/path4138-1.png \
    qml/brush/path4169.png \
    qml/brush/rect4171.png \
    qml/icons/icon-m-geom-freehand-closed.png \
    qml/icons/icon-m-geom-freehand-closed-filled.png \
    qml/glsl/invert.frag \
    qml/components/Toolbar5.qml \
    qml/pages/shaderSettingsDialog.qml \
    qml/icons/sample-image.png \
    qml/icons/sample-mask.png \
    qml/glsl/gray_average.frag \
    qml/glsl/gray_lightness.frag \
    qml/glsl/gray_luminosity.frag \
    qml/glsl/swap_RGB-BRG.frag \
    qml/glsl/pixelate.frag \
    qml/glsl/sepia.frag \
    qml/glsl/edge.frag \
    qml/glsl/warhol.frag \
    qml/glsl/toon.frag \
    qml/glsl/adjust-rgb.frag \
    qml/glsl/adjust-gamma.frag \
    qml/glsl/emboss.frag \
    qml/glsl/contrast.frag \
    qml/glsl/blur.frag \
    qml/components/ShaderPopup.qml \
    qml/glsl/oilpainting.frag \
    qml/glsl/colorspace8.frag \
    qml/glsl/jolla-glasseffect.frag \
    qml/pages/shaderEditor.qml

TRANSLATIONS += i18n/*.ts

RESOURCES +=

DISTFILES += \
    qml/components/ClipboardCanvas.qml \
    qml/components/MainToolbar.qml \
    qml/tools/ToolDraw.qml \
    qml/tools/ToolEraser.qml \
    qml/tools/ToolGeometrics.qml \
    qml/tools/ToolSpray.qml \
    qml/tools/ToolAbout.qml \
    qml/tools/ToolBackground.qml \
    qml/tools/ToolClear.qml \
    qml/tools/ToolClipboard.qml \
    qml/tools/ToolDimensioning.qml \
    qml/tools/ToolGrid.qml \
    qml/tools/ToolImage.qml \
    qml/tools/ToolLayers.qml \
    qml/tools/ToolSave.qml \
    qml/tools/ToolSettings.qml \
    qml/tools/ToolShader.qml \
    qml/tools/ToolText.qml

