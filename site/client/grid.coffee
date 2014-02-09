mything = {}

Template.mgrid.created = ->
  Session.set "myx", 0
  Session.set "myy", 0
  Session.set "zoom", 1000

Template.mgrid.rendered = ->
  getCursorXY = (e) ->
    CurX = (if (window.Event) then e.pageX else event.clientX + ((if document.documentElement.scrollLeft then document.documentElement.scrollLeft else document.body.scrollLeft)))
    CurY = (if (window.Event) then e.pageY else event.clientY + ((if document.documentElement.scrollTop then document.documentElement.scrollTop else document.body.scrollTop)))
    

    # console.log leftOffset
    # console.log 'x - ' + Math.floor((CurX-1-leftOffset)/pixelWidth-topOffset)
    # console.log 'y - ' + Math.floor((CurY)/pixelHeight)


    scaledX = Math.floor((CurX-1-leftOffset)/pixelWidth)
    scaledY = Math.floor((CurY)/pixelHeight-topOffset)
    xx = Session.get "myx"
    yy = Session.get "myy"

    # console.log 'xx - ' + xx
    # console.log 'yy - ' + yy
    if zoomLevel == 1000
      console.log TopThousand.find().count()
      thisThing = TopThousand.findOne({x:scaledX, y:scaledY})
      document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    else if zoomLevel == 10000
      console.log TopTenThousand.find().count()
      thisThing = TopTenThousand.findOne({x:scaledX, y:scaledY})
      document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    if zoomLevel == 100000
      console.log TopHundredThousand.find().count()
      thisThing = TopHundredThousand.findOne({x:scaledX, y:scaledY})
      document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    else if zoomLevel == 1000000
      if Math.abs(xx - scaledX) > 8
        Session.set "myx", scaledX
        Session.set "myy", scaledY
        console.log "Just reset"
        mything = TopMillion
        # console.log mything
        # console.log mything.findOne()
        thisThing = mything.findOne({x:scaledX, y:scaledY})
        document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
      # thisrank = scaledX + scaledY*numBlocksHori + 1
      # console.log thisrank
    # console.log mything.findOne({x:10, y:0})
    # console.log mything
    # thing2 = SelectMillion.findOne({x:scaledX,y:scaledY})
    # thing = TopMillion.findOne()
    # console.log thing2
    # console.log thing.fetch()
    # console.log TopHundred.find().count()
    # console.log TopThousand.find().count()
    # console.log TopMillion.find().count()
    # thisThing = mything.findOne({rank: thisrank})
    # document.getElementById("label").innerHTML = (x[Math.floor((CurX-1)/pixelwidth)][Math.floor(CurY/pixelwidth)].title) + "   |   " + x[Math.floor((CurX-1)/pixelwidth)][Math.floor(CurY/pixelwidth)].value
    # document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    # console.log TopHundred.find()
    # console.log TopThousand.find()
    # console.log TopHundred.findOne({x:0,y:3})
    return

  # document.getElementById('label').innerHTML= (x[CurX][CurY]) + "   |   " + x[CurX][CurY];

  # context.fillStyle = "rgba("+255+","+255+","+255+","+(255/255)+")";
  # context.fillRect( CurX-50, CurY-50, 2, 2 );
  # }
  # makeid = ->
  #   text = ""
  #   possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  #   i = 0

  #   while i < 12
  #     text += possible.charAt(Math.floor(Math.random() * possible.length))
  #     i++
  #   text


  zoomLevel = Session.get "zoom"
  switch (zoomLevel)
    when 9
      numBlocksHori = 3
      numBlocksVert = 3
    when 1000
      numBlocksHori = 40
      numBlocksVert = 25
    when 10000
      numBlocksHori = 125
      numBlocksVert = 80
    when 100000
      numBlocksHori = 400
      numBlocksVert = 250
    when 1000000
      numBlocksHori = 1250
      numBlocksVert = 800
    else
      numBlocksHori = 1
      numBlocksVert = 1


  width = window.innerWidth*0.95
  height = window.innerHeight*0.95
  console.log height
  pixelWidth = Math.max(Math.floor(width/numBlocksHori), 1)
  pixelHeight = Math.max(Math.floor(height/numBlocksVert),1)

  console.log pixelHeight
  # x = []
  # i = 0

  # while i < 1250
  #   y = []
  #   j = 0
  #   while j < 800
  #     # y[j] = "Crabby Patty of Solid " + (1+i)*(1+j)*Math.random();
  #     y[j] =
  #       title: makeid()
  #       value: Math.random() * 15
  #     j += 1
  #   # y[j] = ((1+j))%255
  #   x.push y
  #   i += 1


  canvas = document.getElementById("myCanvas")
  # width = window.innerWidth - 100
  # height = window.innerHeight - 100
  canvas.width = Math.max(width, numBlocksHori)
  canvas.height = Math.max(height, numBlocksVert)
  context = canvas.getContext("2d")

  # var id = context.createImageData(,10); // only do this once per page
  # var d  = id.data;                        // only do this once per page
  mcount = 0
  i = 0
  # pixelwidth = 20
  console.log $('#myCanvas').position()
  leftOffset = parseInt($('#myCanvas').css('marginLeft'))
  topOffset = parseInt($('#myCanvas').css('marginTop'))
  while i < pixelWidth*numBlocksHori
    j = 0

    while j < pixelHeight*numBlocksVert
      mcount += 1
      r = Math.floor(Math.random() * 255)
      g = Math.floor(Math.random() * 255)
      b = Math.floor(Math.random() * 255)
      
      # r = 255;
      # g = 255;
      # b = 255;
      # r = x[i][j];
      # g = x[i][j];
      # b = x[i][j];
      # r = Math.floor((i+j)%255);
      # g = Math.floor((i+j+130)%255);
      # b = Math.floor((i+j+200)%255);
      # console.log(b);
      context.fillStyle = "rgba(" + r + "," + g + "," + b + "," + (255 / 255) + ")"
      context.fillRect i, j, pixelWidth, pixelHeight
      j += pixelHeight
    i += pixelWidth
  console.log "i is " + i
  console.log "j is " + j
  console.log "mcount is " + mcount
  CurX = undefined
  CurY = undefined
  IE = (if document.all then true else false)
  if IE
    CurX = window.event.clientX
    CurY = window.event.clientY
  else
    document.captureEvents Event.MOUSEMOVE  if window.captureEvents
    document.onmousemove = getCursorXY





