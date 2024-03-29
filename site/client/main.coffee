xPos = 0
yPos = 0

dataArray = []
firstHopArray = []
myTitles = {}
firstHopTitles = {}
myIDs = {}
firstHopIDs = {}
linksObject = {}
positions = {}

# Template.dataGrid.dataGrid() # Can be called like so to resize the whole thing - to 'refresh'
Template.dataGrid.dataGrid = ->
  myHistory = TopMillion.find() # This will be limited to only the topmillion that are published based on userTitles
  myFirstHops = FirstHops.find()
  if myHistory.count() and myFirstHops.count()# If we have any history items yet.
    allItems = myHistory.fetch()
    allFirstHops = myFirstHops.fetch()

    dataArray = buildArray(allItems)
    firstHopArray = buildArray(allFirstHops)
    buildPositions(allItems)
    buildPositions(allFirstHops)
    drawData(dataArray,firstHopArray)

    initiateCursor(dataArray,firstHopArray)
    buildLinksList(allItems,1)
    buildLinksList(allFirstHops,0)

  
  
  # if myFirstHops.count()
  #   console.log "We got firsts! " + myFirstHops.count()
  return 

Template.main.events =
  "click #hasExtension": (d) ->
    chrome.webstore.install()

Template.dataGrid.events =
  "click ": (d) ->
    # console.log xPos + " clicked " + yPos
    myTitle = myTitles[dataArray[yPos][xPos]]
    firstTitle = firstHopTitles[firstHopArray[yPos][xPos]]
    # if myTitl



    if myTitle != undefined and $('.backgroundBlur').length==0
      $('#label').addClass("hidden")
      Session.set "clickedItem", myTitle["pageID"]
      scrollMap(positions[myTitle["pageID"]]['x'],positions[myTitle["pageID"]]['y'])

    else if firstTitle != undefined and $('.backgroundBlur').length==0
      $('#label').addClass("hidden")
      Session.set "clickedItem", firstTitle["pageID"]
      scrollMap(positions[firstTitle["pageID"]]['x'],positions[firstTitle["pageID"]]['y'])
    else
      # Session.set "clickedItem", firstTitle
      # console.log "clicked Nothing"

    # Session.set "clickedItem", myTitles[dataArray[yPos][xPos]]["pageID"]
    # console.log Session.get "clickedItem"
    # values = scroller.getValues()
    # console.log values
    # console.log positions[myTitle]["pageID"]

Template.links.events =
  "click .closeRing": ->
    $('svg').remove()
    $('.backgroundBlur').remove()
    $('.switch-viz').addClass("hidden")
    $('.closeRing').addClass("hidden")
    $('#label').removeClass("hidden")

  "click .backgroundBlur": ->
    $('svg').remove()
    $('.backgroundBlur').remove()
    $('.switch-viz').addClass("hidden")
    $('.closeRing').addClass("hidden")
    $('#label').removeClass("hidden")


  "click #viz": ->
    # console.log "gotit"

  "click .close-iframe": ->
    $(".wikiFrame").remove()
    $('.close-iframe').addClass('hidden')

  "click .switch-viz": ->
    vizMode = Session.get "vizMode"
    if vizMode == 'timeline'
      Session.set "vizMode", "related"
      $('.switch-viz').html("Switch to Timeline")
    else 
      Session.set "vizMode", "timeline"
      $('.switch-viz').html("Switch to Related")

    # Check which mode
    # switch to the other, 
    # make text proper


Template.links.created = ->
  Session.set "clickedItem", ""
  Session.set "vizMode", "related"

Template.bottomInfo.rendered = ->
  $('.bottomInfo').width($('#dataCanvas').width())
  if $('.bottom-title').html()
    properText = $('.bottom-title').html().replace(/_/g, " ")
    $('.bottom-title').html( properText)

