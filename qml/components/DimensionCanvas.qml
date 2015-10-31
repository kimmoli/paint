import QtQuick 2.0
import Sailfish.Silica 1.0

import "../code/drawinghelpers.js" as Draw

Canvas
{
    id: dimensionCanvas
    z: 10
    anchors.fill: drawingCanvas
    antialiasing: true
    tileSize: Qt.size(width/10, height/10)
    
    property bool clearNow : false
    
    function clear()
    {
        clearNow = true
        requestPaint()
    }
    
    onPaint:
    {
        var ctx = getContext('2d')
        
        ctx.lineJoin = ctx.lineCap = 'round';
        
        Draw.clear(ctx)
        if (clearNow)
        {
            clearNow = false
            return
        }
        /* This redraws all dimension lines from listmodel, except the selected one if popup is visible */
        for (var i=0 ; i<dimensionModel.count; i++)
        {
            var d=dimensionModel.get(i)
            
            if (!((i === selectedDimension) && dimensionPopupVisible))
                Draw.drawDimensionLine(ctx, d["x0"], d["y0"], d["x1"], d["y1"],
                                       d["fontColor"], d["font"], d["fontSize"], d["lineColor"], d["lineThickness"],
                                       colors, dimensionScale)
        }
    }
}
