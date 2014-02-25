mything = {}
mygridData = []
globalpixelwidth = 1
globalleft = 0
globaltop = 0
dataArray = 0


Template.dataGrid.created = ->
  Session.set "myx", 0
  Session.set "myy", 0
  Session.set "zoom", 1000000

Template.dataGrid.rendered = ->
  # drawit()
    
  # drawData(mygridData)
  # content = document.getElementById("dataCanvas")

  # initZoom()
  # testDraw2()
  # render(975,600,5)

Template.dataGrid.dataGrid = ->
  # Session.get "userTitles"
  mystuff = TopMillion.find() # This will be limited to only the topmillion that are published based on userTitles
  console.log "I'm im in mgrid"
  console.log mystuff.count()

  if mystuff.count()
    dataArray = buildArray(mystuff.fetch())
    drawData(dataArray)
    initiateCursor()
  # console.log mystuff.fetch().length
  return mystuff

# Template.mgrid.mgrid = ->
#   # Deps.autorun ->
    
#   return UserGridData.find()

@buildArray = (data) ->
  array = []
  for i in [0..1249]
    array[i] = []
    for j in [0..799]
      array[i][j] = null
  # console.log array
  maxx = 0
  maxy = 0
  _.forEach data, (item) ->
    x = item['y']
    y = item['x']
    if x > 1250
      x = x-2150
      y = y+400
    array[y][x] = item["articleTitle"]
    if y > maxy
      maxy = y
    if x > maxx
      maxx = x
  console.log "Max x: " + maxx + "| Max y: " + maxy
  return array


# Template.userData.userData = ->
#   # console.log "inUpdatedWiki"
#   # if Session.get "updated"
#   # console.log "updated was true"
#   userID = Session.get "userID"
#   # drawData()
#   # if userID == ''
#   #   userID = 
#   console.log "in User Grid data tempalte"
#   xx = UserData.findOne({accountID:userID})

#   if xx
#     console.log xx['gridHistory']
#     drawData(xx['gridHistory'])


@drawData = (dataArray) ->
  console.log "here we are"
  contentWidth = 1250
  contentHeight = 800
  cellWidth = 1
  cellHeight = 1
  clientWidth = window.innerWidth 
  clientWidth = Math.min(clientWidth - 50, 1250)
  clientHeight = Math.min(window.innerHeight - 200, 800)
  availableWidthRatio = clientWidth/contentWidth
  availableHeightRatio = clientHeight/contentHeight

  # console.log availableHeightRatio
  # console.log availableWidthRatio

  content = document.getElementById("dataCanvas")
  # console.log content
  context = content.getContext("2d")
  tiling = new Tiling

  # Canvas renderer
  @render = (left, top, zoom) ->
    # console.log "left " + left
    globalpixelwidth = zoom
    globalleft = left
    globaltop = top
    # console.log globalpixelwidth
    # console.log "top " + top
    # console.log "herree"
    content = document.getElementById("dataCanvas")
    # Sync current dimensions with canvas
    # console.log "setting content width to " + clientWidth
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
    # console.log TopMillion.find({x:"0", y:"0"})
    # if (col+row) % 100 is 0
    if dataArray[row][col] 
      r = Math.floor((Math.floor(Math.pow(row+Math.pow(col,2),3)) + col * 20) % 255)
      g = Math.floor((Math.floor(Math.pow(row+Math.pow(col,2),3)) + col * 5) % 255)
      b = Math.floor((row + Math.floor(Math.pow(row+Math.pow(col,2),3)) * 2) % 255)
      
      # r = row/1250*255
      # g = 0
      # b = 0

      # context.fillStyle = row%2 + col%2 > 0 ? "#ddd" : "#fff";
      context.fillStyle = "rgba(" + r + "," + g + "," + b + "," + (255 / 255) + ")"
      context.fillRect left, top, width, height
    return
  # @initZoom = () ->
  # Intialize layout
  container = document.getElementById("container")
  container.setAttribute("style","height:"+ clientHeight+ "px; width:"+ clientWidth+ "px;")
  # container.setAttribute("style","width:"+ clientWidth+ "px;")

  # console.log container
  content = document.getElementById("dataCanvas")
  # clientWidth = 0
  # clientHeight = 0

  # Initialize Scroller
  @scroller = new Scroller(render,
    zooming: true
  )
  scrollLeftField = document.getElementById("scrollLeft")
  scrollTopField = document.getElementById("scrollTop")
  zoomLevelField = document.getElementById("zoomLevel")

  scroller.options.minZoom = Math.min(1.0, availableWidthRatio, availableHeightRatio)

  rect = container.getBoundingClientRect()
  scroller.setPosition rect.left + container.clientLeft, rect.top + container.clientTop

  # Reflow handling
  reflow = ->
    clientWidth = container.clientWidth
    # console.log clientWidth
    clientHeight = container.clientHeight
    scroller.setDimensions clientWidth, clientHeight, clientWidth, clientHeight
    # xxx need to fix the above line
    return

  window.addEventListener "resize", reflow, false
  reflow()


  document.addEventListener "keydown", (->
    # console.log event.keyCode
    if event.keyCode == 65
        scroller.zoomBy 2, true
    if event.keyCode == 83
        scroller.zoomBy 0.5, true
    
    return
  ), false

  if "ontouchstart" of window
    container.addEventListener "touchstart", ((e) ->
      
      # Don't react if initial down happens on a form element
      return  if e.touches[0] and e.touches[0].target and e.touches[0].target.tagName.match(/input|textarea|select/i)
      scroller.doTouchStart e.touches, e.timeStamp
      e.preventDefault()
      return
    ), false
    document.addEventListener "touchmove", ((e) ->
      scroller.doTouchMove e.touches, e.timeStamp, e.scale
      return
    ), false
    document.addEventListener "touchend", ((e) ->
      scroller.doTouchEnd e.timeStamp
      return
    ), false
    document.addEventListener "touchcancel", ((e) ->
      scroller.doTouchEnd e.timeStamp
      return
    ), false
  else
    mousedown = false
    container.addEventListener "mousedown", ((e) ->
      return  if e.target.tagName.match(/input|textarea|select/i)
      scroller.doTouchStart [
        pageX: e.pageX
        pageY: e.pageY
      ], e.timeStamp
      mousedown = true
      return
    ), false
    document.addEventListener "mousemove", ((e) ->
      return  unless mousedown
      scroller.doTouchMove [
        pageX: e.pageX
        pageY: e.pageY
      ], e.timeStamp
      mousedown = true
      return
    ), false
    document.addEventListener "mouseup", ((e) ->
      return  unless mousedown
      scroller.doTouchEnd e.timeStamp
      mousedown = false
      return
    ), false
    container.addEventListener (if navigator.userAgent.indexOf("Firefox") > -1 then "DOMMouseScroll" else "mousewheel"), ((e) ->
      scroller.doMouseZoom (if e.detail then (e.detail * -120) else e.wheelDelta), e.timeStamp, e.pageX, e.pageY
      e.preventDefault()
      return
    ), false


    # printpos = () ->
    #   console.log scroller.getValues()

    # document.captureEvents Event.MOUSEMOVE  if window.captureEvents
    # # document.onmousemove = getCursorXY
    # throttledMouse = _.throttle(printpos, 250)
    # document.onmousemove = throttledMouse

