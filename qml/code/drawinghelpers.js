
.pragma library

function drawLine(ctx, x0,y0,x1,y1, lineThick, lineColor)
{
    ctx.lineWidth = lineThick
    ctx.strokeStyle = lineColor

    ctx.beginPath()
    ctx.moveTo(x0, y0)
    ctx.lineTo(x1, y1)
    ctx.stroke()
    ctx.closePath()
}

function drawCircle(ctx, x0,y0,x1,y1, lineThick, lineColor, fill)
{
    ctx.lineWidth = lineThick
    ctx.strokeStyle = lineColor
    ctx.fillStyle  = lineColor

    var radius = Math.max(Math.abs(x1-x0),Math.abs(y1-y0))

    ctx.beginPath()
    ctx.arc(x0, y0, radius, 0, Math.PI*2, true)
    if (fill)
        ctx.fill()
    ctx.stroke()
    ctx.closePath()
}

function drawEllipse(ctx, x0, y0, x1, y1, lineThick, lineColor, fill)
{

    var x = Math.min(x0, x1),
        y = Math.min(y0, y1),
        w = Math.abs(x1-x0),
        h = Math.abs(y1-y0);

    var kappa = .5522848
    var ox = (w / 2) * kappa // control point offset horizontal
    var oy = (h / 2) * kappa // control point offset vertical
    var xe = x + w           // x-end
    var ye = y + h           // y-end
    var xm = x + w / 2       // x-middle
    var ym = y + h / 2       // y-middle

    ctx.lineWidth = lineThick
    ctx.strokeStyle = lineColor
    ctx.fillStyle  = lineColor

    ctx.beginPath();
    ctx.moveTo(x, ym);
    ctx.bezierCurveTo(x, ym - oy, xm - ox, y, xm, y);
    ctx.bezierCurveTo(xm + ox, y, xe, ym - oy, xe, ym);
    ctx.bezierCurveTo(xe, ym + oy, xm + ox, ye, xm, ye);
    ctx.bezierCurveTo(xm - ox, ye, x, ym + oy, x, ym);
    ctx.closePath();
    if (fill)
        ctx.fill()
    ctx.stroke();
}

function drawRectangle(ctx, x0,y0,x1,y1, lineThick, lineColor, fill)
{
    ctx.lineWidth = lineThick
    ctx.strokeStyle = lineColor
    ctx.fillStyle  = lineColor

    var x = Math.min(x0, x1),
        y = Math.min(y0, y1),
        w = Math.abs(x1-x0),
        h = Math.abs(y1-y0);

    if (h==0 || w==0)
        return;

    if (fill)
        ctx.fillRect(x, y, w, h);
    else
        ctx.strokeRect(x, y, w, h);
}

function drawSquare(ctx, x0,y0,x1,y1, lineThick, lineColor, fill)
{
    ctx.lineWidth = lineThick
    ctx.strokeStyle = lineColor
    ctx.fillStyle  = lineColor

    var seglen = Math.sqrt(Math.pow(Math.abs(x1-x0), 2) + Math.pow(Math.abs(y1-y0), 2))
    var angle = Math.atan2(y1-y0, x1-x0)
    // Center
    var cx = x0+seglen/2*Math.cos(angle)
    var cy = y0+seglen/2*Math.sin(angle)
    // 2 other corners
    var mx = cx+seglen/2*Math.cos(angle-Math.PI/2)
    var my = cy+seglen/2*Math.sin(angle-Math.PI/2)
    var nx = cx+seglen/2*Math.cos(angle+Math.PI/2)
    var ny = cy+seglen/2*Math.sin(angle+Math.PI/2)

    ctx.beginPath()
    ctx.moveTo(x0, y0)
    ctx.lineTo(mx, my)
    ctx.lineTo(x1, y1)
    ctx.lineTo(nx, ny)
    ctx.lineTo(x0, y0)
    ctx.closePath()
    if (fill)
        ctx.fill()
    ctx.stroke()
}

function drawText(ctx, txt, x, y, color, font, angle)
{
    ctx.save()
    ctx.translate(x, y)
    ctx.rotate( angle )
    ctx.fillStyle = color
    ctx.font = font
    ctx.textAlign = "center"
    ctx.textBaseline = "middle"
    ctx.fillText(txt, 0, 0)
    ctx.restore()
}

function drawInsertedImage(ctx, imageSource, x, y, w, h, angle)
{
    ctx.save()
    ctx.translate(x, y)
    ctx.rotate( angle )
    ctx.drawImage(imageSource, -w/2, -h/2, w, h)
    ctx.restore()
}

function drawDimensionLine(ctx, x0, y0, x1, y1, fontColor, font, fontSize, lineColor, lineThickness, colors, dimensionScale)
{
    var headlen = 15
    var angle = Math.atan2(y1-y0, x1-x0)

    var seglen = Math.sqrt(Math.pow(Math.abs(x1-x0), 2) + Math.pow(Math.abs(y1-y0), 2))
    var mx = x0+seglen/2*Math.cos(angle)
    var my = y0+seglen/2*Math.sin(angle)

    var scaled = seglen / dimensionScale
    var text = scaled.toFixed(1).toString()
    ctx.font = font
    var textlen = ctx.measureText(text).width
    var fits = (textlen < (seglen-2*headlen))

    ctx.lineWidth = lineThickness
    ctx.strokeStyle = colors[lineColor]

    ctx.beginPath()
    ctx.moveTo(x0, y0)
    ctx.lineTo(x0+headlen*Math.cos(angle-Math.PI/6),y0+headlen*Math.sin(angle-Math.PI/6))
    ctx.moveTo(x0, y0)
    ctx.lineTo(x0+headlen*Math.cos(angle+Math.PI/6),y0+headlen*Math.sin(angle+Math.PI/6))
    ctx.moveTo(x0, y0)
    if (fits)
    {
        ctx.lineTo(x0+(seglen-textlen-lineThickness)/2*Math.cos(angle), y0+(seglen-textlen-lineThickness)/2*Math.sin(angle))
        ctx.moveTo(x0+(textlen+lineThickness+(seglen-textlen)/2)*Math.cos(angle), y0+(textlen+lineThickness+(seglen-textlen)/2)*Math.sin(angle))
    }
    ctx.lineTo(x1, y1)
    ctx.lineTo(x1-headlen*Math.cos(angle-Math.PI/6),y1-headlen*Math.sin(angle-Math.PI/6))
    ctx.moveTo(x1, y1)
    ctx.lineTo(x1-headlen*Math.cos(angle+Math.PI/6),y1-headlen*Math.sin(angle+Math.PI/6))
    ctx.stroke()
    ctx.closePath()

    ctx.save()
    ctx.translate(mx, my)
    ctx.rotate(((angle > Math.PI/2)||(angle < -Math.PI/2)) ? Math.PI+angle : angle)
    ctx.fillStyle = colors[fontColor]
    ctx.font = font
    ctx.textAlign = "center"
    ctx.textBaseline = fits ? "middle" : "bottom"
    ctx.fillText(text, 0, 0)
    ctx.restore()
}
