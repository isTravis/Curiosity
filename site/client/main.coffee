dataArray = 0


# Template.dataGrid.created = ->

# Template.dataGrid.rendered = ->


# Template.dataGrid.dataGrid() # Can be called like so to resize the whole thing - to 'refresh'
Template.dataGrid.dataGrid = ->
  mystuff = TopMillion.find() # This will be limited to only the topmillion that are published based on userTitles
  if mystuff.count()
    dataArray = buildArray(mystuff.fetch())
    drawData(dataArray)
    initiateCursor()
  return 


@buildArray = (data) ->
  array = []
  for i in [0..1249]
    array[i] = []
    for j in [0..799]
      array[i][j] = undefined

  _.forEach data, (item) ->
    x = item['y'] # Yes, I realized I switch x and y in the db. Oops. 
    y = item['x']
    if x > 1250
      x = x-2150
      y = y+400
    array[y][x] = item["articleTitle"]

  return array

@drawData = (dataArray) ->
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
    content = document.getElementById("dataCanvas")
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
      context.fillStyle = "rgba(" + r + "," + g + "," + b + "," + (255 / 255) + ")"
      context.fillRect left, top, width, height
    return


  container = document.getElementById("container")
  container.setAttribute("style","height:"+ clientHeight+ "px; width:"+ clientWidth+ "px;")

  content = document.getElementById("dataCanvas")


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



@initiateCursor = () ->
  printpos = (e) ->
    # console.log scroller.getValues()
    CurX = (if (window.Event) then e.pageX else event.clientX + ((if document.documentElement.scrollLeft then document.documentElement.scrollLeft else document.body.scrollLeft)))
    CurY = (if (window.Event) then e.pageY else event.clientY + ((if document.documentElement.scrollTop then document.documentElement.scrollTop else document.body.scrollTop)))
    correctedX = CurX - leftOffset
    correctedY = CurY - topOffset
    left = zoom = scroller.getValues()["left"]
    top = zoom = scroller.getValues()["top"]
    zoom = scroller.getValues()["zoom"]

    xPos = Math.floor((left+correctedX)/zoom)
    yPos = Math.floor((top+correctedY)/zoom)

    thisTitle = dataArray[yPos][xPos]
    if thisTitle != undefined
      document.getElementById("label").innerHTML = dataArray[yPos][xPos]
    else
      document.getElementById("label").innerHTML = ""

  leftOffset = $('#dataCanvas').position()["left"]
  topOffset = $('#dataCanvas').position()["top"]

  document.captureEvents Event.MOUSEMOVE  if window.captureEvents
  # document.onmousemove = getCursorXY
  throttledMouse = _.throttle(printpos, 250)
  document.onmousemove = throttledMouse