@initiateCursor = () ->

  printpos = (e) ->
    console.log scroller.getValues()
    CurX = (if (window.Event) then e.pageX else event.clientX + ((if document.documentElement.scrollLeft then document.documentElement.scrollLeft else document.body.scrollLeft)))
    CurY = (if (window.Event) then e.pageY else event.clientY + ((if document.documentElement.scrollTop then document.documentElement.scrollTop else document.body.scrollTop)))
    correctedX = CurX - leftOffset
    correctedY = CurY - topOffset
    # console.log correctedX + " | " + correctedY
    zoomX = Math.floor(scroller.getValues()['left']/scroller.getValues()['zoom'])
    zoomY = Math.floor(scroller.getValues()['top']/scroller.getValues()['zoom'])
    # console.log dataArray[zoomX][zoomY]
    left = zoom = scroller.getValues()["left"]
    top = zoom = scroller.getValues()["top"]
    zoom = scroller.getValues()["zoom"]
    xPos = Math.floor((left/(zoom)) + (correctedX/zoom))
    yPos = Math.floor((top/(zoom)) + (correctedY/zoom))
    console.log xPos + " | " + yPos
    console.log dataArray[yPos][xPos]
    console.log dataArray[xPos][yPos]


  leftOffset = $('#dataCanvas').position()["left"]
  topOffset = $('#dataCanvas').position()["top"]

  document.captureEvents Event.MOUSEMOVE  if window.captureEvents
  # document.onmousemove = getCursorXY
  throttledMouse = _.throttle(printpos, 250)
  document.onmousemove = throttledMouse

# @drawit = () ->
#   getCursorXY = (e) ->
#     CurX = (if (window.Event) then e.pageX else event.clientX + ((if document.documentElement.scrollLeft then document.documentElement.scrollLeft else document.body.scrollLeft)))
#     CurY = (if (window.Event) then e.pageY else event.clientY + ((if document.documentElement.scrollTop then document.documentElement.scrollTop else document.body.scrollTop)))
    