Template.links.map = ->
  myMap = WikiLinks.find().fetch()
  # console.log "myMap:"
  # console.log myMap
  if myMap.length 
    myLinks = []
    firstHopLinks = []
    notMyLinks = []
    IDs = {}
    links = myMap[0]["titledLinks"]

    centerTitle = myMap[0]["articleTitle"]
    _.forEach links, (link) ->
      if centerTitle != link["title"]
        if link["pageID"] of myIDs
          # console.log myIDs[link]["title"]
          # console.log link
          myLinks.push(link["title"])
        else if link["pageID"] of firstHopIDs
          firstHopLinks.push(link["title"])
          IDs[link["title"]]= link["pageID"]
        else
          notMyLinks.push(link["title"])
          IDs[link["title"]]= link["pageID"]

    firstHopLinks = firstHopLinks.slice(0,(35-myLinks.length))
    notMyLinks = notMyLinks.slice(0,(35-myLinks.length-firstHopLinks.length))

    myLinks = myLinks.concat(firstHopLinks).concat(notMyLinks).slice(0,35)

    if myTitles[centerTitle]
      vizMode = Session.get "vizMode"
    else
      Session.set "vizMode", "related"
      $('.switch-viz').html("Switch to Timeline")
      vizMode = Session.get "vizMode"

    console.log "centerTitle " + centerTitle

    if vizMode == "timeline"
      console.log Session.get "clickedItem"
      if (Session.get "clickedItem").length
        console.log " but I'm here"
        buildLinearNet(centerTitle, IDs)
    else
      buildCentricNet(centerTitle, myLinks, IDs)
    

    # console.log myLinks.length
  return ""

Template.bottomInfo.bottomInfo = ->
  console.log "Printed bottomInfo"
  xx = Session.get "clickedItem"
  if xx != ""
    console.log ClickedItem.findOne()
    return ClickedItem.find()
  else
    return ""

@buildPositions = (data) ->
  _.forEach data, (item) ->
    x = item['x']
    # console.log x
    y = item['y']
    id = item['pageID']

    rank = x + (y*400 )
    xx = rank %1250
    yy = Math.floor(rank/1250)

    positions[id] = {'x':x, 'y':y}


@buildArray = (data) ->
  array = []
  for i in [0..1249]
    array[i] = []
    for j in [0..799]
      array[i][j] = undefined

  _.forEach data, (item) ->
    # console.log item
    x = item['x'] # Yes, I realized I switch x and y in the db. Oops. 
    y = item['y']

    rank = x + (y*400 )
    xx = rank %1250
    yy = Math.floor(rank/1250)
    # console.log xx + " | " + yy
    # if x > 1250
    #   x = x-1250
    #   y = y+400
    try
      array[y][x] = item["articleTitle"]
    catch
      dumbvariable = 0
    # array[y][x] = item["articleTitle"]
    

  return array


@setCurrentPos = (x,y) -> # Created so that other files can edit the global xPos and yPos. 
# Probably not best practice though... Should have a get Function instead
  xPos = x
  yPos = y
  
@buildLinksList = (history,type) ->
  if type == 1
    _.forEach history, (item) ->
      # console.log item
      title = item["articleTitle"]
      pageID = item["pageID"]

      myTitles[title] = {title:title, pageID:pageID}
      myIDs[pageID] = {title:title, pageID:pageID}
  else
    _.forEach history, (item) ->
      # console.log item
      title = item["articleTitle"]
      pageID = item["pageID"]
      
      firstHopTitles[title] = {title:title, pageID:pageID}
      firstHopIDs[pageID] = {title:title, pageID:pageID}



