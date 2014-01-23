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

		svg = d3.select(".hereD").append("svg")
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







@renderD4 = (renderData) ->
	if renderData
		width = 960
		height = 500
		padding = 1.5
		clusterPadding = 6
		maxRadius = 12
		n = 200
		m = 20
		color = d3.scale.category20().domain(d3.range(m))
		clusters = new Array(m)


		nodes = d3.range(n).map(->
		  i = Math.floor(Math.random() * m)
		  r = Math.sqrt((i + 1) / m * -Math.log(Math.random())) * maxRadius
		  d =
		    cluster: i
		    radius: r

		  clusters[i] = d  if not clusters[i] or (r > clusters[i].radius)
		  d
		)


		force = d3.layout.force().nodes(nodes).size([width, height]).gravity(0).charge(0).start()
		svg = d3.select(".hereD").append("svg").attr("width", width).attr("height", height)
		
		gnodes = svg.selectAll('g.gnode')
		  .data(nodes)
		  .enter()
		  .append('g')
		  .classed('gnode', true)

		circle = gnodes.append("circle").attr("r", (d) ->
		  d.radius
		).style("fill", (d) ->
		  color d.cluster
		).call(force.drag)

		labels = gnodes.append("text")
		  .text((d) ->  "puh" )

		# separation between same-color circles
		# separation between different-color circles
		# total number of circles
		# number of distinct clusters

		console.log "here"
		# The largest node for each cluster.
		force.on "tick", -> 
			console.log "here1"
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

# 