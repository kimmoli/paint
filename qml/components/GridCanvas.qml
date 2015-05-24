import QtQuick 2.0
import Sailfish.Silica 1.0

Canvas
{
    id: gridCanvas
    z: 8
    anchors.fill: canvas
    antialiasing: true
    
    property bool clearNow : false
    
    function clear()
    {
        clearNow = true
        requestPaint()
    }

    function inverse(hex)
    {
      if (hex.length !== 7 || hex.indexOf('#') !== 0)
          return "#ffffff"
      return "#" + pad((255 - parseInt(hex.substring(1, 3), 16)).toString(16)) + pad((255 - parseInt(hex.substring(3, 5), 16)).toString(16)) + pad((255 - parseInt(hex.substring(5, 7), 16)).toString(16))
    }

    function pad(num)
    {
      if (num.length < 2)
        return "0" + num
      else
        return num
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
        
        ctx.strokeStyle = bgColor < colors.length ? inverse(colors[bgColor]) : "#ffffff"
        
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
