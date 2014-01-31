@renderD3 = (renderData,localIDs) ->
	if renderData
		$('.welcome').addClass('hidden')
		w = $(document).width()
		h = $(document).height()
		h = h-100
		r = 6
		color = d3.scale.category20()

		force = d3.layout.force()
			.charge(-80)
			.gravity(0.06)
			.linkDistance(50)
			.size([w, h ])
		$(".wikimap").empty()
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

		# console.log "renderupger " + renderData
		# mygraph = Session.get "networkData"
		# mygraph ="netDataTest.json"
		# mygraph =  JSON.stringify(testingxx)


		nodeMap = []
		renderData['nodes'].forEach (x) ->
			# console.log "derg" + pageHistory[x.id]
			title =  localIDs[x.id]

			nodeMap.push({id:x.id, value:x.attr, title:title})

		# _.forEach renderData['links'], (link) ->
		# 	console.log link.source
		# 	console.log link.source.id


		mlinks = []

		renderData['links'].forEach((x) ->
			sourceID = x.source.id
			targetID = x.target.id
			srcIndex = nodeMap.map((y) ->  y.id).indexOf(sourceID)
			targetIndex = nodeMap.map((y) ->  y.id).indexOf(targetID)
			# console.log srcIndex
			# source: nodeMap[x.source.id]
			# target: nodeMap[x.target.id]
			# value: 0
			mlinks.push({source:srcIndex,target:targetIndex,value:0})
		)

		# console.log nodeMap
		# console.log mlinks

		mnodes = nodeMap
		# mlinks = renderData['links']
		# console.log mnodes
		# mygraph = "netData.json"
		# d3.json "netDataTest.json", (error, graph) ->
		# console.log "mygraph" + mygraph
		# if mygraph
			# d3.json mygraph, (error, graph) ->
		# console.log "d2here"
		force.nodes(mnodes).links(mlinks).start()
		# console.log "d4here"
		link = svg.selectAll(".link")
			.data(mlinks)
			.enter()
			.append("line")
			.attr("class", "link")
			.style("stroke-width", (d) ->
				1
			)
		# console.log "d3here"
		gnodes = svg.selectAll("g.gnode")
			.data(mnodes)
			.enter()
			.append("g")
			.classed("gnode", true)
			.on("mouseover", (d) ->
				nodeSelection = d3.select(this)
				nodeSelection.select("circle").style(opacity: "1.0")
				nodeSelection.select("text").style(opacity: "1.0")
				# console.log nodeSelection.text()
			)
			.on("mouseout", (d) ->
				nodeSelection = d3.select(this)
				nodeSelection.select("circle").style(opacity: "1.0")
				nodeSelection.select("text").style(opacity: "0.2")
				# console.log nodeSelection.text()
			)

		node = gnodes.append("circle")
			.attr("class", "node")
			.attr("class", "node").attr("r", (d) ->
				# d.value/100
				Math.pow(d.value,1/3)*2
			)
			.style("fill", (d) ->
				color d.value
			)
			.style("opacity", "1.0")
			.call(force.drag)
			
		labels = gnodes.append("text").text((d) ->
			# console.log "herrr" + pageHistory
			# console.log pageHistory[d.id]
			d.title
		)
		.style("opacity", "0.2")
		.attr("text-anchor", "middle")
		.attr("class","node-label")

		force.on "tick", ->
			# q = d3.geom.quadtree(mnodes)
			# # console.log q
			# i = 0
			# n = mnodes.length
			# console.log graph.nodes[i]
			# q.visit collide(mnodes[i])  while ++i < n


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

			
		# collide = (node) ->
		# 	rr = node.inlinks + 16
		# 	# console.log rr
		# 	nx1 = node.x - rr
		# 	nx2 = node.x + rr
		# 	ny1 = node.y - rr
		# 	ny2 = node.y + rr
		# 	(quad, x1, y1, x2, y2) ->
		# 	  if quad.point and (quad.point isnt node)
		# 	    x = node.x - quad.point.x
		# 	    y = node.y - quad.point.y
		# 	    l = Math.sqrt(x * x + y * y)
		# 	    rr = node.radius + quad.point.radius
		# 	    if l < rr
		# 	      l = (l - rr) / l * .5
		# 	      node.x -= x *= l
		# 	      node.y -= y *= l
		# 	      quad.point.x += x
		# 	      quad.point.y += y
		# 	  x1 > nx2 or x2 < nx1 or y1 > ny2 or y2 < ny1





