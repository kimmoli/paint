
.pragma library

function clear(ctx)
{
    ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
}

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

function drawRoundedRectangle(ctx, x0,y0,x1,y1, r, lineThick, lineColor, fill)
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

    r  = Math.min(r, w/2)
    r  = Math.min(r, h/2)

    ctx.beginPath();
    ctx.moveTo(x + r, y);
    ctx.lineTo(x + w - r, y);
    ctx.quadraticCurveTo(x + w, y, x + w, y + r);
    ctx.lineTo(x + w, y + h - r);
    ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
    ctx.lineTo(x + r, y + h);
    ctx.quadraticCurveTo(x, y + h, x, y + h - r);
    ctx.lineTo(x, y + r);
    ctx.quadraticCurveTo(x, y, x + r, y);
    ctx.closePath();

    if (fill)
        ctx.fill()
    ctx.stroke();
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

function drawEquilateralTriangle(ctx, x0,y0,x1,y1, lineThick, lineColor, fill)
{
    ctx.lineWidth = lineThick
    ctx.strokeStyle = lineColor
    ctx.fillStyle  = lineColor

    // x0,y0 is tip of triangle, x1,y1 is the middle-base of triangle
    // height
    var h = Math.sqrt(Math.pow(Math.abs(x1-x0), 2) + Math.pow(Math.abs(y1-y0), 2))
    // edge length
    var len = h/Math.sin(Math.PI/3)
    // angle of whole triangle
    var angle = Math.atan2(y1-y0, x1-x0)

    // mx,my,nx,ny are the 2 other corners
    var mx = x0+len*Math.cos(angle-Math.PI/6)
    var my = y0+len*Math.sin(angle-Math.PI/6)
    var nx = x0+len*Math.cos(angle+Math.PI/6)
    var ny = y0+len*Math.sin(angle+Math.PI/6)

    ctx.beginPath()
    ctx.moveTo(x0, y0)
    ctx.lineTo(mx, my)
    ctx.lineTo(nx, ny)
    ctx.lineTo(x0, y0)
    ctx.closePath()
    if (fill)
        ctx.fill()
    ctx.stroke()
}

function drawRightIsoscelesTriangle(ctx, x0,y0,x1,y1, lineThick, lineColor, fill)
{
    ctx.lineWidth = lineThick
    ctx.strokeStyle = lineColor
    ctx.fillStyle  = lineColor

    // x0,y0 and x1,y1 are ends of hypotenuse
    // short edge length (hypotenuse/sqrt(2))
    var len = Math.sqrt(Math.pow(Math.abs(x1-x0), 2) + Math.pow(Math.abs(y1-y0), 2))/Math.sqrt(2)
    // angle of whole triangle
    var angle = Math.atan2(y1-y0, x1-x0)

    // mx,my is the 3rd corner
    var mx = x0+len*Math.cos(angle+Math.PI/4)
    var my = y0+len*Math.sin(angle+Math.PI/4)

    ctx.beginPath()
    ctx.moveTo(x0, y0)
    ctx.lineTo(x1, y1)
    ctx.lineTo(mx, my)
    ctx.lineTo(x0, y0)
    ctx.closePath()
    if (fill)
        ctx.fill()
    ctx.stroke()
}

function drawPolygon(ctx, vertices, x0,y0,x1,y1, lineThick, lineColor, fill, step)
{
    if (typeof(step) == 'undefined')
        step = 1

    ctx.lineWidth = lineThick
    ctx.strokeStyle = lineColor
    ctx.fillStyle  = lineColor

    // x0,y0 is center of polygon, x1,y1 is one of the points
    // radius is distance between these two points
    var r = Math.sqrt(Math.pow(Math.abs(x1-x0), 2) + Math.pow(Math.abs(y1-y0), 2))
    // angle of point x1,y1
    var angle = Math.atan2(y1-y0, x1-x0)

    ctx.beginPath()
    ctx.moveTo(x1, y1)

    var jump = false

    for (var i=step; i<(vertices*step); i=i+step)
    {
        // point on circle edge
        var mx = x0+r*Math.cos(angle+(2*Math.PI/vertices)*i)
        var my = y0+r*Math.sin(angle+(2*Math.PI/vertices)*i)
        ctx.lineTo(mx, my)

        // if polygram, and hit starting point, lift pen up
        if (step > 1)
            if (Math.abs(mx-x1) < 1 && Math.abs(my-y1) < 1)
            {
                i--
                mx = x0+r*Math.cos(angle+(2*Math.PI/vertices)*i)
                my = y0+r*Math.sin(angle+(2*Math.PI/vertices)*i)
                ctx.moveTo(mx, my)
                // do not finish to starting point as we were already there
                jump = true
            }
    }

    if (!jump)
        ctx.lineTo(x1, y1)
    ctx.closePath()
    if (fill)
        ctx.fill()
    ctx.stroke()
}

function drawPolygram(ctx, vertices, x0,y0,x1,y1, lineThick, lineColor, fill)
{
    drawPolygon(ctx, vertices, x0,y0,x1,y1, lineThick, lineColor, fill, 2)
}