@buildCentricNet = (centerNode,links,IDs) ->

  if myTitles[centerNode]
    $('.switch-viz').removeClass("hidden")
  else
    $('.switch-viz').addClass("hidden")
    


  mnodes = []
  mlinks = []
  height = $('#dataCanvas').height()
  width = $('#dataCanvas').width()

  centerx = width/2
  centery = height/2
  mnodes.push({"name":centerNode,"group":1, r:50, color:"rgba(124,240,10,0.0)", x: centerx, y: centery, fixed:true})
  document.getElementById("label").innerHTML = centerNode

  numLinks = links.length
  linkNum = 1
  _.forEach links, (link) ->
    twopi = 2*Math.PI
    # console.log link
    mx = centerx + 125 * Math.cos(twopi/numLinks*linkNum)
    my = centery + 125 * Math.sin(twopi/numLinks*linkNum)
    if link of myTitles
      mnodes.push({"name":link,"group":1, r:10, color:"rgb(250,18,66)", x: mx, y: my, fixed:true})
    else if link of firstHopTitles
      mnodes.push({"name":link,"group":1, r:10, color:"rgb(0,94,255)", x: mx, y: my, fixed:true})
    else
      mnodes.push({"name":link,"group":1, r:10, color:"#333", x: mx, y: my, fixed:true})
    mlinks.push({"source":0,"target":linkNum,"value":1})
    linkNum += 1



  $('svg').remove()
  $('.backgroundBlur').remove()

  # width = 800
  # height = 800
  color = d3.scale.category20()
  force = d3.layout.force()

  $('.blur').append("<div class='backgroundBlur'></div>")
  $(".backgroundBlur").width( $('#dataCanvas').width())
  $(".backgroundBlur").height( $('#dataCanvas').height())

  svg = d3.select("#viz").append("svg").attr("width", width).attr("height", height-2)

  $('.closeRing').removeClass("hidden")
  
  

  # mnodes = network["nodes"]
  # mlinks = network["links"]
  force.nodes(mnodes).links(mlinks).start()

  link = svg.selectAll(".link")
    .data(mlinks)
    .enter()
    .append("line")
    .attr("class", "link")
    .style("stroke-width", (d) ->
      5
    )
    
  clickANode = false
  clickedABlankNode = false
  gnodes = svg.selectAll("g.gnode")
    .data(mnodes)
    .enter()
    .append("g")
    .classed("gnode", true)
    .on("mouseover", (d) ->
      nodeSelection = d3.select(this)
      nodeSelection.select("circle").style(opacity: "1.0")
      nodeSelection.select("text").style(opacity: "1.0")
      nodeSelection.select("circle").style("stroke","#E2D64F")
      # if d.x == centerx and d.y == centery
      #   nodeSelection.select("circle").style("cursor","pointer")
    )
    .on("mouseout", (d) ->
      nodeSelection = d3.select(this)
      nodeSelection.select("circle").style(opacity: "1.0")
      nodeSelection.select("text").style(opacity: "1.0")
      nodeSelection.select("circle").style("stroke","#444")

      
    )
    .on("click", (d) ->
      # console.log "-sdaf"
      # console.log myTitles[d.name]
      # console.log IDs[d.name]
      id = 0

      clickANode = true
      # clickedABlankNode = false
      # console.log d.color
      if d.color != "#333"
        if d.x == centerx and d.y == centery
          # console.log "middle!"
          # url = "http://en.wikipedia.org/wiki/"+d.name
          # win = window.open(url, "_blank")
          # clickANode = false
          $('#viz').append("<iframe class='wikiFrame' src='http://en.wikipedia.org/wiki/"+d.name+"'></iframe>")
          
          $('.close-iframe').removeClass('hidden')
          $('.wikiFrame').css({ top: (0.05*$('#viz').height())+'px' })
          $('.wikiFrame').css({ left: (0.025*$('#viz').width())+'px' })
          $('.wikiFrame').height(0.9*$('#viz').height())
          $('.wikiFrame').width(0.95*$('#viz').width())
          clickedABlankNode = true

        else if myTitles[d.name]!=undefined
          id = myTitles[d.name]["pageID"]
          document.getElementById("label").innerHTML =""
          Session.set "clickedItem", myTitles[d.name]["pageID"]
          scrollMap(positions[id]['x'],positions[id]['y'])

        else
          id = IDs[d.name]
          document.getElementById("label").innerHTML =""
          Session.set "clickedItem", IDs[d.name]
          scrollMap(positions[id]['x'],positions[id]['y'])
        


          # id = IDs[d.name]
          # console.log id
          # console.log positions[id]

          # clickANode = false
          # clickedABlankNode = false
          # $('svg').remove()
          # $('.backgroundBlur').remove()
          # $('.closeRing').addClass("hidden")
          # Session.set "clickedItem", ""
          # $('#label').removeClass("hidden")


        # scrollMap(positions[id]['x'],positions[id]['y'])
      else
        document.getElementById("label").innerHTML =""
        Session.set "clickedItem", (Session.get "clickedItem")
        clickedABlankNode = true
        id =  Session.get "clickedItem"
        scrollMap(positions[id]['x'],positions[id]['y'])
    )

  svg.on("click", (d) ->
    # console.log "okayyy"
    # console.log d
    # console.log clickANode
    if not clickANode
      $('svg').remove()
      $('.backgroundBlur').remove()
      $('.switch-viz').addClass("hidden")
      $('.closeRing').addClass("hidden")
      Session.set "clickedItem", ""
      $('#label').removeClass("hidden")
    if clickedABlankNode
      clickANode = false
      clickedABlankNode = false
  ).style("background","rgba(44,44,44,0.5")

  # console.log clickANode
  # console.log clickedABlankNode

  node = gnodes.append("circle")
    .attr("class", "node")
    .attr("class", "node").attr("r", (d) ->
      d.r
    )
    .style("opacity", "1.0")
    .style("fill", (d) ->
      d.color
    )
    .style("stroke","#444")
    
  labels = gnodes.append("text")
    .text((d) ->
      d.name.replace(/_/g, " ")
    )
    .style("opacity", "1.0")
    .style("fill", "#ccc")
    .style("pointer-events","none")




  leftOffset = $('#dataCanvas').position()["left"]
  topOffset = $('#dataCanvas').position()["top"]
  mwidth = $('#dataCanvas').width()
  mheight = $('#dataCanvas').height()

  # console.log leftOffset + " | " + topOffset + " | " + mwidth + " | " + mheight
  $('#viz').offset({left:leftOffset, top:topOffset })
  $('.backgroundBlur').offset({left:leftOffset, top:topOffset})

  force.on "tick", ->
    
    link.attr("x1", (d) ->
      angle = Math.atan(Math.abs(d.source.y-d.target.y)/Math.abs(d.source.x-d.target.x)  )
      offsetx = Math.abs(50*(Math.cos(angle)))
      if d.target.x > centerx
        d.source.x+offsetx
      else
        d.source.x-offsetx
    ).attr("y1", (d) ->
      angle = Math.atan(Math.abs(d.source.y-d.target.y)/Math.abs(d.source.x-d.target.x))
      offsety = Math.abs(50*(Math.sin(angle)))
      if d.target.y > centery
        d.source.y+offsety
      else
        d.source.y-offsety
      
      # d.source.y-offsety
    ).attr("x2", (d) ->
      d.target.x
    ).attr "y2", (d) ->
      d.target.y

    gnodes.attr "transform", (d) ->
      "translate(" + [d.x, d.y ] + ")"


    labels.attr "transform", (d) ->
      if d.x == centerx and d.y == centery
        mag = -this.getBBox().width/2
        return "translate("+mag+","+0+")"

      slope = (centery-d.y)/(centerx-d.x)
      degangle = 360/(Math.PI*2)*Math.atan(slope)
      radangle = Math.atan(slope)

      if d.x <= centerx
        mag = this.getBBox().width + 15
        xTrans = -mag*Math.cos(radangle)
        yTrans = -mag*Math.sin(radangle)
        "translate("+xTrans+","+yTrans+")rotate("+degangle+")"
      else
        mag = 15
        xTrans = mag*Math.cos(radangle)
        yTrans = mag*Math.sin(radangle)
        "translate("+xTrans+","+yTrans+")rotate("+degangle+")"

    # labels.attr "x", (d) ->
    #   # console.log "here"
    #   return 10

    # labels.attr "x"
      # else
      #   "translate(" +10*Math.cos(angle) +","+10*Math.sin(angle) +")" +"rotate(" + angle + ")"
      # else
      #   "rotate(" + angle+ ")"
    # labels.attr "transform", (d) ->
    #   if d.x < 250
    #     "translate(" +0 +","+150 +")" 
        # "rotate(" + 360/(Math.PI*2)*Math.atan(Math.abs(250-d.y)/Math.abs(250-d.x)) + ")"