@generateClusters = (renderData) ->
	if renderData
		console.log "renderdata " + renderData
		clusterData = []
		for item of renderData['nodes']
			# console.log renderData['nodes'][item]
			title = renderData['nodes'][item]['id']
			inlinks = renderData['nodes'][item]['attr']/100
			# console.log inlinks
			# if inlinks < 45
			clusterData.push({cluster:1, radius:inlinks, title: title})
		return clusterData


@renderD4 = (clusterData,scrapedIDs) ->
	if clusterData
		# console.log clusterData
		# console.log "scrapedid is " + scrapedIDs
		
		$('.welcome').addClass('hidden')

		n = clusterData.length
		m = 0
		maxNodeRadius = 0
		_.forEach clusterData, (node) ->
			if node.cluster > m
				m = node.cluster
				# console.log m
			thisRadius = Math.pow(node.radius,1/3)*2
			if thisRadius > maxNodeRadius
				maxNodeRadius = thisRadius
				# console.log maxRadius
		# maxRadius = Math.ceil(maxRadius)
		# console.log maxRadius


		docHeight = $(document).height()
		docWidth = $(document).width()
		width = docWidth
		height = docHeight-110
		padding = 3
		clusterPadding = 10
		maxRadius = Math.ceil(height/Math.sqrt(n))/10
		# maxRadius = 45
		# n = 25
		# m = 1
		color = d3.scale.category20().domain(d3.range(m))
		clusters = new Array(m)

		
		data = [{cluster: 0.0, radius: 5.0},{cluster: 0.0, radius: 5.0},{cluster: 1.0, radius: 5.0},{cluster: 0.0, radius: 5.0},{cluster: 0.0, radius: 3.0}]
		counter = 0
		# console.log clusterData
		nodes = d3.range(clusterData.length).map(->
		  # console.log clusterData[counter]
		  i = clusterData[counter]['cluster']
		  # r = (clusterData[counter]['radius']/maxNodeRadius)*maxRadius
		  r = (Math.pow((clusterData[counter]['radius']),1/3)) / (Math.pow(maxNodeRadius,1/3)) * maxRadius
		  # if r > 50
		  # 	r = 50
		  # console.log r
		  d =
		    cluster: i
		    radius: r
		    title: clusterData[counter]['title']
		    id: 'id'
		    x:  Math.cos(i / m * 2 * Math.PI) * 200 + width / 2 + Math.random()
		    y:  Math.sin(i / m * 2 * Math.PI) * 200 + height / 2 + Math.random()

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

		# d3.layout.pack().sort(null).size([width, height]).children((d) ->
		#   d.values
		# ).value((d) ->
		#   d.radius * d.radius
		# ).nodes values: d3.nest().key((d) ->
		#   d.cluster
		# ).entries(nodes)

		force = d3.layout.force().nodes(nodes).size([width, height]).gravity(0.02).charge(0)

		$(".wikimap").empty()
		svg = d3.select(".wikimap").append("svg").attr("width", width).attr("height", height)
		


		# node = svg.selectAll("circle").data(nodes).enter().append("circle").style("fill", (d) ->
		#   color d.cluster
		# ).call(force.drag)

		# node.transition().duration(750).delay((d, i) ->
		#   i * 5
		# ).attrTween "r", (d) ->
		#   i = d3.interpolate(0, d.radius)
		#   (t) ->
		#     d.radius = i(t)



		# gnodes = svg.selectAll('g.gnode')
		# 	.data(nodes)
		# 	.enter()
		# 	.append('g')
		# 	.classed('gnode', true)
		# 	.on("mouseover", (d) ->
		# 		nodeSelection = d3.select(this)
		# 		# nodeSelection.select("circle").style(opacity: "1.0")
		# 		nodeSelection.select("text").style(opacity: "1.0")
		# 		# console.log nodeSelection.text()
		# 	)
		# 	.on("mouseout", (d) ->
		# 		nodeSelection = d3.select(this)
		# 		# nodeSelection.select("circle").style(opacity: "1.0")
		# 		nodeSelection.select("text").style(opacity: "0.2")
		# 		# console.log nodeSelection.text()
		# 	)

		# gnodes.transition().duration(750).delay((d, i) ->
		#   i * 5
		# ).attrTween "r", (d) ->
		#   i = d3.interpolate(0, d.radius)
		#   (t) ->
		#     d.radius = i(t)


		# circle = gnodes.append("circle").attr("r", (d) ->
		#   d.radius
		# ).style("fill", (d) ->
		#   color d.cluster
		# )

		# labels = gnodes.append("text")
		#   .text((d) ->  scrapedIDs[d.title] )
		#   .attr("text-anchor", "middle")
		#   .style("opacity", "0.2")
		#   .attr("class","node-label")
		#   .style("font-size","10px")

		# separation between same-color circles
		# separation between different-color circles
		# total number of circles
		# number of distinct clusters
		
		# force.stop()

		# force.on "tick", -> 
		# # @tick = (e) ->

		# 	# node
		# 	circle
		# 		.each(cluster(10 * force.alpha() * force.alpha()))
		# 		.each(collide(.5))
		# 		.attr("cx", (d) ->
		# 			d.x
		# 		).attr( "cy", (d) ->
		# 			d.y
		# 		)
			# labels
			# 	.attr("x", (d) ->
			# 		d.x
			# 	).attr( "y", (d) ->
			# 		d.y
			# 	)
		
		loading = svg.append("text")
			.attr("x", width / 2)
			.attr("y", height / 2)
			.attr("dy", ".35em")
			.style("text-anchor", "middle")
			.text("Rendering. One moment please…");

		setTimeout (->
			
			# Run the layout a fixed number of times.
			# The ideal number of times scales with graph complexity.
			# Of course, don't run too long—you'll hang the page!
			force.start()

			gnodes = svg.selectAll('g.gnode')
				.data(nodes)
				.enter()
				.append('g')
				.classed('gnode', true)
				.on("mouseover", (d) ->
					nodeSelection = d3.select(this)
					#	 nodeSelection.select("circle").style(opacity: "1.0")
					nodeSelection.select("text").style(opacity: "1.0")
					nodeSelection.select("circle").style("stroke","#ddd")
					# nodeSelection.select("circle").style("stroke-width","1px")
					# console.log nodeSelection.text()
				)
				.on("mouseout", (d) ->
					nodeSelection = d3.select(this)
					# nodeSelection.select("circle").style(opacity: "1.0")
					nodeSelection.select("text").style(opacity: "0.2")
					nodeSelection.select("circle").style("stroke","#999")
					# console.log nodeSelection.text()
				)

			# gnodes.transition().duration(750).delay((d, i) ->
			#   i * 5
			# ).attrTween "r", (d) ->
			#   i = d3.interpolate(0, d.radius)
			#   (t) ->
			#     d.radius = i(t)


			circle = gnodes.append("circle").attr("r", (d) ->
			  d.radius
			).style("fill", (d) ->
			  color d.cluster
			).style("stroke","#999")
			.style("stroke-width","2px")

			labels = gnodes.append("text")
				.text((d) ->  scrapedIDs[d.title] )
				.attr("text-anchor", "middle")
				.style("opacity", "0.2")
				.attr("class","node-label")
				.style("font-size","10px")

			force.on "tick", -> 
				# console.log "hereintick"
				# node
				circle
					.each(cluster(10 * force.alpha() * force.alpha()))
					.each(collide(.5))
					.attr("cx", (d) ->
						# d.x
						if d.x > width
							return (width - maxRadius)
						else if d.x < 0
							return (0 + maxRadius)
						else 
							return d.x
						# return d.x = Math.max(15, Math.min(width - 15, d.x))
					).attr( "cy", (d) ->
						# d.y
						# return d.y = Math.max(15, Math.min(height - 15, d.y))
						if d.y > height
							return (height - maxRadius)
						else if d.y < 0
							return (0 + maxRadius)
						else 
							return d.y
					)
				labels
					.attr("x", (d) ->
						d.x
					).attr( "y", (d) ->
						d.y
					)
				# circle.attr("transform", (d) -> return "translate(" + d.x + "," + d.y + ")" )
				# gnodes.attr "transform", (d) ->
				#   "translate(" + [Math.max(r, Math.min(w - r, d.x)), d.y = Math.max(r, Math.min(h - r, d.y))] + ")"

			i = n * n

			while force.alpha() != 0
			  force.tick()
			  --i
			  # console.log force.alpha()
			force.stop()

			


			loading.remove()
		), 50


		# @fakeTick = () ->
		# 	circle
		# 		.each(cluster(10 * 0.01))
		# 		.each(collide(.5))
		# 		.attr("cx", (d) ->
		# 			d.x
		# 		).attr( "cy", (d) ->
		# 			d.y
		# 		)
		# Move d to be adjacent to the cluster node.
		@cluster = (alpha) ->
		  (d) ->
		    cluster = clusters[d.cluster]
		    return  if cluster is d
		    x = d.x - cluster.x
		    y = d.y - cluster.y
		    l = Math.sqrt(x * x + y * y)
		    r = d.radius + cluster.radius
		    unless l is r
		      l = (l - r) / l * alpha
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

		# pp= 0
		# while pp <500
		# 	fakeTick()
		# 	pp++
		# 	console.log "here"
		# 	# console.log force.alpha()
		# force.start()
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


@buildGraph = (edges,numNodes) ->
	selectEdges = reduceEdges(edges,numNodes)
	nodes = []
	links = []

	console.log "selectEdges " + selectEdges.length 

	_.forEach selectEdges, (edge) ->
		src = edge.src
		dest = edge.dest
		strength = edge.strength
		# console.log strength
		srcIndex = nodes.map((x) ->  x.id).indexOf(src)


		if srcIndex < 0
			nodes.push({id:src,links:[],skip:false,attr:strength})
		else
			# console.log nodes[srcIndex].attr
			# console.log "add:" 
			# console.log nodes[srcIndex].attr + strength
			nodeStrength = nodes[srcIndex].attr + strength
			nodeLinks = nodes[srcIndex].links
			nodes[srcIndex] = {id:src,links:nodeLinks,skip:false,attr:nodeStrength}

		destIndex = nodes.map((x) ->  x.id).indexOf(dest)
		if destIndex < 0
			nodes.push({id:dest,links:[],skip:false,attr:strength})
		else
			nodeStrength = nodes[destIndex].attr + strength
			nodeLinks = nodes[destIndex].links
			nodes[destIndex] = {id:dest,links:nodeLinks,skip:false,attr:nodeStrength}

		# console.log "here"
		srcIndex = nodes.map((x) ->  x.id).indexOf(src)
		# console.log srcIndex
		destIndex = nodes.map((x) ->  x.id).indexOf(dest)
		nodes[srcIndex].links.push({source:nodes[srcIndex],target:nodes[destIndex],skip:false})
		# console.log "here2"
		# nodes[destIndex].links.push({src:nodes[srcIndex],dest:nodes[destIndex]})
		# IS the link supposed to exist in both the src and dest links[]?

		links.push({source:nodes[srcIndex],target:nodes[destIndex],skip:false})

	# _.forEach links, (link) ->
	# 	console.log link
	console.log "rebuilt node length is " + nodes.length
	console.log "rebuilt link length is " + links.length
	graph = {nodes: nodes, links: links}

	
	return graph
	# export interface INode {
 #    id: string;
 #    links: ILink[];
 #    attr?: any;
 #    skip: bool;
 #  }

 #  export interface ILink {
 #    source: INode;
 #    target: INode;
 #    attr?: any;
 #    skip: bool;
 #  }

 #  export interface IGraph {
 #    nodes: INode[];
 #    links: ILink[];
 #  }


@reduceEdges = (edges,numNodes) ->
	# Ween down the full edges list 

	# numNodes = 200
	nodes = []
	topEdges = []
	# console.log edges
	# Sort edges by strength value
	edges.sort (a, b) ->
		b.strength - a.strength

	edgecounter = 0
	_.forEach edges, (e) ->
		if e.src != e.dest
			# console.log e.src + " and " + e.dest
			if nodes.length < numNodes

				if nodes.indexOf(e.src) < 0
					# console.log "here"
					nodes.push(e.src)
				if nodes.indexOf(e.dest) < 0
					nodes.push(e.dest)
				edgecounter += 1
				topEdges.push(e)

	console.log "nodeslength " + nodes.length
	# return edges.slice(0,edgecounter)
	return topEdges

	