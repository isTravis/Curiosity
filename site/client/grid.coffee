mything = {}
mygridData = []
Template.mgrid.created = ->
  Session.set "myx", 0
  Session.set "myy", 0
  Session.set "zoom", 1000000

Template.mgrid.rendered = ->
  drawit()
  drawData(mygridData)
  # testDraw()


Template.userGridData.userGridData = ->
  # console.log "inUpdatedWiki"
  # if Session.get "updated"
  # console.log "updated was true"
  userID = Session.get "userID"
  # drawData()
  # if userID == ''
  #   userID = 
  console.log "in User Grid data tempalte"
  xx = UserGridData.findOne({accountID:userID})

  if xx
    console.log xx['gridHistory']
    drawData(xx['gridHistory'])



@testDraw = () ->
  console.log "here we are"
  contentWidth = 1250
  contentHeight = 800
  cellWidth = 1
  cellHeight = 1
  content = document.getElementById("content")
  console.log content
  context = content.getContext("2d")
  tiling = new Tiling

  # Canvas renderer
  render = (left, top, zoom) ->
    console.log "left " + left
    console.log "top " + top
    
    # Sync current dimensions with canvas
    content.width = clientWidth
    content.height = clientHeight
    
    # Full clearing
    context.clearRect 0, 0, clientWidth, clientHeight
    
    # Use tiling
    tiling.setup clientWidth, clientHeight, contentWidth, contentHeight, cellWidth, cellHeight
    tiling.render left, top, zoom, paint
    return


  # Cell Paint Logic
  paint = (row, col, left, top, width, height, zoom) ->
    if row % 10 is 0
      r = Math.floor((row + col * 10) % 255)
      g = Math.floor((row + col * 10) % 255)
      b = Math.floor((row + col * 2) % 255)
      
      # context.fillStyle = row%2 + col%2 > 0 ? "#ddd" : "#fff";
      context.fillStyle = "rgba(" + r + "," + g + "," + b + "," + (255 / 255) + ")"
      context.fillRect left, top, width, height
    return

@drawData = (data) ->
  #create canvas over position of background
  #iterate over array of data
  # create blocks in each spot
  getCursorXY = (e) ->
    CurX = (if (window.Event) then e.pageX else event.clientX + ((if document.documentElement.scrollLeft then document.documentElement.scrollLeft else document.body.scrollLeft)))
    CurY = (if (window.Event) then e.pageY else event.clientY + ((if document.documentElement.scrollTop then document.documentElement.scrollTop else document.body.scrollTop)))
    
    scaledX = Math.floor((CurX-1-leftOffset)/pixelWidth)
    scaledY = Math.floor((CurY)/pixelHeight-topOffset)
    # console.log scaledX
    xx = Session.get "myx"
    yy = Session.get "myy"

    if zoomLevel == 1000
      thisThing = TopThousand.findOne({x:scaledX, y:scaledY})
      document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    else if zoomLevel == 10000
      thisThing = TopTenThousand.findOne({x:scaledX, y:scaledY})
      document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    if zoomLevel == 100000
      # thisThing = TopHundredThousand.findOne({x:scaledX, y:scaledY})
      # document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
      if Math.abs(xx - scaledX) > 8 or Math.abs(yy - scaledY) > 8
        Session.set "myx", scaledX
        Session.set "myy", scaledY
        # console.log "Just reset"
        mything = TopHundredThousand
        thisThing = mything.findOne({x:scaledX, y:scaledY})

        console.log "hi"
        console.log zoomLevel
        console.log thisThing.articleTitle
      thisThing = mything.findOne({x:scaledX, y:scaledY})
      document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    else if zoomLevel == 1000000
      if Math.abs(xx - scaledX) > 8 or Math.abs(yy - scaledY) > 8
        Session.set "myx", scaledX
        Session.set "myy", scaledY
        # console.log "Just reset"
        mything = TopMillion
        thisThing = mything.findOne({x:scaledX, y:scaledY})

        console.log "hi"
        console.log zoomLevel
        console.log thisThing.articleTitle
      thisThing = mything.findOne({x:scaledX, y:scaledY})
      document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    return

  if data.length > 0
    mygridData = data
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


  width = document.getElementById("myCanvas").width
  height = document.getElementById("myCanvas").height
  # console.log height
  pixelWidth = Math.max(Math.floor(width/numBlocksHori), 1)
  pixelHeight = Math.max(Math.floor(height/numBlocksVert),1)

  leftOffset = parseInt($('#myCanvas').css('marginLeft'))

  # $('.datacanvas').css('top', 0)
  $('.datacanvas').css('left', leftOffset)

  canvas2 = document.getElementById("dataCanvas")
  canvas2.width = Math.max(numBlocksHori*pixelWidth, numBlocksHori)
  canvas2.height = Math.max(numBlocksVert*pixelHeight, numBlocksVert)
  context2 = canvas2.getContext("2d")
  leftOffset = parseInt($('#myCanvas').css('marginLeft'))
  topOffset = parseInt($('#myCanvas').css('marginTop'))

  mcount = 0
  i = 0
  
  # data = [{'x':5, 'y':10},{'x':2, 'y':20},{'x':15, 'y':10}]
  console.log "length" + data.length
  _.forEach data, (block) ->
    blockx = parseInt(block['x'])
    blocky = parseInt(block['y'])
    context2.fillStyle = "rgba(" + 255 + "," + 0 + "," + 0 + "," + (255 / 255) + ")"
    console.log blockx + " | " + blocky  + " | " + pixelWidth  + " | " + pixelHeight
    context2.fillRect blockx*pixelWidth, blocky*pixelHeight, pixelWidth, pixelHeight
  # while i < pixelWidth*numBlocksHori
  #   j = 0
  #   while j < pixelHeight*numBlocksVert
  #     mcount += 1
  #     r = Math.floor(Math.random() * 255)
  #     g = Math.floor(Math.random() * 255)
  #     b = Math.floor(Math.random() * 255)
  #     context.fillStyle = "rgba(" + r + "," + g + "," + b + "," + (255 / 255) + ")"
  #     context.fillRect i, j, pixelWidth, pixelHeight
  #     j += pixelHeight
  #   i += pixelWidth
  # console.log "i is " + i
  # console.log "j is " + j
  # console.log "mcount is " + mcount

  # CurX = undefined
  # CurY = undefined

  # document.captureEvents Event.MOUSEMOVE  if window.captureEvents
  # # document.onmousemove = getCursorXY
  # throttledMouse = _.throttle(getCursorXY, 50)
  # document.onmousemove = throttledMouse



