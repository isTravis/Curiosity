@renderD3 = (renderData) ->
	if renderData
		w = 1200
		h = 800
		r = 6
		color = d3.scale.category20()

		force = d3.layout.force()
			.charge(-80)
			.gravity(0.06)
			.linkDistance(50)
			.size([w, h ])

		svg = d3.select(".wikimap").append("svg")
			.attr("width", w)
			.attr("height", h)
			.attr("transform", "translate(" + w / 4 + "," + h / 3 + ")")


		testingxx =
		  links: [
		    source: 1
		    target: 0
		    value: 1
		  ,
		    source: 2
		    target: 1
		    value: 5
		  ,
		    source: 1
		    target: 2
		    value: 5
		  ]
		  nodes: [
		    group: 12
		    name: "Travis"
		  ,
		    group: 8
		    name: "Napoleon"
		  ,
		    group: 2
		    name: "Pug"
		  ]

		console.log "renderupger " + renderData
		# mygraph = Session.get "networkData"
		# mygraph ="netDataTest.json"
		# mygraph =  JSON.stringify(testingxx)
		mnodes = renderData['nodes']
		mlinks = renderData['links']
		console.log mnodes
		# mygraph = "netData.json"
		# d3.json "netDataTest.json", (error, graph) ->
		# console.log "mygraph" + mygraph
		# if mygraph
			# d3.json mygraph, (error, graph) ->
		force.nodes(mnodes).links(mlinks).start()
		link = svg.selectAll(".link")
			.data(mlinks)
			.enter()
			.append("line")
			.attr("class", "link")
			.style("stroke-width", (d) ->
				1
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
				console.log nodeSelection.text()
			)
			.on("mouseout", (d) ->
				nodeSelection = d3.select(this)
				nodeSelection.select("circle").style(opacity: "1.0")
				nodeSelection.select("text").style(opacity: "0.2")
				console.log nodeSelection.text()
			)

		node = gnodes.append("circle")
			.attr("class", "node")
			.attr("class", "node").attr("r", (d) ->
				d.inlinks
			)
			.style("fill", (d) ->
				color d.inlinks
			)
			.style("opacity", "1.0")
			.call(force.drag)
			
		labels = gnodes.append("text").text((d) ->
			d.name
		)
		.style("opacity", "0.2")
		.attr("text-anchor", "middle")
		.attr("class","node-label")

		force.on "tick", ->
			q = d3.geom.quadtree(mnodes)
			# console.log q
			i = 0
			n = mnodes.length
			# console.log graph.nodes[i]
			q.visit collide(mnodes[i])  while ++i < n


			# Update the links
			link.attr("x1", (d) ->
			  d.source.x
			).attr("y1", (d) ->
			  d.source.y
			).attr("x2", (d) ->
			  d.target.x
			).attr "y2", (d) ->
			  d.target.y
			# node.each(collide(.5))

			# console.log svg.selectAll(".gnode")
			# svg.selectAll(".gnode").attr("cx", (d) ->
			#     d.source.x
			#   ).attr "cy", (d) ->
			#     d.y

			# Translate the groups
			gnodes.attr "transform", (d) ->
			  "translate(" + [Math.max(r, Math.min(w - r, d.x)), d.y = Math.max(r, Math.min(h - r, d.y))] + ")"

			
		collide = (node) ->
			rr = node.inlinks + 16
			# console.log rr
			nx1 = node.x - rr
			nx2 = node.x + rr
			ny1 = node.y - rr
			ny2 = node.y + rr
			(quad, x1, y1, x2, y2) ->
			  if quad.point and (quad.point isnt node)
			    x = node.x - quad.point.x
			    y = node.y - quad.point.y
			    l = Math.sqrt(x * x + y * y)
			    rr = node.radius + quad.point.radius
			    if l < rr
			      l = (l - rr) / l * .5
			      node.x -= x *= l
			      node.y -= y *= l
			      quad.point.x += x
			      quad.point.y += y
			  x1 > nx2 or x2 < nx1 or y1 > ny2 or y2 < ny1





@generateClusters = (renderData) ->
	if renderData
		console.log "renderdata " + renderData
		clusterData = []
		for item of renderData['nodes']
			# console.log renderData['nodes'][item]
			title = renderData['nodes'][item]['name']
			inlinks = renderData['nodes'][item]['inlinks']
			# console.log inlinks
			# if inlinks < 45
			clusterData.push({cluster:1, radius:inlinks, title: title})
		return clusterData


