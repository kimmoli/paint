import QtQuick 2.0
import Sailfish.Silica 1.0

import "../code/drawinghelpers.js" as Draw

Canvas
{
    id: gridCanvas
    z: 13
    anchors.fill: drawingCanvas
    antialiasing: true
    
    property bool clearNow : false
    
    function clear()
    {
        clearNow = true
        requestPaint()
    }

    onPaint:
    {
        var ctx = getContext('2d')
        
        ctx.clearRect(0, 0, width, height);
        if (clearNow)
        {
            clearNow = false
            return
        }
        
        if (!gridVisible)
            return
        
        ctx.lineWidth = 1
        
        ctx.strokeStyle = bgColor < colors.length ? Draw.inverse(colors[bgColor]) : "#ffffff"
        
        for (var y = 0 ; y < height; y = y + gridSpacing)
        {
            ctx.beginPath()
            ctx.moveTo(0, y)
            ctx.lineTo(width, y)
            ctx.stroke()
            ctx.closePath()
        }
        
        for (var x = 0 ; x < width; x = x + gridSpacing)
        {
            ctx.beginPath()
            ctx.moveTo(x, 0)
            ctx.lineTo(x, height)
            ctx.stroke()
            ctx.closePath()
        }
    }
}