#     # scaledX = Math.floor((CurX-1-leftOffset)/pixelWidth)
#     # scaledY = Math.floor((CurY)/pixelHeight-topOffset)
#     scaledX = Math.floor((CurX-1)/globalpixelwidth)
#     scaledY = Math.floor((CurY)/globalpixelwidth)
#     # console.log scaledX
#     # console.log scaledY
#     xx = Session.get "myx"
#     yy = Session.get "myy"

#     if zoomLevel == 1000
#       thisThing = TopThousand.findOne({x:scaledX, y:scaledY})
#       document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
#     else if zoomLevel == 10000
#       thisThing = TopTenThousand.findOne({x:scaledX, y:scaledY})
#       document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
#     if zoomLevel == 100000
#       # thisThing = TopHundredThousand.findOne({x:scaledX, y:scaledY})
#       # document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
#       if Math.abs(xx - scaledX) > 8 or Math.abs(yy - scaledY) > 8
#         Session.set "myx", scaledX
#         Session.set "myy", scaledY
#         # console.log "Just reset"
#         mything = TopHundredThousand
#         thisThing = mything.findOne({x:scaledX, y:scaledY})

#         # console.log "hi"
#         # console.log zoomLevel
#         # console.log thisThing.articleTitle
#       thisThing = mything.findOne({x:scaledX, y:scaledY})
#       document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
#     else if zoomLevel == 1000000
#       if Math.abs(xx - scaledX) > 8 or Math.abs(yy - scaledY) > 8
#         Session.set "myx", scaledX
#         Session.set "myy", scaledY
#         # console.log "Just reset"
#         mything = TopMillion
#         thisThing = mything.findOne({x:scaledX, y:scaledY})

#         # console.log "hi"
#         # console.log zoomLevel
#         # console.log thisThing
#         # console.log thisThing.articleTitle

#       thisThing = mything.findOne({x:scaledX, y:scaledY})
#       # console.log thisThing
#       document.getElementById("label").innerHTML = thisThing.articleTitle + "   |   " + thisThing.viewCount
#     return


#   zoomLevel = Session.get "zoom"
#   switch (zoomLevel)
#     when 9
#       numBlocksHori = 3
#       numBlocksVert = 3
#     when 1000
#       numBlocksHori = 40
#       numBlocksVert = 25
#     when 10000
#       numBlocksHori = 125
#       numBlocksVert = 80
#     when 100000
#       numBlocksHori = 400
#       numBlocksVert = 250
#     when 1000000
#       numBlocksHori = 1250
#       numBlocksVert = 800
#     else
#       numBlocksHori = 1
#       numBlocksVert = 1


#   width = window.innerWidth*0.95
#   height = window.innerHeight*0.95
#   # console.log height
#   pixelWidth = Math.max(Math.floor(width/numBlocksHori), 1)
#   pixelHeight = Math.max(Math.floor(height/numBlocksVert),1)


#   canvas = document.getElementById("myCanvas")
#   canvas.width = Math.max(numBlocksHori*pixelWidth, numBlocksHori)
#   canvas.height = Math.max(numBlocksVert*pixelHeight, numBlocksVert)
#   context = canvas.getContext("2d")
#   leftOffset = parseInt($('#myCanvas').css('marginLeft'))
#   topOffset = parseInt($('#myCanvas').css('marginTop'))

#   mcount = 0
#   i = 0
  
#   while i < pixelWidth*numBlocksHori
#     j = 0
#     while j < pixelHeight*numBlocksVert
#       mcount += 1
#       # r = Math.floor(Math.random() * 255)
#       # g = Math.floor(Math.random() * 255)
#       # b = Math.floor(Math.random() * 255)
#       # r = Math.floor(128+(Math.random()*25));
#       # g = Math.floor(230+(Math.random()*25));
#       # b = Math.floor(50+(Math.random()*25));
#       # r = x[i][j];
#       # g = x[i][j];
#       # b = x[i][j];
#       r = 0;
#       g = 0;
#       b = 0;
#       # r = Math.floor((i+j)%255);
#       # g = Math.floor((i+j+130)%255);
#       # b = Math.floor((i+j+200)%255);
#       # console.log(b);
#       context.fillStyle = "rgba(" + r + "," + g + "," + b + "," + (255 / 255) + ")"
#       context.fillRect i, j, pixelWidth, pixelHeight
#       j += pixelHeight
#     i += pixelWidth
#   # console.log "i is " + i
#   # console.log "j is " + j
#   # console.log "mcount is " + mcount

#   CurX = undefined
#   CurY = undefined

#   document.captureEvents Event.MOUSEMOVE  if window.captureEvents
#   # document.onmousemove = getCursorXY
#   throttledMouse = _.throttle(getCursorXY, 250)
#   document.onmousemove = throttledMouse

  