function drawArrow(ctx, x0,y0,x1,y1, lineThick, lineColor, fill)
{
    ctx.lineWidth = lineThick
    ctx.strokeStyle = lineColor
    ctx.fillStyle  = lineColor

    // x0,y0 is the point of arrow, x1,y1 is end of arrow
    // len is distance between these two points
    var len = Math.sqrt(Math.pow(Math.abs(x1-x0), 2) + Math.pow(Math.abs(y1-y0), 2))
    var angle = Math.atan2(y1-y0, x1-x0)

    // arrow tip is 1/3 of length
    // arrow base width is 1/4 of length

    ctx.beginPath()
    ctx.moveTo(x0, y0)

    var cx = x0+len/3*Math.cos(angle)
    var cy = y0+len/3*Math.sin(angle)

    ctx.lineTo(cx+len/4*Math.cos(angle-Math.PI/2), cy+len/4*Math.sin(angle-Math.PI/2))
    ctx.lineTo(cx+len/8*Math.cos(angle-Math.PI/2), cy+len/8*Math.sin(angle-Math.PI/2))
    ctx.lineTo(x1+len/8*Math.cos(angle-Math.PI/2), y1+len/8*Math.sin(angle-Math.PI/2))
    ctx.lineTo(x1+len/8*Math.cos(angle+Math.PI/2), y1+len/8*Math.sin(angle+Math.PI/2))
    ctx.lineTo(cx+len/8*Math.cos(angle+Math.PI/2), cy+len/8*Math.sin(angle+Math.PI/2))
    ctx.lineTo(cx+len/4*Math.cos(angle+Math.PI/2), cy+len/4*Math.sin(angle+Math.PI/2))
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

function drawImageData(ctx, imageData, x, y, angle, scale)
{
    ctx.save()
    ctx.translate(x, y)
    ctx.rotate( angle )
    ctx.scale(scale, scale)
    ctx.putImageData(imageData, -imageData.width/2, -imageData.height/2)
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

function drawBalloonText(ctx, text, x, y, textColor, textFont, fontSize, balloonColor, angle, tailend)
{
    ctx.save()
    ctx.translate(x, y)
    ctx.rotate( angle )
    ctx.font = textFont

    drawRoundedRectangle(ctx, -Math.max(fontSize, ctx.measureText(text).width/1.5), -fontSize,
                              Math.max(fontSize, ctx.measureText(text).width/1.5), fontSize,
                              fontSize*0.95,
                              1, balloonColor, true)

    if (tailend === 1)
        drawRightIsoscelesTriangle(ctx, Math.max(fontSize, ctx.measureText(text).width/1.5), 0,
                                        Math.max(fontSize, ctx.measureText(text).width/1.5), fontSize*1.4,
                                        1, balloonColor, true)
    else if (tailend === 2)
        drawRightIsoscelesTriangle(ctx, -Math.max(fontSize, ctx.measureText(text).width/1.5), fontSize*1.4,
                                        -Math.max(fontSize, ctx.measureText(text).width/1.5), 0,
                                        1, balloonColor, true)

    ctx.fillStyle = textColor
    ctx.font = textFont
    ctx.textAlign = "center"
    ctx.textBaseline = "middle"
    ctx.fillText(text, 0, 0)
    ctx.restore()
}

function pad(num)
{
  if (num.length < 2)
    return "0" + num
  else
    return num
}

function inverse(hex)
{
  if (hex.length !== 7 || hex.indexOf('#') !== 0)
      return "#ffffff"
  return "#" + pad((255 - parseInt(hex.substring(1, 3), 16)).toString(16)) + pad((255 - parseInt(hex.substring(3, 5), 16)).toString(16)) + pad((255 - parseInt(hex.substring(5, 7), 16)).toString(16))
}

function drawCropRubberBand(ctx, rect, lineColor)
{
    ctx.lineWidth = 1
    ctx.strokeStyle = lineColor
    ctx.strokeRect(rect[0], rect[1], rect[2], rect[3]);

    ctx.strokeStyle = inverse(lineColor)
    ctx.strokeRect(rect[0]-1, rect[1]-1, rect[2]+2, rect[3]+2);
}

function drawBrush(ctx, x0,y0,x1,y1, brush, scale, size, continuous)
{
    if (x0 === x1 && y0 === y1)
        return

    var seglen = Math.sqrt(Math.pow(Math.abs(x1-x0), 2) + Math.pow(Math.abs(y1-y0), 2))
    var angle = Math.atan2(y1-y0, x1-x0)

    for (var z=0; (z<=seglen || z==0) ; z=z + (continuous ?  1 : (size/2)))
    {
        ctx.save()
        ctx.translate(x0 + (z*Math.cos(angle)) - size/2, y0 + (z*Math.sin(angle)) - size/2)
        ctx.scale(scale, scale)
        ctx.drawImage(brush, 0, 0)
        ctx.restore()
    }
}
