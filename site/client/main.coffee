xPos = 0
yPos = 0

dataArray = []
myTitles = {}
myIDs = {}
linksObject = {}


# Template.dataGrid.dataGrid() # Can be called like so to resize the whole thing - to 'refresh'
Template.dataGrid.dataGrid = ->
  myHistory = TopMillion.find() # This will be limited to only the topmillion that are published based on userTitles
  if myHistory.count() # If we have any history items yet.
    allItems = myHistory.fetch()
    dataArray = buildArray(allItems)
    drawData(dataArray)
    initiateCursor(dataArray)
    buildLinksList(allItems)
    
  return 

Template.dataGrid.events =
  "click ": (d) ->
    console.log xPos + " clicked " + yPos
    document.getElementById("titleText").innerHTML = dataArray[yPos][xPos]
    console.log myTitles[dataArray[yPos][xPos]]
    Session.set "clickedItem", myTitles[dataArray[yPos][xPos]]["pageID"]
    console.log Session.get "clickedItem"
Template.links.events =
  "click .backgroundBlur": ->
    $('svg').remove()
    $('.backgroundBlur').remove()

Template.links.created = ->
  Session.set "clickedItem", 0

Template.links.map = ->
  myMap = WikiLinks.find().fetch()
  console.log "myMap:"
  console.log myMap
  if myMap.length 
    myLinks = []
    notMyLinks = []
    links = myMap[0]["titledLinks"]
    _.forEach links, (link) ->
      if link["pageID"] of myIDs
        # console.log myIDs[link]["title"]
        console.log link["title"]
        myLinks.push(link["title"])
      else
        notMyLinks.push(link["title"])
    notMyLinks = notMyLinks.slice(0,(35-myLinks.length))

    myLinks = myLinks.concat(notMyLinks)
    buildCentricNet(myMap[0]["articleTitle"], myLinks)
    console.log myLinks.length


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


@setCurrentPos = (x,y) -> # Created so that other files can edit the global xPos and yPos. 
# Probably not best practice though... Should have a get Function instead
  xPos = x
  yPos = y
  
@buildLinksList = (history) ->
  _.forEach history, (item) ->
    # console.log item
    title = item["articleTitle"]
    pageID = item["pageID"]

    myTitles[title] = {title:title, pageID:pageID}
    myIDs[pageID] = {title:title, pageID:pageID}

@buildCentricNet = (centerNode,links) ->
  mnodes = []
  mlinks = []
  height = 800
  width = 800
  center = height/2
  mnodes.push({"name":centerNode,"group":1, r:50, color:"white", x: center, y: center, fixed:true})


  numLinks = links.length
  linkNum = 1
  _.forEach links, (link) ->
    twopi = 2*Math.PI
    mx = center + 125 * Math.cos(twopi/numLinks*linkNum)
    my = center + 125 * Math.sin(twopi/numLinks*linkNum)
    if link of myTitles
      mnodes.push({"name":link,"group":1, r:10, color:"red", x: mx, y: my, fixed:true})
    else
      mnodes.push({"name":link,"group":1, r:10, color:"blue", x: mx, y: my, fixed:true})

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

  svg = d3.select("#viz").append("svg").attr("width", width).attr("height", height)

  

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
    

  gnodes = svg.selectAll("g.gnode")
    .data(mnodes)
    .enter()
    .append("g")
    .classed("gnode", true)
    .on("mouseover", (d) ->
      nodeSelection = d3.select(this)
      nodeSelection.select("circle").style(opacity: "1.0")
      nodeSelection.select("text").style(opacity: "1.0")
      nodeSelection.select("circle").style("stroke","#ccc")
    )
    .on("mouseout", (d) ->
      nodeSelection = d3.select(this)
      nodeSelection.select("circle").style(opacity: "1.0")
      nodeSelection.select("text").style(opacity: "1.0")
      nodeSelection.select("circle").style("stroke","#444")
      
    )

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
      d.name
    )
    .style("opacity", "1.0")




  leftOffset = $('#dataCanvas').position()["left"]
  topOffset = $('#dataCanvas').position()["top"]
  mwidth = $('#dataCanvas').width()
  mheight = $('#dataCanvas').height()

  # console.log leftOffset + " | " + topOffset + " | " + mwidth + " | " + mheight
  $('#viz').offset({left:mwidth/2-center+leftOffset, top:topOffset+mheight/2-center})
  $('.backgroundBlur').offset({left:leftOffset, top:topOffset})

  force.on "tick", ->
    link.attr("x1", (d) ->
      d.source.x
    ).attr("y1", (d) ->
      d.source.y
    ).attr("x2", (d) ->
      d.target.x
    ).attr "y2", (d) ->
      d.target.y

    gnodes.attr "transform", (d) ->
      "translate(" + [d.x, d.y ] + ")"


    labels.attr "transform", (d) ->
      if d.x == 400 and d.y == 400
        mag = -this.getBBox().width/2
        return "translate("+mag+","+0+")"

      slope = (center-d.y)/(center-d.x)
      degangle = 360/(Math.PI*2)*Math.atan(slope)
      radangle = Math.atan(slope)

      if d.x <= center
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


network = {
  "nodes":[
    {"name":"Myriel","group":1, x: 250, y: 250, fixed:true},
    {"name":"Napoleon","group":1, x: 300, y:150, fixed:true},
    {"name":"Mlle.Baptistine","group":1, x: 300, y: 50, fixed:true},
    {"name":"Mme.Magloire","group":1, x: 0, y: 500, fixed:true},
    {"name":"CountessdeLo","group":1, x: 500, y: 0, fixed:true},
    {"name":"Geborand","group":1, x: 500, y: 500, fixed:true}],
  "links":[
    {"source":0,"target":1,"value":1},
    {"source":0,"target":2,"value":8},
    {"source":0,"target":3,"value":10},
    {"source":0,"target":4,"value":6},
    {"source":0,"target":5,"value":6}
  ]

}