# network = {
#   "nodes":[
#     {"name":"Myriel","group":1, x: 250, y: 250, fixed:true},
#     {"name":"Napoleon","group":1, x: 300, y:150, fixed:true},
#     {"name":"Mlle.Baptistine","group":1, x: 300, y: 50, fixed:true},
#     {"name":"Mme.Magloire","group":1, x: 0, y: 500, fixed:true},
#     {"name":"CountessdeLo","group":1, x: 500, y: 0, fixed:true},
#     {"name":"Geborand","group":1, x: 500, y: 500, fixed:true}],
#   "links":[
#     {"source":0,"target":1,"value":1},
#     {"source":0,"target":2,"value":8},
#     {"source":0,"target":3,"value":10},
#     {"source":0,"target":4,"value":6},
#     {"source":0,"target":5,"value":6}
#   ]

# }
@buildLinearNet = (centerNode,IDs) ->
  console.log "woahwoahwoah what"
  if myTitles[centerNode]
    $('.switch-viz').removeClass("hidden")
  else
    $('.switch-viz').addClass("hidden")


  mnodes = []
  mlinks = []
  height = $('#dataCanvas').height()
  width = $('#dataCanvas').width()

  centerx = width/2
  centery = height/2
  # mnodes.push({"name":centerNode,"group":1, r:50, color:"rgba(124,240,10,0.0)", x: centerx, y: centery, fixed:true})
  document.getElementById("label").innerHTML = centerNode

  currentID = Session.get "clickedItem"
  visitTimes = Session.get "visitTimes"
  userTitles = Session.get "userTitles"

  # console.log currentID
  console.log "ok4"
  currentTitle = myIDs[currentID]['title']  
  
  
  # console.log currentTitle
  console.log "ok5"
  index = userTitles.indexOf(currentTitle)
  # console.log visitTimes[index]
  baseTime = visitTimes[index]
  # console.log "index is " + index
  # console.log myIDs[currentID]
  # console.log centerNode

  trailDistance = 4
  trailNodes = []
  goodPast = 0
  goodFuture = 0
  pastIndex = 1
  futureIndex = 1

  tempPastNodes = []
  while goodPast < trailDistance
    thisPast = userTitles[index-pastIndex]
    if isGoodSite(thisPast)
      tempPastNodes.push(index-pastIndex)
      goodPast += 1
    pastIndex += 1

  tempPastNodes.reverse()

  for jj in [0..trailDistance-1]
    trailNodes.push(tempPastNodes[jj])

  trailNodes.push(index)

  while goodFuture < trailDistance
    thisFuture = userTitles[index+futureIndex]
    if isGoodSite(thisFuture)
      trailNodes.push(index+futureIndex)
      goodFuture += 1
    futureIndex += 1

  # console.log trailNodes
  trailNodes.reverse()

  iteratorIndex = 0
  totalNodes = trailDistance*2+1
  nodeoffset = 100
  availableWidth = $('#dataCanvas').width()-nodeoffset
  widthPer = availableWidth/(totalNodes-1)
  nodeYPos = $('#dataCanvas').height()/2

  _.forEach trailNodes, (node) ->
    if node is index
      mnodes.push({"name":userTitles[node],"group":1, r:50, color:"rgba(250,18,66,0.0)", x: nodeoffset/2+widthPer*iteratorIndex, y: nodeYPos, fixed:true})
    else
      mnodes.push({"name":userTitles[node],"group":2, r:10, color:"rgb(250,18,66)", x: nodeoffset/2+widthPer*iteratorIndex, y: nodeYPos, fixed:true})
    iteratorIndex += 1

  for i in [0..totalNodes-2]
    # console.log i + " " + (i+1)
    time0 = parseFloat(visitTimes[trailNodes[i]])/1000
    time1 = parseFloat(visitTimes[trailNodes[i+1]])/1000
    # console.log "time0: " + time0 + "    |    " + "time1: " + time1
    if time1-time0 > 0
      mlinks.push({"source":i,"target":i+1,"value":time1-time0})
    else
      mlinks.push({"source":i,"target":i+1,"value":45})
    
  # console.log mnodes
  # console.log mlinks
  # console.log userTitles[index-3] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index-3])/1000/60)).toFixed(3))+"minutes difference"
  # console.log userTitles[index-2] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index-2])/1000/60)).toFixed(3))+"minutes difference"
  # console.log userTitles[index-1] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index-1])/1000/60)).toFixed(3))+"minutes difference"
  # console.log userTitles[index] + " | " +   String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index  ])/1000/60)).toFixed(3))+"minutes difference"
  # console.log userTitles[index+1] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index+1])/1000/60)).toFixed(3))+"minutes difference"
  # console.log userTitles[index+2] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index+2])/1000/60)).toFixed(3))+"minutes difference"
  # console.log userTitles[index+3] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index+3])/1000/60)).toFixed(3))+"minutes difference"
  
  $('svg').remove()
  $('.backgroundBlur').remove()

  color = d3.scale.category20()
  force = d3.layout.force()

  $('.blur').append("<div class='backgroundBlur'></div>")
  $(".backgroundBlur").width( $('#dataCanvas').width())
  $(".backgroundBlur").height( $('#dataCanvas').height())

  svg = d3.select("#viz").append("svg").attr("width", width).attr("height", height-2)

  # $('.closeRing').removeClass("hidden")
  
  

  # mnodes = network["nodes"]
  # mlinks = network["links"]
  force.nodes(mnodes).links(mlinks).start()

  link = svg.selectAll(".link")
    .data(mlinks)
    .enter()
    .append("line")
    .attr("class", "link")
    .style("stroke-width", (d) ->
      2
    )

    
  clickANode = false
  clickedABlankNode = false
  gnodes = svg.selectAll("g.gnode")
    .data(mnodes)
    .enter()
    .append("g")
    .classed("gnode", true)
    .on("mouseover", (d) ->
      nodeSelection = d3.select(this)
      nodeSelection.select("circle").style(opacity: "1.0")
      nodeSelection.select("text").style(opacity: "1.0")
      nodeSelection.select("circle").style("stroke","#E2D64F")
      # if d.x == centerx and d.y == centery
      #   nodeSelection.select("circle").style("cursor","pointer")
    )
    .on("mouseout", (d) ->
      nodeSelection = d3.select(this)
      nodeSelection.select("circle").style(opacity: "1.0")
      nodeSelection.select("text").style(opacity: "1.0")
      nodeSelection.select("circle").style("stroke","#444")

      
    )
    .on("click", (d) ->
      # console.log "-sdaf"
      # console.log myTitles[d.name]
      # console.log IDs[d.name]
      id = 0

      clickANode = true
      # clickedABlankNode = false
      console.log d.color
      if d.color != "#333"
        if d.x == centerx and d.y == centery
          # console.log "middle!"
          # url = "http://en.wikipedia.org/wiki/"+d.name
          # win = window.open(url, "_blank")
          # clickANode = false
          $('#viz').append("<iframe class='wikiFrame' src='http://en.wikipedia.org/wiki/"+d.name+"'></iframe>")
          
          $('.close-iframe').removeClass('hidden')
          $('.wikiFrame').css({ top: (0.05*$('#viz').height())+'px' })
          $('.wikiFrame').css({ left: (0.025*$('#viz').width())+'px' })
          $('.wikiFrame').height(0.9*$('#viz').height())
          $('.wikiFrame').width(0.95*$('#viz').width())
          clickedABlankNode = true

        else if myTitles[d.name]!=undefined
          id = myTitles[d.name]["pageID"]
          document.getElementById("label").innerHTML =""
          Session.set "clickedItem", myTitles[d.name]["pageID"]
          scrollMap(positions[id]['x'],positions[id]['y'])

        else
          id = IDs[d.name]
          document.getElementById("label").innerHTML =""
          Session.set "clickedItem", IDs[d.name]
          scrollMap(positions[id]['x'],positions[id]['y'])
        


          # id = IDs[d.name]
          # console.log id
          # console.log positions[id]

          # clickANode = false
          # clickedABlankNode = false
          # $('svg').remove()
          # $('.backgroundBlur').remove()
          # $('.closeRing').addClass("hidden")
          # Session.set "clickedItem", ""
          # $('#label').removeClass("hidden")


        # scrollMap(positions[id]['x'],positions[id]['y'])
      else
        document.getElementById("label").innerHTML =""
        Session.set "clickedItem", (Session.get "clickedItem")
        clickedABlankNode = true
        id =  Session.get "clickedItem"
        scrollMap(positions[id]['x'],positions[id]['y'])
    )

  svg.on("click", (d) ->
    # console.log "okayyy"
    # console.log d
    # console.log clickANode
    if not clickANode
      $('svg').remove()
      $('.backgroundBlur').remove()
      
      $('.closeRing').addClass("hidden")
      
      $('#label').removeClass("hidden")
      console.log "ok0"
      $('.switch-viz').addClass("hidden")
      console.log "ok1"
      Session.set "clickedItem", ""
      console.log "ok2"


    if clickedABlankNode
      clickANode = false
      clickedABlankNode = false
  ).style("background","rgba(44,44,44,0.5")

  # console.log clickANode
  # console.log clickedABlankNode

  node = gnodes.append("circle")
    .attr("class", "node")
    .attr("class", "node").attr("r", (d) ->
      d.r
    )
    .style("opacity", "1.0")
    .style("fill", (d) ->
      return d.color

    )
    .style("stroke","#444")
    
  labels = gnodes.append("text")
    .text((d) ->
      d.name.replace(/_/g, " ")
    )
    .style("opacity", "1.0")
    .style("fill", "#ccc")
    .style("pointer-events","none")

  timelabels = gnodes.append("text")
    .text((d) ->
      try
        secondsToWords(mlinks[d.index]['value'])
      catch
        ""
    )
    .style("opacity", "1.0")
    .style("fill", "#ccc")
    .style("pointer-events","none")





  leftOffset = $('#dataCanvas').position()["left"]
  topOffset = $('#dataCanvas').position()["top"]
  mwidth = $('#dataCanvas').width()
  mheight = $('#dataCanvas').height()

  # console.log leftOffset + " | " + topOffset + " | " + mwidth + " | " + mheight
  $('#viz').offset({left:leftOffset, top:topOffset })
  $('.backgroundBlur').offset({left:leftOffset, top:topOffset})

  force.on "tick", ->
    
    link.attr("x1", (d) ->
      # angle = Math.atan(Math.abs(d.source.y-d.target.y)/Math.abs(d.source.x-d.target.x)  )
      # offsetx = Math.abs(50*(Math.cos(angle)))
      # if d.target.x > centerx
      #   d.source.x+offsetx
      # else
      #   d.source.x-offsetx
      return d.source.x+(d.source.r)
    ).attr("y1", (d) ->
      # angle = Math.atan(Math.abs(d.source.y-d.target.y)/Math.abs(d.source.x-d.target.x))
      # offsety = Math.abs(50*(Math.sin(angle)))
      # if d.target.y > centery
      #   d.source.y+offsety
      # else
      #   d.source.y-offsety
      return d.source.y
      
      # d.source.y-offsety
    ).attr("x2", (d) ->
      d.target.x-(d.target.r)
    ).attr "y2", (d) ->
      d.target.y

    gnodes.attr "transform", (d) ->
      "translate(" + [d.x, d.y ] + ")"


    labels.attr "transform", (d) ->
      if d.x == centerx and d.y == centery
        mag = -this.getBBox().width/2
        return "translate("+mag+","+0+")"

      slope = (centery-d.y)/(centerx-d.x)
      degangle = 360/(Math.PI*2)*Math.atan(slope)
      radangle = Math.atan(slope)

      # if d.x <= centerx
      #   mag = this.getBBox().width + 15
      #   xTrans = -mag*Math.cos(radangle)
      #   yTrans = -mag*Math.sin(radangle)
      #   "translate("+xTrans+","+yTrans+")rotate("+degangle+")"
      # else
        # mag = 15
        # xTrans = mag*Math.cos(radangle)
        # yTrans = mag*Math.sin(radangle)
      mag = -this.getBBox().width/2

      return "translate("+mag+","+(-20)+")rotate("+0+")"

    timelabels.attr "transform", (d) ->
      yTrans = 20
      xTrans = widthPer/4
      if d.x == centerx and d.y == centery
        return "translate("+widthPer/2+","+yTrans+")"
      else
        
        return "translate("+xTrans+","+yTrans+")"




