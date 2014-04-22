@drawData = (dataArray, firstHopArray) ->
  contentWidth = 1250
  contentHeight = 800
  cellWidth = 1
  cellHeight = 1
  clientWidth = window.innerWidth-5
  clientHeight = window.innerHeight-105
  # clientWidth = Math.min(clientWidth - 50, 1250)
  # clientHeight = Math.min(window.innerHeight - 200, 800)

  minzoom = Math.max(clientWidth/contentWidth, clientHeight/contentHeight)
  # console.log minzoom + "minzoom"
  # console.log clientWidth
  # console.log clientHeight

  availableWidthRatio = clientWidth/contentWidth
  availableHeightRatio = clientHeight/contentHeight

  content = document.getElementById("dataCanvas")
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
      r = Math.floor(250)
      g = Math.floor(18)
      b = Math.floor(66)
      context.fillStyle = "rgba(" + r + "," + g + "," + b + "," + (255 / 255) + ")"
      context.fillRect left, top, width, height
    else if firstHopArray[row][col] 
      r = Math.floor(0)
      g = Math.floor(94)
      b = Math.floor(255)
      context.fillStyle = "rgba(" + r + "," + g + "," + b + "," + (255 / 255) + ")"
      context.fillRect left, top, width, height
    # else
    #   r = Math.floor(0)
    #   g = Math.floor(255)
    #   b = Math.floor(255)
    #   context.fillStyle = "rgba(" + r + "," + g + "," + b + "," + (255 / 255) + ")"
    #   context.fillRect left, top, width, height
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

  # scroller.options.minZoom = Math.min(1.0, availableWidthRatio, availableHeightRatio)
  scroller.options.minZoom = minzoom


  rect = container.getBoundingClientRect()
  
  scroller.zoomTo minzoom
  scroller.setPosition (rect.left + container.clientLeft)*minzoom, (rect.top + container.clientTop)*minzoom

  # Reflow handling
  reflow = ->
    clientWidth = container.clientWidth
    clientHeight = container.clientHeight
    scroller.setDimensions clientWidth, clientHeight, clientWidth, clientHeight
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


@initiateCursor = (dataArray, firstHopArray) ->
  printpos = (e) ->
    # console.log scroller.getValues()
    CurX = (if (window.Event) then e.pageX else event.clientX + ((if document.documentElement.scrollLeft then document.documentElement.scrollLeft else document.body.scrollLeft)))
    CurY = (if (window.Event) then e.pageY else event.clientY + ((if document.documentElement.scrollTop then document.documentElement.scrollTop else document.body.scrollTop)))
    correctedX = CurX - leftOffset
    correctedY = CurY - topOffset
    left = zoom = scroller.getValues()["left"] # Scroller left-corner
    top = zoom = scroller.getValues()["top"] # Scroller top-corner
    zoom = scroller.getValues()["zoom"] # Scroller zoom level

    xPos = Math.floor((left+correctedX)/zoom)
    yPos = Math.floor((top+correctedY)/zoom)
    setCurrentPos(xPos,yPos)

    # console.log xPos + " | " + yPos
    thisTitle = dataArray[yPos][xPos]
    fistLinkTitle = firstHopArray[yPos][xPos]
    # console.log fistLinkTitle
    if thisTitle != undefined and $('.backgroundBlur').length==0
      document.getElementById("label").innerHTML = thisTitle.replace(/_/g, " ")
    else if fistLinkTitle != undefined and $('.backgroundBlur').length==0
      document.getElementById("label").innerHTML = fistLinkTitle.replace(/_/g, " ")
    else
      document.getElementById("label").innerHTML = ""

  leftOffset = $('#dataCanvas').position()["left"]
  topOffset = $('#dataCanvas').position()["top"]

  document.captureEvents Event.MOUSEMOVE  if window.captureEvents
  # document.onmousemove = getCursorXY
  throttledMouse = _.throttle(printpos, 250)
  document.onmousemove = throttledMouse




@scrollMap = (x,y)->
  values = scroller.getValues()
  zoom = scroller.getValues()['zoom']
  scrollerx = scroller.getValues()['left']
  scrollery = scroller.getValues()['top']
  # console.log values
  console.log "I got "+x+" and "+y
  console.log "Gunna scroll to "+x*zoom+" and "+y*zoom
  height = $('#dataCanvas').height()
  width = $('#dataCanvas').width()
  centerx = width/2
  centery = height/2
  console.log height + " | " + width + " | " + centerx + " | " + centery
  if zoom == 75
    scroller.scrollTo(x*zoom-centerx+37.5,y*zoom-centery+37.5,true)
  else
    doSomething = ->
      zoom = scroller.getValues()['zoom']
      scroller.scrollTo(x*zoom-centerx+37.5,y*zoom-centery+37.5,true)
      
      return
    setTimeout(doSomething, 500);
    scroller.zoomTo 75, true 
  console.log "I'm at "+scroller.getValues()["left"]+" and "+scroller.getValues()["top"]
  return

  # i = 0
  # while i < 5
  #   setTimeout (->

  #     console.log i
  #     scrollerx +=1
  #     scrollery +=1
  #     i += 1
      
    #   return
    # ), 1000
    