@drawit = () ->
  getCursorXY = (e) ->
    CurX = (if (window.Event) then e.pageX else event.clientX + ((if document.documentElement.scrollLeft then document.documentElement.scrollLeft else document.body.scrollLeft)))
    CurY = (if (window.Event) then e.pageY else event.clientY + ((if document.documentElement.scrollTop then document.documentElement.scrollTop else document.body.scrollTop)))
    
    scaledX = Math.floor((CurX-1-leftOffset)/pixelWidth)
    scaledY = Math.floor((CurY)/pixelHeight-topOffset)
    # console.log scaledX
    xx = Session.get "myx"
    yy = Session.get "myy"

    if zoomLevel == 1000
      thisThing = TopThousand.findOne({x:scaledX, y:scaledY})
      document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    else if zoomLevel == 10000
      thisThing = TopTenThousand.findOne({x:scaledX, y:scaledY})
      document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    if zoomLevel == 100000
      # thisThing = TopHundredThousand.findOne({x:scaledX, y:scaledY})
      # document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
      if Math.abs(xx - scaledX) > 8 or Math.abs(yy - scaledY) > 8
        Session.set "myx", scaledX
        Session.set "myy", scaledY
        # console.log "Just reset"
        mything = TopHundredThousand
        thisThing = mything.findOne({x:scaledX, y:scaledY})

        console.log "hi"
        console.log zoomLevel
        console.log thisThing.articleTitle
      thisThing = mything.findOne({x:scaledX, y:scaledY})
      document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    else if zoomLevel == 1000000
      if Math.abs(xx - scaledX) > 8 or Math.abs(yy - scaledY) > 8
        Session.set "myx", scaledX
        Session.set "myy", scaledY
        # console.log "Just reset"
        mything = TopMillion
        thisThing = mything.findOne({x:scaledX, y:scaledY})

        console.log "hi"
        console.log zoomLevel
        console.log thisThing.articleTitle
      thisThing = mything.findOne({x:scaledX, y:scaledY})
      document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
    return


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
  # console.log height
  pixelWidth = Math.max(Math.floor(width/numBlocksHori), 1)
  pixelHeight = Math.max(Math.floor(height/numBlocksVert),1)


  canvas = document.getElementById("myCanvas")
  canvas.width = Math.max(numBlocksHori*pixelWidth, numBlocksHori)
  canvas.height = Math.max(numBlocksVert*pixelHeight, numBlocksVert)
  context = canvas.getContext("2d")
  leftOffset = parseInt($('#myCanvas').css('marginLeft'))
  topOffset = parseInt($('#myCanvas').css('marginTop'))

  mcount = 0
  i = 0
  
  while i < pixelWidth*numBlocksHori
    j = 0
    while j < pixelHeight*numBlocksVert
      mcount += 1
      # r = Math.floor(Math.random() * 255)
      # g = Math.floor(Math.random() * 255)
      # b = Math.floor(Math.random() * 255)
      # r = Math.floor(128+(Math.random()*25));
      # g = Math.floor(230+(Math.random()*25));
      # b = Math.floor(50+(Math.random()*25));
      # r = x[i][j];
      # g = x[i][j];
      # b = x[i][j];
      r = 0;
      g = 0;
      b = 0;
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

  document.captureEvents Event.MOUSEMOVE  if window.captureEvents
  # document.onmousemove = getCursorXY
  throttledMouse = _.throttle(getCursorXY, 50)
  document.onmousemove = throttledMouse

  