@getNearbyEvents = () ->
  currentID = Session.get "clickedItem"
  visitTimes = Session.get "visitTimes"
  userTitles = Session.get "userTitles"

  # console.log currentID
  currentTitle = myIDs[currentID]['title']
  # console.log currentTitle
  index = userTitles.indexOf(currentTitle)
  # console.log visitTimes[index]
  baseTime = visitTimes[index]

  console.log userTitles[index-3] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index-3])/1000/60)).toFixed(3))+"minutes difference"
  console.log userTitles[index-2] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index-2])/1000/60)).toFixed(3))+"minutes difference"
  console.log userTitles[index-1] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index-1])/1000/60)).toFixed(3))+"minutes difference"
  console.log userTitles[index] + " | " +   String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index  ])/1000/60)).toFixed(3))+"minutes difference"
  console.log userTitles[index+1] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index+1])/1000/60)).toFixed(3))+"minutes difference"
  console.log userTitles[index+2] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index+2])/1000/60)).toFixed(3))+"minutes difference"
  console.log userTitles[index+3] + " | " + String(((parseFloat(visitTimes[index])/1000/60)-(parseFloat(visitTimes[index+3])/1000/60)).toFixed(3))+"minutes difference"
  
@isGoodSite = (pageTitle) ->
  # console.log pageTitle
  isFile = /File:/g
  isCategory = /Category:/g
  isTemplate = /Template:/g
  isTemplateTalk = /Template talk:/g
  isHelp = /Help:/g
  isWikipedia = /Wikipedia:/g
  isPortal = /Portal:/g
  isUser = /User:/g
  isAPI = /api.php/g
  isTalk = /Talk:/g
  isSpecial = /Special:/g
  # console.log myTitles
  if(isSpecial.test(pageTitle) or isTalk.test(pageTitle) or isAPI.test(pageTitle) or isFile.test(pageTitle) or isCategory.test(pageTitle) or isTemplate.test(pageTitle) or isHelp.test(pageTitle) or isWikipedia.test(pageTitle) or isPortal.test(pageTitle) or isTemplateTalk.test(pageTitle) or isUser.test(pageTitle))
    return false
  if myTitles[pageTitle] is undefined
    # console.log pageTitle
    return false
  return true

@secondsToWords = (seconds) ->
  if seconds < 60
    return seconds.toFixed(1) + " seconds"
  else if seconds < 3600
    return (seconds/60).toFixed(1) + " minutes"

  else if seconds < 86400
    return (seconds/3600).toFixed(1) + " hours"

  else if seconds < 604800
    return (seconds/86400).toFixed(1) + " days"

  else if seconds < 2419200
    return (seconds/604800).toFixed(1) + " weeks"

  else if seconds < 29030400
    return (seconds/2419200).toFixed(1) + " months"

  else 
    return (seconds/29030400).toFixed(1) + " years"
  