Template.ddd.rendered = ->
	width = 1200
	height = 800
	color = d3.scale.category20()
	force = d3.layout.force().charge(-110).linkDistance(200).size([width, height])
	svg = d3.select(".hereD").append("svg").attr("width", width).attr("height", height)
	d3.json "netDataTest.json", (error, graph) ->
	  force.nodes(graph.nodes).links(graph.links).start()
	  link = svg.selectAll(".link").data(graph.links).enter().append("line").attr("class", "link").style("stroke-width", (d) ->
	    # Math.sqrt d.value
	    1
	  )
	  node = svg.selectAll(".node").data(graph.nodes).enter().append("circle").attr("class", "node").attr("r", (d) ->
	  	if d.inlinks > 100
	  		10
	  	else
	  		d.inlinks
	  ).style("fill", (d) ->
	    color d.inlinks
	    console.log d.inlinks
	  ).on("mouseover", (d) ->
	    nodeSelection = d3.select(this).style(opacity: "0.8")
	    nodeSelection.select("text").style(opacity: "1.0")
	    console.log nodeSelection.text()
	  ).call(force.drag)
	  node.append("title").text (d) ->
	    d.name
	    # console.log d.name

	  force.on "tick", ->
	    link.attr("x1", (d) ->
	      d.source.x
	    ).attr("y1", (d) ->
	      d.source.y
	    ).attr("x2", (d) ->
	      d.target.x
	    ).attr "y2", (d) ->
	      d.target.y

	    node.attr("cx", (d) ->
	      d.x
	    ).attr "cy", (d) ->
	      d.y
	 