@renderD4 = (clusterData) ->
	if clusterData
		docHeight = $(document).height()
		docWidth = $(document).width()
		width = docWidth
		height = docHeight-100
		padding = 1.5
		clusterPadding = 6
		maxRadius = 45
		n = 25
		m = 1
		color = d3.scale.category20().domain(d3.range(m))
		clusters = new Array(m)

		
		data = [{cluster: 0.0, radius: 5.0},{cluster: 0.0, radius: 5.0},{cluster: 1.0, radius: 5.0},{cluster: 0.0, radius: 5.0},{cluster: 0.0, radius: 3.0}]
		counter = 0
		# console.log clusterData
		nodes = d3.range(clusterData.length).map(->
		  # console.log clusterData[counter]
		  i = clusterData[counter]['cluster']
		  r = clusterData[counter]['radius']
		  if r > 50
		  	r = 50
		  # console.log r
		  d =
		    cluster: i
		    radius: r
		    title: clusterData[counter]['title']
		    id: 'id'
		    x: Math.cos(i / m * 2 * Math.PI) * 200 + width / 2 + Math.random()
		    y: Math.sin(i / m * 2 * Math.PI) * 200 + height / 2 + Math.random()

		  # console.log d
		  clusters[i] = d  if not clusters[i] or (r > clusters[i].radius)
		  counter += 1
		  d
		)

		# console.log clusters
		# console.log nodes
		# clusters2 = clusters
		# nodes2 = nodes
		# nodes = [{cluster: 0.0, radius: 5.0},{cluster: 1.0, radius: 5.0},{cluster: 0.0, radius: 5.0},{cluster: 0.0, radius: 3.0}]
		# clusters = [{cluster: 0.0, radius: 5.0},{cluster: 1.0, radius: 5.0}]
		# console.log clusters
		# console.log nodes

		# nodes = nodes2
		# clusters = clusters2

		force = d3.layout.force().nodes(nodes).size([width, height]).gravity(0.2).charge(0).start()
		svg = d3.select(".wikimap").append("svg").attr("width", width).attr("height", height)
		
		gnodes = svg.selectAll('g.gnode')
			.data(nodes)
			.enter()
			.append('g')
			.classed('gnode', true)
			.on("mouseover", (d) ->
				nodeSelection = d3.select(this)
				# nodeSelection.select("circle").style(opacity: "1.0")
				nodeSelection.select("text").style(opacity: "1.0")
				# console.log nodeSelection.text()
			)
			.on("mouseout", (d) ->
				nodeSelection = d3.select(this)
				# nodeSelection.select("circle").style(opacity: "1.0")
				nodeSelection.select("text").style(opacity: "0.0")
				# console.log nodeSelection.text()
			)

		gnodes.transition().duration(750).delay((d, i) ->
		  i * 5
		).attrTween "r", (d) ->
		  i = d3.interpolate(0, d.radius)
		  (t) ->
		    d.radius = i(t)


		circle = gnodes.append("circle").attr("r", (d) ->
		  d.radius
		).style("fill", (d) ->
		  color d.cluster
		)

		labels = gnodes.append("text")
		  .text((d) ->  d.title )
		  .attr("text-anchor", "middle")
		  .style("opacity", "0.0")
		  .attr("class","node-label")

		# separation between same-color circles
		# separation between different-color circles
		# total number of circles
		# number of distinct clusters


		force.on "tick", -> 
			circle
				.each(cluster(10 *.01))
				.each(collide(.5))
				.attr("cx", (d) ->
					d.x
				).attr( "cy", (d) ->
					d.y
				)
			labels
				.attr("x", (d) ->
					d.x
				).attr( "y", (d) ->
					d.y
				)

		# Move d to be adjacent to the cluster node.
		@cluster = (alpha) ->
		  (d) ->
		    cluster = clusters[d.cluster]
		    k = 1
		    
		    # For cluster nodes, apply custom gravity.
		    if cluster is d
		      cluster =
		        x: width / 2
		        y: height / 2
		        radius: -d.radius

		      k = .1 * Math.sqrt(d.radius)
		    x = d.x - cluster.x
		    y = d.y - cluster.y
		    l = Math.sqrt(x * x + y * y)
		    r = d.radius + cluster.radius
		    unless l is r
		      l = (l - r) / l * alpha * k
		      d.x -= x *= l
		      d.y -= y *= l
		      cluster.x += x
		      cluster.y += y

		# Resolves collisions between d and all other circles.
		@collide = (alpha) ->
		  quadtree = d3.geom.quadtree(nodes)
		  (d) ->
		    r = d.radius + maxRadius + Math.max(padding, clusterPadding)
		    nx1 = d.x - r
		    nx2 = d.x + r
		    ny1 = d.y - r
		    ny2 = d.y + r
		    quadtree.visit (quad, x1, y1, x2, y2) ->
		      if quad.point and (quad.point isnt d)
		        x = d.x - quad.point.x
		        y = d.y - quad.point.y
		        l = Math.sqrt(x * x + y * y)
		        r = d.radius + quad.point.radius + ((if d.cluster is quad.point.cluster then padding else clusterPadding))
		        if l < r
		          l = (l - r) / l * alpha
		          d.x -= x *= l
		          d.y -= y *= l
		          quad.point.x += x
		          quad.point.y += y
		      x1 > nx2 or x2 < nx1 or y1 > ny2 or y2 < ny1

		
# @renderTimeline = () ->
# 	type = (d) ->
# 		d.frequency = +d.frequency
# 		d
		
# 	margin =
# 		top: 	20
# 		right: 20
# 		bottom: 30
# 		left: 40

# 	width = 960 - margin.left - margin.right
# 	height = 500 - margin.top - margin.bottom
# 	x = d3.scale.ordinal().rangeRoundBands([0, width], .1)
# 	y = d3.scale.linear().range([height, 0])
# 	xAxis = d3.svg.axis().scale(x).orient("bottom")
# 	yAxis = d3.svg.axis().scale(y).orient("left").ticks(10, "%")
# 	svg = d3.select("body").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")
# 	d3.tsv "data.tsv", type, (error, data) ->
# 		x.domain data.map((d) ->
# 		  d.letter
# 		)
# 		y.domain [0, d3.max(data, (d) ->
# 		  d.frequency
# 		)]
# 		svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call xAxis
# 		svg.append("g").attr("class", "y axis").call(yAxis).append("text").attr("transform", "rotate(-90)").attr("y", 6).attr("dy", ".71em").style("text-anchor", "end").text "Frequency"
# 		svg.selectAll(".bar").data(data).enter().append("rect").attr("class", "bar").attr("x", (d) ->
# 		  x d.letter
# 		).attr("width", x.rangeBand()).attr("y", (d) ->
# 		  y d.frequency
# 		).attr "height", (d) ->
# 		  height - y(d.frequency)


